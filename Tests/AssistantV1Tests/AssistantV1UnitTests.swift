/**
 * Copyright IBM Corporation 2018
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
import RestKit
@testable import AssistantV1

class AssistantV1UnitTests: XCTestCase {

    private var assistant: Assistant!
    private let timeout = 1.0

    private let workspaceID = "test workspace"

    override func setUp() {
        assistant = Assistant(version: versionDate, accessToken: accessToken)

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: configuration)
        assistant.session = mockSession
    }

    // MARK: - errorResponseDecoder

    func testErrorResponseDecoder() {
        let testJSON: [String: JSON] = ["error": JSON.string("failed")]
        let testData = try! JSONEncoder().encode(testJSON)
        let testResponse = HTTPURLResponse(url: exampleURL, statusCode: 500, httpVersion: nil, headerFields: nil)!

        let error = assistant.errorResponseDecoder(data: testData, response: testResponse)
        if case let .http(statusCode, message, _) = error {
            XCTAssertEqual(statusCode, 500)
            XCTAssertNotNil(message)
        }
    }

    func testErrorResponseDecoderWithBadJSON() {
        let testData = Data()
        let testResponse = HTTPURLResponse(url: exampleURL, statusCode: 500, httpVersion: nil, headerFields: nil)!

        let error = assistant.errorResponseDecoder(data: testData, response: testResponse)
        if case let .http(statusCode, message, metadata) = error {
            XCTAssertEqual(statusCode, 500)
            XCTAssertNil(message)
            XCTAssertNil(metadata)
        }
    }

    // MARK: - Message

    func testMessage() {
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let endOfURL = request.url!.pathComponents.suffix(3)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "message")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            do {
                let body = Data(reading: request.httpBodyStream!)
                let decodedBody = try JSONDecoder().decode(MessageRequest.self, from: body)

                XCTAssertNotNil(decodedBody.alternateIntents)
                XCTAssertNotNil(decodedBody.context)
                XCTAssertNotNil(decodedBody.entities)
                XCTAssertNotNil(decodedBody.input)
                XCTAssertNotNil(decodedBody.intents)
                XCTAssertNotNil(decodedBody.output)
            } catch {
                XCTFail(missingBodyMessage(error))
            }

            return (HTTPURLResponse(), Data())
        }

        let input = InputData(text: "asdf")
        let context = Context(conversationID: "Hi, how are you?")
        let entities = [RuntimeEntity(entity: "entity", location: [0], value: "whatever")]
        let intents = [RuntimeIntent(intent: "intent", confidence: 1.0)]
        let output = OutputData(logMessages: [LogMessage(level: "SEVERE", msg: "shit's broken")], text: ["just kidding"])

        let expectation = self.expectation(description: "message")
        assistant.message(
            workspaceID: self.workspaceID,
            input: input,
            alternateIntents: true,
            context: context,
            entities: entities,
            intents: intents,
            output: output,
            nodesVisitedDetails: true) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: - Workspaces

    func testListWorkspaces() {
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            XCTAssertEqual(request.url?.lastPathComponent, "workspaces")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertTrue(request.url?.query?.contains("page_limit=10") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_count=true") ?? false)
            XCTAssertTrue(request.url?.query?.contains("sort=alphabetical") ?? false)
            XCTAssertTrue(request.url?.query?.contains("cursor=mouse") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_audit=true") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "listWorkspaces")
        assistant.listWorkspaces(
            pageLimit: 10,
            includeCount: true,
            sort: "alphabetical",
            cursor: "mouse",
            includeAudit: true) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testCreateWorkspace() {
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertNotNil(request.allHTTPHeaderFields)

            XCTAssertEqual(request.url?.lastPathComponent, "workspaces")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            do {
                let body = Data(reading: request.httpBodyStream!)
                let decodedBody = try JSONDecoder().decode(CreateWorkspace.self, from: body)

                XCTAssertNotNil(decodedBody.counterexamples)
                XCTAssertNotNil(decodedBody.description)
                XCTAssertNotNil(decodedBody.entities)
                XCTAssertNotNil(decodedBody.intents)
                XCTAssertNotNil(decodedBody.language)
                XCTAssertNotNil(decodedBody.learningOptOut)
                XCTAssertNotNil(decodedBody.metadata)
                XCTAssertNotNil(decodedBody.name)
                XCTAssertNotNil(decodedBody.systemSettings)
            } catch {
                XCTFail(missingBodyMessage(error))
            }

            return (HTTPURLResponse(), Data())
        }

        let intents = [CreateIntent(intent: "intent")]
        let entities = [CreateEntity(entity: "entity")]
        let dialogNodes = [CreateDialogNode(dialogNode: "Best node")]
        let counterExamples = [CreateCounterexample(text: "no u")]
        let metadata: [String: JSON] = ["key": JSON.string("value")]
        let systemSettings = WorkspaceSystemSettings(tooling: nil, disambiguation: nil, humanAgentAssist: nil)

        let expectation = self.expectation(description: "createWorkspace")
        assistant.createWorkspace(
            name: "Anthony's workspace",
            description: "The best workspace there ever was",
            language: "en",
            intents: intents,
            entities: entities,
            dialogNodes: dialogNodes,
            counterexamples: counterExamples,
            metadata: metadata,
            learningOptOut: true,
            systemSettings: systemSettings) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testGetWorkspace() {
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(2)
            XCTAssertEqual(endOfURL.first!, "workspaces")
            XCTAssertEqual(endOfURL.last!, self.workspaceID)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertTrue(request.url?.query?.contains("export=true") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_audit=true") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "getWorkspace")
        assistant.getWorkspace(
            workspaceID: self.workspaceID,
            export: true,
            includeAudit: true) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testUpdateWorkspace() {
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let endOfURL = request.url!.pathComponents.suffix(2)
            XCTAssertEqual(endOfURL.first!, "workspaces")
            XCTAssertEqual(endOfURL.last!, self.workspaceID)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertTrue(request.url?.query?.contains("append=true") ?? false)

            do {
                let body = Data(reading: request.httpBodyStream!)
                let decodedBody = try JSONDecoder().decode(UpdateWorkspace.self, from: body)

                XCTAssertNotNil(decodedBody.counterexamples)
                XCTAssertNotNil(decodedBody.description)
                XCTAssertNotNil(decodedBody.dialogNodes)
                XCTAssertNotNil(decodedBody.entities)
                XCTAssertNotNil(decodedBody.intents)
                XCTAssertNotNil(decodedBody.language)
                XCTAssertNotNil(decodedBody.learningOptOut)
                XCTAssertNotNil(decodedBody.metadata)
                XCTAssertNotNil(decodedBody.name)
                XCTAssertNotNil(decodedBody.systemSettings)
            } catch {
                XCTFail(missingBodyMessage(error))
            }

            return (HTTPURLResponse(), Data())
        }

        let intents = [CreateIntent(intent: "intent")]
        let entities = [CreateEntity(entity: "entity")]
        let dialogNodes = [CreateDialogNode(dialogNode: "Best node")]
        let counterExamples = [CreateCounterexample(text: "no u")]
        let metadata: [String: JSON] = ["key": JSON.string("value")]
        let systemSettings = WorkspaceSystemSettings(tooling: nil, disambiguation: nil, humanAgentAssist: nil)

        let expectation = self.expectation(description: "updateWorkspace")
        assistant.updateWorkspace(
            workspaceID: self.workspaceID,
            name: "Anthony's workspace",
            description: "The best workspace there ever was",
            language: "en",
            intents: intents,
            entities: entities,
            dialogNodes: dialogNodes,
            counterexamples: counterExamples,
            metadata: metadata,
            learningOptOut: true,
            systemSettings: systemSettings,
            append: true) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testDeleteWorkspace() {
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "DELETE")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(2)
            XCTAssertEqual(endOfURL.first!, "workspaces")
            XCTAssertEqual(endOfURL.last!, self.workspaceID)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "deleteWorkspace")
        assistant.deleteWorkspace(workspaceID: self.workspaceID) {
            _, _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: - Intents

    func testListIntents() {
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(3)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "intents")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertTrue(request.url?.query?.contains("export=true") ?? false)
            XCTAssertTrue(request.url?.query?.contains("page_limit=10") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_count=true") ?? false)
            XCTAssertTrue(request.url?.query?.contains("sort=alphabetical") ?? false)
            XCTAssertTrue(request.url?.query?.contains("cursor=mouse") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_audit=true") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "listIntents")
        assistant.listIntents(
            workspaceID: self.workspaceID,
            export: true,
            pageLimit: 10,
            includeCount: true,
            sort: "alphabetical",
            cursor: "mouse",
            includeAudit: true) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testCreateIntent() {
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let endOfURL = request.url!.pathComponents.suffix(3)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "intents")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            do {
                let body = Data(reading: request.httpBodyStream!)
                let decodedBody = try JSONDecoder().decode(CreateIntent.self, from: body)

                XCTAssertNotNil(decodedBody.description)
                XCTAssertNotNil(decodedBody.examples)
            } catch {
                XCTFail(missingBodyMessage(error))
            }

            return (HTTPURLResponse(), Data())
        }

        let examples = [CreateExample(text: "example")]

        let expectation = self.expectation(description: "createIntent")
        assistant.createIntent(
            workspaceID: self.workspaceID,
            intent: "intent",
            description: "The best intent there ever was",
            examples: examples) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testGetIntent() {
        let intent = "intent"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(4)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "intents")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], intent)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertTrue(request.url?.query?.contains("export=true") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_audit=true") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "getIntent")
        assistant.getIntent(
            workspaceID: self.workspaceID,
            intent: intent,
            export: true,
            includeAudit: true) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testUpdateIntent() {
        let intent = "intent"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let endOfURL = request.url!.pathComponents.suffix(4)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "intents")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], intent)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            do {
                let body = Data(reading: request.httpBodyStream!)
                let decodedBody = try JSONDecoder().decode(UpdateIntent.self, from: body)

                XCTAssertNotNil(decodedBody.intent)
                XCTAssertNotNil(decodedBody.description)
                XCTAssertNotNil(decodedBody.examples)
            } catch {
                XCTFail(missingBodyMessage(error))
            }

            return (HTTPURLResponse(), Data())
        }

        let newExamples = [CreateExample(text: "example")]

        let expectation = self.expectation(description: "updateIntent")
        assistant.updateIntent(
            workspaceID: self.workspaceID,
            intent: intent,
            newIntent: "my new intent",
            newDescription: "the best intent ever",
            newExamples: newExamples) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testDeleteIntent() {
        let intent = "intent"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "DELETE")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(4)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "intents")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], intent)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "deleteIntent")
        assistant.deleteIntent(workspaceID: self.workspaceID, intent: intent) {
            _, _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: - Examples

    func testListExamples() {
        let intent = "intent"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(5)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "intents")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], intent)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 4], "examples")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertTrue(request.url?.query?.contains("page_limit=10") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_count=true") ?? false)
            XCTAssertTrue(request.url?.query?.contains("sort=alphabetical") ?? false)
            XCTAssertTrue(request.url?.query?.contains("cursor=mouse") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_audit=true") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "listExamples")
        assistant.listExamples(
            workspaceID: self.workspaceID,
            intent: intent,
            pageLimit: 10,
            includeCount: true,
            sort: "alphabetical",
            cursor: "mouse",
            includeAudit: true) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testCreateExample() {
        let intent = "intent"
        let text = "text"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let endOfURL = request.url!.pathComponents.suffix(5)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "intents")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], intent)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 4], "examples")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            do {
                let body = Data(reading: request.httpBodyStream!)
                let decodedBody = try JSONDecoder().decode(CreateExample.self, from: body)

                XCTAssertNotNil(decodedBody.mentions)
                XCTAssertEqual(decodedBody.text, text)
            } catch {
                XCTFail(missingBodyMessage(error))
            }

            return (HTTPURLResponse(), Data())
        }

        let mentions = [Mentions(entity: "entity", location: [0, 1])]

        let expectation = self.expectation(description: "createExample")
        assistant.createExample(
            workspaceID: self.workspaceID,
            intent: intent,
            text: text,
            mentions: mentions) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testGetExample() {
        let intent = "intent"
        let text = "text"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(6)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "intents")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], intent)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 4], "examples")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 5], text)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_audit=true") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "getExample")
        assistant.getExample(
            workspaceID: self.workspaceID,
            intent: intent,
            text: text,
            includeAudit: true) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testUpdateExample() {
        let intent = "intent"
        let text = "text"
        let newText = "new text"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let endOfURL = request.url!.pathComponents.suffix(6)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "intents")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], intent)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 4], "examples")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 5], text)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            do {
                let body = Data(reading: request.httpBodyStream!)
                let decodedBody = try JSONDecoder().decode(UpdateExample.self, from: body)

                XCTAssertNotNil(decodedBody.mentions)
                XCTAssertNotNil(decodedBody.text)
            } catch {
                XCTFail(missingBodyMessage(error))
            }

            return (HTTPURLResponse(), Data())
        }

        let newMentions = [Mentions(entity: "entity", location: [0, 1])]

        let expectation = self.expectation(description: "updateExample")
        assistant.updateExample(
            workspaceID: self.workspaceID,
            intent: intent,
            text: text,
            newText: newText,
            newMentions: newMentions) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testDeleteExample() {
        let intent = "intent"
        let text = "text"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "DELETE")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(6)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "intents")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], intent)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 4], "examples")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 5], text)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "deleteExample")
        assistant.deleteExample(
            workspaceID: self.workspaceID,
            intent: intent,
            text: text) {
            _, _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: - Counter examples

    func testListCounterexamples() {
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(3)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "counterexamples")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertTrue(request.url?.query?.contains("page_limit=10") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_count=true") ?? false)
            XCTAssertTrue(request.url?.query?.contains("sort=alphabetical") ?? false)
            XCTAssertTrue(request.url?.query?.contains("cursor=mouse") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_audit=true") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "listCounterexamples")
        assistant.listCounterexamples(
            workspaceID: self.workspaceID,
            pageLimit: 10,
            includeCount: true,
            sort: "alphabetical",
            cursor: "mouse",
            includeAudit: true) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testCreateCounterexample() {
        let text = "text"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let endOfURL = request.url!.pathComponents.suffix(3)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "counterexamples")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            do {
                let body = Data(reading: request.httpBodyStream!)
                let decodedBody = try JSONDecoder().decode(CreateCounterexample.self, from: body)

                XCTAssertEqual(decodedBody.text, text)
            } catch {
                XCTFail(missingBodyMessage(error))
            }

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "createCounterexample")
        assistant.createCounterexample(
            workspaceID: self.workspaceID,
            text: text) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testGetCounterexample() {
        let text = "text"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(4)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "counterexamples")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], text)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_audit=true") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "getCounterexample")
        assistant.getCounterexample(
            workspaceID: self.workspaceID,
            text: text,
            includeAudit: true) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testUpdateCounterexample() {
        let text = "text"
        let newText = "new text"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let endOfURL = request.url!.pathComponents.suffix(4)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "counterexamples")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], text)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            do {
                let body = Data(reading: request.httpBodyStream!)
                let decodedBody = try JSONDecoder().decode(UpdateCounterexample.self, from: body)

                XCTAssertEqual(decodedBody.text, newText)
            } catch {
                XCTFail(missingBodyMessage(error))
            }

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "updateCounterexample")
        assistant.updateCounterexample(
            workspaceID: self.workspaceID,
            text: text,
            newText: newText) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testDeleteCounterexample() {
        let text = "text"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "DELETE")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(4)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "counterexamples")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], text)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "deleteCounterexample")
        assistant.deleteCounterexample(
            workspaceID: self.workspaceID,
            text: text) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: - Entities

    func testListEntities() {
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(3)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "entities")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertTrue(request.url?.query?.contains("export=true") ?? false)
            XCTAssertTrue(request.url?.query?.contains("page_limit=10") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_count=true") ?? false)
            XCTAssertTrue(request.url?.query?.contains("sort=alphabetical") ?? false)
            XCTAssertTrue(request.url?.query?.contains("cursor=mouse") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_audit=true") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "listEntities")
        assistant.listEntities(
            workspaceID: self.workspaceID,
            export: true,
            pageLimit: 10,
            includeCount: true,
            sort: "alphabetical",
            cursor: "mouse",
            includeAudit: true) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testCreateEntity() {
        let entity = "entity"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let endOfURL = request.url!.pathComponents.suffix(3)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "entities")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            do {
                let body = Data(reading: request.httpBodyStream!)
                let decodedBody = try JSONDecoder().decode(CreateEntity.self, from: body)

                XCTAssertEqual(decodedBody.entity, entity)
                XCTAssertNotNil(decodedBody.description)
                XCTAssertNotNil(decodedBody.fuzzyMatch)
                XCTAssertNotNil(decodedBody.metadata)
                XCTAssertNotNil(decodedBody.values)
            } catch {
                XCTFail(missingBodyMessage(error))
            }

            return (HTTPURLResponse(), Data())
        }

        let metadata = ["key": JSON.string("value")]
        let values = [CreateValue(value: "value")]

        let expectation = self.expectation(description: "createEntity")
        assistant.createEntity(
            workspaceID: self.workspaceID,
            entity: entity,
            description: "The best entity there ever was",
            metadata: metadata,
            values: values,
            fuzzyMatch: true) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testGetEntity() {
        let entity = "entity"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(4)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "entities")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], entity)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_audit=true") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "getEntity")
        assistant.getEntity(
            workspaceID: self.workspaceID,
            entity: entity,
            export: true,
            includeAudit: true) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testUpdateEntity() {
        let entity = "entity"
        let newEntity = "new entity"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let endOfURL = request.url!.pathComponents.suffix(4)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "entities")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], entity)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            do {
                let body = Data(reading: request.httpBodyStream!)
                let decodedBody = try JSONDecoder().decode(UpdateEntity.self, from: body)

                XCTAssertEqual(decodedBody.entity, newEntity)
                XCTAssertNotNil(decodedBody.description)
                XCTAssertNotNil(decodedBody.fuzzyMatch)
                XCTAssertNotNil(decodedBody.metadata)
                XCTAssertNotNil(decodedBody.values)
            } catch {
                XCTFail(missingBodyMessage(error))
            }

            return (HTTPURLResponse(), Data())
        }

        let metadata = ["key": JSON.string("value")]
        let newValues = [CreateValue(value: "value")]

        let expectation = self.expectation(description: "updateEntity")
        assistant.updateEntity(
            workspaceID: self.workspaceID,
            entity: entity,
            newEntity: newEntity,
            newDescription: "The best entity there ever was",
            newMetadata: metadata,
            newFuzzyMatch: true,
            newValues: newValues) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testDeleteEntity() {
        let entity = "entity"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "DELETE")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(4)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "entities")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], entity)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "deleteEntity")
        assistant.deleteEntity(
            workspaceID: self.workspaceID,
            entity: entity) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: - Mentions

    func testListMentions() {
        let entity = "entity"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(5)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "entities")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], entity)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 4], "mentions")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertTrue(request.url?.query?.contains("export=true") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_audit=true") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "listMentions")
        assistant.listMentions(
            workspaceID: self.workspaceID,
            entity: entity,
            export: true,
            includeAudit: true) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: - Values

    func testListValues() {
        let entity = "entity"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(5)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "entities")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], entity)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 4], "values")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertTrue(request.url?.query?.contains("export=true") ?? false)
            XCTAssertTrue(request.url?.query?.contains("page_limit=10") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_count=true") ?? false)
            XCTAssertTrue(request.url?.query?.contains("sort=alphabetical") ?? false)
            XCTAssertTrue(request.url?.query?.contains("cursor=mouse") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_audit=true") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "listValues")
        assistant.listValues(
            workspaceID: self.workspaceID,
            entity: entity,
            export: true,
            pageLimit: 10,
            includeCount: true,
            sort: "alphabetical",
            cursor: "mouse",
            includeAudit: true) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testCreateValue() {
        let entity = "entity"
        let value = "value"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let endOfURL = request.url!.pathComponents.suffix(5)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "entities")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], entity)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 4], "values")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            do {
                let body = Data(reading: request.httpBodyStream!)
                let decodedBody = try JSONDecoder().decode(CreateValue.self, from: body)

                XCTAssertEqual(decodedBody.value, value)
                XCTAssertNotNil(decodedBody.metadata)
                XCTAssertNotNil(decodedBody.patterns)
                XCTAssertNotNil(decodedBody.synonyms)
                XCTAssertNotNil(decodedBody.valueType)
            } catch {
                XCTFail(missingBodyMessage(error))
            }

            return (HTTPURLResponse(), Data())
        }

        let metadata = ["key": JSON.string("value")]

        let expectation = self.expectation(description: "createValue")
        assistant.createValue(
            workspaceID: self.workspaceID,
            entity: entity,
            value: value,
            metadata: metadata,
            synonyms: ["synonym"],
            patterns: ["pattern"],
            valueType: "my value") {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testGetValue() {
        let entity = "entity"
        let value = "value"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(6)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "entities")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], entity)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 4], "values")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 5], value)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertTrue(request.url?.query?.contains("export=true") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_audit=true") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "getValue")
        assistant.getValue(
            workspaceID: self.workspaceID,
            entity: entity,
            value: value,
            export: true,
            includeAudit: true) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testUpdateValue() {
        let entity = "entity"
        let value = "value"
        let newValue = "new value"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let endOfURL = request.url!.pathComponents.suffix(6)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "entities")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], entity)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 4], "values")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 5], value)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            do {
                let body = Data(reading: request.httpBodyStream!)
                let decodedBody = try JSONDecoder().decode(UpdateValue.self, from: body)

                XCTAssertEqual(decodedBody.value, newValue)
                XCTAssertNotNil(decodedBody.metadata)
                XCTAssertNotNil(decodedBody.patterns)
                XCTAssertNotNil(decodedBody.synonyms)
                XCTAssertNotNil(decodedBody.valueType)
            } catch {
                XCTFail(missingBodyMessage(error))
            }

            return (HTTPURLResponse(), Data())
        }

        let newMetadata = ["key": JSON.string("value")]

        let expectation = self.expectation(description: "updateValue")
        assistant.updateValue(
            workspaceID: self.workspaceID,
            entity: entity,
            value: value,
            newValue: newValue,
            newMetadata: newMetadata,
            newType: "new type",
            newSynonyms: ["new synonym"],
            newPatterns: ["new pattern"]) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testDeleteValue() {
        let entity = "entity"
        let value = "value"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "DELETE")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(6)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "entities")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], entity)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 4], "values")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 5], value)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "deleteValue")
        assistant.deleteValue(
            workspaceID: self.workspaceID,
            entity: entity,
            value: value) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: - Synonyms

    func testListSynonyms() {
        let entity = "entity"
        let value = "value"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(7)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "entities")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], entity)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 4], "values")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 5], value)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 6], "synonyms")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertTrue(request.url?.query?.contains("page_limit=10") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_count=true") ?? false)
            XCTAssertTrue(request.url?.query?.contains("sort=alphabetical") ?? false)
            XCTAssertTrue(request.url?.query?.contains("cursor=mouse") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_audit=true") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "listSynonyms")
        assistant.listSynonyms(
            workspaceID: self.workspaceID,
            entity: entity,
            value: value,
            pageLimit: 10,
            includeCount: true,
            sort: "alphabetical",
            cursor: "mouse",
            includeAudit: true) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testCreateSynonym() {
        let entity = "entity"
        let value = "value"
        let synonym = "synonym"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let endOfURL = request.url!.pathComponents.suffix(7)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "entities")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], entity)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 4], "values")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 5], value)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 6], "synonyms")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            do {
                let body = Data(reading: request.httpBodyStream!)
                let decodedBody = try JSONDecoder().decode(CreateSynonym.self, from: body)

                XCTAssertEqual(decodedBody.synonym, synonym)
            } catch {
                XCTFail(missingBodyMessage(error))
            }

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "createSynonym")
        assistant.createSynonym(
            workspaceID: self.workspaceID,
            entity: entity,
            value: value,
            synonym: synonym) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testGetSynonym() {
        let entity = "entity"
        let value = "value"
        let synonym = "synonym"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(8)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "entities")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], entity)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 4], "values")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 5], value)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 6], "synonyms")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 7], synonym)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_audit=true") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "getSynonym")
        assistant.getSynonym(
            workspaceID: self.workspaceID,
            entity: entity,
            value: value,
            synonym: synonym,
            includeAudit: true) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testUpdateSynonym() {
        let entity = "entity"
        let value = "value"
        let synonym = "synonym"
        let newSynonym = "antonym"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let endOfURL = request.url!.pathComponents.suffix(8)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "entities")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], entity)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 4], "values")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 5], value)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 6], "synonyms")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 7], synonym)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            do {
                let body = Data(reading: request.httpBodyStream!)
                let decodedBody = try JSONDecoder().decode(UpdateSynonym.self, from: body)

                XCTAssertEqual(decodedBody.synonym, newSynonym)
            } catch {
                XCTFail(missingBodyMessage(error))
            }

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "updateSynonym")
        assistant.updateSynonym(
            workspaceID: self.workspaceID,
            entity: entity,
            value: value,
            synonym: synonym,
            newSynonym: newSynonym) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testDeleteSynonym() {
        let entity = "entity"
        let value = "value"
        let synonym = "synonym"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "DELETE")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(8)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "entities")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], entity)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 4], "values")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 5], value)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 6], "synonyms")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 7], synonym)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "deleteSynonym")
        assistant.deleteSynonym(
            workspaceID: self.workspaceID,
            entity: entity,
            value: value,
            synonym: synonym) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: - Dialog Nodes

    func testListDialogNodes() {
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(3)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "dialog_nodes")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertTrue(request.url?.query?.contains("page_limit=10") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_count=true") ?? false)
            XCTAssertTrue(request.url?.query?.contains("sort=alphabetical") ?? false)
            XCTAssertTrue(request.url?.query?.contains("cursor=mouse") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_audit=true") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "listDialogNodes")
        assistant.listDialogNodes(
            workspaceID: self.workspaceID,
            pageLimit: 10,
            includeCount: true,
            sort: "alphabetical",
            cursor: "mouse",
            includeAudit: true) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testCreateDialogNode() {
        let dialogNode = "dialogNode"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let endOfURL = request.url!.pathComponents.suffix(3)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "dialog_nodes")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            do {
                let body = Data(reading: request.httpBodyStream!)
                let decodedBody = try JSONDecoder().decode(CreateDialogNode.self, from: body)

                XCTAssertEqual(decodedBody.dialogNode, dialogNode)
                XCTAssertNotNil(decodedBody.actions)
                XCTAssertNotNil(decodedBody.conditions)
                XCTAssertNotNil(decodedBody.context)
                XCTAssertNotNil(decodedBody.description)
                XCTAssertNotNil(decodedBody.digressIn)
                XCTAssertNotNil(decodedBody.digressOut)
                XCTAssertNotNil(decodedBody.digressOutSlots)
                XCTAssertNotNil(decodedBody.eventName)
                XCTAssertNotNil(decodedBody.metadata)
                XCTAssertNotNil(decodedBody.nextStep)
                XCTAssertNotNil(decodedBody.nodeType)
                XCTAssertNotNil(decodedBody.output)
                XCTAssertNotNil(decodedBody.parent)
                XCTAssertNotNil(decodedBody.previousSibling)
                XCTAssertNotNil(decodedBody.title)
                XCTAssertNotNil(decodedBody.userLabel)
                XCTAssertNotNil(decodedBody.variable)
            } catch {
                XCTFail(missingBodyMessage(error))
            }

            return (HTTPURLResponse(), Data())
        }

        let generic = DialogNodeOutputGeneric(responseType: "json")
        let additionalProperties = ["key": JSON.string("value")]
        let output = DialogNodeOutput(generic: [generic], modifiers: nil, additionalProperties: additionalProperties)
        let context = ["key1": JSON.string("value1")]
        let metadata = ["key2": JSON.string("value2")]
        let nextStep = DialogNodeNextStep(behavior: "jump")
        let actions = [DialogNodeAction(name: "action", resultVariable: "nothing")]

        let expectation = self.expectation(description: "createDialogNode")
        assistant.createDialogNode(
            workspaceID: self.workspaceID,
            dialogNode: dialogNode,
            description: "The best dialog node there ever was",
            conditions: "best",
            parent: "parent",
            previousSibling: "brother",
            output: output,
            context: context,
            metadata: metadata,
            nextStep: nextStep,
            actions: actions,
            title: "title",
            nodeType: "nodeType",
            eventName: "eventName",
            variable: "variable",
            digressIn: "digressIn",
            digressOut: "digressOut",
            digressOutSlots: "digressOutSlot",
            userLabel: "my label") {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testGetDialogNode() {
        let dialogNode = "dialogNode"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(4)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "dialog_nodes")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], dialogNode)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertTrue(request.url?.query?.contains("include_audit=true") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "getDialogNode")
        assistant.getDialogNode(
            workspaceID: self.workspaceID,
            dialogNode: dialogNode,
            includeAudit: true) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testUpdateDialogNode() {
        let dialogNode = "dialogNode"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let endOfURL = request.url!.pathComponents.suffix(4)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "dialog_nodes")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], dialogNode)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            do {
                let body = Data(reading: request.httpBodyStream!)
                let decodedBody = try JSONDecoder().decode(UpdateDialogNode.self, from: body)

                XCTAssertNotNil(decodedBody.actions)
                XCTAssertNotNil(decodedBody.conditions)
                XCTAssertNotNil(decodedBody.context)
                XCTAssertNotNil(decodedBody.description)
                XCTAssertNotNil(decodedBody.dialogNode)
                XCTAssertNotNil(decodedBody.digressIn)
                XCTAssertNotNil(decodedBody.digressOut)
                XCTAssertNotNil(decodedBody.digressOutSlots)
                XCTAssertNotNil(decodedBody.eventName)
                XCTAssertNotNil(decodedBody.metadata)
                XCTAssertNotNil(decodedBody.nextStep)
                XCTAssertNotNil(decodedBody.nodeType)
                XCTAssertNotNil(decodedBody.output)
                XCTAssertNotNil(decodedBody.parent)
                XCTAssertNotNil(decodedBody.previousSibling)
                XCTAssertNotNil(decodedBody.title)
                XCTAssertNotNil(decodedBody.userLabel)
                XCTAssertNotNil(decodedBody.variable)
            } catch {
                XCTFail(missingBodyMessage(error))
            }

            return (HTTPURLResponse(), Data())
        }

        let generic = DialogNodeOutputGeneric(responseType: "json")
        let additionalProperties = ["key": JSON.string("value")]
        let newOutput = DialogNodeOutput(generic: [generic], modifiers: nil, additionalProperties: additionalProperties)
        let newContext = ["key1": JSON.string("value1")]
        let newMetadata = ["key2": JSON.string("value2")]
        let newNextStep = DialogNodeNextStep(behavior: "jump")
        let newActions = [DialogNodeAction(name: "action", resultVariable: "nothing")]

        let expectation = self.expectation(description: "updateDialogNode")
        assistant.updateDialogNode(
            workspaceID: self.workspaceID,
            dialogNode: dialogNode,
            newDialogNode: "newDialogNode",
            newDescription: "newDescription",
            newConditions: "newConditions",
            newParent: "newParent",
            newPreviousSibling: "newPreviousSibling",
            newOutput: newOutput,
            newContext: newContext,
            newMetadata: newMetadata,
            newNextStep: newNextStep,
            newTitle: "newTitle",
            newType: "newType",
            newEventName: "newEventName",
            newVariable: "newVariable",
            newActions: newActions,
            newDigressIn: "newDigressIn",
            newDigressOut: "newDigressOut",
            newDigressOutSlots: "newDigressOutSlots",
            newUserLabel: "newUserLabel") {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testDeleteDialogNode() {
        let dialogNode = "dialogNode"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "DELETE")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(4)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "dialog_nodes")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 3], dialogNode)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "deleteDialogNode")
        assistant.deleteDialogNode(
            workspaceID: self.workspaceID,
            dialogNode: dialogNode) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: - Logs

    func testListLogs() {
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            let endOfURL = request.url!.pathComponents.suffix(3)
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "workspaces")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], self.workspaceID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "logs")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertTrue(request.url?.query?.contains("page_limit=10") ?? false)
            XCTAssertTrue(request.url?.query?.contains("filter=ERROR") ?? false)
            XCTAssertTrue(request.url?.query?.contains("sort=alphabetical") ?? false)
            XCTAssertTrue(request.url?.query?.contains("cursor=mouse") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "listLogs")
        assistant.listLogs(
            workspaceID: self.workspaceID,
            sort: "alphabetical",
            filter: "ERROR",
            pageLimit: 10,
            cursor: "mouse") {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testListAllLogs() {
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            XCTAssertEqual(request.url!.pathComponents.last!, "logs")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertTrue(request.url?.query?.contains("page_limit=10") ?? false)
            XCTAssertTrue(request.url?.query?.contains("filter=ERROR") ?? false)
            XCTAssertTrue(request.url?.query?.contains("sort=alphabetical") ?? false)
            XCTAssertTrue(request.url?.query?.contains("cursor=mouse") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "listAllLogs")
        assistant.listAllLogs(
            filter: "ERROR",
            sort: "alphabetical",
            pageLimit: 10,
            cursor: "mouse") {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: - User data

    func testDeleteUserData() {
        let customerID = "customerID"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "DELETE")
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertNil(request.httpBodyStream)

            XCTAssertEqual(request.url!.pathComponents.last!, "user_data")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "deleteUserData")
        assistant.deleteUserData(
            customerID: customerID) {
                _, _ in
                expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }
}
