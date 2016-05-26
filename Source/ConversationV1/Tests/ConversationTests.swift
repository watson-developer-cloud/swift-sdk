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
import ConversationV1

class ConversationTests: XCTestCase {

    
    // MARK: - Parameters and constants
    
    // the Conversation service
    private var conversation: Conversation!
    private let workspaceID:  Conversation.WorkspaceID = "dc13b91f-1f56-4efa-81e4-79310c569cb5"
    
    // the initial node and response from Watson
    private let initialMessage = "Hello"
    private let initialResponse = "Welcome to the Watson Car Demo..."
    
    private let secondMessage = "Turn on wipers"
    private let secondResponse = "Your wipers are now on"
    
    private let firstIntentMessage  = "Turn the wipers on"
    private let firstIntentResponse = "turn_on"
    
    // invalid parameters for negative tests
    private let this_id_is_invalid = "9354b734-d5b2-4fd3-bee0-e38adbcab575"
    
    // timeout for asynchronous completion handlers
    private let timeout: NSTimeInterval = 30.0

    // MARK: - Test Configuration

    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateConversation()
    }

    /** Instantiate Language Translation. */
    func instantiateConversation() {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard
            let file = bundle.pathForResource("Credentials", ofType: "plist"),
            let credentials = NSDictionary(contentsOfFile: file) as? [String: String],
            let username = credentials["ConversationUsername"],
            let password = credentials["ConversationPassword"]
            else {
                XCTFail("Unable to read credentials.")
                return
        }
        conversation = Conversation(username: username, password: password)
    }

    /** Fail false negatives. */
    func failWithError(error: NSError) {
        XCTFail("Positive test failed with error: \(error)")
    }

    /** Fail false positives. */
    func failWithResult<T>(result: T) {
        XCTFail("Negative test returned a result.")
    }

    /** Wait for expectations. */
    func waitForExpectations() {
        waitForExpectationsWithTimeout(timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: - Positive Tests
    
    // MARK: - Intent tests
    func testIntentIsReturned() {
        let description = "Sending first message."
        let expectation = expectationWithDescription(description)
        
        conversation.sendText(
            workspaceID,
            message: firstIntentMessage,
            context: nil,
            failure: { (error) in
                XCTAssertNil(error)
        }) { (response) in
            XCTAssertNotNil(response)
            
            guard let intents = response.intents else {
                XCTFail("No suitable intents object found in response payload")
                return
            }
            
            XCTAssertFalse(intents.isEmpty)
            
            let topIntent = intents.first
            
            XCTAssertNotNil(topIntent)
        
            guard let outputText = topIntent?.intent else {
                XCTFail("Could not find intent string from the top intent")
                return
            }
            
            guard let confidence = topIntent?.confidence else {
                XCTFail("There is no confidence in the response")
                return
            }
            
            XCTAssert(confidence.isNormal)
            XCTAssertEqual(outputText, self.firstIntentResponse)
            
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    // MARK: - Dialog tests
    /*
     * Enable when Dialog is supported in this service
     *
    /// Create the Dialog application
    func testSendInitialMessageNoContext() {
        let description = "Sending first message with no context."
        let expectation = expectationWithDescription(description)
        
        conversation.sendText(
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
                
                expectation.fulfill()
            }
            catch {
                XCTFail("Could not decode text from response output")
            }
        }
        
        waitForExpectations()
    }
    
    /// Create the Dialog application
    func testSendMessageWithContext() {
        let description = "Sending first message with no context."
        let expectation = expectationWithDescription(description)
        
        conversation.sendText(
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
                
                guard let previousContext = response.context else {
                    XCTFail("No suitable context found in response")
                    return
                }
                
                
                self.conversation.sendText(
                    self.secondMessage,
                    context: previousContext,
                    workspaceID: self.workspaceID,
                    failure: { (error) in
                        XCTAssertNil(error)
                    })
                { (response) in
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
                    
                        expectation.fulfill()
                    }
                    catch {
                        XCTFail("Could not decode text from response output")
                    }
                }
            }
            catch {
                XCTFail("Could not decode text from response output")
            }
        }
        
        waitForExpectations()
    }
    */

    // MARK: - Negative Tests

    // TODO: Write negative tests.
}
