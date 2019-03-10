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
import RestKit

internal class SpeechToTextSocket: WebSocketDelegate {

    private(set) internal var results = SpeechRecognitionResults()
    private(set) internal var state: SpeechToTextState = .disconnected

    internal var onConnect: (() -> Void)?
    internal var onListening: (() -> Void)?
    internal var onResults: ((SpeechRecognitionResults) -> Void)?
    internal var onError: ((WatsonError) -> Void)?
    internal var onDisconnect: (() -> Void)?

    internal let url: URL
    private let authMethod: AuthenticationMethod
    private let maxConnectAttempts: Int
    private var connectAttempts: Int
    private let defaultHeaders: [String: String]

    private var socket: WebSocket
    private let queue: OperationQueue

    internal init(
        url: URL,
        authMethod: AuthenticationMethod,
        defaultHeaders: [String: String])
    {
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        self.socket = WebSocket(request: request)
        self.url = url
        self.authMethod = authMethod
        self.maxConnectAttempts = 1
        self.connectAttempts = 0
        self.defaultHeaders = defaultHeaders
        self.queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.isSuspended = true
    }

    internal func connect() {
        // ensure the socket is not already connected
        guard state == .disconnected || state == .connecting else {
            return
        }

        // flush operation queue
        if state == .disconnected {
            queue.cancelAllOperations()
        }

        // update state
        state = .connecting

        // restrict the number of retries
        guard connectAttempts <= maxConnectAttempts else {
            let failureReason = "Invalid HTTP upgrade. Check credentials."
            let error = WatsonError.http(statusCode: 400, message: failureReason, metadata: ["type": "Websocket"])
            onError?(error)
            return
        }

        // create request with headers
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        if let userAgentHeader = RestRequest.userAgent {
            request.setValue(userAgentHeader, forHTTPHeaderField: "User-Agent")
        }
        for (key, value) in defaultHeaders {
            request.addValue(value, forHTTPHeaderField: key)
        }

        authMethod.authenticate(request: request) {
            request, error in
            if let request = request {
                // initialize socket and connect
                self.socket = WebSocket(request: request)
                self.socket.delegate = self
                self.socket.connect()
            } else {
                self.onError?(error ?? WatsonError.http(statusCode: 400, message: "Token Manager error", metadata: nil))
            }
        }
    }

    internal func writeStart(settings: RecognitionSettings) {
        guard state != .disconnected else { return }
        guard let data = try? JSONEncoder().encode(settings) else { return }
        guard let start = String(data: data, encoding: .utf8) else { return }
        queue.addOperation {
            self.socket.write(string: start)
            self.results = SpeechRecognitionResults()
            if self.state != .disconnected {
                self.state = .listening
                self.onListening?()
            }
        }
    }

    internal func writeAudio(audio: Data) {
        guard state != .disconnected else { return }
        queue.addOperation {
            self.socket.write(data: audio)
            if self.state == .listening {
                self.state = .sentAudio
            }
        }
    }

    internal func writeStop() {
        guard state != .disconnected else { return }
        guard let data = try? JSONEncoder().encode(RecognitionStop()) else { return }
        guard let stop = String(data: data, encoding: .utf8) else { return }
        queue.addOperation {
            self.socket.write(string: stop)
        }
    }

    internal func waitForResults() {
        queue.addOperation {
            switch self.state {
            case .connecting, .connected, .listening, .disconnected:
                return // no results to wait for
            case .sentAudio, .transcribing:
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

    internal static func buildURL(
        url: String,
        model: String?,
        baseModelVersion: String?,
        languageCustomizationID: String?,
        acousticCustomizationID: String?,
        learningOptOut: Bool?,
        customerID: String?) -> URL?
    {
        var queryParameters = [URLQueryItem]()
        if let model = model {
            queryParameters.append(URLQueryItem(name: "model", value: model))
        }
        if let baseModelVersion = baseModelVersion {
            queryParameters.append(URLQueryItem(name: "base_model_version", value: baseModelVersion))
        }
        if let languageCustomizationID = languageCustomizationID {
            queryParameters.append(URLQueryItem(name: "language_customization_id", value: languageCustomizationID))
        }
        if let acousticCustomizationID = acousticCustomizationID {
            queryParameters.append(URLQueryItem(name: "acoustic_customization_id", value: acousticCustomizationID))
        }
        if let learningOptOut = learningOptOut {
            let value = "\(learningOptOut)"
            queryParameters.append(URLQueryItem(name: "x-watson-learning-opt-out", value: value))
        }
        if let customerID = customerID {
            let value = "customer_id=\(customerID)"
            queryParameters.append(URLQueryItem(name: "x-watson-metadata", value: value))
        }
        var urlComponents = URLComponents(string: url)
        if !queryParameters.isEmpty {
            urlComponents?.queryItems = queryParameters
        }
        return urlComponents?.url
    }

    private func onStateMessage(state: RecognitionState) {
        if state.state == "listening" && self.state == .transcribing {
            self.state = .listening
            onListening?()
        }
    }

    private func onResultsMessage(results: SpeechRecognitionResults) {
        state = .transcribing
        onResults?(results)
    }

    private func onErrorMessage(error: String) {
        let error = WatsonError.other(message: error, metadata: nil)
        onError?(error)
    }

    private func isAuthenticationFailure(error: Error) -> Bool {
        if let error = error as? WSError {
            let matchesCode = (error.code == 400)
            let matchesType     = (error.type == .upgradeError)
            return matchesCode && matchesType
        }
        return false
    }

    private func isNormalDisconnect(error: Error) -> Bool {
        guard let error = error as? WSError else { return false }
        return error.code == Int(CloseCode.normal.rawValue)
    }

    internal func websocketDidConnect(socket: WebSocketClient) {
        state = .connected
        connectAttempts = 0
        queue.isSuspended = false
        results = SpeechRecognitionResults()
        onConnect?()
    }

    internal func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        return // should not receive any binary data from the service
    }

    internal func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        guard let json = text.data(using: .utf8) else { return }
        let decoder = JSONDecoder()
        if let state = try? decoder.decode(RecognitionState.self, from: json) {
            onStateMessage(state: state)
        } else if let object = try? decoder.decode([String: String].self, from: json), let error = object["error"] {
            onErrorMessage(error: error)
        } else if let results = try? decoder.decode(SpeechRecognitionResults.self, from: json) {
            // all properties of `SpeechRecognitionResults` are optional, so this block will always
            // execute unless the message has already been parsed as a `RecognitionState` or error
            onResultsMessage(results: results)
        }
    }

    internal func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        state = .disconnected
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
            if let basicAuth = authMethod as? BasicAuthentication {
                // Clear the token to force a refresh (new token fetch)
                basicAuth.token = nil
            }
            self.connectAttempts += 1
            self.connect()
            return
        }
        onError?(WatsonError.other(message: String(describing: error), metadata: nil))
        onDisconnect?()
    }
}
