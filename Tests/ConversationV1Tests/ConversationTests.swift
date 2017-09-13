/**
 * Copyright IBM Corporation 2016, 2017
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
import Foundation
import ConversationV1

class ConversationTests: XCTestCase {
    
    private var conversation: Conversation!
    private let workspaceID = "8d869397-411b-4f0a-864d-a2ba419bb249"

    // MARK: - Test Configuration

    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateConversation()
    }
    
    static var allTests : [(String, (ConversationTests) -> () throws -> Void)] {
        return [
            ("testMessage", testMessage),
            ("testMessageAllFields1", testMessageAllFields1),
            ("testMessageAllFields2", testMessageAllFields2),
            ("testMessageGetContextVariable", testMessageGetContextVariable),
            ("testListAllWorkspaces", testListAllWorkspaces),
            ("testListAllWorkspacesWithPageLimit1", testListAllWorkspacesWithPageLimit1),
            ("testListAllWorkspacesWithIncludeCount", testListAllWorkspacesWithIncludeCount),
            ("testCreateAndDeleteWorkspace", testCreateAndDeleteWorkspace),
            ("testListSingleWorkspace", testListSingleWorkspace),
            ("testCreateUpdateAndDeleteWorkspace", testCreateUpdateAndDeleteWorkspace),
            ("testListAllIntents", testListAllIntents),
            ("testListAllIntentsWithIncludeCount", testListAllIntentsWithIncludeCount),
            ("testListAllIntentsWithPageLimit1", testListAllIntentsWithPageLimit1),
            ("testListAllIntentsWithExport", testListAllIntentsWithExport),
            ("testCreateAndDeleteIntent", testCreateAndDeleteIntent),
            ("testGetIntentWithExport", testGetIntentWithExport),
            ("testCreateUpdateAndDeleteIntent", testCreateUpdateAndDeleteIntent),
            ("testListAllExamples", testListAllExamples),
            ("testListAllExamplesWithIncludeCount", testListAllExamplesWithIncludeCount),
            ("testListAllExamplesWithPageLimit1", testListAllExamplesWithPageLimit1),
            ("testCreateAndDeleteExample", testCreateAndDeleteExample),
            ("testGetExample", testGetExample),
            ("testCreateUpdateAndDeleteExample", testCreateUpdateAndDeleteExample),
            ("testListAllCounterexamples", testListAllCounterexamples),
            ("testListAllCounterexamplesWithIncludeCount", testListAllCounterexamplesWithIncludeCount),
            ("testListAllCounterexamplesWithPageLimit1", testListAllCounterexamplesWithPageLimit1),
            ("testCreateAndDeleteCounterexample", testCreateAndDeleteCounterexample),
            ("testGetCounterexample", testGetCounterexample),
            ("testCreateUpdateAndDeleteCounterexample", testCreateUpdateAndDeleteCounterexample),
            ("testListAllEntities", testListAllEntities),
            ("testListAllEntitiesWithIncludeCount", testListAllEntitiesWithIncludeCount),
            ("testListAllEntitiesWithPageLimit1", testListAllEntitiesWithPageLimit1),
            ("testListAllEntitiesWithExport", testListAllEntitiesWithExport),
            ("testCreateAndDeleteEntity", testCreateAndDeleteEntity),
            ("testCreateUpdateAndDeleteEntity", testCreateUpdateAndDeleteEntity),
            ("testGetEntity", testGetEntity),
            ("testListAllValues", testListAllValues),
            ("testCreateUpdateAndDeleteValue", testCreateUpdateAndDeleteValue),
            ("testGetValue", testGetValue),
            ("testListAllSynonym", testListAllSynonym),
            ("testListAllSynonymWithIncludeCount", testListAllSynonymWithIncludeCount),
            ("testListAllSynonymWithPageLimit1", testListAllSynonymWithPageLimit1),
            ("testCreateAndDeleteSynonym", testCreateAndDeleteSynonym),
            ("testGetSynonym", testGetSynonym),
            ("testCreateUpdateAndDeleteSynonym", testCreateUpdateAndDeleteSynonym),
            ("testListLogs", testListLogs),
            ("testMessageUnknownWorkspace", testMessageUnknownWorkspace),
            ("testMessageInvalidWorkspaceID", testMessageInvalidWorkspaceID)
        ]
    }

    /** Instantiate Conversation. */
    func instantiateConversation() {
        let username = Credentials.ConversationUsername
        let password = Credentials.ConversationPassword
        let version = "2017-05-26"
        conversation = Conversation(username: username, password: password, version: version)
        conversation.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        conversation.defaultHeaders["X-Watson-Test"] = "true"
    }

    /** Fail false negatives. */
    func failWithError(error: Error) {
        XCTFail("Positive test failed with error: \(error)")
    }

    /** Fail false positives. */
    func failWithResult<T>(result: T) {
        XCTFail("Negative test returned a result.")
    }
    
    /** Fail false positives. */
    func failWithResult() {
        XCTFail("Negative test returned a result.")
    }

    /** Wait for expectations. */
    func waitForExpectations(timeout: TimeInterval = 5.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: - Positive Tests
    
    func testMessage() {
        let description1 = "Start a conversation."
        let expectation1 = self.expectation(description: description1)
        
        let response1 = ["Hi. It looks like a nice drive today. What would you like me to do?"]
        let nodes1 = ["node_1_1467221909631"]
        
        var context: Context?
        conversation.message(withWorkspace: workspaceID, failure: failWithError) {
            response in
            
            // verify input
            XCTAssertNil(response.input)
            
            // verify context
            XCTAssertNotNil(response.context.conversationID)
            XCTAssertNotEqual(response.context.conversationID, "")
            XCTAssertNotNil(response.context.system)
            //XCTAssertEqual(response.context.system.dialogStack, ["root"])
            XCTAssertEqual(response.context.system.dialogTurnCounter, 1)
            XCTAssertEqual(response.context.system.dialogRequestCounter, 1)
            
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
        let expectation2 = self.expectation(description: description2)
        
        let text = "Turn on the radio."
        let request = MessageRequest(text: text, context: context!)
        let response2 = ["", "Sure thing! Which genre would you prefer? Jazz is my personal favorite.."]
        let nodes2 = ["node_1_1467232431348", "node_2_1467232480480", "node_1_1467994455318"]
        
        conversation.message(withWorkspace: workspaceID, request: request, failure: failWithError) {
            response in
            
            // verify input
            XCTAssertEqual(response.input!.text, text)
            
            // verify context
            XCTAssertEqual(response.context.conversationID, context!.conversationID)
            XCTAssertNotNil(response.context.system)
            //XCTAssertEqual(response.context.system.dialogStack, ["node_1_1467994455318"])
            XCTAssertEqual(response.context.system.dialogTurnCounter, 2)
            XCTAssertEqual(response.context.system.dialogRequestCounter, 2)
            
            // verify entities
            XCTAssertEqual(response.entities.count, 1)
            XCTAssertEqual(response.entities[0].entity, "appliance")
            XCTAssertEqual(response.entities[0].startIndex, 12)
            XCTAssertEqual(response.entities[0].endIndex, 17)
            XCTAssertEqual(response.entities[0].value, "music")
            
            // verify intents
            XCTAssertEqual(response.intents.count, 1)
            XCTAssertEqual(response.intents[0].intent, "turn_on")
            XCTAssert(response.intents[0].confidence >= 0.80)
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
        let expectation1 = expectation(description: description1)
        
        var context: Context?
        var entities: [Entity]?
        var intents: [Intent]?
        var output: Output?
        
        conversation.message(withWorkspace: workspaceID, failure: failWithError) {
            response in
            context = response.context
            entities = response.entities
            intents = response.intents
            output = response.output
            expectation1.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Continue a conversation."
        let expectation2 = expectation(description: description2)
        
        let text2 = "Turn on the radio."
        let request2 = MessageRequest(text: text2, context: context, entities: entities, intents: intents, output: output)
        conversation.message(withWorkspace: workspaceID, request: request2, failure: failWithError) {
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
                XCTAssertEqual(intent1.confidence, intent2.confidence, accuracy: 10E-5)
            }
            
            // verify entities are equal
            for i in 0..<response.entities.count {
                let entity1 = entities![i]
                let entity2 = response.entities[i]
                XCTAssertEqual(entity1.entity, entity2.entity)
                XCTAssertEqual(entity1.startIndex, entity2.startIndex)
                XCTAssertEqual(entity1.endIndex, entity2.endIndex)
                XCTAssertEqual(entity1.value, entity2.value)
            }
            
            expectation2.fulfill()
        }
        waitForExpectations()
    }
    
    func testMessageAllFields2() {
        let description1 = "Start a conversation."
        let expectation1 = expectation(description: description1)
        
        var context: Context?
        var entities: [Entity]?
        var intents: [Intent]?
        var output: Output?
        
        conversation.message(withWorkspace: workspaceID, failure: failWithError) {
            response in
            context = response.context
            expectation1.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Continue a conversation."
        let expectation2 = expectation(description: description2)
        
        let text2 = "Turn on the radio."
        let request2 = MessageRequest(text: text2, context: context, entities: entities, intents: intents, output: output)
        conversation.message(withWorkspace: workspaceID, request: request2, failure: failWithError) {
            response in
            context = response.context
            entities = response.entities
            intents = response.intents
            output = response.output
            expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Continue a conversation with non-empty intents and entities."
        let expectation3 = expectation(description: description3)
        
        let text3 = "Rock music."
        let request3 = MessageRequest(text: text3, context: context, entities: entities, intents: intents, output: output)
        conversation.message(withWorkspace: workspaceID, request: request3, failure: failWithError) {
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
                XCTAssertEqual(intent1.confidence, intent2.confidence, accuracy: 10E-5)
            }
            
            // verify entities are equal
            for i in 0..<response.entities.count {
                let entity1 = entities![i]
                let entity2 = response.entities[i]
                XCTAssertEqual(entity1.entity, entity2.entity)
                XCTAssertEqual(entity1.startIndex, entity2.startIndex)
                XCTAssertEqual(entity1.endIndex, entity2.endIndex)
                XCTAssertEqual(entity1.value, entity2.value)
            }
            
            expectation3.fulfill()
        }
        waitForExpectations()
    }
    
    func testMessageGetContextVariable() {
        let description1 = "Start a conversation."
        let expectation1 = expectation(description: description1)
        
        var context: Context?
        conversation.message(withWorkspace: workspaceID, failure: failWithError) {
            response in
            context = response.context
            expectation1.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Continue a conversation."
        let expectation2 = expectation(description: description2)
        
        let text2 = "Turn on the radio."
        let request2 = MessageRequest(text: text2, context: context)
        conversation.message(withWorkspace: workspaceID, request: request2, failure: failWithError) {
            response in
            let reprompt = response.context.json["reprompt"] as? Bool
            XCTAssertNotNil(reprompt)
            XCTAssertTrue(reprompt!)
            expectation2.fulfill()
        }
        waitForExpectations()
    }
    
    // MARK: - Workspaces
    
    func testListAllWorkspaces() {
        let description = "List all workspaces."
        let expectation = self.expectation(description: description)
        
        conversation.listWorkspaces(failure: failWithError) { workspaceResponse in
            for workspace in workspaceResponse.workspaces {
                XCTAssertNotNil(workspace.name)
                XCTAssertNotNil(workspace.created)
                XCTAssertNotNil(workspace.updated)
                XCTAssertNotNil(workspace.language)
                //XCTAssertNotNil(workspace.metadata)
                XCTAssertNotNil(workspace.workspaceID)
            }
            XCTAssertNotNil(workspaceResponse.pagination.refreshUrl)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testListAllWorkspacesWithPageLimit1() {
        let description = "List all workspaces with page limit specified as 1."
        let expectation = self.expectation(description: description)
        
        conversation.listWorkspaces(pageLimit: 1, failure: failWithError) { workspaceResponse in
            XCTAssertEqual(workspaceResponse.workspaces.count, 1)
            for workspace in workspaceResponse.workspaces {
                XCTAssertNotNil(workspace.name)
                XCTAssertNotNil(workspace.created)
                XCTAssertNotNil(workspace.updated)
                XCTAssertNotNil(workspace.language)
                XCTAssertNotNil(workspace.metadata)
                XCTAssertNotNil(workspace.workspaceID)
            }
            XCTAssertNotNil(workspaceResponse.pagination.refreshUrl)
            XCTAssertNotNil(workspaceResponse.pagination.nextUrl)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testListAllWorkspacesWithIncludeCount() {
        let description = "List all workspaces with includeCount as true."
        let expectation = self.expectation(description: description)
        
        conversation.listWorkspaces(includeCount: true, failure: failWithError) { workspaceResponse in
            for workspace in workspaceResponse.workspaces {
                XCTAssertNotNil(workspace.name)
                XCTAssertNotNil(workspace.created)
                XCTAssertNotNil(workspace.updated)
                XCTAssertNotNil(workspace.language)
                //XCTAssertNotNil(workspace.metadata)
                XCTAssertNotNil(workspace.workspaceID)
            }
            XCTAssertNotNil(workspaceResponse.pagination.refreshUrl)
            XCTAssertNotNil(workspaceResponse.pagination.total)
            XCTAssertNotNil(workspaceResponse.pagination.matched)
            XCTAssertEqual(workspaceResponse.pagination.total, workspaceResponse.workspaces.count)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testCreateAndDeleteWorkspace() {
        var newWorkspace: String?
        
        let description1 = "Create a workspace."
        let expectation1 = expectation(description: description1)

        let workspaceName = "swift-sdk-test-workspace"
        let workspaceDescription = "temporary workspace for the swift sdk unit tests"
        let workspaceLanguage = "en"
        var workspaceMetadata = [String: Any]()
        workspaceMetadata["testKey"] = "testValue"
        let intentExample = CreateExample(text: "This is an example of Intent1")
        let workspaceIntent = CreateIntent(intent: "Intent1", description: "description of Intent1", examples: [intentExample])
        let entityValue = CreateValue(value: "Entity1Value", metadata: workspaceMetadata, synonyms: ["Synonym1", "Synonym2"])
        let workspaceEntity = CreateEntity(entity: "Entity1", description: "description of Entity1", values: [entityValue])
        //let workspaceDialogNode = CreateDialogNode(dialogNode: "DialogNode1", description: "description of DialogNode1")
        let workspaceCounterexample = CreateExample(text: "This is a counterexample")
        
        let createWorkspaceBody = CreateWorkspace(name: workspaceName, description: workspaceDescription, language: workspaceLanguage, intents: [workspaceIntent], entities: [workspaceEntity], dialogNodes: nil, counterexamples: [workspaceCounterexample],metadata: workspaceMetadata)
        
        conversation.createWorkspace(body: createWorkspaceBody, failure: failWithError) { workspace in
            XCTAssertEqual(workspace.name, workspaceName)
            XCTAssertEqual(workspace.description, workspaceDescription)
            XCTAssertEqual(workspace.language, workspaceLanguage)
            XCTAssertNotNil(workspace.created)
            XCTAssertNotNil(workspace.updated)
            XCTAssertNotNil(workspace.workspaceID)
            
            newWorkspace = workspace.workspaceID
            expectation1.fulfill()
        }
        waitForExpectations(timeout: 10.0)
        
        guard let newWorkspaceID = newWorkspace else {
            XCTFail("Failed to get the ID of the newly created workspace.")
            return
        }
        
        let description2 = "Get the newly created workspace."
        let expectation2 = expectation(description: description2)
        
        conversation.getWorkspace(workspaceID: newWorkspaceID, export: true, failure: failWithError) { workspace in
            XCTAssertEqual(workspace.name, workspaceName)
            XCTAssertEqual(workspace.description, workspaceDescription)
            XCTAssertEqual(workspace.language, workspaceLanguage)
            XCTAssertNotNil(workspace.metadata)
            XCTAssertNotNil(workspace.created)
            XCTAssertNotNil(workspace.updated)
            XCTAssertEqual(workspace.workspaceID, newWorkspaceID)
            XCTAssertNotNil(workspace.status)
            
            XCTAssertNotNil(workspace.intents)
            for intent in workspace.intents! {
                XCTAssertEqual(intent.intent, workspaceIntent.intent)
                XCTAssertEqual(intent.description, workspaceIntent.description)
                XCTAssertNotNil(intent.created)
                XCTAssertNotNil(intent.updated)
                XCTAssertNotNil(intent.examples)
                for example in intent.examples! {
                    XCTAssertNotNil(example.created)
                    XCTAssertNotNil(example.updated)
                    XCTAssertEqual(example.text, intentExample.text)
                }
            }
            
            XCTAssertNotNil(workspace.counterexamples)
            for counterexample in workspace.counterexamples! {
                XCTAssertNotNil(counterexample.created)
                XCTAssertNotNil(counterexample.updated)
                XCTAssertEqual(counterexample.text, workspaceCounterexample.text)
            }
            
            expectation2.fulfill()
        }
        waitForExpectations(timeout: 10.0)
        
        let description3 = "Delete the newly created workspace."
        let expectation3 = expectation(description: description3)
        
        conversation.deleteWorkspace(workspaceID: newWorkspaceID, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }
    
    func testListSingleWorkspace() {
        let description = "List details of a single workspace."
        let expectation = self.expectation(description: description)
        
        conversation.getWorkspace(workspaceID: workspaceID, export: false, failure: failWithError) { workspace in
            XCTAssertNotNil(workspace.name)
            XCTAssertNotNil(workspace.created)
            XCTAssertNotNil(workspace.updated)
            XCTAssertNotNil(workspace.language)
            XCTAssertNotNil(workspace.metadata)
            XCTAssertNotNil(workspace.workspaceID)
            XCTAssertNotNil(workspace.status)
            XCTAssertNil(workspace.intents)
            XCTAssertNil(workspace.entities)
            XCTAssertNil(workspace.counterexamples)
            //XCTAssertNil(workspace.dialogNodes)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testCreateUpdateAndDeleteWorkspace() {
        var newWorkspace: String?
        
        let description1 = "Create a workspace."
        let expectation1 = expectation(description: description1)
        
        let workspaceName = "swift-sdk-test-workspace"
        let workspaceDescription = "temporary workspace for the swift sdk unit tests"
        let workspaceLanguage = "en"
        let createWorkspaceBody = CreateWorkspace(name: workspaceName, description: workspaceDescription, language: workspaceLanguage)
        conversation.createWorkspace(body: createWorkspaceBody, failure: failWithError) { workspace in
            XCTAssertEqual(workspace.name, workspaceName)
            XCTAssertEqual(workspace.description, workspaceDescription)
            XCTAssertEqual(workspace.language, workspaceLanguage)
            XCTAssertNotNil(workspace.created)
            XCTAssertNotNil(workspace.updated)
            XCTAssertNotNil(workspace.workspaceID)
            
            newWorkspace = workspace.workspaceID
            expectation1.fulfill()
        }
        waitForExpectations()
        
        guard let newWorkspaceID = newWorkspace else {
            XCTFail("Failed to get the ID of the newly created workspace.")
            return
        }
        let description2 = "Update the newly created workspace."
        let expectation2 = expectation(description: description2)
        
        let newWorkspaceName = "swift-sdk-test-workspace-2"
        let newWorkspaceDescription = "new description for the temporary workspace"
        
        let updateWorkspaceBody = UpdateWorkspace(name: newWorkspaceName, description: newWorkspaceDescription)
        conversation.updateWorkspace(workspaceID: newWorkspaceID, body: updateWorkspaceBody, failure: failWithError) { workspace in
            XCTAssertEqual(workspace.name, newWorkspaceName)
            XCTAssertEqual(workspace.description, newWorkspaceDescription)
            XCTAssertEqual(workspace.language, workspaceLanguage)
            XCTAssertNotNil(workspace.created)
            XCTAssertNotNil(workspace.updated)
            XCTAssertNotNil(workspace.workspaceID)
            expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Delete the newly created workspace."
        let expectation3 = expectation(description: description3)
        
        conversation.deleteWorkspace(workspaceID: newWorkspaceID, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }
    
    // MARK: - Intents
    
    func testListAllIntents() {
        let description = "List all the intents in a workspace."
        let expectation = self.expectation(description: description)

        conversation.listIntents(workspaceID: workspaceID, failure: failWithError) { intents in
            for intent in intents.intents {
                XCTAssertNotNil(intent.intent)
                XCTAssertNotNil(intent.created)
                XCTAssertNotNil(intent.updated)
                XCTAssertNil(intent.examples)
            }
            XCTAssertNotNil(intents.pagination.refreshUrl)
            XCTAssertNil(intents.pagination.nextUrl)
            XCTAssertNil(intents.pagination.total)
            XCTAssertNil(intents.pagination.matched)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testListAllIntentsWithIncludeCount() {
        let description = "List all the intents in a workspace with includeCount as true."
        let expectation = self.expectation(description: description)
        
        conversation.listIntents(workspaceID: workspaceID, includeCount: true, failure: failWithError) { intents in
            for intent in intents.intents {
                XCTAssertNotNil(intent.intent)
                XCTAssertNotNil(intent.created)
                XCTAssertNotNil(intent.updated)
                XCTAssertNil(intent.examples)
            }
            XCTAssertNotNil(intents.pagination.refreshUrl)
            XCTAssertNil(intents.pagination.nextUrl)
            XCTAssertNotNil(intents.pagination.total)
            XCTAssertNotNil(intents.pagination.matched)
            XCTAssertEqual(intents.pagination.total, intents.intents.count)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testListAllIntentsWithPageLimit1() {
        let description = "List all the intents in a workspace with pageLimit specified as 1."
        let expectation = self.expectation(description: description)
        
        conversation.listIntents(workspaceID: workspaceID, pageLimit: 1, failure: failWithError) { intents in
            XCTAssertEqual(intents.intents.count, 1)
            for intent in intents.intents {
                XCTAssertNotNil(intent.intent)
                XCTAssertNotNil(intent.created)
                XCTAssertNotNil(intent.updated)
                XCTAssertNil(intent.examples)
            }
            XCTAssertNotNil(intents.pagination.refreshUrl)
            XCTAssertNotNil(intents.pagination.nextUrl)
            XCTAssertNil(intents.pagination.total)
            XCTAssertNil(intents.pagination.matched)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testListAllIntentsWithExport() {
        let description = "List all the intents in a workspace with export as true."
        let expectation = self.expectation(description: description)
        
        conversation.listIntents(workspaceID: workspaceID, export: true, failure: failWithError) { intents in
            for intent in intents.intents {
                XCTAssertNotNil(intent.intent)
                XCTAssertNotNil(intent.created)
                XCTAssertNotNil(intent.updated)
                XCTAssertNotNil(intent.examples)
                for example in intent.examples! {
                    XCTAssertNotNil(example.created)
                    XCTAssertNotNil(example.updated)
                    XCTAssertNotNil(example.text)
                }
            }
            XCTAssertNotNil(intents.pagination.refreshUrl)
            XCTAssertNil(intents.pagination.nextUrl)
            XCTAssertNil(intents.pagination.total)
            XCTAssertNil(intents.pagination.matched)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testCreateAndDeleteIntent() {
        let description = "Create a new intent."
        let expectation = self.expectation(description: description)
        
        let newIntentName = "swift-sdk-test-intent" + UUID().uuidString
        let newIntentDescription = "description for \(newIntentName)"
        let example1 = CreateExample(text: "example 1 for \(newIntentName)")
        let example2 = CreateExample(text: "example 2 for \(newIntentName)")
        conversation.createIntent(workspaceID: workspaceID, intent: newIntentName, description: newIntentDescription, examples: [example1, example2], failure: failWithError) { intent in
            XCTAssertEqual(intent.intent, newIntentName)
            XCTAssertEqual(intent.description, newIntentDescription)
            XCTAssertNotNil(intent.created)
            XCTAssertNotNil(intent.updated)
            expectation.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Delete the new intent."
        let expectation2 = self.expectation(description: description2)

        conversation.deleteIntent(workspaceID: workspaceID, intent: newIntentName, failure: failWithError) {
            expectation2.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetIntentWithExport() {
        let description = "Get details of a specific intent."
        let expectation = self.expectation(description: description)
        
        conversation.getIntent(workspaceID: workspaceID, intent: "weather", export: true, failure: failWithError) { intent in
            XCTAssertNotNil(intent.intent)
            XCTAssertNotNil(intent.created)
            XCTAssertNotNil(intent.updated)
            XCTAssertNotNil(intent.examples)
            for example in intent.examples! {
                XCTAssertNotNil(example.created)
                XCTAssertNotNil(example.updated)
                XCTAssertNotNil(example.text)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testCreateUpdateAndDeleteIntent() {
        let description = "Create a new intent."
        let expectation = self.expectation(description: description)
        
        let newIntentName = "swift-sdk-test-intent" + UUID().uuidString
        let newIntentDescription = "description for \(newIntentName)"
        let example1 = CreateExample(text: "example 1 for \(newIntentName)")
        let example2 = CreateExample(text: "example 2 for \(newIntentName)")
        conversation.createIntent(workspaceID: workspaceID, intent: newIntentName, description: newIntentDescription, examples: [example1, example2], failure: failWithError) { intent in
            XCTAssertEqual(intent.intent, newIntentName)
            XCTAssertEqual(intent.description, newIntentDescription)
            XCTAssertNotNil(intent.created)
            XCTAssertNotNil(intent.updated)
            expectation.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Update the new intent."
        let expectation2 = self.expectation(description: description2)
        
        let updatedIntentName = "updated-name-for-\(newIntentName)"
        let updatedIntentDescription = "updated-description-for-\(newIntentName)"
        let updatedExample1 = CreateExample(text: "updated example for \(newIntentName)")
        conversation.updateIntent(workspaceID: workspaceID, intent: newIntentName, newIntent: updatedIntentName, newDescription: updatedIntentDescription, newExamples: [updatedExample1], failure: failWithError) { intent in
            XCTAssertEqual(intent.intent, updatedIntentName)
            XCTAssertEqual(intent.description, updatedIntentDescription)
            XCTAssertNotNil(intent.created)
            XCTAssertNotNil(intent.updated)
            expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Delete the new intent."
        let expectation3 = self.expectation(description: description3)
        
        conversation.deleteIntent(workspaceID: workspaceID, intent: updatedIntentName, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Examples
    
    func testListAllExamples() {
        let description = "List all the examples of an intent."
        let expectation = self.expectation(description: description)
        
        conversation.listExamples(workspaceID: workspaceID, intent: "weather", failure: failWithError) { examples in
            for example in examples.examples {
                XCTAssertNotNil(example.created)
                XCTAssertNotNil(example.updated)
                XCTAssertNotNil(example.text)
            }
            XCTAssertNotNil(examples.pagination.refreshUrl)
            XCTAssertNil(examples.pagination.total)
            XCTAssertNil(examples.pagination.matched)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testListAllExamplesWithIncludeCount() {
        let description = "List all the examples for an intent with includeCount as true."
        let expectation = self.expectation(description: description)
        
        conversation.listExamples(workspaceID: workspaceID, intent: "weather", includeCount: true, failure: failWithError) { examples in
            for example in examples.examples {
                XCTAssertNotNil(example.created)
                XCTAssertNotNil(example.updated)
                XCTAssertNotNil(example.text)
            }
            XCTAssertNotNil(examples.pagination.refreshUrl)
            XCTAssertNotNil(examples.pagination.total)
            XCTAssertNotNil(examples.pagination.matched)
            XCTAssertEqual(examples.pagination.total, examples.examples.count)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testListAllExamplesWithPageLimit1() {
        let description = "List all the examples for an intent with pageLimit specified as 1."
        let expectation = self.expectation(description: description)
        
        conversation.listExamples(workspaceID: workspaceID, intent: "weather", pageLimit: 1, failure: failWithError) { examples in
            XCTAssertEqual(examples.examples.count, 1)
            for example in examples.examples {
                XCTAssertNotNil(example.created)
                XCTAssertNotNil(example.updated)
                XCTAssertNotNil(example.text)
            }
            XCTAssertNotNil(examples.pagination.refreshUrl)
            XCTAssertNotNil(examples.pagination.nextUrl)
            XCTAssertNil(examples.pagination.total)
            XCTAssertNil(examples.pagination.matched)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testCreateAndDeleteExample() {
        let description = "Create a new example."
        let expectation = self.expectation(description: description)
        
        let newExample = "swift-sdk-test-example" + UUID().uuidString
        conversation.createExample(workspaceID: workspaceID, intent: "weather", text: newExample, failure: failWithError) { example in
            XCTAssertNotNil(example.created)
            XCTAssertNotNil(example.updated)
            XCTAssertEqual(example.text, newExample)
            expectation.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Delete the new example."
        let expectation2 = self.expectation(description: description2)
        
        conversation.deleteExample(workspaceID: workspaceID, intent: "weather", text: newExample, failure: failWithError) {
            expectation2.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetExample() {
        let description = "Get details of a specific example."
        let expectation = self.expectation(description: description)
        
        let exampleText = "tell me the weather"
        conversation.getExample(workspaceID: workspaceID, intent: "weather", text: exampleText, failure: failWithError) { example in
            XCTAssertNotNil(example.created)
            XCTAssertNotNil(example.updated)
            XCTAssertEqual(example.text, exampleText)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testCreateUpdateAndDeleteExample() {
        let description = "Create a new example."
        let expectation = self.expectation(description: description)
        
        let newExample = "swift-sdk-test-example" + UUID().uuidString
        conversation.createExample(workspaceID: workspaceID, intent: "weather", text: newExample, failure: failWithError) { example in
            XCTAssertNotNil(example.created)
            XCTAssertNotNil(example.updated)
            XCTAssertEqual(example.text, newExample)
            expectation.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Update the new example."
        let expectation2 = self.expectation(description: description2)
        
        let updatedText = "updated-" + newExample
        conversation.updateExample(workspaceID: workspaceID, intent: "weather", text: newExample, newText: updatedText, failure: failWithError) { example in
            XCTAssertNotNil(example.created)
            XCTAssertNotNil(example.updated)
            XCTAssertEqual(example.text, updatedText)
            expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Delete the new example."
        let expectation3 = self.expectation(description: description3)
        
        conversation.deleteExample(workspaceID: workspaceID, intent: "weather", text: updatedText, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }
    
    // MARK: - Counterexamples
    
    func testListAllCounterexamples() {
        let description = "List all the counterexamples of a workspace."
        let expectation = self.expectation(description: description)
        
        conversation.listCounterexamples(workspaceID: workspaceID, failure: failWithError) { counterexamples in
            for counterexample in counterexamples.counterexamples {
                XCTAssertNotNil(counterexample.created)
                XCTAssertNotNil(counterexample.updated)
                XCTAssertNotNil(counterexample.text)
            }
            XCTAssertNotNil(counterexamples.pagination.refreshUrl)
            XCTAssertNil(counterexamples.pagination.nextUrl)
            XCTAssertNil(counterexamples.pagination.total)
            XCTAssertNil(counterexamples.pagination.matched)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testListAllCounterexamplesWithIncludeCount() {
        let description = "List all the counterexamples of a workspace with includeCount as true."
        let expectation = self.expectation(description: description)
        
        conversation.listCounterexamples(workspaceID: workspaceID, includeCount: true, failure: failWithError) { counterexamples in
            for counterexample in counterexamples.counterexamples {
                XCTAssertNotNil(counterexample.created)
                XCTAssertNotNil(counterexample.updated)
                XCTAssertNotNil(counterexample.text)
            }
            XCTAssertNotNil(counterexamples.pagination.refreshUrl)
            XCTAssertNil(counterexamples.pagination.nextUrl)
            XCTAssertNotNil(counterexamples.pagination.total)
            XCTAssertNotNil(counterexamples.pagination.matched)
            XCTAssertEqual(counterexamples.pagination.total, counterexamples.counterexamples.count)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testListAllCounterexamplesWithPageLimit1() {
        let description = "List all the counterexamples of a workspace with pageLimit specified as 1."
        let expectation = self.expectation(description: description)
        
        conversation.listCounterexamples(workspaceID: workspaceID, pageLimit: 1, failure: failWithError) { counterexamples in
            for counterexample in counterexamples.counterexamples {
                XCTAssertNotNil(counterexample.created)
                XCTAssertNotNil(counterexample.updated)
                XCTAssertNotNil(counterexample.text)
            }
            XCTAssertNotNil(counterexamples.pagination.refreshUrl)
            XCTAssertNil(counterexamples.pagination.total)
            XCTAssertNil(counterexamples.pagination.matched)
            XCTAssertEqual(counterexamples.counterexamples.count, 1)
            expectation.fulfill()
        }
        waitForExpectations()
    }
 
    func testCreateAndDeleteCounterexample() {
        let description = "Create a new counterexample."
        let expectation = self.expectation(description: description)
        
        let newExample = "swift-sdk-test-counterexample" + UUID().uuidString
        conversation.createCounterexample(workspaceID: workspaceID, text: newExample, failure: failWithError) { counterexample in
            XCTAssertNotNil(counterexample.created)
            XCTAssertNotNil(counterexample.updated)
            XCTAssertNotNil(counterexample.text)
            expectation.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Delete the new counterexample."
        let expectation2 = self.expectation(description: description2)
        
        conversation.deleteCounterexample(workspaceID: workspaceID, text: newExample, failure: failWithError) {
            expectation2.fulfill()
        }
        waitForExpectations()
    }

    func testGetCounterexample() {
        let description = "Get details of a specific counterexample."
        let expectation = self.expectation(description: description)
        
        let exampleText = "I want financial advice today."
        conversation.getCounterexample(workspaceID: workspaceID, text: exampleText, failure: failWithError) { counterexample in
            XCTAssertNotNil(counterexample.created)
            XCTAssertNotNil(counterexample.updated)
            XCTAssertEqual(counterexample.text, exampleText)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testCreateUpdateAndDeleteCounterexample() {
        let description = "Create a new counterexample."
        let expectation = self.expectation(description: description)
        
        let newExample = "swift-sdk-test-counterexample" + UUID().uuidString
        conversation.createCounterexample(workspaceID: workspaceID, text: newExample, failure: failWithError) { counterexample in
            XCTAssertNotNil(counterexample.created)
            XCTAssertNotNil(counterexample.updated)
            XCTAssertEqual(counterexample.text, newExample)
            expectation.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Update the new example."
        let expectation2 = self.expectation(description: description2)
        
        let updatedText = "updated-"+newExample
        conversation.updateCounterexample(workspaceID: workspaceID, text: newExample, newText: updatedText, failure: failWithError) { counterexample in
            XCTAssertNotNil(counterexample.created)
            XCTAssertNotNil(counterexample.updated)
            XCTAssertEqual(counterexample.text, updatedText)
            expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Delete the new counterexample."
        let expectation3 = self.expectation(description: description3)
        
        conversation.deleteCounterexample(workspaceID: workspaceID, text: updatedText, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Entities

    func testListAllEntities() {
        let description = "List all entities"
        let expectation = self.expectation(description: description)

        conversation.listEntities(workspaceID: workspaceID, failure: failWithError){entities in
            for entity in entities.entities {
                XCTAssertNotNil(entity.entity)
                XCTAssertNotNil(entity.created)
                XCTAssertNotNil(entity.updated)
            }
            XCTAssert(entities.entities.count > 0)
            XCTAssertNotNil(entities.pagination.refreshUrl)
            XCTAssertNil(entities.pagination.nextUrl)
            XCTAssertNil(entities.pagination.total)
            XCTAssertNil(entities.pagination.matched)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListAllEntitiesWithIncludeCount() {
        let description = "List all the entities in a workspace with includeCount as true."
        let expectation = self.expectation(description: description)

        conversation.listEntities(workspaceID: workspaceID, includeCount: true, failure: failWithError) { entities in
            for entity in entities.entities {
                XCTAssertNotNil(entity.entity)
                XCTAssertNotNil(entity.created)
                XCTAssertNotNil(entity.updated)
            }
            XCTAssertNotNil(entities.pagination.refreshUrl)
            XCTAssertNil(entities.pagination.nextUrl)
            XCTAssertNotNil(entities.pagination.total)
            XCTAssertNotNil(entities.pagination.matched)
            XCTAssertEqual(entities.pagination.total, entities.entities.count)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListAllEntitiesWithPageLimit1() {
        let description = "List all entities with page limit 1"
        let expectation = self.expectation(description: description)

        conversation.listEntities(workspaceID: workspaceID, pageLimit: 1, failure: failWithError){entities in
            for entity in entities.entities {
                XCTAssertNotNil(entity.entity)
                XCTAssertNotNil(entity.created)
                XCTAssertNotNil(entity.updated)
            }
            XCTAssertNotNil(entities.pagination.refreshUrl)
            XCTAssertNotNil(entities.pagination.nextUrl)
            XCTAssertNil(entities.pagination.total)
            XCTAssertNil(entities.pagination.matched)

            XCTAssert(entities.entities.count > 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListAllEntitiesWithExport() {
        let description = "List all the entities in a workspace with export as true."
        let expectation = self.expectation(description: description)

        conversation.listEntities(workspaceID: workspaceID, export: true, failure: failWithError) { entities in
            for entity in entities.entities {
                XCTAssertNotNil(entity.entity)
                XCTAssertNotNil(entity.created)
                XCTAssertNotNil(entity.updated)
            }
            XCTAssertNotNil(entities.entities)
            XCTAssertNil(entities.pagination.total)
            XCTAssertNil(entities.pagination.matched)
            XCTAssertNil(entities.pagination.nextUrl)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testCreateAndDeleteEntity(){
        let description = "Create an Entity"
        let expectation = self.expectation(description: description)

        let newEntityName = "swift-sdk-test-entity" + UUID().uuidString
        let entity = CreateEntity.init(entity: newEntityName, description: "This is a test entity")

        conversation.createEntity(workspaceID: workspaceID, body: entity, failure: failWithError){ entityResponse in
            XCTAssertEqual(entityResponse.entity, entity.entity)
            XCTAssertEqual(entityResponse.description, entity.description)
            XCTAssertNotNil(entityResponse.created)
            XCTAssertNotNil(entityResponse.updated)
            expectation.fulfill()
        }
        waitForExpectations()

        let descriptionTwo = "Delete the entity"
        let expectationTwo = self.expectation(description: descriptionTwo)

        conversation.deleteEntity(workspaceID: workspaceID, entity: entity.entity) {
            expectationTwo.fulfill()
        }
        waitForExpectations()
    }

    func testCreateUpdateAndDeleteEntity(){
        let description = "Create an Entity"
        let expectation = self.expectation(description: description)

        let newEntityName = "swift-sdk-test-entity" + UUID().uuidString
        let entity = CreateEntity.init(entity: newEntityName, description: "This is a test entity")

        conversation.createEntity(workspaceID: workspaceID, body: entity, failure: failWithError){ entityResponse in
            XCTAssertEqual(entityResponse.entity, entity.entity)
            XCTAssertEqual(entityResponse.description, entity.description)
            XCTAssertNotNil(entityResponse.created)
            XCTAssertNotNil(entityResponse.updated)
            expectation.fulfill()
        }
        waitForExpectations()

        let descriptionTwo = "Update the entity"
        let expectationTwo = self.expectation(description: descriptionTwo)

        let updatedEntityName = "up-" + entity.entity
        let updatedEntityDescription = "This is a new description for a test entity"
        let updatedEntity = UpdateEntity.init(entity: updatedEntityName, description: updatedEntityDescription)
        conversation.updateEntity(workspaceID: workspaceID, entity: entity.entity, body: updatedEntity, failure: failWithError){ entityResponse in
            XCTAssertEqual(entityResponse.entity, updatedEntityName)
            XCTAssertEqual(entityResponse.description, updatedEntityDescription)
            XCTAssertNotNil(entityResponse.created)
            XCTAssertNotNil(entityResponse.updated)
            expectationTwo.fulfill()
        }
        waitForExpectations()

        let descriptionFour = "Delete the entity"
        let expectationFour = self.expectation(description: descriptionFour)

        conversation.deleteEntity(workspaceID: workspaceID, entity: updatedEntityName, failure: failWithError) {
            expectationFour.fulfill()
        }
        waitForExpectations()
    }

    func testGetEntity() {
        let description = "Get details of a specific entity."
        let expectation = self.expectation(description: description)

        conversation.listEntities(workspaceID: workspaceID, failure: failWithError) {entityCollection in
            XCTAssert(entityCollection.entities.count > 0)
            let entity = entityCollection.entities[0]
            self.conversation.getEntity(workspaceID: self.workspaceID, entity: entity.entity, export: true, failure: self.failWithError) { entityExport in
                XCTAssertEqual(entityExport.entity, entity.entity)
                XCTAssertEqual(entityExport.description, entity.description)
                XCTAssertNotNil(entityExport.created)
                XCTAssertNotNil(entityExport.updated)
                expectation.fulfill()
            }
        }
        waitForExpectations()
    }

    // MARK: - Values

    func testListAllValues() {
        let description = "List all the values for an entity."
        let expectation = self.expectation(description: description)

        let entityName = "appliance"

        conversation.listValues(workspaceID: workspaceID, entity: entityName, failure: failWithError) { valueCollection in
            for value in valueCollection.values {
                XCTAssertNotNil(value.value)
                XCTAssertNotNil(value.created)
                XCTAssertNotNil(value.updated)
            }
            XCTAssertNotNil(valueCollection.pagination.refreshUrl)
            XCTAssertNil(valueCollection.pagination.total)
            XCTAssertNil(valueCollection.pagination.matched)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testCreateUpdateAndDeleteValue(){
        let description = "Create a value for an entity"
        let expectation = self.expectation(description: description)

        let entityName = "appliance"
        let valueName = "swift-sdk-test-value" + UUID().uuidString

        conversation.createValue(workspaceID: workspaceID, entity: entityName, value: valueName, failure: failWithError) { value in
            XCTAssertEqual(value.value, valueName)
            XCTAssertNotNil(value.created)
            XCTAssertNotNil(value.updated)
            expectation.fulfill()
        }
        waitForExpectations()

        let descriptionTwo = "Update the value"
        let expectationTwo = self.expectation(description: descriptionTwo)

        let updatedValueName = "up-" + valueName

        conversation.updateValue(workspaceID: workspaceID, entity: entityName, value: valueName, newValue: updatedValueName, newMetadata: ["oldname": valueName], failure: failWithError) { value in
            XCTAssertEqual(value.value, updatedValueName)
            XCTAssertNotNil(value.created)
            XCTAssertNotNil(value.updated)
            XCTAssertNotNil(value.metadata)
            expectationTwo.fulfill()
        }
        waitForExpectations()

        let descriptionThree = "Delete the updated value"
        let expectationThree = self.expectation(description: descriptionThree)

        conversation.deleteValue(workspaceID: workspaceID, entity: entityName, value: updatedValueName, failure: failWithError) {
            expectationThree.fulfill()
        }
        waitForExpectations()
    }

    func testGetValue() {
        let description = "Get a value for an entity."
        let expectation = self.expectation(description: description)

        let entityName = "appliance"

        conversation.listValues(workspaceID: workspaceID, entity: entityName, failure: failWithError) { valueCollection in
            XCTAssert(valueCollection.values.count > 0)
            let value = valueCollection.values[0]
            self.conversation.getValue(workspaceID: self.workspaceID, entity: entityName, value: value.value, export: true, failure: self.failWithError) { valueExport in
                XCTAssertEqual(valueExport.value, value.value)
                XCTAssertNotNil(valueExport.created)
                XCTAssertNotNil(valueExport.updated)
                expectation.fulfill()
            }
        }
        waitForExpectations()
    }

    // MARK: - Synonyms

    func testListAllSynonym() {
        let description = "List all the synonyms for an entity and value."
        let expectation = self.expectation(description: description)

        conversation.listSynonyms(workspaceID: workspaceID, entity: "appliance", value: "lights", failure: failWithError) { synonyms in
            for synonym in synonyms.synonyms {
                XCTAssertNotNil(synonym.created)
                XCTAssertNotNil(synonym.updated)
                XCTAssertNotNil(synonym.synonym)
            }
            XCTAssertNotNil(synonyms.pagination.refreshUrl)
            XCTAssertNil(synonyms.pagination.total)
            XCTAssertNil(synonyms.pagination.matched)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListAllSynonymWithIncludeCount() {
        let description = "List all the synonyms for an entity and value with includeCount as true."
        let expectation = self.expectation(description: description)

        conversation.listSynonyms(workspaceID: workspaceID, entity: "appliance", value: "lights", includeCount: true, failure: failWithError) { synonyms in
            for synonym in synonyms.synonyms {
                XCTAssertNotNil(synonym.created)
                XCTAssertNotNil(synonym.updated)
                XCTAssertNotNil(synonym.synonym)
            }
            XCTAssertNotNil(synonyms.pagination.refreshUrl)
            XCTAssertNotNil(synonyms.pagination.total)
            XCTAssertNotNil(synonyms.pagination.matched)
            XCTAssertEqual(synonyms.pagination.total, synonyms.synonyms.count)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListAllSynonymWithPageLimit1() {
        let description = "List all the synonyms for an entity and value with pageLimit specified as 1."
        let expectation = self.expectation(description: description)

        conversation.listSynonyms(workspaceID: workspaceID, entity: "appliance", value: "lights", pageLimit: 1, failure: failWithError) { synonyms in
            XCTAssertEqual(synonyms.synonyms.count, 1)
            for synonym in synonyms.synonyms {
                XCTAssertNotNil(synonym.created)
                XCTAssertNotNil(synonym.updated)
                XCTAssertNotNil(synonym.synonym)
            }
            XCTAssertNotNil(synonyms.pagination.refreshUrl)
            XCTAssertNotNil(synonyms.pagination.nextUrl)
            XCTAssertNil(synonyms.pagination.total)
            XCTAssertNil(synonyms.pagination.matched)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testCreateAndDeleteSynonym() {
        let description = "Create a new synonym."
        let expectation = self.expectation(description: description)

        let newSynonym = "swift-sdk-test-synonym" + UUID().uuidString
        conversation.createSynonym(workspaceID: workspaceID,entity: "appliance", value: "lights", synonym: newSynonym, failure: failWithError) { synonym in
            XCTAssertNotNil(synonym.created)
            XCTAssertNotNil(synonym.updated)
            XCTAssertEqual(synonym.synonym, newSynonym)
            expectation.fulfill()
        }
        waitForExpectations()

        let description2 = "Delete the new synonym."
        let expectation2 = self.expectation(description: description2)

        conversation.deleteSynonym(workspaceID: workspaceID,entity: "appliance", value: "lights", synonym: newSynonym, failure: failWithError) {
            expectation2.fulfill()
        }
        waitForExpectations()
    }

    func testGetSynonym() {
        let description = "Get details of a specific synonym."
        let expectation = self.expectation(description: description)

        let synonymName = "headlight"
        conversation.getSynonym(workspaceID: workspaceID,entity: "appliance", value: "lights", synonym: synonymName, failure: failWithError) { synonym in
            XCTAssertEqual(synonym.synonym, synonymName)
            XCTAssertNotNil(synonym.created)
            XCTAssertNotNil(synonym.updated)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testCreateUpdateAndDeleteSynonym() {
        let description = "Create a new synonym."
        let expectation = self.expectation(description: description)

        let newSynonym = "swift-sdk-test-synonym" + UUID().uuidString
        conversation.createSynonym(workspaceID: workspaceID, entity: "appliance", value: "lights", synonym: newSynonym, failure: failWithError) { synonym in
            XCTAssertNotNil(synonym.created)
            XCTAssertNotNil(synonym.updated)
            XCTAssertEqual(synonym.synonym, newSynonym)
            expectation.fulfill()
        }
        waitForExpectations()

        let description2 = "Update the new synonym."
        let expectation2 = self.expectation(description: description2)

        let updatedSynonym = "new-" + newSynonym
        conversation.updateSynonym(workspaceID: workspaceID, entity: "appliance", value: "lights", synonym: newSynonym, newSynonym: updatedSynonym, failure: failWithError){ synonym in
            XCTAssertNotNil(synonym.created)
            XCTAssertNotNil(synonym.updated)
            XCTAssertEqual(synonym.synonym, updatedSynonym)
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Delete the new synonym."
        let expectation3 = self.expectation(description: description3)

        conversation.deleteSynonym(workspaceID: workspaceID, entity: "appliance", value: "lights", synonym: updatedSynonym, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Logs

    func testListLogs() {
        let description = "List the logs from the sdk"
        let expectation = self.expectation(description: description)

        conversation.listLogs(workspaceID: workspaceID, failure: failWithError) { logCollection in
            XCTAssert(logCollection.logs.count > 0)
            expectation.fulfill()
        }

        waitForExpectations()
    }

    // MARK: - Negative Tests

    func testMessageUnknownWorkspace() {
        let description = "Start a conversation with an invalid workspace."
        let expectation = self.expectation(description: description)

        let workspaceID = "this-id-is-unknown"
        let failure = { (error: Error) in
            // The following check fails on Linux with Swift 3.1.1 and earlier, but has been fixed in later releases.
            XCTAssert(error.localizedDescription.contains("not a valid GUID"))
            expectation.fulfill()
        }
        
        conversation.message(withWorkspace: workspaceID, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    func testBadEndpoint() {
        let description = "Bad endpoint."
        let expectation = self.expectation(description: description)

        let badService = Conversation(username: "username", password: "password", version: "2017-02-03")
        badService.serviceURL = "https://foo.bar.baz/"
        let workspaceID = "workspaceID"
        let failure = { (error: Error) in
            expectation.fulfill()
        }

        badService.message(withWorkspace: workspaceID, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    func testMessageInvalidWorkspaceID() {
        let description = "Start a conversation with an invalid workspace."
        let expectation = self.expectation(description: description)

        let workspaceID = "this id is invalid"   // workspace id with spaces should gracefully return error
        let failure = { (error: Error) in
            // The following check fails on Linux with Swift 3.1.1 and earlier, but has been fixed in later releases.
            XCTAssert(error.localizedDescription.contains("not a valid GUID"))
            expectation.fulfill()
        }

        conversation.message(withWorkspace: workspaceID, failure: failure, success: failWithResult)
        waitForExpectations()
    }
}
