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
import RestKit

class AssistantTests: XCTestCase {

    private var assistant: Assistant!
    private let workspaceID = WatsonCredentials.AssistantWorkspace

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
            ("testListMentions", testListMentions),
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
            ("testInvalidServiceURL", testInvalidServiceURL),
        ]
    }

    /** Instantiate Assistant. */
    func instantiateAssistant() {
        if let apiKey = WatsonCredentials.AssistantAPIKey {
            assistant = Assistant(version: versionDate, apiKey: apiKey)
        } else {
            let username = WatsonCredentials.AssistantUsername
            let password = WatsonCredentials.AssistantPassword
            assistant = Assistant(username: username, password: password, version: versionDate)
        }
        if let url = WatsonCredentials.AssistantURL {
            assistant.serviceURL = url
        }
        assistant.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        assistant.defaultHeaders["X-Watson-Test"] = "true"
    }

    func waitForExpectations(timeout: TimeInterval = 10.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: - Positive Tests

    func testMessage() {
        let description1 = "Start a conversation."
        let expectation1 = self.expectation(description: description1)

        let result1 = ["Hi. It looks like a nice drive today. What would you like me to do?  "]

        var context: Context?
        assistant.message(workspaceID: workspaceID, nodesVisitedDetails: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let message = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            // verify input
            XCTAssertNil(message.input.text)

            // verify context
            XCTAssertNotNil(message.context.conversationID)
            XCTAssertNotEqual(message.context.conversationID, "")
            XCTAssertNotNil(message.context.system)
            XCTAssertNotNil(message.context.system!.additionalProperties)
            XCTAssertFalse(message.context.system!.additionalProperties.isEmpty)

            // verify entities
            XCTAssertTrue(message.entities.isEmpty)

            // verify intents
            XCTAssertTrue(message.intents.isEmpty)

            // verify output
            XCTAssertTrue(message.output.logMessages.isEmpty)
            XCTAssertEqual(message.output.text, result1)
            XCTAssertNotNil(message.output.nodesVisited)
            XCTAssertEqual(message.output.nodesVisited!.count, 1)
            XCTAssertNotNil(message.output.nodesVisitedDetails)
            XCTAssertNotNil(message.output.nodesVisitedDetails!.first)
            XCTAssertNotNil(message.output.nodesVisitedDetails!.first!.dialogNode)

            context = message.context
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Continue a conversation."
        let expectation2 = self.expectation(description: description2)

        let input = MessageInput(text: "Turn on the radio.")
        let result2 = ["Sure thing! Which genre would you prefer? Jazz is my personal favorite."]

        assistant.message(workspaceID: workspaceID, input: input, context: context!) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let message = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            // verify input
            XCTAssertEqual(message.input.text, input.text)

            // verify context
            XCTAssertEqual(message.context.conversationID, context!.conversationID)
            XCTAssertNotNil(message.context.system)
            XCTAssertNotNil(message.context.system!.additionalProperties)
            XCTAssertFalse(message.context.system!.additionalProperties.isEmpty)

            // verify entities
            XCTAssertEqual(message.entities.count, 1)
            XCTAssertEqual(message.entities[0].entity, "appliance")
            XCTAssertEqual(message.entities[0].location[0], 12)
            XCTAssertEqual(message.entities[0].location[1], 17)
            XCTAssertEqual(message.entities[0].value, "music")

            // verify intents
            XCTAssertEqual(message.intents.count, 1)
            XCTAssertEqual(message.intents[0].intent, "turn_on")
            XCTAssert(message.intents[0].confidence >= 0.80)
            XCTAssert(message.intents[0].confidence <= 1.00)

            // verify output
            XCTAssertTrue(message.output.logMessages.isEmpty)
            XCTAssertEqual(message.output.text, result2)
            XCTAssertNotNil(message.output.nodesVisited)
            XCTAssertEqual(message.output.nodesVisited!.count, 3)

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

        assistant.message(workspaceID: workspaceID) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let message = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            context = message.context
            entities = message.entities
            intents = message.intents
            output = message.output
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Continue a conversation."
        let expectation2 = expectation(description: description2)

        let input2 = MessageInput(text: "Turn on the radio.")
        assistant.message(
            workspaceID: workspaceID,
            input: input2,
            intents: intents,
            entities: entities,
            context: context,
            output: output)
        {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let message = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            // verify objects are non-nil
            XCTAssertNotNil(entities)
            XCTAssertNotNil(intents)
            XCTAssertNotNil(output)

            // verify intents are equal
            for index in 0..<message.intents.count {
                let intent1 = intents![index]
                let intent2 = message.intents[index]
                XCTAssertEqual(intent1.intent, intent2.intent)
                XCTAssertEqual(intent1.confidence, intent2.confidence, accuracy: 10E-5)
            }

            // verify entities are equal
            for index in 0..<message.entities.count {
                let entity1 = entities![index]
                let entity2 = message.entities[index]
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

        assistant.message(workspaceID: workspaceID) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let message = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            context = message.context
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Continue a conversation."
        let expectation2 = expectation(description: description2)

        let input2 = MessageInput(text: "Turn on the radio.")
        assistant.message(
            workspaceID: workspaceID,
            input: input2,
            intents: intents,
            entities: entities,
            context: context,
            output: output)
        {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let message = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            context = message.context
            entities = message.entities
            intents = message.intents
            output = message.output
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Continue a conversation with non-empty intents and entities."
        let expectation3 = expectation(description: description3)

        let input3 = MessageInput(text: "Rock music.")
        assistant.message(
            workspaceID: workspaceID,
            input: input3,
            intents: intents,
            entities: entities,
            context: context,
            output: output)
        {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let message = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            // verify objects are non-nil
            XCTAssertNotNil(entities)
            XCTAssertNotNil(intents)
            XCTAssertNotNil(output)

            // verify intents are equal
            for index in 0..<message.intents.count {
                let intent1 = intents![index]
                let intent2 = message.intents[index]
                XCTAssertEqual(intent1.intent, intent2.intent)
                XCTAssertEqual(intent1.confidence, intent2.confidence, accuracy: 10E-5)
            }

            // verify entities are equal
            for index in 0..<message.entities.count {
                let entity1 = entities![index]
                let entity2 = message.entities[index]
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
        assistant.message(workspaceID: workspaceID) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let message = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            context = message.context
            context?.additionalProperties["foo"] = .string("bar")
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Continue a conversation."
        let expectation2 = expectation(description: description2)

        let input2 = MessageInput(text: "Turn on the radio.")
        assistant.message(workspaceID: workspaceID, input: input2, context: context) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let message = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            let additionalProperties = message.context.additionalProperties
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

        assistant.listWorkspaces(includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let workspaceResult = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            for workspace in workspaceResult.workspaces {
                XCTAssertNotNil(workspace.name)
                XCTAssertNotNil(workspace.created)
                XCTAssertNotNil(workspace.updated)
                XCTAssertNotNil(workspace.language)
                XCTAssertNotNil(workspace.workspaceID)
            }
            XCTAssertNotNil(workspaceResult.pagination.refreshURL)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListAllWorkspacesWithPageLimit1() {
        let description = "List all workspaces with page limit specified as 1."
        let expectation = self.expectation(description: description)

        assistant.listWorkspaces(pageLimit: 1, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let workspaceResult = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(workspaceResult.workspaces.count, 1)
            for workspace in workspaceResult.workspaces {
                XCTAssertNotNil(workspace.name)
                XCTAssertNotNil(workspace.created)
                XCTAssertNotNil(workspace.updated)
                XCTAssertNotNil(workspace.language)
                XCTAssertNotNil(workspace.workspaceID)
            }
            XCTAssertNotNil(workspaceResult.pagination.refreshURL)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListAllWorkspacesWithIncludeCount() {
        let description = "List all workspaces with includeCount as true."
        let expectation = self.expectation(description: description)

        assistant.listWorkspaces(includeCount: true, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let workspaceResult = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            for workspace in workspaceResult.workspaces {
                XCTAssertNotNil(workspace.name)
                XCTAssertNotNil(workspace.created)
                XCTAssertNotNil(workspace.updated)
                XCTAssertNotNil(workspace.language)
                XCTAssertNotNil(workspace.workspaceID)
            }
            XCTAssertNotNil(workspaceResult.pagination.refreshURL)
            XCTAssertNotNil(workspaceResult.pagination.total)
            XCTAssertNotNil(workspaceResult.pagination.matched)
            XCTAssertGreaterThanOrEqual(workspaceResult.pagination.total!, workspaceResult.workspaces.count)
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
        let intentExample = Example(text: "This is an example of Intent1")
        let workspaceIntent = CreateIntent(intent: "Intent1", description: "description of Intent1", examples: [intentExample])
        let entityValue = CreateValue(value: "Entity1Value", metadata: workspaceMetadata, synonyms: ["Synonym1", "Synonym2"])
        let workspaceEntity = CreateEntity(entity: "Entity1", description: "description of Entity1", values: [entityValue])
        let workspaceDialogNode = DialogNode(dialogNode: "DialogNode1", description: "description of DialogNode1")
        let workspaceCounterexample = Counterexample(text: "This is a counterexample")

        assistant.createWorkspace(
            name: workspaceName,
            description: workspaceDescription,
            language: workspaceLanguage,
            metadata: workspaceMetadata,
            intents: [workspaceIntent],
            entities: [workspaceEntity],
            dialogNodes: [workspaceDialogNode],
            counterexamples: [workspaceCounterexample])
        {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let workspace = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

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

        assistant.getWorkspace(workspaceID: newWorkspaceID, export: true, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let workspace = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

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
        waitForExpectations(timeout: 20.0)

        let description3 = "Delete the newly created workspace."
        let expectation3 = expectation(description: description3)

        assistant.deleteWorkspace(workspaceID: newWorkspaceID) {
            _, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    func testListSingleWorkspace() {
        let description = "List details of a single workspace."
        let expectation = self.expectation(description: description)

        assistant.getWorkspace(workspaceID: workspaceID, export: false, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let workspace = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

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
        assistant.createWorkspace(name: workspaceName, description: workspaceDescription, language: workspaceLanguage) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let workspace = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

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

        assistant.updateWorkspace(workspaceID: newWorkspaceID, name: newWorkspaceName, description: newWorkspaceDescription) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let workspace = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(workspace.name, newWorkspaceName)
            XCTAssertEqual(workspace.description, newWorkspaceDescription)
            XCTAssertEqual(workspace.language, workspaceLanguage)
            XCTAssertNotNil(workspace.workspaceID)
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Delete the newly created workspace."
        let expectation3 = expectation(description: description3)

        assistant.deleteWorkspace(workspaceID: newWorkspaceID) {
            _, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }

            expectation3.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Intents

    func testListAllIntents() {
        let description = "List all the intents in a workspace."
        let expectation = self.expectation(description: description)

        assistant.listIntents(workspaceID: workspaceID, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let intents = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            for intent in intents.intents {
                XCTAssertNotNil(intent.intent)
                XCTAssertNotNil(intent.created)
                XCTAssertNotNil(intent.updated)
                XCTAssertNil(intent.examples)
            }
            XCTAssertNotNil(intents.pagination.refreshURL)
            XCTAssertNil(intents.pagination.nextURL)
            XCTAssertNil(intents.pagination.total)
            XCTAssertNil(intents.pagination.matched)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListAllIntentsWithIncludeCount() {
        let description = "List all the intents in a workspace with includeCount as true."
        let expectation = self.expectation(description: description)

        assistant.listIntents(workspaceID: workspaceID, includeCount: true, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let intents = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            for intent in intents.intents {
                XCTAssertNotNil(intent.intent)
                XCTAssertNotNil(intent.created)
                XCTAssertNotNil(intent.updated)
                XCTAssertNil(intent.examples)
            }
            XCTAssertNotNil(intents.pagination.refreshURL)
            XCTAssertNil(intents.pagination.nextURL)
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

        assistant.listIntents(workspaceID: workspaceID, pageLimit: 1, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let intents = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(intents.intents.count, 1)
            for intent in intents.intents {
                XCTAssertNotNil(intent.intent)
                XCTAssertNotNil(intent.created)
                XCTAssertNotNil(intent.updated)
                XCTAssertNil(intent.examples)
            }
            XCTAssertNotNil(intents.pagination.refreshURL)
            XCTAssertNotNil(intents.pagination.nextURL)
            XCTAssertNil(intents.pagination.total)
            XCTAssertNil(intents.pagination.matched)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListAllIntentsWithExport() {
        let description = "List all the intents in a workspace with export as true."
        let expectation = self.expectation(description: description)

        assistant.listIntents(workspaceID: workspaceID, export: true, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let intents = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

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
            XCTAssertNotNil(intents.pagination.refreshURL)
            XCTAssertNil(intents.pagination.nextURL)
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
        let example1 = Example(text: "example 1 for \(newIntentName)")
        let example2 = Example(text: "example 2 for \(newIntentName)")
        assistant.createIntent(workspaceID: workspaceID, intent: newIntentName, description: newIntentDescription, examples: [example1, example2]) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let intent = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(intent.intent, newIntentName)
            XCTAssertEqual(intent.description, newIntentDescription)
            expectation.fulfill()
        }
        waitForExpectations()

        let description2 = "Delete the new intent."
        let expectation2 = self.expectation(description: description2)

        assistant.deleteIntent(workspaceID: workspaceID, intent: newIntentName) {
            _, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }

            expectation2.fulfill()
        }
        waitForExpectations()
    }

    func testGetIntentWithExport() {
        let description = "Get details of a specific intent."
        let expectation = self.expectation(description: description)

        assistant.getIntent(workspaceID: workspaceID, intent: "weather", export: true, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let intent = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

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
        let example1 = Example(text: "example 1 for \(newIntentName)")
        let example2 = Example(text: "example 2 for \(newIntentName)")
        assistant.createIntent(workspaceID: workspaceID, intent: newIntentName, description: newIntentDescription, examples: [example1, example2]) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let intent = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(intent.intent, newIntentName)
            XCTAssertEqual(intent.description, newIntentDescription)
            expectation.fulfill()
        }
        waitForExpectations()

        let description2 = "Update the new intent."
        let expectation2 = self.expectation(description: description2)

        let updatedIntentName = "updated-name-for-\(newIntentName)"
        let updatedIntentDescription = "updated-description-for-\(newIntentName)"
        let updatedExample1 = Example(text: "updated example for \(newIntentName)")
        assistant.updateIntent(workspaceID: workspaceID, intent: newIntentName, newIntent: updatedIntentName, newDescription: updatedIntentDescription, newExamples: [updatedExample1]) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let intent = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(intent.intent, updatedIntentName)
            XCTAssertEqual(intent.description, updatedIntentDescription)
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Delete the new intent."
        let expectation3 = self.expectation(description: description3)

        assistant.deleteIntent(workspaceID: workspaceID, intent: updatedIntentName) {
            _, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }

            expectation3.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Examples

    func testListAllExamples() {
        let description = "List all the examples of an intent."
        let expectation = self.expectation(description: description)

        assistant.listExamples(workspaceID: workspaceID, intent: "weather", includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let examples = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            for example in examples.examples {
                XCTAssertNotNil(example.created)
                XCTAssertNotNil(example.updated)
                XCTAssertNotNil(example.text)
            }
            XCTAssertNotNil(examples.pagination.refreshURL)
            XCTAssertNil(examples.pagination.total)
            XCTAssertNil(examples.pagination.matched)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListAllExamplesWithIncludeCount() {
        let description = "List all the examples for an intent with includeCount as true."
        let expectation = self.expectation(description: description)

        assistant.listExamples(workspaceID: workspaceID, intent: "weather", includeCount: true, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let examples = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            for example in examples.examples {
                XCTAssertNotNil(example.created)
                XCTAssertNotNil(example.updated)
                XCTAssertNotNil(example.text)
            }
            XCTAssertNotNil(examples.pagination.refreshURL)
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

        assistant.listExamples(workspaceID: workspaceID, intent: "weather", pageLimit: 1, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let examples = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(examples.examples.count, 1)
            for example in examples.examples {
                XCTAssertNotNil(example.created)
                XCTAssertNotNil(example.updated)
                XCTAssertNotNil(example.text)
            }
            XCTAssertNotNil(examples.pagination.refreshURL)
            XCTAssertNotNil(examples.pagination.nextURL)
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
        assistant.createExample(workspaceID: workspaceID, intent: "weather", text: newExample) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let example = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(example.text, newExample)
            expectation.fulfill()
        }
        waitForExpectations()

        let description2 = "Delete the new example."
        let expectation2 = self.expectation(description: description2)

        assistant.deleteExample(workspaceID: workspaceID, intent: "weather", text: newExample) {
            _, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }

            expectation2.fulfill()
        }
        waitForExpectations()
    }

    func testGetExample() {
        let description = "Get details of a specific example."
        let expectation = self.expectation(description: description)

        let exampleText = "tell me the weather"
        assistant.getExample(workspaceID: workspaceID, intent: "weather", text: exampleText, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let example = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

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
        assistant.createExample(workspaceID: workspaceID, intent: "weather", text: newExample) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let example = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(example.text, newExample)
            expectation.fulfill()
        }
        waitForExpectations()

        let description2 = "Update the new example."
        let expectation2 = self.expectation(description: description2)

        let updatedText = "updated-" + newExample
        assistant.updateExample(workspaceID: workspaceID, intent: "weather", text: newExample, newText: updatedText) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let example = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(example.text, updatedText)
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Delete the new example."
        let expectation3 = self.expectation(description: description3)

        assistant.deleteExample(workspaceID: workspaceID, intent: "weather", text: updatedText) {
            _, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }

            expectation3.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Counterexamples

    func testListAllCounterexamples() {
        let description = "List all the counterexamples of a workspace."
        let expectation = self.expectation(description: description)

        assistant.listCounterexamples(workspaceID: workspaceID, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let counterexamples = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            for counterexample in counterexamples.counterexamples {
                XCTAssertNotNil(counterexample.created)
                XCTAssertNotNil(counterexample.updated)
                XCTAssertNotNil(counterexample.text)
            }
            XCTAssertNotNil(counterexamples.pagination.refreshURL)
            XCTAssertNil(counterexamples.pagination.nextURL)
            XCTAssertNil(counterexamples.pagination.total)
            XCTAssertNil(counterexamples.pagination.matched)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListAllCounterexamplesWithIncludeCount() {
        let description = "List all the counterexamples of a workspace with includeCount as true."
        let expectation = self.expectation(description: description)

        assistant.listCounterexamples(workspaceID: workspaceID, includeCount: true, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let counterexamples = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            for counterexample in counterexamples.counterexamples {
                XCTAssertNotNil(counterexample.created)
                XCTAssertNotNil(counterexample.updated)
                XCTAssertNotNil(counterexample.text)
            }
            XCTAssertNotNil(counterexamples.pagination.refreshURL)
            XCTAssertNil(counterexamples.pagination.nextURL)
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

        assistant.listCounterexamples(workspaceID: workspaceID, pageLimit: 1, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let counterexamples = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            for counterexample in counterexamples.counterexamples {
                XCTAssertNotNil(counterexample.created)
                XCTAssertNotNil(counterexample.updated)
                XCTAssertNotNil(counterexample.text)
            }
            XCTAssertNotNil(counterexamples.pagination.refreshURL)
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
        assistant.createCounterexample(workspaceID: workspaceID, text: newExample) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let counterexample = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertNotNil(counterexample.text)
            expectation.fulfill()
        }
        waitForExpectations()

        let description2 = "Delete the new counterexample."
        let expectation2 = self.expectation(description: description2)

        assistant.deleteCounterexample(workspaceID: workspaceID, text: newExample) {
            _, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }

            expectation2.fulfill()
        }
        waitForExpectations()
    }

    func testGetCounterexample() {
        let description = "Get details of a specific counterexample."
        let expectation = self.expectation(description: description)

        let example = "when will it be funny"
        assistant.getCounterexample(workspaceID: workspaceID, text: example, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let counterexample = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertNotNil(counterexample.created)
            XCTAssertNotNil(counterexample.updated)
            XCTAssertEqual(counterexample.text, example)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testCreateUpdateAndDeleteCounterexample() {
        let description = "Create a new counterexample."
        let expectation = self.expectation(description: description)

        let newExample = "swift-sdk-test-counterexample" + UUID().uuidString
        assistant.createCounterexample(workspaceID: workspaceID, text: newExample) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let counterexample = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(counterexample.text, newExample)
            expectation.fulfill()
        }
        waitForExpectations()

        let description2 = "Update the new example."
        let expectation2 = self.expectation(description: description2)

        let updatedText = "updated-"+newExample
        assistant.updateCounterexample(workspaceID: workspaceID, text: newExample, newText: updatedText) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let counterexample = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(counterexample.text, updatedText)
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Delete the new counterexample."
        let expectation3 = self.expectation(description: description3)

        assistant.deleteCounterexample(workspaceID: workspaceID, text: updatedText) {
            _, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }

            expectation3.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Entities

    func testListAllEntities() {
        let description = "List all entities"
        let expectation = self.expectation(description: description)

        assistant.listEntities(workspaceID: workspaceID, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let entities = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            for entity in entities.entities {
                XCTAssertNotNil(entity.entity)
                XCTAssertNotNil(entity.created)
                XCTAssertNotNil(entity.updated)
            }
            XCTAssert(entities.entities.count > 0)
            XCTAssertNotNil(entities.pagination.refreshURL)
            XCTAssertNil(entities.pagination.nextURL)
            XCTAssertNil(entities.pagination.total)
            XCTAssertNil(entities.pagination.matched)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListAllEntitiesWithIncludeCount() {
        let description = "List all the entities in a workspace with includeCount as true."
        let expectation = self.expectation(description: description)

        assistant.listEntities(workspaceID: workspaceID, includeCount: true, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let entities = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            for entity in entities.entities {
                XCTAssertNotNil(entity.entity)
                XCTAssertNotNil(entity.created)
                XCTAssertNotNil(entity.updated)
            }
            XCTAssertNotNil(entities.pagination.refreshURL)
            XCTAssertNil(entities.pagination.nextURL)
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

        assistant.listEntities(workspaceID: workspaceID, pageLimit: 1, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let entities = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            for entity in entities.entities {
                XCTAssertNotNil(entity.entity)
                XCTAssertNotNil(entity.created)
                XCTAssertNotNil(entity.updated)
            }
            XCTAssertNotNil(entities.pagination.refreshURL)
            XCTAssertNotNil(entities.pagination.nextURL)
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

        assistant.listEntities(workspaceID: workspaceID, export: true, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let entities = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            for entity in entities.entities {
                XCTAssertNotNil(entity.entity)
                XCTAssertNotNil(entity.created)
                XCTAssertNotNil(entity.updated)
            }
            XCTAssertNotNil(entities.entities)
            XCTAssertNil(entities.pagination.total)
            XCTAssertNil(entities.pagination.matched)
            XCTAssertNil(entities.pagination.nextURL)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testCreateAndDeleteEntity(){
        let description = "Create an Entity"
        let expectation = self.expectation(description: description)

        let entityName = "swift-sdk-test-entity" + UUID().uuidString
        let entityDescription = "This is a test entity"

        assistant.createEntity(workspaceID: workspaceID, entity: entityName, description: entityDescription){
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let entity = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(entity.entity, entityName)
            XCTAssertEqual(entity.description, entityDescription)
            expectation.fulfill()
        }
        waitForExpectations()

        let descriptionTwo = "Delete the entity"
        let expectationTwo = self.expectation(description: descriptionTwo)

        assistant.deleteEntity(workspaceID: workspaceID, entity: entityName) {
            _, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }

            expectationTwo.fulfill()
        }
        waitForExpectations()
    }

    func testCreateUpdateAndDeleteEntity(){
        let description = "Create an Entity"
        let expectation = self.expectation(description: description)

        let entityName = "swift-sdk-test-entity" + UUID().uuidString
        let entityDescription = "This is a test entity"

        assistant.createEntity(workspaceID: workspaceID, entity: entityName, description: entityDescription){
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let entity = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(entity.entity, entityName)
            XCTAssertEqual(entity.description, entityDescription)
            expectation.fulfill()
        }
        waitForExpectations()

        let descriptionTwo = "Update the entity"
        let expectationTwo = self.expectation(description: descriptionTwo)

        let updatedEntityName = "up-" + entityName
        let updatedEntityDescription = "This is a new description for a test entity"
        assistant.updateEntity(
            workspaceID: workspaceID,
            entity: entityName,
            newEntity: updatedEntityName,
            newDescription: updatedEntityDescription)
        {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let entity = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(entity.entity, updatedEntityName)
            XCTAssertEqual(entity.description, updatedEntityDescription)
            expectationTwo.fulfill()
        }
        waitForExpectations()

        let descriptionFour = "Delete the entity"
        let expectationFour = self.expectation(description: descriptionFour)

        assistant.deleteEntity(workspaceID: workspaceID, entity: updatedEntityName) {
            _, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }

            expectationFour.fulfill()
        }
        waitForExpectations()
    }

    func testGetEntity() {
        let description = "Get details of a specific entity."
        let expectation = self.expectation(description: description)

        assistant.listEntities(workspaceID: workspaceID) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let entityCollection = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssert(entityCollection.entities.count > 0)
            let entity0 = entityCollection.entities[0]
            self.assistant.getEntity(workspaceID: self.workspaceID, entity: entity0.entity, export: true, includeAudit: true) {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let entity = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }

                XCTAssertEqual(entity.entity, entity0.entity)
                XCTAssertEqual(entity.description, entity0.description)
                XCTAssertNotNil(entity.created)
                XCTAssertNotNil(entity.updated)
                expectation.fulfill()
            }
        }
        waitForExpectations()
    }

    // MARK: - Mentions

    func testListMentions() {
        let description = "List all the mentions for an entity."
        let expectation = self.expectation(description: description)
        let entityName = "appliance"
        assistant.listMentions(
            workspaceID: workspaceID,
            entity: entityName,
            export: true,
            includeAudit: true) {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let mentionCollection = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }

                for mention in mentionCollection.examples {
                    XCTAssertNotNil(mention.text)
                    XCTAssertNotNil(mention.intent)
                    XCTAssertNotNil(mention.location)
                    XCTAssert(mention.location.count == 2)
                }
                XCTAssertNotNil(mentionCollection.pagination.refreshURL)
                expectation.fulfill()
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
            includeAudit: true) {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let valueCollection = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }

                for value in valueCollection.values {
                    XCTAssertNotNil(value.value)
                    XCTAssertNotNil(value.created)
                    XCTAssertNotNil(value.updated)
                }
                XCTAssertNotNil(valueCollection.pagination.refreshURL)
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
        assistant.createValue(workspaceID: workspaceID, entity: entityName, value: valueName) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let value = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(value.value, valueName)
            expectation.fulfill()
        }
        waitForExpectations()

        let descriptionTwo = "Update the value"
        let expectationTwo = self.expectation(description: descriptionTwo)

        let updatedValueName = "up-" + valueName
        assistant.updateValue(
            workspaceID: workspaceID,
            entity: entityName,
            value: valueName,
            newValue: updatedValueName,
            newMetadata: ["oldname": .string(valueName)])
        {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let value = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(value.value, updatedValueName)
            XCTAssertNotNil(value.metadata)
            expectationTwo.fulfill()
        }
        waitForExpectations()

        let descriptionThree = "Delete the updated value"
        let expectationThree = self.expectation(description: descriptionThree)

        assistant.deleteValue(workspaceID: workspaceID, entity: entityName, value: updatedValueName) {
            _, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }

            expectationThree.fulfill()
        }
        waitForExpectations()
    }

    func testGetValue() {
        let description = "Get a value for an entity."
        let expectation = self.expectation(description: description)

        let entityName = "appliance"

        assistant.listValues(workspaceID: workspaceID, entity: entityName) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let valueCollection = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssert(valueCollection.values.count > 0)
            let value0 = valueCollection.values[0]
            self.assistant.getValue(workspaceID: self.workspaceID, entity: entityName, value: value0.value, export: true, includeAudit: true) {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let value = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }

                XCTAssertEqual(value0.value, value.value)
                XCTAssertNotNil(value.created)
                XCTAssertNotNil(value.updated)
                expectation.fulfill()
            }
        }
        waitForExpectations()
    }

    // MARK: - Synonyms

    func testListAllSynonym() {
        let description = "List all the synonyms for an entity and value."
        let expectation = self.expectation(description: description)

        assistant.listSynonyms(workspaceID: workspaceID, entity: "appliance", value: "lights", includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let synonyms = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            for synonym in synonyms.synonyms {
                XCTAssertNotNil(synonym.created)
                XCTAssertNotNil(synonym.updated)
                XCTAssertNotNil(synonym.synonym)
            }
            XCTAssertNotNil(synonyms.pagination.refreshURL)
            XCTAssertNil(synonyms.pagination.total)
            XCTAssertNil(synonyms.pagination.matched)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListAllSynonymWithIncludeCount() {
        let description = "List all the synonyms for an entity and value with includeCount as true."
        let expectation = self.expectation(description: description)

        assistant.listSynonyms(workspaceID: workspaceID, entity: "appliance", value: "lights", includeCount: true, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let synonyms = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            for synonym in synonyms.synonyms {
                XCTAssertNotNil(synonym.created)
                XCTAssertNotNil(synonym.updated)
                XCTAssertNotNil(synonym.synonym)
            }
            XCTAssertNotNil(synonyms.pagination.refreshURL)
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

        assistant.listSynonyms(workspaceID: workspaceID, entity: "appliance", value: "lights", pageLimit: 1, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let synonyms = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(synonyms.synonyms.count, 1)
            for synonym in synonyms.synonyms {
                XCTAssertNotNil(synonym.created)
                XCTAssertNotNil(synonym.updated)
                XCTAssertNotNil(synonym.synonym)
            }
            XCTAssertNotNil(synonyms.pagination.refreshURL)
            XCTAssertNotNil(synonyms.pagination.nextURL)
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
        assistant.createSynonym(workspaceID: workspaceID, entity: "appliance", value: "lights", synonym: newSynonym) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let synonym = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(synonym.synonym, newSynonym)
            expectation.fulfill()
        }
        waitForExpectations()

        let description2 = "Delete the new synonym."
        let expectation2 = self.expectation(description: description2)

        assistant.deleteSynonym(workspaceID: workspaceID, entity: "appliance", value: "lights", synonym: newSynonym) {
            _, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }

            expectation2.fulfill()
        }
        waitForExpectations()
    }

    func testGetSynonym() {
        let description = "Get details of a specific synonym."
        let expectation = self.expectation(description: description)

        let synonymName = "headlight"
        assistant.getSynonym(workspaceID: workspaceID, entity: "appliance", value: "lights", synonym: synonymName, includeAudit: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let synonym = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

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
        assistant.createSynonym(workspaceID: workspaceID, entity: "appliance", value: "lights", synonym: newSynonym) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let synonym = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(synonym.synonym, newSynonym)
            expectation.fulfill()
        }
        waitForExpectations()

        let description2 = "Update the new synonym."
        let expectation2 = self.expectation(description: description2)

        let updatedSynonym = "new-" + newSynonym
        assistant.updateSynonym(workspaceID: workspaceID, entity: "appliance", value: "lights", synonym: newSynonym, newSynonym: updatedSynonym){
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let synonym = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(synonym.synonym, updatedSynonym)
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Delete the new synonym."
        let expectation3 = self.expectation(description: description3)

        assistant.deleteSynonym(workspaceID: workspaceID, entity: "appliance", value: "lights", synonym: updatedSynonym) {
            _, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }

            expectation3.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Dialog Nodes

    func testListAllDialogNodes() {
        let description = "List all dialog nodes"
        let expectation = self.expectation(description: description)

        assistant.listDialogNodes(workspaceID: workspaceID, includeCount: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let nodes = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            for node in nodes.dialogNodes {
                XCTAssertNotNil(node.dialogNode)
            }
            XCTAssertGreaterThan(nodes.dialogNodes.count, 0)
            XCTAssertNotNil(nodes.pagination.refreshURL)
            XCTAssertNotNil(nodes.pagination.total)
            XCTAssertNotNil(nodes.pagination.matched)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testCreateAndDeleteDialogNode() {
        let description1 = "Create a dialog node."
        let dialogNode = "OrderMyPizza"
        let dialogMetadata: [String: JSON] = ["swift-sdk-test": .boolean(true)]
        let expectation1 = self.expectation(description: description1)

        assistant.createDialogNode(
            workspaceID: workspaceID,
            dialogNode: dialogNode,
            description: "Reply affirmatively",
            conditions: "#order_pizza",
            metadata: dialogMetadata,
            title: "Order Pizza",
            nodeType: "standard")
        {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let node = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(node.dialogNode, dialogNode)
            XCTAssertEqual(node.description, "Reply affirmatively")
            XCTAssertEqual(node.conditions, "#order_pizza")
            XCTAssertNil(node.parent)
            XCTAssertNil(node.previousSibling)
            XCTAssertNil(node.context)
            XCTAssertEqual(node.metadata!, dialogMetadata)
            XCTAssertNil(node.nextStep)
            XCTAssertNil(node.actions)
            XCTAssertEqual(node.title, "Order Pizza")
            XCTAssertEqual(node.nodeType, "standard")
            XCTAssertNil(node.eventName)
            XCTAssertNil(node.variable)
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Delete a dialog node"
        let expectation2 = self.expectation(description: description2)

        assistant.deleteDialogNode(workspaceID: workspaceID, dialogNode: dialogNode) {
            _, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }

            expectation2.fulfill()
        }
        waitForExpectations()
    }

    func testCreateUpdateAndDeleteDialogNode() {
        let description1 = "Create a dialog node."
        let expectation1 = self.expectation(description: description1)
        assistant.createDialogNode(workspaceID: workspaceID, dialogNode: "test-node") {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let node = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(node.dialogNode, "test-node")
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Update a dialog node."
        let expectation2 = self.expectation(description: description2)
        assistant.updateDialogNode(
            workspaceID: workspaceID,
            dialogNode: "test-node",
            newDialogNode: "test-node-updated")
        {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let node = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(node.dialogNode, "test-node-updated")
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Delete a dialog node."
        let expectation3 = self.expectation(description: description3)
        assistant.deleteDialogNode(workspaceID: workspaceID, dialogNode: "test-node-updated") {
            _, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }

            expectation3.fulfill()
        }
        waitForExpectations()
    }

    func testGetDialogNode() {
        let description = "Get details of a specific dialog node."
        let expectation = self.expectation(description: description)
        assistant.listDialogNodes(workspaceID: workspaceID) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let nodes = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertGreaterThan(nodes.dialogNodes.count, 0)
            let dialogNode = nodes.dialogNodes.first!
            self.assistant.getDialogNode(
                workspaceID: self.workspaceID,
                dialogNode: dialogNode.dialogNode) {
                    response, error in

                    if let error = error {
                        XCTFail(unexpectedErrorMessage(error))
                        return
                    }
                    guard let node = response?.result else {
                        XCTFail(missingResultMessage)
                        return
                    }

                    XCTAssertEqual(dialogNode.dialogNode, node.dialogNode)
                    expectation.fulfill()
                }
        }
        waitForExpectations()
    }

    // MARK: - Logs

    func testListAllLogs() {
        let expectation = self.expectation(description: "List all logs")
        let filter = "workspace_id::\(workspaceID),language::en"
        assistant.listAllLogs(filter: filter) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let logCollection = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssert(logCollection.logs.count > 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListLogs() {
        let expectation = self.expectation(description: "List logs")
        assistant.listLogs(workspaceID: workspaceID) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let logCollection = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

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
        assistant.message(workspaceID: workspaceID) {
            _, error in

            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testMessageInvalidWorkspaceID() {
        let description = "Start a conversation with an invalid workspace."
        let expectation = self.expectation(description: description)
        let workspaceID = "this id is invalid"

        assistant.message(workspaceID: workspaceID) {
            _, error in

            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testInvalidServiceURL() {
        let description = "Start a conversation with an invalid workspace."
        let expectation = self.expectation(description: description)
        assistant.serviceURL = "this is broken"
        assistant.listWorkspaces { (_, error) in
            guard let error = error else {
                XCTFail(missingErrorMessage)
                return
            }

            switch error {
            case WatsonError.badURL:
                break
            default:
                XCTFail("Unexpected error: \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
}
