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

internal class SpeechToTextSocket: WebSocketDelegate {
    
    private(set) internal var results = SpeechRecognitionResults()
    private(set) internal var state: SpeechToTextState = .Disconnected
    
    internal var onConnect: (() -> Void)? = nil
    internal var onListening: (() -> Void)? = nil
    internal var onResults: ((SpeechRecognitionResults) -> Void)? = nil
    internal var onError: ((Error) -> Void)? = nil
    internal var onDisconnect: (() -> Void)? = nil
    
    private let url: URL
    private let restToken: RestToken
    private let maxTokenRefreshes: Int
    private var tokenRefreshes: Int
    private let defaultHeaders: [String: String]
    
    private var socket: WebSocket
    private let queue: OperationQueue
    
    internal init(
        url: URL,
        restToken: RestToken,
        defaultHeaders: [String: String])
    {
        self.url = url
        self.restToken = restToken
        self.maxTokenRefreshes = 1
        self.tokenRefreshes = 0
        self.defaultHeaders = defaultHeaders
        self.socket = WebSocket(url: url)
        self.queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.isSuspended = true
    }
    
    internal func connect() {
        // ensure the socket is not already connected
        guard state == .Disconnected || state == .Connecting else {
            return
        }
        
        // flush operation queue
        if state == .Disconnected {
            queue.cancelAllOperations()
        }
        
        // update state
        state = .Connecting
        
        // restrict the number of retries
        guard tokenRefreshes <= maxTokenRefreshes else {
            let failureReason = "Invalid HTTP upgrade. Check credentials?"
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: "WebSocket", code: 400, userInfo: userInfo)
            onError?(error)
            return
        }
        
        // refresh token, if necessary
        guard let token = restToken.token else {
            restToken.refreshToken(failure: onError) {
                self.tokenRefreshes += 1
                self.connect()
            }
            return
        }
        
        // create request with headers
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        request.addValue(RestRequest.userAgent, forHTTPHeaderField: "User-Agent")
        request.addValue(token, forHTTPHeaderField: "X-Watson-Authorization-Token")
        for (key, value) in defaultHeaders {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        // initialize socket and connect
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    internal func writeStart(settings: RecognitionSettings) {
        guard state != .Disconnected else { return }
        guard let start = try? settings.toJSON().serializeString() else { return }
        queue.addOperation {
            self.socket.write(string: start)
            self.results = SpeechRecognitionResults()
            if self.state != .Disconnected {
                self.state = .Listening
                self.onListening?()
            }
        }
    }
    
    internal func writeAudio(audio: Data) {
        guard state != .Disconnected else { return }
        queue.addOperation {
            self.socket.write(data: audio)
            if self.state == .Listening {
                self.state = .SentAudio
            }
        }
    }
    
    internal func writeStop() {
        guard state != .Disconnected else { return }
        guard let stop = try? RecognitionStop().toJSON().serializeString() else { return }
        queue.addOperation {
            self.socket.write(string: stop)
        }
    }
    
    internal func waitForResults() {
        queue.addOperation {
            switch self.state {
            case .Connecting, .Connected, .Listening, .Disconnected:
                return // no results to wait for
            case .SentAudio, .Transcribing:
                self.queue.isSuspended = true
                let onListeningCache = self.onListening
                self.onListening = {
                    self.onListening = onListeningCache
                    self.queue.isSuspended = false
                }
            }
        }
    }
    
    internal func disconnect(forceTimeout: TimeInterval? = nil) {
        queue.addOperation {
            self.queue.isSuspended = true
            self.queue.cancelAllOperations()
            self.socket.disconnect(forceTimeout: forceTimeout)
        }
    }
    
    internal static func buildURL(url: String, model: String?, customizationID: String?, learningOptOut: Bool?) -> URL? {
        var queryParameters = [URLQueryItem]()
        if let model = model {
            queryParameters.append(URLQueryItem(name: "model", value: model))
        }
        if let customizationID = customizationID {
            queryParameters.append(URLQueryItem(name: "customization_id", value: customizationID))
        }
        if let learningOptOut = learningOptOut {
            let value = "\(learningOptOut)"
            queryParameters.append(URLQueryItem(name: "x-watson-learning-opt-out", value: value))
        }
        var urlComponents = URLComponents(string: url)
        urlComponents?.queryItems = queryParameters
        return urlComponents?.url
    }

    private func onStateMessage(state: RecognitionState) {
        if state.state == "listening" && self.state == .Transcribing {
            self.state = .Listening
            onListening?()
        }
    }
    
    private func onResultsMessage(event: SpeechRecognitionEvent) {
        state = .Transcribing
        results.addResults(event: event)
        onResults?(results)
    }
    
    private func onErrorMessage(error: String) {
        let error = RestError.failure(0, error)
        onError?(error)
    }
    
    private func isAuthenticationFailure(error: Error) -> Bool {
        let error = error as NSError
        
        guard let description = error.userInfo[NSLocalizedDescriptionKey] as? String else {
            return false
        }
        
        let matchesDomain = (error.domain == "WebSocket")
        let matchesCode = (error.code == 400)
        let matchesDescription = (description == "Invalid HTTP upgrade")
        if matchesDomain && matchesCode && matchesDescription {
            return true
        }
        return false
    }
    
    private func isNormalDisconnect(error: Error) -> Bool {
        let error = error as NSError
        let matchesDomain = (error.domain == "WebSocket")
        let matchesCode = (error.code == 1000)
        if matchesDomain && matchesCode {
            return true
        }
        return false
    }
    
    internal func websocketDidConnect(socket: WebSocketClient) {
        state = .Connected
        tokenRefreshes = 0
        queue.isSuspended = false
        results = SpeechRecognitionResults()
        onConnect?()
    }
    
    internal func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        return // should not receive any binary data from the service
    }
    
    internal func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        guard let json = try? JSONWrapper(string: text) else {
            return
        }
        if let state = try? json.decode(type: RecognitionState.self) {
            onStateMessage(state: state)
        }
        if let event = try? json.decode(type: SpeechRecognitionEvent.self) {
            onResultsMessage(event: event)
        }
        if let error = try? json.getString(at: "error") {
            onErrorMessage(error: error)
        }
    }
    
    internal func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        state = .Disconnected
        queue.isSuspended = true
        guard let error = error else {
            onDisconnect?()
            return
        }
        if isNormalDisconnect(error: error) {
            onDisconnect?()
            return
        }
        if isAuthenticationFailure(error: error) {
            restToken.refreshToken(failure: onError) {
                self.tokenRefreshes += 1
                self.connect()
            }
            return
        }
        onError?(error)
        onDisconnect?()
    }
}
