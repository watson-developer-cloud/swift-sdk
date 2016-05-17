
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

import XCTest
import WatsonDeveloperCloud
import Freddy

class ConversationTests: XCTestCase {

    // MARK: - Parameters and constants

    // the Conversation service
    var service:     Conversation!
    var workspaceID: Conversation.WorkspaceID! = "car_demo_1"

    // the initial node and response from Watson
    let initialMessage = "Hello"
    let initialResponse = "Welcome to the Watson Car Demo..."

    let secondMessage = "Turn on wipers"
    let secondResponse = "Your wipers are now on"
    
    // invalid parameters for negative tests
    let invalidWorkspaceID = "9354b734-d5b2-4fd3-bee0-e38adbcab575"

    // timeout for asynchronous completion handlers
    private let timeout: NSTimeInterval = 30.0

    // MARK: - Conversation Tests

    /// Test the Conversation service by executing each operation with valid parameters.
    func testConversation() {

        // Send a test message with no history/context
        sendInitialMessageNoContext()

        // Send a test message with no history/context, and then send a follow-up message
        sendMessageWithContext()
        
        // verify error conditions
        executeNegativeTests()
    }

    /// Test the Conversation service by executing each operation with invalid parameters.
    func executeNegativeTests() {

    }

    // MARK: - Helper functions

    /// Load credentials and instantiate Dialog service
    override func setUp() {
        super.setUp()

        // identify credentials file
        let bundle = NSBundle(forClass: self.dynamicType)
        guard let url = bundle.pathForResource("Credentials", ofType: "plist") else {
            XCTFail("Unable to locate credentials file.")
            return
        }

        // load credentials from file
        let dict = NSDictionary(contentsOfFile: url)
        guard let credentials = dict as? Dictionary<String, String> else {
            XCTFail("Unable to read credentials file.")
            return
        }

        // read Dialog username
        guard let username = credentials["ConversationUsername"] else {
            XCTFail("Unable to read Conversation username.")
            return
        }

        // read Dialog password
        guard let password = credentials["ConversationPassword"] else {
            XCTFail("Unable to read Conversation password.")
            return
        }

        // instantiate the service
        if service == nil {
            service = Conversation(username: username, password: password)
        }
    }

    /// Wait for an expectation to be fulfilled.
    func waitForExpectation() {
        waitForExpectationsWithTimeout(timeout) { error in
            XCTAssertNil(error, "Timeout.")
        }
    }

    // MARK: - Positive tests

    /// Create the Dialog application
    func sendInitialMessageNoContext() {
        let description = "Sending first message with no context."
        let expectation = expectationWithDescription(description)

        sendInitialMessage() {
            (response) in
                expectation.fulfill()
            }

        waitForExpectation()
    }
    
    /// Create the Dialog application
    func sendMessageWithContext() {
        let description = "Sending first message with no context."
        let expectation = expectationWithDescription(description)
        
        sendInitialMessage() {
            (response) in
            self.sendFollowupMessage(response) {
                (followupResponse) in
                expectation.fulfill()
            }
        }
        
        waitForExpectation()
    }
    
    private func sendInitialMessage(completion: (result: MessageResponse) -> Void) {
        service.sendText(
            initialMessage,
            context: nil,
            workspaceID: workspaceID,
            failure: { (error) in
                XCTAssertNil(error)
        }) { (response) in
            XCTAssertNotNil(response)
            XCTAssertNotNil(response.output)
            
            guard let output = response.output else {
                XCTFail("No suitable output found in response payload")
                return
            }
            
            let text = output["text"];
            XCTAssertNotNil(text)
            
            do {
                guard let outputText = try text?.string() else {
                    XCTFail("Could not find text from response output")
                    return
                }
                
                XCTAssertEqual(outputText, self.initialResponse)
                
                completion(result: response)
            }
            catch {
                XCTFail("Could not decode text from response output")
            }
        }
    }
    
    private func sendFollowupMessage(lastResponse: MessageResponse, completion: (result: MessageResponse) -> Void) {
        
        guard let previousContext = lastResponse.context else {
            XCTFail("No suitable context found in response")
            return
        }
        
        
        service.sendText(
            secondMessage,
            context: previousContext,
            workspaceID: workspaceID,
            failure: { (error) in
                XCTAssertNil(error)
        }) { (response) in
            XCTAssertNotNil(response)
            XCTAssertNotNil(response.output)
            
            guard let output = response.output else {
                XCTFail("No suitable output found in response payload")
                return
            }
            
            let text = output["text"];
            XCTAssertNotNil(text)
            
            do {
                guard let outputText = try text?.string() else {
                    XCTFail("Could not find text from response output")
                    return
                }
                
                XCTAssertEqual(outputText, self.secondResponse)
                
                completion(result: response)
            }
            catch {
                XCTFail("Could not decode text from response output")
            }
        }
    }
}
