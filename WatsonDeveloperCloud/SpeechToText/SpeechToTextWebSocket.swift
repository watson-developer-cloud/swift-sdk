/**
 * Copyright IBM Corporation 2015
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import Starscream

/** Abstracts the WebSockets connection to the Watson Speech to Text service. */
class SpeechToTextWebSocket: WebSocket {

    private let authStrategy: AuthenticationStrategy
    private let failure: (NSError -> Void)?
    private let success: [SpeechToTextResult] -> Void
    private var results = [SpeechToTextResult]()
    private let operations = NSOperationQueue()
    private var state = State.Disconnected
    private var retries = 0
    private var maxRetries = 2

    enum State {
        case Disconnected
        case Listening
        case StartedRequest
        case ReceivingResults
    }

    /**
     Create a `SpeechToTextWebSocket` object to communicate with Speech to Text.

     - parameter authStrategy: An `AuthenticationStrategy` that defines how to authenticate
        with the Watson Developer Cloud's Speech to Text service. The `AuthenticationStrategy`
        is used internally to obtain tokens, refresh expired tokens, and maintain information
        about authentication state.
     - parameter settings: The configuration for this transcription request.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with all transcription results whenever
        a final or interim transcription is received.

     - returns: A `SpeechToTextWebSocket` object that can communicate with Speech to Text.
     */
    init?(
        authStrategy: AuthenticationStrategy,
        settings: SpeechToTextSettings,
        failure: (NSError -> Void)? = nil,
        success: [SpeechToTextResult] -> Void)
    {
        self.authStrategy = authStrategy
        self.failure = failure
        self.success = success

        operations.maxConcurrentOperationCount = 1
        operations.suspended = true

        guard let url = SpeechToTextConstants.websocketsURL(settings) else {
            let description = "Unable to construct a WebSockets connection to Speech to Text."
            failure?(createError(SpeechToTextConstants.domain, description: description))
            super.init(url: NSURL(string: "http://www.ibm.com")!)
            return nil
        }
        super.init(url: url)
        self.onConnect = websocketDidConnect
        self.onDisconnect = websocketDidDisconnect
        self.onData = websocketDidReceiveData
        self.onText = websocketDidReceiveMessage
    }

    override func connect() {
        connectWithToken()
    }

    override func disconnect(forceTimeout forceTimeout: NSTimeInterval? = nil) {
        operations.addOperationWithBlock {
            self.operations.suspended = true
        }
        operations.addOperationWithBlock {
            super.disconnect(forceTimeout: forceTimeout)
        }
    }

    func disconnectNow(forceTimeout forceTimeout: NSTimeInterval? = nil) {
        super.disconnect(forceTimeout: forceTimeout)
    }

    override func writeData(data: NSData) {
        operations.addOperationWithBlock {
            if self.state == .Listening {
                self.state = .StartedRequest
            }
            super.writeData(data)
        }
    }

    override func writeString(str: String) {
        operations.addOperationWithBlock {
            if self.state == .Listening {
                self.state = .StartedRequest
            }
            super.writeString(str)
        }
    }

    override func writePing(data: NSData) {
        operations.addOperationWithBlock {
            super.writePing(data)
        }
    }

    private func connectWithToken() {
        guard retries < maxRetries else {
            let description = "Invalid HTTP upgrade. Please verify your credentials."
            failure?(createError(SpeechToTextConstants.domain, description: description))
            return
        }

        retries += 1

        if let token = authStrategy.token where retries == 1 {
            headers["X-Watson-Authorization-Token"] = token
            super.connect()
        } else {
            authStrategy.refreshToken { error in
                guard let token = self.authStrategy.token where error == nil else {
                    let description = "Failed to obtain an authentication token. Check credentials."
                    let error = createError(SpeechToTextConstants.domain, description: description)
                    self.failure?(error)
                    return
                }
                self.headers["X-Watson-Authorization-Token"] = token
                super.connect()
            }
        }
    }

    func websocketDidConnect() {
        state = .Listening
        operations.suspended = false
        retries = 0
    }

    func websocketDidDisconnect(error: NSError?) {
        state = .Disconnected
        operations.suspended = true
        if isAuthenticationFailure(error) {
            connect()
        } else if let error = error {
            failure?(error)
        }
    }

    /**
     Process a data payload from Speech to Text.

     - parameter data: The data payload from Speech to Text.
     */
    func websocketDidReceiveData(data: NSData) {
        return
    }

    /**
     Process a generic text payload from Speech to Text.

     - parameter text: The text payload from Speech to Text.
     */
    func websocketDidReceiveMessage(text: String) {
        guard let response = SpeechToTextGenericResponse.parseResponse(text) else {
            let description = "Could not serialize a generic text response to an object."
            failure?(createError(SpeechToTextConstants.domain, description: description))
            return
        }

        switch response {
        case .State(let state): didReceiveState(state)
        case .Results(let wrapper): didReceiveResults(wrapper)
        case .Error(let error): didReceiveError(error)
        }
    }

    /**
     Handle a state message from Speech to Text.

     - parameter state: The state of the Speech to Text recognition request.
     */
    private func didReceiveState(state: SpeechToTextState) {
        if self.state == .ReceivingResults && state.state == "listening" {
            self.state = .Listening
            operations.suspended = false
        }
        return
    }

    /**
     Handle transcription results from Speech to Text.

     - parameter wrapper: A `SpeechToTextResultWrapper` that encapsulates the new or updated
        transcriptions along with state information to update the internal `results` array.
     */
    private func didReceiveResults(wrapper: SpeechToTextResultWrapper) {
        if state == .StartedRequest {
            state = .ReceivingResults
        }

        var localIndex = wrapper.resultIndex
        var wrapperIndex = 0
        while localIndex < results.count {
            results[localIndex] = wrapper.results[wrapperIndex]
            localIndex = localIndex + 1
            wrapperIndex = wrapperIndex + 1
        }
        while wrapperIndex < wrapper.results.count {
            results.append(wrapper.results[wrapperIndex])
            wrapperIndex = wrapperIndex + 1
        }

        success(results)
    }

    /*
     Handle an error generated by Speech to Text.

     - parameter error: The error that occurred.
     */
    private func didReceiveError(error: SpeechToTextError) {
        state = .Listening
        let error = createError(SpeechToTextConstants.domain, description: error.error)
        failure?(error)
    }

    /**
     Determine if a WebSockets error is the result of an authentication failure. This is
     particularly helpful when we want to intercept authentication failures and retry
     the connection with an updated token before returning the error to the user.

     - parameter error: A WebSockets error that may have been caused by an authentication failure.

     - returns: `true` if the given error is the result of an authentication failure; false,
     otherwise.
     */
    private func isAuthenticationFailure(error: NSError?) -> Bool {
        guard let error = error else {
            return false
        }
        guard let description = error.userInfo[NSLocalizedDescriptionKey] as? String else {
            return false
        }

        let authDomain = (error.domain == "WebSocket")
        let authCode = (error.code == 400)
        let authDescription = (description == "Invalid HTTP upgrade")
        if authDomain && authCode && authDescription {
            return true
        }
        
        return false
    }
}
