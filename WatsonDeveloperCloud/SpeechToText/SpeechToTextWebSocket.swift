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

class SpeechToTextWebSocket {

    private let socket: WatsonWebSocket
    private var results: [SpeechToTextResult]
    private let failure: (NSError -> Void)?
    private let success: [SpeechToTextResult] -> Void

    init?(
        authStrategy: AuthenticationStrategy,
        settings: SpeechToTextSettings,
        failure: (NSError -> Void)? = nil,
        success: [SpeechToTextResult] -> Void)
    {
        guard let url = NSURL(string: SpeechToTextConstants.websocketsURL(settings)) else {
            // A bug in the Swift compiler requires us to set all properties before returning nil
            // This bug is fixed in Swift 2.2, so we can remove this code when Xcode is updated
            self.socket = WatsonWebSocket(authStrategy: authStrategy,
                url: NSURL(string: "http://www.ibm.com")!)
            self.results = []
            self.failure = nil
            self.success = {result in }
            return nil
        }

        self.socket = WatsonWebSocket(authStrategy: authStrategy, url: url)
        self.results = [SpeechToTextResult]()
        self.failure = failure
        self.success = success

        socket.onText = onText
        socket.onData = onData
        socket.onError = onSocketError
    }

    // MARK: WatsonWebSocket API Functions

    func writeData(data: NSData) {
        socket.writeData(data)
    }

    func writeString(str: String) {
        socket.writeString(str)
    }

    func writePing(data: NSData) {
        socket.writePing(data)
    }

    func disconnect(forceTimeout: NSTimeInterval? = nil) {
        socket.disconnect(forceTimeout)
    }

    // MARK: WatsonWebSocket Delegate Functions

    private func onText(text: String) {
        guard let response = SpeechToTextGenericResponse.parseResponse(text) else {
            if let failure = failure {
                let description = "Could not serialize a generic text response to an object."
                let error = createError(SpeechToTextConstants.domain, description: description)
                failure(error)
            }
            return
        }

        switch response {
        case .State(let state): onState(state)
        case .Results(let wrapper): onResults(wrapper)
        case .Error(let error): onServiceError(error)
        }
    }

    private func onData(data: NSData) {
        return
    }

    private func onSocketError(error: NSError) {
        socket.disconnect()
        if let failure = failure {
            failure(error)
        }
    }

    // MARK: Helper Functions: Parse Generic Response

    private func onState(state: SpeechToTextState) {
        return
    }

    private func onResults(wrapper: SpeechToTextResultWrapper) {
        updateResultsArray(wrapper)
        success(results)
    }

    private func updateResultsArray(wrapper: SpeechToTextResultWrapper) {
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
    }

    private func onServiceError(error: SpeechToTextError) {
        if let failure = failure {
            let error = createError(SpeechToTextConstants.domain, description: error.error)
            failure(error)
        }
    }
}
