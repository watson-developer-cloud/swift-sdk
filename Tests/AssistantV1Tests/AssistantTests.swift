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

// swiftlint:disable function_body_length force_try force_unwrapping file_length

import XCTest
import Foundation
import AssistantV1

class AssistantTests: XCTestCase {

    private var assistant: Assistant!
    private let workspaceID = Credentials.AssistantWorkspace

    // MARK: - Test Configuration

    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateAssistant()
    }

    static var allTests: [(String, (AssistantTests) -> () throws -> Void)] {
        return [
            ("testMessage", testMessage),
            ("testMessageAllFields1", testMessageAllFields1),
            ("testMessageAllFields2", testMessageAllFields2),
            ("testMessageContextVariable", testMessageContextVariable),
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
            ("testListAllDialogNodes", testListAllDialogNodes),
            ("testCreateAndDeleteDialogNode", testCreateAndDeleteDialogNode),
            ("testCreateUpdateAndDeleteDialogNode", testCreateUpdateAndDeleteDialogNode),
            ("testGetDialogNode", testGetDialogNode),
            // ("testListAllLogs", testListAllLogs), // temporarily disabled due to server-side bug
            // ("testListLogs", testListLogs), // temporarily disabled due to server-side bug
            ("testMessageUnknownWorkspace", testMessageUnknownWorkspace),
            ("testMessageInvalidWorkspaceID", testMessageInvalidWorkspaceID),
        ]
    }

    /** Instantiate Assistant. */
    func instantiateAssistant() {
        let username = Credentials.AssistantUsername
        let password = Credentials.AssistantPassword
        let version = "2018-02-16"
        assistant = Assistant(username: username, password: password, version: version)
        assistant.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        assistant.defaultHeaders["X-Watson-Test"] = "true"
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
    func waitForExpectations(timeout: TimeInterval = 10.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: - Positive Tests

    func testMessage() {
        let description1 = "Start a conversation."
        let expectation1 = self.expectation(description: description1)

        let response1 = ["Hi. It looks like a nice drive today. What would you like me to do?  "]

        var context: Context?
        assistant.message(workspaceID: workspaceID, nodesVisitedDetails: true, failure: failWithError) {
            response in

            // verify input
            XCTAssertNil(response.input?.text)

            // verify context
            XCTAssertNotNil(response.context.conversationID)
            XCTAssertNotEqual(response.context.conversationID, "")
            XCTAssertNotNil(response.context.system)
            XCTAssertNotNil(response.context.system!.additionalProperties)
            XCTAssertFalse(response.context.system!.additionalProperties.isEmpty)

            // verify entities
            XCTAssertTrue(response.entities.isEmpty)

            // verify intents
            XCTAssertTrue(response.intents.isEmpty)

            // verify output
            XCTAssertTrue(response.output.logMessages.isEmpty)
            XCTAssertEqual(response.output.text, response1)
            XCTAssertNotNil(response.output.nodesVisited)
            XCTAssertEqual(response.output.nodesVisited!.count, 1)
            XCTAssertNotNil(response.output.nodesVisitedDetails)
            XCTAssertNotNil(response.output.nodesVisitedDetails!.first)
            XCTAssertNotNil(response.output.nodesVisitedDetails!.first!.dialogNode)

            context = response.context
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Continue a conversation."
        let expectation2 = self.expectation(description: description2)

        let input = InputData(text: "Turn on the radio.")
        let request = MessageRequest(input: input, context: context!)
        let response2 = ["Sure thing! Which genre would you prefer? Jazz is my personal favorite."]

        assistant.message(workspaceID: workspaceID, request: request, failure: failWithError) {
            response in

            // verify input
            XCTAssertEqual(response.input?.text, input.text)

            // verify context
            XCTAssertEqual(response.context.conversationID, context!.conversationID)
            XCTAssertNotNil(response.context.system)
            XCTAssertNotNil(response.context.system!.additionalProperties)
            XCTAssertFalse(response.context.system!.additionalProperties.isEmpty)

            // verify entities
            XCTAssertEqual(response.entities.count, 1)
            XCTAssertEqual(response.entities[0].entity, "appliance")
            XCTAssertEqual(response.entities[0].location[0], 12)
            XCTAssertEqual(response.entities[0].location[1], 17)
            XCTAssertEqual(response.entities[0].value, "music")

            // verify intents
            XCTAssertEqual(response.intents.count, 1)
            XCTAssertEqual(response.intents[0].intent, "turn_on")
            XCTAssert(response.intents[0].confidence >= 0.80)
            XCTAssert(response.intents[0].confidence <= 1.00)

            // verify output
            XCTAssertTrue(response.output.logMessages.isEmpty)
            XCTAssertEqual(response.output.text, response2)
            XCTAssertNotNil(response.output.nodesVisited)
            XCTAssertEqual(response.output.nodesVisited!.count, 3)

            expectation2.fulfill()
        }
        waitForExpectations()
    }

    func testMessageAllFields1() {
        let description1 = "Start a conversation."
        let expectation1 = expectation(description: description1)

        var context: Context?
        var entities: [RuntimeEntity]?
        var intents: [RuntimeIntent]?
        var output: OutputData?

        assistant.message(workspaceID: workspaceID, failure: failWithError) {
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

        let input2 = InputData(text: "Turn on the radio.")
        let request2 = MessageRequest(input: input2, context: context, entities: entities, intents: intents, output: output)
        assistant.message(workspaceID: workspaceID, request: request2, failure: failWithError) {
            response in

            // verify objects are non-nil
            XCTAssertNotNil(entities)
            XCTAssertNotNil(intents)
            XCTAssertNotNil(output)

            // verify intents are equal
            for index in 0..<response.intents.count {
                let intent1 = intents![index]
                let intent2 = response.intents[index]
                XCTAssertEqual(intent1.intent, intent2.intent)
                XCTAssertEqual(intent1.confidence, intent2.confidence, accuracy: 10E-5)
            }

            // verify entities are equal
            for index in 0..<response.entities.count {
                let entity1 = entities![index]
                let entity2 = response.entities[index]
                XCTAssertEqual(entity1.entity, entity2.entity)
                XCTAssertEqual(entity1.location[0], entity2.location[0])
                XCTAssertEqual(entity1.location[1], entity2.location[1])
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
        var entities: [RuntimeEntity]?
        var intents: [RuntimeIntent]?
        var output: OutputData?

        assistant.message(workspaceID: workspaceID, failure: failWithError) {
            response in
            context = response.context
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Continue a conversation."
        let expectation2 = expectation(description: description2)

        let input2 = InputData(text: "Turn on the radio.")
        let request2 = MessageRequest(input: input2, context: context, entities: entities, intents: intents, output: output)
        assistant.message(workspaceID: workspaceID, request: request2, failure: failWithError) {
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

        let input3 = InputData(text: "Rock music.")
        let request3 = MessageRequest(input: input3, context: context, entities: entities, intents: intents, output: output)
        assistant.message(workspaceID: workspaceID, request: request3, failure: failWithError) {
            response in

            // verify objects are non-nil
            XCTAssertNotNil(entities)
            XCTAssertNotNil(intents)
            XCTAssertNotNil(output)

            // verify intents are equal
            for index in 0..<response.intents.count {
                let intent1 = intents![index]
                let intent2 = response.intents[index]
                XCTAssertEqual(intent1.intent, intent2.intent)
                XCTAssertEqual(intent1.confidence, intent2.confidence, accuracy: 10E-5)
            }

            // verify entities are equal
            for index in 0..<response.entities.count {
                let entity1 = entities![index]
                let entity2 = response.entities[index]
                XCTAssertEqual(entity1.entity, entity2.entity)
                XCTAssertEqual(entity1.location[0], entity2.location[0])
                XCTAssertEqual(entity1.location[1], entity2.location[1])
                XCTAssertEqual(entity1.value, entity2.value)
            }

            expectation3.fulfill()
        }
        waitForExpectations()
    }

    func testMessageContextVariable() {
        let description1 = "Start a conversation."
        let expectation1 = expectation(description: description1)

        var context: Context?
        assistant.message(workspaceID: workspaceID, failure: failWithError) {
            response in
            context = response.context
            context?.additionalProperties["foo"] = .string("bar")
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Continue a conversation."
        let expectation2 = expectation(description: description2)

        let input2 = InputData(text: "Turn on the radio.")
        let request2 = MessageRequest(input: input2, context: context)
        assistant.message(workspaceID: workspaceID, request: request2, failure: failWithError) {
            response in
            let additionalProperties = response.context.additionalProperties
            guard case let .string(bar) = additionalProperties["foo"]! else {
                XCTFail("Additional property \"foo\" expected but not present.")
                return
            }
            guard case let .boolean(reprompt) = additionalProperties["reprompt"]! else {
                XCTFail("Additional property \"reprompt\" expected but not present.")
                return
            }
            XCTAssertEqual(bar, "bar")
            XCTAssertTrue(reprompt)
            expectation2.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Workspaces

    func testListAllWorkspaces() {
        let description = "List all workspaces."
        let expectation = self.expectation(description: description)

        assistant.listWorkspaces(includeAudit: true, failure: failWithError) { workspaceResponse in
            for workspace in workspaceResponse.workspaces {
                XCTAssertNotNil(workspace.name)
                XCTAssertNotNil(workspace.created)
                XCTAssertNotNil(workspace.updated)
                XCTAssertNotNil(workspace.language)
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

        assistant.listWorkspaces(pageLimit: 1, includeAudit: true, failure: failWithError) { workspaceResponse in
            XCTAssertEqual(workspaceResponse.workspaces.count, 1)
            for workspace in workspaceResponse.workspaces {
                XCTAssertNotNil(workspace.name)
                XCTAssertNotNil(workspace.created)
                XCTAssertNotNil(workspace.updated)
                XCTAssertNotNil(workspace.language)
                XCTAssertNotNil(workspace.workspaceID)
            }
            XCTAssertNotNil(workspaceResponse.pagination.refreshUrl)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListAllWorkspacesWithIncludeCount() {
        let description = "List all workspaces with includeCount as true."
        let expectation = self.expectation(description: description)

        assistant.listWorkspaces(includeCount: true, includeAudit: true, failure: failWithError) { workspaceResponse in
            for workspace in workspaceResponse.workspaces {
                XCTAssertNotNil(workspace.name)
                XCTAssertNotNil(workspace.created)
                XCTAssertNotNil(workspace.updated)
                XCTAssertNotNil(workspace.language)
                XCTAssertNotNil(workspace.workspaceID)
            }
            XCTAssertNotNil(workspaceResponse.pagination.refreshUrl)
            XCTAssertNotNil(workspaceResponse.pagination.total)
            XCTAssertNotNil(workspaceResponse.pagination.matched)
            XCTAssertGreaterThanOrEqual(workspaceResponse.pagination.total!, workspaceResponse.workspaces.count)
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
        let workspaceMetadata: [String: JSON] = ["testKey": .string("testValue")]
        let intentExample = CreateExample(text: "This is an example of Intent1")
        let workspaceIntent = CreateIntent(intent: "Intent1", description: "description of Intent1", examples: [intentExample])
        let entityValue = CreateValue(value: "Entity1Value", metadata: workspaceMetadata, synonyms: ["Synonym1", "Synonym2"])
        let workspaceEntity = CreateEntity(entity: "Entity1", description: "description of Entity1", values: [entityValue])
        let workspaceDialogNode = CreateDialogNode(dialogNode: "DialogNode1", description: "description of DialogNode1")
        let workspaceCounterexample = CreateCounterexample(text: "This is a counterexample")

        let createWorkspaceBody = CreateWorkspace(name: workspaceName, description: workspaceDescription, language: workspaceLanguage, intents: [workspaceIntent],
                                                  entities: [workspaceEntity], dialogNodes: [workspaceDialogNode], counterexamples: [workspaceCounterexample],
                                                  metadata: workspaceMetadata)
        assistant.createWorkspace(properties: createWorkspaceBody, failure: failWithError) { workspace in
            XCTAssertEqual(workspace.name, workspaceName)
            XCTAssertEqual(workspace.description, workspaceDescription)
            XCTAssertEqual(workspace.language, workspaceLanguage)
            XCTAssertNotNil(workspace.workspaceID)

            newWorkspace = workspace.workspaceID
            expectation1.fulfill()
        }
        waitForExpectations(timeout: 20.0)

        guard let newWorkspaceID = newWorkspace else {
            XCTFail("Failed to get the ID of the newly created workspace.")
            return
        }

        let description2 = "Get the newly created workspace."
        let expectation2 = expectation(description: description2)

        assistant.getWorkspace(workspaceID: newWorkspaceID, export: true, includeAudit: true, failure: failWithError) { workspace in
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
                XCTAssertEqual(intent.intentName, workspaceIntent.intent)
                XCTAssertEqual(intent.description, workspaceIntent.description)
                XCTAssertNotNil(intent.created)
                XCTAssertNotNil(intent.updated)
                XCTAssertNotNil(intent.examples)
                for example in intent.examples! {
                    XCTAssertNotNil(example.created)
                    XCTAssertNotNil(example.updated)
                    XCTAssertEqual(example.exampleText, intentExample.text)
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
        waitForExpectations(timeout: 20.0)

        let description3 = "Delete the newly created workspace."
        let expectation3 = expectation(description: description3)

        assistant.deleteWorkspace(workspaceID: newWorkspaceID, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    func testListSingleWorkspace() {
        let description = "List details of a single workspace."
        let expectation = self.expectation(description: description)

        assistant.getWorkspace(workspaceID: workspaceID, export: false, includeAudit: true, failure: failWithError) { workspace in
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
            XCTAssertNil(workspace.dialogNodes)
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
        assistant.createWorkspace(properties: createWorkspaceBody, failure: failWithError) { workspace in
            XCTAssertEqual(workspace.name, workspaceName)
            XCTAssertEqual(workspace.description, workspaceDescription)
            XCTAssertEqual(workspace.language, workspaceLanguage)
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
        assistant.updateWorkspace(workspaceID: newWorkspaceID, properties: updateWorkspaceBody, failure: failWithError) { workspace in
            XCTAssertEqual(workspace.name, newWorkspaceName)
            XCTAssertEqual(workspace.description, newWorkspaceDescription)
            XCTAssertEqual(workspace.language, workspaceLanguage)
            XCTAssertNotNil(workspace.workspaceID)
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Delete the newly created workspace."
        let expectation3 = expectation(description: description3)

        assistant.deleteWorkspace(workspaceID: newWorkspaceID, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Intents

    func testListAllIntents() {
        let description = "List all the intents in a workspace."
        let expectation = self.expectation(description: description)

        assistant.listIntents(workspaceID: workspaceID, includeAudit: true, failure: failWithError) { intents in
            for intent in intents.intents {
                XCTAssertNotNil(intent.intentName)
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

        assistant.listIntents(workspaceID: workspaceID, includeCount: true, includeAudit: true, failure: failWithError) { intents in
            for intent in intents.intents {
                XCTAssertNotNil(intent.intentName)
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

        assistant.listIntents(workspaceID: workspaceID, pageLimit: 1, includeAudit: true, failure: failWithError) { intents in
            XCTAssertEqual(intents.intents.count, 1)
            for intent in intents.intents {
                XCTAssertNotNil(intent.intentName)
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

        assistant.listIntents(workspaceID: workspaceID, export: true, includeAudit: true, failure: failWithError) { intents in
            for intent in intents.intents {
                XCTAssertNotNil(intent.intentName)
                XCTAssertNotNil(intent.created)
                XCTAssertNotNil(intent.updated)
                XCTAssertNotNil(intent.examples)
                for example in intent.examples! {
                    XCTAssertNotNil(example.created)
                    XCTAssertNotNil(example.updated)
                    XCTAssertNotNil(example.exampleText)
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
        assistant.createIntent(workspaceID: workspaceID, intent: newIntentName, description: newIntentDescription, examples: [example1, example2], failure: failWithError) { intent in
            XCTAssertEqual(intent.intentName, newIntentName)
            XCTAssertEqual(intent.description, newIntentDescription)
            expectation.fulfill()
        }
        waitForExpectations()

        let description2 = "Delete the new intent."
        let expectation2 = self.expectation(description: description2)

        assistant.deleteIntent(workspaceID: workspaceID, intent: newIntentName, failure: failWithError) {
            expectation2.fulfill()
        }
        waitForExpectations()
    }

    func testGetIntentWithExport() {
        let description = "Get details of a specific intent."
        let expectation = self.expectation(description: description)

        assistant.getIntent(workspaceID: workspaceID, intent: "weather", export: true, includeAudit: true, failure: failWithError) { intent in
            XCTAssertNotNil(intent.intentName)
            XCTAssertNotNil(intent.created)
            XCTAssertNotNil(intent.updated)
            XCTAssertNotNil(intent.examples)
            for example in intent.examples! {
                XCTAssertNotNil(example.created)
                XCTAssertNotNil(example.updated)
                XCTAssertNotNil(example.exampleText)
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
        assistant.createIntent(workspaceID: workspaceID, intent: newIntentName, description: newIntentDescription, examples: [example1, example2], failure: failWithError) { intent in
            XCTAssertEqual(intent.intentName, newIntentName)
            XCTAssertEqual(intent.description, newIntentDescription)
            expectation.fulfill()
        }
        waitForExpectations()

        let description2 = "Update the new intent."
        let expectation2 = self.expectation(description: description2)

        let updatedIntentName = "updated-name-for-\(newIntentName)"
        let updatedIntentDescription = "updated-description-for-\(newIntentName)"
        let updatedExample1 = CreateExample(text: "updated example for \(newIntentName)")
        assistant.updateIntent(workspaceID: workspaceID, intent: newIntentName, newIntent: updatedIntentName, newDescription: updatedIntentDescription,
                               newExamples: [updatedExample1], failure: failWithError) { intent in
            XCTAssertEqual(intent.intentName, updatedIntentName)
            XCTAssertEqual(intent.description, updatedIntentDescription)
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Delete the new intent."
        let expectation3 = self.expectation(description: description3)

        assistant.deleteIntent(workspaceID: workspaceID, intent: updatedIntentName, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Examples

    func testListAllExamples() {
        let description = "List all the examples of an intent."
        let expectation = self.expectation(description: description)

        assistant.listExamples(workspaceID: workspaceID, intent: "weather", includeAudit: true, failure: failWithError) { examples in
            for example in examples.examples {
                XCTAssertNotNil(example.created)
                XCTAssertNotNil(example.updated)
                XCTAssertNotNil(example.exampleText)
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

        assistant.listExamples(workspaceID: workspaceID, intent: "weather", includeCount: true, includeAudit: true, failure: failWithError) { examples in
            for example in examples.examples {
                XCTAssertNotNil(example.created)
                XCTAssertNotNil(example.updated)
                XCTAssertNotNil(example.exampleText)
            }
            XCTAssertNotNil(examples.pagination.refreshUrl)
            XCTAssertNotNil(examples.pagination.total)
            XCTAssertNotNil(examples.pagination.matched)
            XCTAssertGreaterThanOrEqual(examples.pagination.total!, examples.examples.count)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListAllExamplesWithPageLimit1() {
        let description = "List all the examples for an intent with pageLimit specified as 1."
        let expectation = self.expectation(description: description)

        assistant.listExamples(workspaceID: workspaceID, intent: "weather", pageLimit: 1, includeAudit: true, failure: failWithError) { examples in
            XCTAssertEqual(examples.examples.count, 1)
            for example in examples.examples {
                XCTAssertNotNil(example.created)
                XCTAssertNotNil(example.updated)
                XCTAssertNotNil(example.exampleText)
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
        assistant.createExample(workspaceID: workspaceID, intent: "weather", text: newExample, failure: failWithError) { example in
            XCTAssertEqual(example.exampleText, newExample)
            expectation.fulfill()
        }
        waitForExpectations()

        let description2 = "Delete the new example."
        let expectation2 = self.expectation(description: description2)

        assistant.deleteExample(workspaceID: workspaceID, intent: "weather", text: newExample, failure: failWithError) {
            expectation2.fulfill()
        }
        waitForExpectations()
    }

    func testGetExample() {
        let description = "Get details of a specific example."
        let expectation = self.expectation(description: description)

        let exampleText = "tell me the weather"
        assistant.getExample(workspaceID: workspaceID, intent: "weather", text: exampleText, includeAudit: true, failure: failWithError) { example in
            XCTAssertNotNil(example.created)
            XCTAssertNotNil(example.updated)
            XCTAssertEqual(example.exampleText, exampleText)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testCreateUpdateAndDeleteExample() {
        let description = "Create a new example."
        let expectation = self.expectation(description: description)

        let newExample = "swift-sdk-test-example" + UUID().uuidString
        assistant.createExample(workspaceID: workspaceID, intent: "weather", text: newExample, failure: failWithError) { example in
            XCTAssertEqual(example.exampleText, newExample)
            expectation.fulfill()
        }
        waitForExpectations()

        let description2 = "Update the new example."
        let expectation2 = self.expectation(description: description2)

        let updatedText = "updated-" + newExample
        assistant.updateExample(workspaceID: workspaceID, intent: "weather", text: newExample, newText: updatedText, failure: failWithError) { example in
            XCTAssertEqual(example.exampleText, updatedText)
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Delete the new example."
        let expectation3 = self.expectation(description: description3)

        assistant.deleteExample(workspaceID: workspaceID, intent: "weather", text: updatedText, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Counterexamples

    func testListAllCounterexamples() {
        let description = "List all the counterexamples of a workspace."
        let expectation = self.expectation(description: description)

        assistant.listCounterexamples(workspaceID: workspaceID, includeAudit: true, failure: failWithError) { counterexamples in
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

        assistant.listCounterexamples(workspaceID: workspaceID, includeCount: true, includeAudit: true, failure: failWithError) { counterexamples in
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

        assistant.listCounterexamples(workspaceID: workspaceID, pageLimit: 1, includeAudit: true, failure: failWithError) { counterexamples in
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
        assistant.createCounterexample(workspaceID: workspaceID, text: newExample, failure: failWithError) { counterexample in
            XCTAssertNotNil(counterexample.text)
            expectation.fulfill()
        }
        waitForExpectations()

        let description2 = "Delete the new counterexample."
        let expectation2 = self.expectation(description: description2)

        assistant.deleteCounterexample(workspaceID: workspaceID, text: newExample, failure: failWithError) {
            expectation2.fulfill()
        }
        waitForExpectations()
    }

    func testGetCounterexample() {
        let description = "Get details of a specific counterexample."
        let expectation = self.expectation(description: description)

        let exampleText = "when will it be funny"
        assistant.getCounterexample(workspaceID: workspaceID, text: exampleText, includeAudit: true, failure: failWithError) { counterexample in
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
        assistant.createCounterexample(workspaceID: workspaceID, text: newExample, failure: failWithError) { counterexample in
            XCTAssertEqual(counterexample.text, newExample)
            expectation.fulfill()
        }
        waitForExpectations()

        let description2 = "Update the new example."
        let expectation2 = self.expectation(description: description2)

        let updatedText = "updated-"+newExample
        assistant.updateCounterexample(workspaceID: workspaceID, text: newExample, newText: updatedText, failure: failWithError) { counterexample in
            XCTAssertEqual(counterexample.text, updatedText)
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Delete the new counterexample."
        let expectation3 = self.expectation(description: description3)

        assistant.deleteCounterexample(workspaceID: workspaceID, text: updatedText, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Entities

    func testListAllEntities() {
        let description = "List all entities"
        let expectation = self.expectation(description: description)

        assistant.listEntities(workspaceID: workspaceID, includeAudit: true, failure: failWithError){entities in
            for entity in entities.entities {
                XCTAssertNotNil(entity.entityName)
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

        assistant.listEntities(workspaceID: workspaceID, includeCount: true, includeAudit: true, failure: failWithError) { entities in
            for entity in entities.entities {
                XCTAssertNotNil(entity.entityName)
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

        assistant.listEntities(workspaceID: workspaceID, pageLimit: 1, includeAudit: true, failure: failWithError){entities in
            for entity in entities.entities {
                XCTAssertNotNil(entity.entityName)
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

        assistant.listEntities(workspaceID: workspaceID, export: true, includeAudit: true, failure: failWithError) { entities in
            for entity in entities.entities {
                XCTAssertNotNil(entity.entityName)
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

        let entityName = "swift-sdk-test-entity" + UUID().uuidString
        let entityDescription = "This is a test entity"
        let entity = CreateEntity.init(entity: entityName, description: entityDescription)

        assistant.createEntity(workspaceID: workspaceID, properties: entity, failure: failWithError){ entityResponse in
            XCTAssertEqual(entityResponse.entityName, entityName)
            XCTAssertEqual(entityResponse.description, entityDescription)
            expectation.fulfill()
        }
        waitForExpectations()

        let descriptionTwo = "Delete the entity"
        let expectationTwo = self.expectation(description: descriptionTwo)

        assistant.deleteEntity(workspaceID: workspaceID, entity: entity.entity) {
            expectationTwo.fulfill()
        }
        waitForExpectations()
    }

    func testCreateUpdateAndDeleteEntity(){
        let description = "Create an Entity"
        let expectation = self.expectation(description: description)

        let entityName = "swift-sdk-test-entity" + UUID().uuidString
        let entityDescription = "This is a test entity"
        let entity = CreateEntity.init(entity: entityName, description: entityDescription)

        assistant.createEntity(workspaceID: workspaceID, properties: entity, failure: failWithError){ entityResponse in
            XCTAssertEqual(entityResponse.entityName, entityName)
            XCTAssertEqual(entityResponse.description, entityDescription)
            expectation.fulfill()
        }
        waitForExpectations()

        let descriptionTwo = "Update the entity"
        let expectationTwo = self.expectation(description: descriptionTwo)

        let updatedEntityName = "up-" + entityName
        let updatedEntityDescription = "This is a new description for a test entity"
        let updatedEntity = UpdateEntity.init(entity: updatedEntityName, description: updatedEntityDescription)
        assistant.updateEntity(workspaceID: workspaceID, entity: entityName, properties: updatedEntity, failure: failWithError){ entityResponse in
            XCTAssertEqual(entityResponse.entityName, updatedEntityName)
            XCTAssertEqual(entityResponse.description, updatedEntityDescription)
            expectationTwo.fulfill()
        }
        waitForExpectations()

        let descriptionFour = "Delete the entity"
        let expectationFour = self.expectation(description: descriptionFour)

        assistant.deleteEntity(workspaceID: workspaceID, entity: updatedEntityName, failure: failWithError) {
            expectationFour.fulfill()
        }
        waitForExpectations()
    }

    func testGetEntity() {
        let description = "Get details of a specific entity."
        let expectation = self.expectation(description: description)

        assistant.listEntities(workspaceID: workspaceID, failure: failWithError) {entityCollection in
            XCTAssert(entityCollection.entities.count > 0)
            let entity = entityCollection.entities[0]
            self.assistant.getEntity(workspaceID: self.workspaceID, entity: entity.entityName, export: true, includeAudit: true, failure: self.failWithError) { entityExport in
                XCTAssertEqual(entityExport.entityName, entity.entityName)
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
        assistant.listValues(
            workspaceID: workspaceID,
            entity: entityName,
            export: true,
            includeCount: true,
            includeAudit: true,
            failure: failWithError) {
                valueCollection in
                for value in valueCollection.values {
                    XCTAssertNotNil(value.valueText)
                    XCTAssertNotNil(value.created)
                    XCTAssertNotNil(value.updated)
                }
                XCTAssertNotNil(valueCollection.pagination.refreshUrl)
                XCTAssertNotNil(valueCollection.pagination.total)
                XCTAssertNotNil(valueCollection.pagination.matched)
                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testCreateUpdateAndDeleteValue(){
        let description = "Create a value for an entity"
        let expectation = self.expectation(description: description)

        let entityName = "appliance"
        let valueName = "swift-sdk-test-value" + UUID().uuidString
        let value = CreateValue(value: valueName)
        assistant.createValue(workspaceID: workspaceID, entity: entityName, properties: value, failure: failWithError) { value in
            XCTAssertEqual(value.valueText, valueName)
            expectation.fulfill()
        }
        waitForExpectations()

        let descriptionTwo = "Update the value"
        let expectationTwo = self.expectation(description: descriptionTwo)

        let updatedValueName = "up-" + valueName
        let updatedValue = UpdateValue(value: updatedValueName, metadata: ["oldname": .string(valueName)])
        assistant.updateValue(workspaceID: workspaceID, entity: entityName, value: valueName, properties: updatedValue, failure: failWithError) { value in
            XCTAssertEqual(value.valueText, updatedValueName)
            XCTAssertNotNil(value.metadata)
            expectationTwo.fulfill()
        }
        waitForExpectations()

        let descriptionThree = "Delete the updated value"
        let expectationThree = self.expectation(description: descriptionThree)

        assistant.deleteValue(workspaceID: workspaceID, entity: entityName, value: updatedValueName, failure: failWithError) {
            expectationThree.fulfill()
        }
        waitForExpectations()
    }

    func testGetValue() {
        let description = "Get a value for an entity."
        let expectation = self.expectation(description: description)

        let entityName = "appliance"

        assistant.listValues(workspaceID: workspaceID, entity: entityName, failure: failWithError) { valueCollection in
            XCTAssert(valueCollection.values.count > 0)
            let value = valueCollection.values[0]
            self.assistant.getValue(workspaceID: self.workspaceID, entity: entityName, value: value.valueText, export: true, includeAudit: true, failure: self.failWithError) { valueExport in
                XCTAssertEqual(valueExport.valueText, value.valueText)
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

        assistant.listSynonyms(workspaceID: workspaceID, entity: "appliance", value: "lights", includeAudit: true, failure: failWithError) { synonyms in
            for synonym in synonyms.synonyms {
                XCTAssertNotNil(synonym.created)
                XCTAssertNotNil(synonym.updated)
                XCTAssertNotNil(synonym.synonymText)
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

        assistant.listSynonyms(workspaceID: workspaceID, entity: "appliance", value: "lights", includeCount: true, includeAudit: true, failure: failWithError) { synonyms in
            for synonym in synonyms.synonyms {
                XCTAssertNotNil(synonym.created)
                XCTAssertNotNil(synonym.updated)
                XCTAssertNotNil(synonym.synonymText)
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

        assistant.listSynonyms(workspaceID: workspaceID, entity: "appliance", value: "lights", pageLimit: 1, includeAudit: true, failure: failWithError) { synonyms in
            XCTAssertEqual(synonyms.synonyms.count, 1)
            for synonym in synonyms.synonyms {
                XCTAssertNotNil(synonym.created)
                XCTAssertNotNil(synonym.updated)
                XCTAssertNotNil(synonym.synonymText)
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
        assistant.createSynonym(workspaceID: workspaceID, entity: "appliance", value: "lights", synonym: newSynonym, failure: failWithError) { synonym in
            XCTAssertEqual(synonym.synonymText, newSynonym)
            expectation.fulfill()
        }
        waitForExpectations()

        let description2 = "Delete the new synonym."
        let expectation2 = self.expectation(description: description2)

        assistant.deleteSynonym(workspaceID: workspaceID, entity: "appliance", value: "lights", synonym: newSynonym, failure: failWithError) {
            expectation2.fulfill()
        }
        waitForExpectations()
    }

    func testGetSynonym() {
        let description = "Get details of a specific synonym."
        let expectation = self.expectation(description: description)

        let synonymName = "headlight"
        assistant.getSynonym(workspaceID: workspaceID, entity: "appliance", value: "lights", synonym: synonymName, includeAudit: true, failure: failWithError) { synonym in
            XCTAssertEqual(synonym.synonymText, synonymName)
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
        assistant.createSynonym(workspaceID: workspaceID, entity: "appliance", value: "lights", synonym: newSynonym, failure: failWithError) { synonym in
            XCTAssertEqual(synonym.synonymText, newSynonym)
            expectation.fulfill()
        }
        waitForExpectations()

        let description2 = "Update the new synonym."
        let expectation2 = self.expectation(description: description2)

        let updatedSynonym = "new-" + newSynonym
        assistant.updateSynonym(workspaceID: workspaceID, entity: "appliance", value: "lights", synonym: newSynonym, newSynonym: updatedSynonym, failure: failWithError){ synonym in
            XCTAssertEqual(synonym.synonymText, updatedSynonym)
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Delete the new synonym."
        let expectation3 = self.expectation(description: description3)

        assistant.deleteSynonym(workspaceID: workspaceID, entity: "appliance", value: "lights", synonym: updatedSynonym, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Dialog Nodes

    func testListAllDialogNodes() {
        let description = "List all dialog nodes"
        let expectation = self.expectation(description: description)

        assistant.listDialogNodes(workspaceID: workspaceID, includeCount: true, failure: failWithError) { nodes in
            for node in nodes.dialogNodes {
                XCTAssertNotNil(node.dialogNodeID)
            }
            XCTAssertGreaterThan(nodes.dialogNodes.count, 0)
            XCTAssertNotNil(nodes.pagination.refreshUrl)
            XCTAssertNotNil(nodes.pagination.total)
            XCTAssertNotNil(nodes.pagination.matched)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testCreateAndDeleteDialogNode() {
        let description1 = "Create a dialog node."
        let expectation1 = self.expectation(description: description1)

        let dialogNode = CreateDialogNode(
            dialogNode: "YesYouCan",
            description: "Reply affirmatively",
            conditions: "#order_pizza",
            parent: nil,
            previousSibling: nil,
            output: [
                "text": .object([
                    "selection_policy": .string("random"),
                    "values": .array([.string("Yes you can!"), .string("Of course!")]),
                ]),
            ],
            context: nil,
            metadata: ["swift-sdk-test": .boolean(true)],
            nextStep: nil,
            actions: nil,
            title: "YesYouCan",
            nodeType: "standard",
            eventName: nil,
            variable: nil)
        assistant.createDialogNode(workspaceID: workspaceID, properties: dialogNode, failure: failWithError) {
            node in
            XCTAssertEqual(dialogNode.dialogNode, node.dialogNodeID)
            XCTAssertEqual(dialogNode.description, node.description)
            XCTAssertEqual(dialogNode.conditions, node.conditions)
            XCTAssertNil(node.parent)
            XCTAssertNil(node.previousSibling)
            XCTAssertEqual(dialogNode.output!, node.output!)
            XCTAssertNil(node.context)
            XCTAssertEqual(dialogNode.metadata!, node.metadata!)
            XCTAssertNil(node.nextStep)
            XCTAssertNil(node.actions)
            XCTAssertEqual(dialogNode.title!, node.title)
            XCTAssertEqual(dialogNode.nodeType!, node.nodeType)
            XCTAssertNil(node.eventName)
            XCTAssertNil(node.variable)
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Delete a dialog node"
        let expectation2 = self.expectation(description: description2)

        assistant.deleteDialogNode(workspaceID: workspaceID, dialogNode: dialogNode.dialogNode, failure: failWithError) {
            expectation2.fulfill()
        }
        waitForExpectations()
    }

    func testCreateUpdateAndDeleteDialogNode() {
        let description1 = "Create a dialog node."
        let expectation1 = self.expectation(description: description1)
        let dialogNode = CreateDialogNode(dialogNode: "test-node")
        assistant.createDialogNode(workspaceID: workspaceID, properties: dialogNode, failure: failWithError) {
            node in
            XCTAssertEqual(dialogNode.dialogNode, node.dialogNodeID)
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Update a dialog node."
        let expectation2 = self.expectation(description: description2)
        let updatedNode = UpdateDialogNode(dialogNode: "test-node-updated")
        assistant.updateDialogNode(workspaceID: workspaceID, dialogNode: "test-node", properties: updatedNode, failure: failWithError) {
            node in
            XCTAssertEqual(updatedNode.dialogNode, node.dialogNodeID)
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Delete a dialog node."
        let expectation3 = self.expectation(description: description3)
        assistant.deleteDialogNode(workspaceID: workspaceID, dialogNode: updatedNode.dialogNode!, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    func testGetDialogNode() {
        let description = "Get details of a specific dialog node."
        let expectation = self.expectation(description: description)
        assistant.listDialogNodes(workspaceID: workspaceID, failure: failWithError) { nodes in
            XCTAssertGreaterThan(nodes.dialogNodes.count, 0)
            let dialogNode = nodes.dialogNodes.first!
            self.assistant.getDialogNode(
                workspaceID: self.workspaceID,
                dialogNode: dialogNode.dialogNodeID,
                failure: self.failWithError) {
                    node in
                    XCTAssertEqual(dialogNode.dialogNodeID, node.dialogNodeID)
                    expectation.fulfill()
                }
        }
        waitForExpectations()
    }

    // MARK: - Logs

    func testListAllLogs() {
        let expectation = self.expectation(description: "List all logs")
        let filter = "workspace_id::\(workspaceID),language::en"
        assistant.listAllLogs(filter: filter, failure: failWithError) { logCollection in
            XCTAssert(logCollection.logs.count > 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListLogs() {
        let expectation = self.expectation(description: "List logs")
        assistant.listLogs(workspaceID: workspaceID, failure: failWithError) { logCollection in
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
        let failure = { (error: Error) in expectation.fulfill() }
        assistant.message(workspaceID: workspaceID, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    func testMessageInvalidWorkspaceID() {
        let description = "Start a conversation with an invalid workspace."
        let expectation = self.expectation(description: description)
        let workspaceID = "this id is invalid"
        let failure = { (error: Error) in expectation.fulfill() }
        assistant.message(workspaceID: workspaceID, failure: failure, success: failWithResult)
        waitForExpectations()
    }
}
