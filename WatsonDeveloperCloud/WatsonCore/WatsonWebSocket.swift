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

/**
 Abstracts a WebSockets connection. In particular, `WatsonWebSocket` internally manages the state
 of the connection and queues any operations requested while the socket is disconnected.
 */
class WatsonWebSocket {

    private let authStrategy: AuthenticationStrategy
    private let operations = NSOperationQueue()
    private let socket: WebSocket
    private var isConnecting = false
    private var isClosedByError = false
    private var retries = 0
    private var maxRetries = 2

    /// A function executed whenever text is received from the remote server.
    var onText: (String -> Void)?

    /// A function executed whenever data is received from the remote server.
    var onData: (NSData -> Void)?

    /// A function executed whenever an error is produced by the WebSockets connection.
    var onError: (NSError -> Void)?

    /**
     Create a `WatsonWebSocket`
    
     - parameter authStrategy: An `AuthenticationStrategy` that defines how to authenticate
        with a Watson Developer Cloud service. The `AuthenticationStrategy` is used internally
        to obtain tokens, refresh expired tokens, and maintain information about authentication
        state.
     - parameter url: The url of the remote server.
     - parameter protocols: The WebSockets protocols that should be used for this connection.
    
     - returns: A `WatsonWebSocket` that can be used to send text and data to the remote server.
     */
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
                self.isClosedByError = true
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

    /**
     Send data to the remote server.

     - parameter data: The data to send.
     */
    func writeData(data: NSData) {
        connectWithToken()
        if !isClosedByError {
            operations.addOperationWithBlock {
                self.socket.writeData(data)
            }
        }
    }

    /**
     Send text to the remote server.

     - parameter str: The text string to send.
     */
    func writeString(str: String) {
        connectWithToken()
        if !isClosedByError {
            operations.addOperationWithBlock {
                self.socket.writeString(str)
            }
        }
    }

    /**
     Send a ping to the remote server.

     - parameter data: The data to send.
     */
    func writePing(data: NSData) {
        connectWithToken()
        if !isClosedByError {
            operations.addOperationWithBlock {
                self.socket.writePing(data)
            }
        }
    }

    /**
     Disconnect from the remote server after all previous operations have been completed.
     */
    func disconnect() {
        connectWithToken()
        if !isClosedByError {
            operations.addOperationWithBlock {
                self.socket.disconnect()
            }
        }
    }

    /**
     Immediately disconnect from the remote server without waiting for outstanding operations to
     complete.

     - parameter forceTimeout: The time to wait for a graceful disconnect before forcing the
        connection to close.
     */
    func disconnectNow(forceTimeout: NSTimeInterval? = nil) {
        socket.disconnect(forceTimeout: forceTimeout)
    }

    /** Connect to the remote server using the provided authentication strategy. */
    private func connectWithToken() {
        guard !socket.isConnected && !isConnecting && !isClosedByError else {
            return
        }

        guard retries < maxRetries else {
            isClosedByError = true
            let domain = "swift.WebSocketManager"
            let description = "Invalid HTTP upgrade. Please verify your credentials."
            let error = createError(domain, description: description)
            onError?(error)
            return
        }

        self.retries += 1
        self.isConnecting = true

        if let token = authStrategy.token where retries == 1 {
            self.socket.headers["X-Watson-Authorization-Token"] = token
            self.socket.connect()
        } else {
            authStrategy.refreshToken { error in
                guard error == nil else {
                    self.isClosedByError = true
                    let domain = "swift.WebSocketManager"
                    let description = "Failed to obtain an authentication token. Check credentials."
                    let error = createError(domain, description: description)
                    self.onError?(error)
                    return
                }
                guard let token = self.authStrategy.token else {
                    self.isClosedByError = true
                    let domain = "swift.WebSocketManager"
                    let description = "Failed to obtain an authentication token. Check credentials."
                    let error = createError(domain, description: description)
                    self.onError?(error)
                    return
                }
                self.socket.headers["X-Watson-Authorization-Token"] = token
                self.socket.connect()
            }
        }
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
