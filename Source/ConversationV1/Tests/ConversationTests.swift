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
    
    private var conversation: Conversation!
    private let workspaceID = "8d869397-411b-4f0a-864d-a2ba419bb249"
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
            let username = credentials["ConversationUsername"],
            let password = credentials["ConversationPassword"]
            else {
                XCTFail("Unable to read credentials.")
                return
        }
        conversation = Conversation(username: username, password: password, version: "2016-07-19")
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
        let description1 = "Start a conversation."
        let expectation1 = expectationWithDescription(description1)
        
        let response1 = ["Hi. It looks like a nice drive today. What would you like me to do?"]
        let nodes1 = ["node_1_1467221909631"]
        
        var context: Context?
        conversation.message(workspaceID, failure: failWithError) {
            response in
            
            // verify input
            XCTAssertNil(response.input.text)
            
            // verify context
            XCTAssertNotNil(response.context.conversationID)
            XCTAssertNotEqual(response.context.conversationID, "")
            XCTAssertNotNil(response.context.system)
            XCTAssertEqual(response.context.system!.dialogStack, ["root"])
            XCTAssertEqual(response.context.system!.dialogTurnCounter, 1)
            XCTAssertEqual(response.context.system!.dialogRequestCounter, 1)
            
            // verify entities
            XCTAssertTrue(response.entities.isEmpty)
            
            // verify intents
            XCTAssertTrue(response.intents.isEmpty)
            
            // verify output
            XCTAssertTrue(response.output.logMessages.isEmpty)
            XCTAssertEqual(response.output.text, response1)
            XCTAssertEqual(response.output.nodesVisited, nodes1)
            
            context = response.context
            expectation1.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Continue a conversation."
        let expectation2 = expectationWithDescription(description2)
        
        let text = "Turn on the radio."
        let response2 = ["", "Sure thing! Which genre would you prefer? Jazz is my personal favorite.."]
        let nodes2 = ["node_1_1467232431348", "node_2_1467232480480", "node_1_1467994455318"]
        
        conversation.message(workspaceID, text: text, context: context, failure: failWithError) {
            response in
            
            // verify input
            XCTAssertEqual(response.input.text, text)
            
            // verify context
            XCTAssertEqual(response.context.conversationID, context!.conversationID)
            XCTAssertNotNil(response.context.system)
            XCTAssertEqual(response.context.system!.dialogStack, ["node_1_1467994455318"])
            XCTAssertEqual(response.context.system!.dialogTurnCounter, 2)
            XCTAssertEqual(response.context.system!.dialogRequestCounter, 2)
            
            // verify entities
            XCTAssertEqual(response.entities.count, 1)
            XCTAssertEqual(response.entities[0].entity, "appliance")
            XCTAssertEqual(response.entities[0].location?.startIndex, 12)
            XCTAssertEqual(response.entities[0].location?.endIndex, 17)
            XCTAssertEqual(response.entities[0].value, "music")
            
            // verify intents
            XCTAssertEqual(response.intents.count, 1)
            XCTAssertEqual(response.intents[0].intent, "turn_on")
            XCTAssert(response.intents[0].confidence >= 0.90)
            XCTAssert(response.intents[0].confidence <= 1.00)
            
            // verify output
            XCTAssertTrue(response.output.logMessages.isEmpty)
            XCTAssertEqual(response.output.text, response2)
            XCTAssertEqual(response.output.nodesVisited, nodes2)
            
            expectation2.fulfill()
        }
        waitForExpectations()
    }
    
    func testMessageAllFields1() {
        let description1 = "Start a conversation."
        let expectation1 = expectationWithDescription(description1)
        
        var context: Context?
        var entities: [Entity]?
        var intents: [Intent]?
        var output: OutputData?
        
        conversation.message(workspaceID, failure: failWithError) {
            response in
            context = response.context
            entities = response.entities
            intents = response.intents
            output = response.output
            expectation1.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Continue a conversation."
        let expectation2 = expectationWithDescription(description2)
        
        let input2 = InputData(text: "Turn on the radio.")
        conversation.message(workspaceID, input: input2, context: context, entities: entities, intents: intents, output: output, failure: failWithError) {
            response in
            
            // verify objects are non-nil
            XCTAssertNotNil(entities)
            XCTAssertNotNil(intents)
            XCTAssertNotNil(output)
            
            // verify intents are equal
            for i in 0..<response.intents.count {
                let intent1 = intents![i]
                let intent2 = response.intents[i]
                XCTAssertEqual(intent1.intent, intent2.intent)
                if intent1.confidence != nil && intent2.confidence != nil {
                    XCTAssertEqualWithAccuracy(intent1.confidence!, intent2.confidence!, accuracy: 10E-5)
                } else {
                    XCTAssertEqual(intent1.confidence, intent2.confidence)
                }
            }
            
            // verify entities are equal
            for i in 0..<response.entities.count {
                let entity1 = entities![i]
                let entity2 = response.entities[i]
                XCTAssertEqual(entity1.entity, entity2.entity)
                XCTAssertEqual(entity1.location?.startIndex, entity2.location?.startIndex)
                XCTAssertEqual(entity1.location?.endIndex, entity2.location?.endIndex)
                XCTAssertEqual(entity1.value, entity2.value)
            }
            
            expectation2.fulfill()
        }
        waitForExpectations()
    }
    
    func testMessageAllFields2() {
        let description1 = "Start a conversation."
        let expectation1 = expectationWithDescription(description1)
        
        var context: Context?
        var entities: [Entity]?
        var intents: [Intent]?
        var output: OutputData?
        
        conversation.message(workspaceID, failure: failWithError) {
            response in
            context = response.context
            expectation1.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Continue a conversation."
        let expectation2 = expectationWithDescription(description2)
        
        let text2 = "Turn on the radio."
        conversation.message(workspaceID, text: text2, context: context, failure: failWithError) {
            response in
            context = response.context
            entities = response.entities
            intents = response.intents
            output = response.output
            expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Continue a conversation with non-empty intents and entities."
        let expectation3 = expectationWithDescription(description3)
        
        let input3 = InputData(text: "Rock music.")
        conversation.message(workspaceID, input: input3, context: context, entities: entities, intents: intents, output: output, failure: failWithError) {
            response in
            
            // verify objects are non-nil
            XCTAssertNotNil(entities)
            XCTAssertNotNil(intents)
            XCTAssertNotNil(output)
            
            // verify intents are equal
            for i in 0..<response.intents.count {
                let intent1 = intents![i]
                let intent2 = response.intents[i]
                XCTAssertEqual(intent1.intent, intent2.intent)
                if intent1.confidence != nil && intent2.confidence != nil {
                    XCTAssertEqualWithAccuracy(intent1.confidence!, intent2.confidence!, accuracy: 10E-5)
                } else {
                    XCTAssertEqual(intent1.confidence, intent2.confidence)
                }
            }
            
            // verify entities are equal
            for i in 0..<response.entities.count {
                let entity1 = entities![i]
                let entity2 = response.entities[i]
                XCTAssertEqual(entity1.entity, entity2.entity)
                XCTAssertEqual(entity1.location?.startIndex, entity2.location?.startIndex)
                XCTAssertEqual(entity1.location?.endIndex, entity2.location?.endIndex)
                XCTAssertEqual(entity1.value, entity2.value)
            }
            
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Negative Tests

    func testMessageInvalidWorkspace() {
        let description = "Start a conversation with an invalid workspace."
        let expectation = expectationWithDescription(description)
        
        let workspaceID = "this-id-is-invalid"
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        conversation.message(workspaceID, failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
    func testMessageInvalidConversationID() {
        let description = "Continue a conversation with an invalid conversation id."
        let expectation = expectationWithDescription(description)
        
        let text = "Turn on the radio."
        let context = Context(conversationID: "this-id-is-invalid")
        conversation.message(workspaceID, text: text, context: context, failure: failWithError) {
            response in
            expectation.fulfill()
        }
        waitForExpectations()
    }
}
