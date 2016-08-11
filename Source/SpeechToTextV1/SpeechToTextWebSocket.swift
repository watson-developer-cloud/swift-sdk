/**
 * Copyright IBM Corporation 2016
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
import Freddy
import RestKit

/** Abstracts the WebSockets connection to the Watson Speech to Text service. */
class SpeechToTextWebSocket: WebSocket {

    private let restToken: RestToken
    private let failure: (NSError -> Void)?
    private let success: [TranscriptionResult] -> Void
    private var results = [TranscriptionResult]()
    private let operations = NSOperationQueue()
    private var state = State.Disconnected
    private var retries = 0
    private let maxRetries = 2
    private let userAgent = buildUserAgent("watson-apis-ios-sdk/0.6.0 SpeechToTextV1")
    private let domain = "com.ibm.watson.developer-cloud.SpeechToTextV1"

    enum State {
        case Disconnected
        case Listening
        case StartedRequest
        case ReceivingResults
    }

    /**
     Create a `SpeechToTextWebSocket` object to communicate with Speech to Text.

     - parameter websocketsURL: The URL that shall be used to stream audio for transcription.
     - parameter restToken: A `RestToken` that defines how to authenticate with the Speech to
        Text service. The `RestToken` is used internally to obtain tokens, refresh expired tokens,
        and maintain information about authentication state.
     - parameter settings: The configuration for this transcription request.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with all transcription results whenever
        a final or interim transcription is received.

     - returns: A `SpeechToTextWebSocket` object that can communicate with Speech to Text.
     */
    init?(
        websocketsURL: String,
        restToken: RestToken,
        settings: TranscriptionSettings,
        failure: (NSError -> Void)? = nil,
        success: [TranscriptionResult] -> Void)
    {
        self.restToken = restToken
        self.failure = failure
        self.success = success

        operations.maxConcurrentOperationCount = 1
        operations.suspended = true

        guard let url = SpeechToTextWebSocket.websocketsURL(websocketsURL, settings: settings) else {
            let failureReason = "Unable to construct a WebSockets connection to Speech to Text."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return nil
        }
        super.init(url: url)
        self.onConnect = onConnectDelegate
        self.onDisconnect = onDisconnectDelegate
        self.onData = onDataDelegate
        self.onText = onTextDelegate
    }

    /** Build the URL to use when connecting to Speech to Text with Websockets.
     
     - parameter url: The base URL that shall be used to stream audio for transcription.
     - parameter settings: The `TranscriptionSettings` to use for the Speech to Text session.
     - returns: An NSURL, if it can be constructed from the given settings.
     */
    private static func websocketsURL(url: String, settings: TranscriptionSettings) -> NSURL? {
        guard let urlComponents = NSURLComponents(string: url) else {
            return nil
        }
        
        var urlParams = [NSURLQueryItem]()
        if let model = settings.model {
            urlParams.append(NSURLQueryItem(name: "model", value: model))
        }
        if settings.learningOptOut == true {
            urlParams.append(NSURLQueryItem(name: "x-watson-learning-opt-out", value: "true"))
        }
        
        urlComponents.queryItems = urlParams
        guard let url = urlComponents.URL else {
            return nil
        }
        
        return url
    }
    
    /**
     Connect to the Speech to Text service using WebSockets.
     
     The `RestToken` provided to the `init` will be used to authenticate with the Speech to Text
     service. If necessary, the token associated with the `RestToken` will be refreshed.
     */
    override func connect() {
        connectWithToken()
    }

    /**
     Disconnect from the Speech to Text service after all queued operations have completed.
     
     - parameter forceTimeout: The amount of time to wait (after all queued operations have
        completed) for the WebSocket connection to gracefully disconnect. If it does not gracefully
        disconnect within the time allotted, then the connection will be forcibly closed.
     */
    override func disconnect(forceTimeout forceTimeout: NSTimeInterval? = nil) {
        operations.addOperationWithBlock {
            self.operations.suspended = true
        }
        operations.addOperationWithBlock {
            super.disconnect(forceTimeout: forceTimeout)
        }
    }

    /**
     Disconnect from the Speech to Text service immediately, without waiting for any queued
     operations to complete.

     - parameter forceTimeout: The amount of time to wait for the WebSocket connection to
        gracefully disconnect. If it does not gracefully disconnect within the time allotted,
        then the connection will be forcibly closed.
     */
    func disconnectNow(forceTimeout forceTimeout: NSTimeInterval? = nil) {
        super.disconnect(forceTimeout: forceTimeout)
    }

    /**
     Queue an operation to write data to the Speech to Text service.

     - parameter data: The data to send to the Speech to Text service.
     */
    override func writeData(data: NSData, completion: (Void -> Void)? = nil) {
        operations.addOperationWithBlock {
            if self.state == .Listening {
                self.state = .StartedRequest
            }
            super.writeData(data)
        }
    }

    /**
     Queue an operation to write a string to the Speech to Text service.

     - parameter str: The string to send to the Speech to Text service.
     */
    override func writeString(str: String, completion: (Void -> Void)? = nil) {
        operations.addOperationWithBlock {
            if self.state == .Listening {
                self.state = .StartedRequest
            }
            super.writeString(str)
        }
    }

    /**
     Queue an operation to write a ping to the Speech to Text service.

     - parameter data: Data to include in the ping to the Speech to Text service.
     */
    override func writePing(data: NSData, completion: (Void -> Void)? = nil) {
        operations.addOperationWithBlock {
            super.writePing(data)
        }
    }

    /**
     Connect to the Speech to Text service using this instance's `RestToken`. If necessary, the
     token is refreshed.
     */
    private func connectWithToken() {
        guard retries < maxRetries else {
            let failureReason = "Invalid HTTP upgrade. Please verify your credentials."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        retries += 1

        if let token = restToken.token where retries == 1 {
            headers["X-Watson-Authorization-Token"] = token
            headers["User-Agent"] = userAgent
            super.connect()
        } else {
            let failure = { (error: NSError) in
                let failureReason = "Failed to obtain an authentication token. " +
                                    "Check credentials."
                let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                self.failure?(error)
            }
            restToken.refreshToken(failure) {
                self.headers["X-Watson-Authorization-Token"] = self.restToken.token
                self.headers["User-Agent"] = self.userAgent
                super.connect()
            }
        }
    }

    /**
     When the connection to the Speech to Text service is connected then set the state, start
     the queue, and reset the number of connection retries.
     */
    func onConnectDelegate() {
        state = .Listening
        operations.suspended = false
        retries = 0
    }

    /**
     When the connection to the Speech to Text service is disconnected then set the state, pause
     the queue, and try reconnecting if this was an authentication failure.
     
     - parameter error: An error describing why the WebSockets connection was disconnected. If
        this error represents an authentication failure, then we try refreshing the token and
        reconnecting. If this error represents a successful disconnection, then it is ignored.
        Otherwise, the error is returned to the client through this instance's `failure` function.
     */
    func onDisconnectDelegate(error: NSError?) {
        state = .Disconnected
        operations.suspended = true
        if isAuthenticationFailure(error) {
            connect()
        } else if isDisconnectedByServer(error) {
            return
        } else if let error = error {
            failure?(error)
        }
    }

    /**
     Process a data payload from Speech to Text.

     - parameter data: The data payload from Speech to Text.
     */
    func onDataDelegate(data: NSData) {
        return
    }

    /**
     Process a generic text payload from Speech to Text.

     - parameter text: The text payload from Speech to Text.
     */
    func onTextDelegate(text: String) {
        do {
            let json = try JSON(jsonString: text)
            let state = try? json.decode(type: TranscriptionState.self)
            let results = try? json.decode(type: TranscriptionResultWrapper.self)
            let error = try? json.string("error")

            if let state = state {
                onStateDelegate(state)
            } else if let results = results {
                onResultsDelegate(results)
            } else if let error = error {
                onErrorDelegate(error)
            }
        } catch {
            let failureReason = "Could not serialize a generic text response to an object."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
    }

    /**
     Handle a state message from Speech to Text.

     - parameter state: The state of the Speech to Text recognition request.
     */
    private func onStateDelegate(state: TranscriptionState) {
        if self.state == .ReceivingResults && state.state == "listening" {
            self.state = .Listening
            operations.suspended = false
        }
        return
    }

    /**
     Handle transcription results from Speech to Text.

     - parameter wrapper: A `TranscriptionResultWrapper` that encapsulates the new or updated
        transcriptions along with state information to update the internal `results` array.
     */
    private func onResultsDelegate(wrapper: TranscriptionResultWrapper) {
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
    private func onErrorDelegate(error: String) {
        state = .Listening
        let failureReason = error
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        let error = NSError(domain: domain, code: 0, userInfo: userInfo)
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

    /**
     Determine if a WebSockets error is the result of a successful disconnect by the server.

     - parameter error: A WebSockets error that may have been caused by a successful disconnect
        by the server.

     - returns: `true` if the given error is the result of a successful disconnect by the server;
        false, otherwise.
     */
    private func isDisconnectedByServer(error: NSError?) -> Bool {
        guard let error = error else {
            return false
        }
        guard let description = error.userInfo[NSLocalizedDescriptionKey] as? String else {
            return false
        }

        let authDomain = (error.domain == "WebSocket")
        let authCode = (error.code == 1000)
        let authDescription = (description == "connection closed by server")
        if authDomain && authCode && authDescription {
            return true
        }

        return false
    }
}
