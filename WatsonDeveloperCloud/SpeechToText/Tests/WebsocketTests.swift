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

import XCTest
@testable import WatsonDeveloperCloud

class WebsocketTests: XCTestCase {
    
    private let timeout: NSTimeInterval = 30.0

    private lazy var username: String = ""
    private lazy var password: String = ""
    
    var connectionExpectation: XCTestExpectation?
    var listeningExpectation: XCTestExpectation?
    var messageExpectation: XCTestExpectation?
    var disconnectExpectation: XCTestExpectation?

    override func setUp() {
        super.setUp()
        if let url = NSBundle(forClass: self.dynamicType).pathForResource("Credentials", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: url) as? Dictionary<String, String> {
                
                username = dict["SpeechToTextUsername"]!
                password = dict["SpeechToTextPassword"]!
                
            } else {
                XCTFail("Unable to extract dictionary from plist")
            }
        } else {
            XCTFail("Plist file not found")
        }
        
    }
    
    func testWatsonSockets() {
        
        let basicAuth = BasicAuthenticationStrategy(
            tokenURL: "https://stream.watsonplatform.net/authorization/api/v1/token",
            serviceURL: "https://stream.watsonplatform.net/speech-to-text/api",
            username: username,
            password: password)
        
        
        let socket = WatsonSocket(authStrategy: basicAuth)
        
        let url = NSBundle(forClass: self.dynamicType)
            .URLForResource("SpeechSample", withExtension: "flac")
        
        guard let audioData = NSData(contentsOfURL: url!) else {
            XCTFail("Need to read file")
            return
        }

        //connectionExpectation = expectationWithDescription("connection")
        //listeningExpectation = expectationWithDescription("listening")
        //messageExpectation = expectationWithDescription("receive message")
        disconnectExpectation = expectationWithDescription("disconnect")
        
        // let data = NSData()
        
        socket.delegate = SocketTestDelegate(socket: socket, disconnectExpectation: disconnectExpectation!)
        socket.format = .FLAC
        
        socket.send(audioData)
        
        if let ws = socket.socket {
            XCTAssertTrue(ws.isConnected, "Web socket is not connected")
        }
        
        waitForExpectationsWithTimeout(timeout) {
            error in XCTAssertNil(error, "Timeout")
        }
        
        
    }
    
    
    class SocketTestDelegate : WatsonSocketDelegate {
        
        let socket: WatsonSocket!
        
        var disconnectExpectation: XCTestExpectation?
        
        init(socket: WatsonSocket, disconnectExpectation: XCTestExpectation)
        {
            self.socket = socket
            self.disconnectExpectation = disconnectExpectation
        }
        
        func onMessageReceived(results: SpeechToText.SpeechToTextResponse) {
        
            Log.sharedLogger.info("Received: \(results)")
       
        
            //if results[0].alternatives![0].transcript?.characters.count > 1 {
        
                socket.disconnect()
            //}

        }
    
    func onConnected() {
        
        //connectionExpectation?.fulfill()
        
        XCTAssertFalse(socket.audioUploadQueue.suspended, "Audio upload queue should be running")
    }
    
    func onListening() {
        
        //listeningExpectation?.fulfill()
        XCTAssertTrue(socket.isListening, "Listening property should be set true")
        
        
    }
    
    func onDisconnected() {
    
        disconnectExpectation?.fulfill()
        
        XCTAssertTrue(socket.audioUploadQueue.suspended, "Audio queue should be suspended when disconnected")
        XCTAssertFalse(socket.isListening, "Listening property should be set false")
        
    }
        
    }

    
}