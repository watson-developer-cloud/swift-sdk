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
import AssistantV2
import RestKit

class AssistantV2Tests: XCTestCase {

    private var assistant: Assistant!
    private let assistantID = WatsonCredentials.AssistantV2ID

    // MARK: - Test Configuration

    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateAssistant()
    }

    static var allTests: [(String, (AssistantV2Tests) -> () throws -> Void)] {
        return [
            ("testCreateSession", testCreateSession),
            ("testCreateSessionWithInvalidAssistantID", testCreateSessionWithInvalidAssistantID),
            ("testDeleteSession", testDeleteSession),
            ("testDeleteSessionWithInvalidSessionID", testDeleteSessionWithInvalidSessionID),
            ("testMessage", testMessage),
            ("testMessageWithInvalidSessionID", testMessageWithInvalidSessionID),
        ]
    }

    /** Instantiate Assistant. */
    func instantiateAssistant() {
        if let apiKey = WatsonCredentials.AssistantAPIKey {
            assistant = Assistant(version: versionDate, apiKey: apiKey)
        } else {
            let username = WatsonCredentials.AssistantV2Username
            let password = WatsonCredentials.AssistantV2Password
            assistant = Assistant(version: versionDate, username: username, password: password)
        }
        if let url = WatsonCredentials.AssistantV2URL {
            assistant.serviceURL = url
        }
        assistant.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        assistant.defaultHeaders["X-Watson-Test"] = "true"
    }

    /** Wait for expectations. */
    func waitForExpectations(timeout: TimeInterval = 10.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: - Sessions

    func testCreateSession() {
        let description = "Create a session"
        let expectation = self.expectation(description: description)
        assistant.createSession(assistantID: assistantID) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let session = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertNotNil(session.sessionID)
            expectation.fulfill()
        }

        waitForExpectations()
    }

    func testCreateSessionWithInvalidAssistantID() {
        let description = "Create a session"
        let expectation = self.expectation(description: description)

        let invalidID = "Invalid Assistant ID"
        assistant.createSession(assistantID: invalidID) {
            _, error in

            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }

        waitForExpectations()
    }

    func testDeleteSession() {
        let description1 = "Create a session"
        let expectation1 = self.expectation(description: description1)
        var newSessionID: String?
        assistant.createSession(assistantID: assistantID) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let session = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertNotNil(session.sessionID)
            newSessionID = session.sessionID
            expectation1.fulfill()
        }

        waitForExpectations()

        guard let sessionID = newSessionID else {
            XCTFail("Failed to get the ID of the newly created session")
            return
        }

        let description2 = "Delete the newly created session"
        let expectation2 = self.expectation(description: description2)
        assistant.deleteSession(assistantID: assistantID, sessionID: sessionID) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            expectation2.fulfill()
        }

        waitForExpectations()
    }

    func testDeleteSessionWithInvalidSessionID() {
        let description = "Delete an invalid session"
        let expectation = self.expectation(description: description)

        let invalidID = "Invalid Session ID"
        assistant.deleteSession(assistantID: assistantID, sessionID: invalidID) {
            _, error in

            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }

        waitForExpectations()
    }

    // MARK: - Messages

    func testMessage() {
        // Create a session
        let description1 = "Create a session"
        let expectation1 = self.expectation(description: description1)
        var newSessionID: String?
        assistant.createSession(assistantID: assistantID) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let session = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertNotNil(session.sessionID)
            newSessionID = session.sessionID
            expectation1.fulfill()
        }

        waitForExpectations()

        guard let sessionID = newSessionID else {
            XCTFail("Failed to get the ID of the newly created session")
            return
        }

        // First message from the bot
        let description2 = "Start a conversation."
        let expectation2 = self.expectation(description: description2)

        assistant.message(assistantID: assistantID, sessionID: sessionID, input: nil, context: nil) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let message = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            let output = message.output
            let context = message.context

            // verify response message
            guard let dialogRuntimeResponse = output.generic, dialogRuntimeResponse.count == 1 else {
                XCTFail("Expected to receive a response message")
                return
            }

            XCTAssertEqual(dialogRuntimeResponse[0].responseType, "text")
            XCTAssertNotNil(dialogRuntimeResponse[0].text)

            // verify context
            XCTAssertNil(context)

            expectation2.fulfill()
        }
        waitForExpectations()

        // User responds to the bot
        let description3 = "Continue a conversation."
        let expectation3 = self.expectation(description: description3)

        let messageInput = MessageInput(messageType: MessageInput.MessageType.text.rawValue, text: "I'm good, how are you?")

        assistant.message(assistantID: assistantID, sessionID: sessionID, input: messageInput, context: nil) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let message = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            let output = message.output
            let context = message.context

            // verify response message
            guard let dialogRuntimeResponse = output.generic, dialogRuntimeResponse.count == 1 else {
                XCTFail("Expected to receive a response message")
                return
            }

            XCTAssertEqual(dialogRuntimeResponse[0].responseType, "text")
            XCTAssertNotNil(dialogRuntimeResponse[0].text)

            // verify intents
            guard let intents = output.intents, intents.count == 1 else {
                XCTFail("Expected to receive one runtime intent")
                return
            }

            XCTAssertEqual(intents[0].intent, "General_Greetings")

            // verify context
            XCTAssertNil(context)

            expectation3.fulfill()
        }
        waitForExpectations()
    }

    func testMessageWithInvalidSessionID() {
        let description = "Send message with an invalid session"
        let expectation = self.expectation(description: description)

        let invalidID = "Invalid Session ID"
        assistant.message(assistantID: assistantID, sessionID: invalidID) {
            _, error in

            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }

        waitForExpectations()
    }
}
