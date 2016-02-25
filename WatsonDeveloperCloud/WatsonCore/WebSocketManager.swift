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

// TODO: Should the writeX() functions add operation to queue if connectWithToken() fails?

class WebSocketManager {

    private let authStrategy: AuthenticationStrategy
    private let operations = NSOperationQueue()
    private let socket: WebSocket
    private var isConnecting = false
    private var retries = 0
    private var maxRetries = 1

    var onText: (String -> Void)?
    var onData: (NSData -> Void)?
    var onError: (NSError -> Void)?

    init(authStrategy: AuthenticationStrategy, url: NSURL, protocols: [String]? = nil) {
        self.authStrategy = authStrategy

        operations.maxConcurrentOperationCount = 1
        operations.suspended = true

        socket = WebSocket(url: url, protocols: protocols)
        socket.onConnect = {
            self.operations.suspended = false
            self.isConnecting = false
            self.retries = 0
        }
        socket.onDisconnect = { error in
            self.operations.suspended = true
            self.isConnecting = false
            if self.isAuthenticationFailure(error) {
                self.connectWithToken()
            } else if let error = error {
                self.onError?(error)
            }
        }
        socket.onText = { text in
            self.onText?(text)
        }
        socket.onData = { data in
            self.onData?(data)
        }
        connectWithToken()
    }

    func writeData(data: NSData) {
        if !socket.isConnected {
            connectWithToken()
        }
        operations.addOperationWithBlock {
            self.socket.writeData(data)
        }
    }

    func writeString(str: String) {
        if !socket.isConnected {
            connectWithToken()
        }
        operations.addOperationWithBlock {
            self.socket.writeString(str)
        }
    }

    func writePing(data: NSData) {
        if !socket.isConnected {
            connectWithToken()
        }
        operations.addOperationWithBlock {
            self.socket.writePing(data)
        }
    }

    func disconnect(forceTimeout: NSTimeInterval? = nil) {
        if !operations.suspended {
            operations.waitUntilAllOperationsAreFinished()
        }
        socket.disconnect(forceTimeout: forceTimeout)
    }

    private func connectWithToken() {
        guard !isConnecting else {
            return
        }

        guard retries++ < maxRetries else {
            let domain = "WebSocketManager.swift"
            let code = -1
            let description = "Invalid HTTP upgrade. Please verify your credentials."
            let userInfo = [NSLocalizedDescriptionKey: description]
            let error = NSError(domain: domain, code: code, userInfo: userInfo)
            onError?(error)
            return
        }

        if let token = authStrategy.token where retries == 0 {
            self.socket.headers["X-Watson-Authorization-Token"] = token
            isConnecting = true
            self.socket.connect()
        } else {
            authStrategy.refreshToken { error in
                guard error == nil else {
                    if let error = error {
                        self.onError?(error)
                    }
                    return
                }
                guard let token = self.authStrategy.token else {
                    let domain = "WebSocketManager.swift"
                    let code = -1
                    let description = "Could not obtain an authentication token."
                    let userInfo = [NSLocalizedDescriptionKey: description]
                    let error = NSError(domain: domain, code: code, userInfo: userInfo)
                    self.onError?(error)
                    return
                }
                self.socket.headers["X-Watson-Authorization-Token"] = token
                self.isConnecting = true
                self.socket.connect()
            }
        }
    }

    private func isAuthenticationFailure(error: NSError?) -> Bool {
        // TODO: check for 401 error code
        return false
    }
}
