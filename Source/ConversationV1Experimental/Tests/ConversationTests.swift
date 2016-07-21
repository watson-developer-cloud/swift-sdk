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
import ConversationV1Experimental

class ConversationTests: XCTestCase {
    
    private var conversation: Conversation!
    private let timeout: NSTimeInterval = 5.0

    // MARK: - Test Configuration

    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateConversation()
    }

    /** Instantiate Conversation. */
    func instantiateConversation() {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard
            let file = bundle.pathForResource("Credentials", ofType: "plist"),
            let credentials = NSDictionary(contentsOfFile: file) as? [String: String],
            let username = credentials["ConversationExperimentalUsername"],
            let password = credentials["ConversationExperimentalPassword"]
            else {
                XCTFail("Unable to read credentials.")
                return
        }
        conversation = Conversation(username: username, password: password, version: "2016-06-16")
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
    
    func testMessage() {
        let description = "Send a message and verify the response."
        let expectation = expectationWithDescription(description)
        
        let workspace = "9c507471-ab3f-4011-9ceb-4e730b650b02"
        let message = "Turn the wipers on."
        conversation.message(workspace, message: message, failure: failWithError) { response in
            // verify intents
            guard let intents = response.intents else {
                XCTFail("No suitable intents object found in response payload")
                return
            }
            XCTAssertFalse(intents.isEmpty)
            
            // verify first intent
            let topIntent = intents.first
            XCTAssertEqual(topIntent?.intent, "turn_on")
            XCTAssert(topIntent?.confidence >= 0.0)
            XCTAssert(topIntent?.confidence <= 1.0)
            
            // verify entities
            XCTAssert(response.entities?.isEmpty == true)
            
            expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Negative Tests

    func testMessageInvalidWorkspace() {
        let description = "Send a message to an invalid workspace."
        let expectation = expectationWithDescription(description)
        
        let workspaceID = "this-id-is-invalid"
        let message = "Turn the wipers on."
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        conversation.message(workspaceID, message: message, failure: failure, success: failWithResult)
        waitForExpectations()
    }
}
