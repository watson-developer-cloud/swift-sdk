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

internal class SpeechToTextSocket {
    
    private(set) internal var results = [TranscriptionResult]()
    private(set) internal var state: SpeechToTextState = .Disconnected
    
    internal var onConnect: (Void -> Void)? = nil
    internal var onListening: (Void -> Void)? = nil
    internal var onResults: ([TranscriptionResult] -> Void)? = nil
    internal var onError: (NSError -> Void)? = nil
    internal var onDisconnect: (Void -> Void)? = nil
    
    private let socket: WebSocket
    private let queue = NSOperationQueue()
    private let restToken: RestToken
    private var tokenRefreshes = 0
    private let maxTokenRefreshes = 1
    private let userAgent = buildUserAgent("watson-apis-ios-sdk/0.6.0 SpeechToTextV1")
    private let domain = "com.ibm.watson.developer-cloud.SpeechToTextV1"
    
    internal init(
        username: String,
        password: String,
        model: String?,
        learningOptOut: Bool?,
        serviceURL: String = "https://stream.watsonplatform.net/speech-to-text/api",
        tokenURL: String = "https://stream.watsonplatform.net/authorization/api/v1/token",
        websocketsURL: String = "wss://stream.watsonplatform.net/speech-to-text/api/v1/recognize")
    {
        // initialize authentication token
        let tokenURL = tokenURL + "?url=" + serviceURL
        restToken = RestToken(tokenURL: tokenURL, username: username, password: password)
        
        // build url with options
        let url = SpeechToTextSocket.buildURL(websocketsURL, model: model, learningOptOut: learningOptOut)!
        
        // initialize socket
        socket = WebSocket(url: url)
        socket.delegate = self
        
        // configure operation queue
        queue.maxConcurrentOperationCount = 1
        queue.suspended = true
    }
    
    internal func connect() {
        print("connecting")
        
        // ensure the socket is not already connected
        guard state == .Disconnected else {
            return
        }
        
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
            print("refreshing token")
            restToken.refreshToken(onError) {
                self.tokenRefreshes += 1
                self.connect()
            }
            return
        }
        
        // connect with token
        socket.headers["X-Watson-Authorization-Token"] = token
        socket.headers["User-Agent"] = userAgent
        socket.connect()
    }
    
    internal func writeStart(settings: TranscriptionSettings) {
        print("queueing start message")
        guard let start = try? settings.toJSON().serializeString() else {
            return
        }
        queue.addOperationWithBlock {
            print("writing start")
            self.socket.writeString(start)
            if self.state != .Disconnected {
                self.state = .Listening
                self.onListening?()
            }
        }
    }
    
    internal func writeAudio(audio: NSData) {
        print("queueing audio write")
        queue.addOperationWithBlock {
            print("writing audio")
            self.socket.writeData(audio)
            if self.state == .Listening {
                self.state = .SentAudio
            }
        }
    }
    
    internal func writeStop() {
        print("queueing stop message")
        guard let stop = try? TranscriptionStop().toJSON().serializeString() else {
            return
        }
        queue.addOperationWithBlock {
            print("writing stop")
            self.socket.writeString(stop)
        }
    }
    
    internal func writeNop() {
        let nop = "{\"action\": \"no-op\"}"
        queue.addOperationWithBlock {
            print("writing stop")
            self.socket.writeString(nop)
        }
    }
    
    internal func waitForResults() {
        print("queueing wait for results")
        queue.addOperationWithBlock {
            print("waiting for results")
            switch self.state {
            case .Connected: return // no results to wait for
            case .Listening: return // no results to wait for
            case .Disconnected: return // no results to wait for
            default:
                self.queue.suspended = true
                let onListeningCache = self.onListening
                self.onListening = {
                    self.onListening = onListeningCache
                    self.queue.suspended = false
                }
            }
        }
    }
    
    internal func disconnect(forceTimeout: NSTimeInterval? = nil) {
        print("queueing disconnect")
        queue.addOperationWithBlock {
            print("disconnecting")
            self.queue.suspended = true
            self.socket.disconnect(forceTimeout: forceTimeout)
        }
    }
    
    private static func buildURL(url: String, model: String?, learningOptOut: Bool?) -> NSURL? {
        var queryParameters = [NSURLQueryItem]()
        if let model = model {
            queryParameters.append(NSURLQueryItem(name: "model", value: model))
        }
        if let learningOptOut = learningOptOut {
            let value = "\(learningOptOut)"
            queryParameters.append(NSURLQueryItem(name: "x-watson-learning-opt-out", value: value))
        }
        let urlComponents = NSURLComponents(string: url)
        urlComponents?.queryItems = queryParameters
        return urlComponents?.URL
    }

    private func onStateMessage(state: TranscriptionState) {
        if state.state == "listening" && self.state == .Transcribing {
            self.state = .Listening
            onListening?()
        }
    }
    
    private func onResultsMessage(wrapper: TranscriptionResultWrapper) {
        state = .Transcribing
        var resultsIndex = wrapper.resultIndex
        var wrapperIndex = 0
        while resultsIndex < results.count && wrapperIndex < wrapper.results.count {
            results[resultsIndex] = wrapper.results[wrapperIndex]
            resultsIndex += 1
            wrapperIndex += 1
        }
        while wrapperIndex < wrapper.results.count {
            results.append(wrapper.results[wrapperIndex])
            wrapperIndex += 1
        }
        onResults?(results)
    }
    
    private func onErrorMessage(error: String) {
        let failureReason = error
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        let error = NSError(domain: domain, code: 0, userInfo: userInfo)
        onError?(error)
    }
    
    private func isAuthenticationFailure(error: NSError) -> Bool {
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
    
    private func isNormalDisconnect(error: NSError) -> Bool {
        guard let description = error.userInfo[NSLocalizedDescriptionKey] as? String else {
            return false
        }
        
        let matchesDomain = (error.domain == "WebSocket")
        let matchesCode = (error.code == 1000)
        let matchesDescription = (description == "connection closed by server")
        if matchesDomain && matchesCode && matchesDescription {
            return true
        }
        return false
    }
}

// MARK: - WebSocket Delegate
extension SpeechToTextSocket: WebSocketDelegate {
    
    internal func websocketDidConnect(socket: WebSocket) {
        print("did connect")
        state = .Connected
        tokenRefreshes = 0
        queue.suspended = false
        results = [TranscriptionResult]()
        onConnect?()
    }
    
    internal func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        return // should not receive any binary data from the service
    }
    
    internal func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("did receive message: \(text)")
        guard let json = try? JSON(jsonString: text) else {
            return
        }
        if let state = try? json.decode(type: TranscriptionState.self) {
            onStateMessage(state)
        }
        if let results = try? json.decode(type: TranscriptionResultWrapper.self) {
            onResultsMessage(results)
        }
        if let error = try? json.string("error") {
            onErrorMessage(error)
        }
    }
    
    internal func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("did disconnect: \(error)")
        state = .Disconnected
        guard let error = error else {
            onDisconnect?()
            return
        }
        if isNormalDisconnect(error) {
            onDisconnect?()
            return
        }
        if isAuthenticationFailure(error) {
            restToken.refreshToken(onError) {
                self.tokenRefreshes += 1
                self.connect()
            }
            return
        }
        onError?(error)
        onDisconnect?()
    }
}
