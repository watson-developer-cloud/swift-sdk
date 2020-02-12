/**
 * (C) Copyright IBM Corp. 2016, 2019.
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

        let authenticator = WatsonIAMAuthenticator.init(apiKey: WatsonCredentials.AssistantAPIKey)
        assistant = Assistant(version: versionDate, authenticator: authenticator)

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
            _, error in

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
    
    func testMessageWithSystemEntity() {
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
        
        let message1Expectation = self.expectation(description: "message 1")
        assistant.message(assistantID: assistantID, sessionID: newSessionID!) {
                response, error in
            
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }
            
            guard let result = response?.result else {
                XCTFail("no response")
                return
            }
            
            message1Expectation.fulfill()
        }
            
        waitForExpectations()
        
    let message2Expectation = self.expectation(description: "message 2")
    let messageInput = MessageInput(messageType: MessageInput.MessageType.text.rawValue, text: "are you open on christmas")
    assistant.message(assistantID: assistantID, sessionID: newSessionID!, input: messageInput, context: nil) {
            response, error in
            
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }
            
            guard let result = response?.result else {
                XCTFail("no response")
                return
            }
            
            message2Expectation.fulfill()
        }
        
        waitForExpectations()
    }

    // MARK: - Skill Contexts

    func testMessageContextSkills() {
        // Create a session
        var newSessionID: String?
        let expectation1 = self.expectation(description: "Create a session")
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

        // create global context with user ID
        let system = MessageContextGlobalSystem(userID: "my_user_id")
        let global = MessageContextGlobal(system: system)

        // build user-defined context variables, put in skill-specific context for main skill
        var userDefinedContext: [String: WatsonJSON] = [:]
        userDefinedContext["account_number"] = .string("123456")
        let mainSkillContext = MessageContextSkill(userDefined: userDefinedContext)
        let skills = MessageContextSkills(additionalProperties: ["main skill": mainSkillContext])

        let context = MessageContext(global: global, skills: skills)

        let input = MessageInput(messageType: "text", text: "Hello", options: MessageInputOptions(returnContext: true))

        // Start conversation with a non-empty context
        let expectation2 = self.expectation(description: "Start a conversation.")
        assistant.message(assistantID: assistantID, sessionID: sessionID, input: input, context: context) {
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

            // verify response message
            guard let dialogRuntimeResponse = output.generic, dialogRuntimeResponse.count == 1 else {
                XCTFail("Expected to receive a response message")
                return
            }

            XCTAssertEqual(dialogRuntimeResponse[0].responseType, "text")
            XCTAssertNotNil(dialogRuntimeResponse[0].text)

            // verify context
            XCTAssertNotNil(message.context)
            XCTAssertNotNil(message.context?.skills)
            XCTAssertNotNil(message.context?.skills?.additionalProperties)
            XCTAssertTrue(message.context?.skills?.additionalProperties.keys.contains("main skill") ?? false)

            expectation2.fulfill()
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

    // MARK: - Search Skill

    func testAssistantSearchSkill() {

        let sessionExpectationDescription = "Create a session"
        let sessionExpectation = self.expectation(description: sessionExpectationDescription)

        // setup session
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
            sessionExpectation.fulfill()
        }

        waitForExpectations()

        guard let sessionID = newSessionID else {
            XCTFail("Failed to get the ID of the newly created session")
            return
        }

        let genericMessages: [String] = [
            "Hello",
            "Are you open on christmas",
            "I\'d like to make an appointment",
            "Tomorrow at 3pm",
            "Make that thursday at 2pm",
        ]

        // send multiple messages to get assistant going
        for genericMessage in genericMessages {
            let genericMessageDescription = "generic message"
            let genericMessageExpectation = self.expectation(description: genericMessageDescription)
            let messageInput = MessageInput(messageType: "text", text: genericMessage)

            assistant.message(assistantID: assistantID, sessionID: sessionID, input: messageInput) {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }

                XCTAssertNotNil(response?.result)
                genericMessageExpectation.fulfill()
            }

            waitForExpectations()
        }

        // send a message that triggers search skill
        let searchSkillMessageDescription = "search skill message"
        let searchSkillMessageExpectation = self.expectation(description: searchSkillMessageDescription)
        let searchSkillMessageInput = MessageInput(messageType: "text", text: "who did watson beat in jeopardy?")

        assistant.message(assistantID: assistantID, sessionID: sessionID, input: searchSkillMessageInput) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let message = response?.result?.output.generic?[0] else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertNotNil(message)
            XCTAssert(message.responseType == "search")

            searchSkillMessageExpectation.fulfill()
        }

        waitForExpectations()
    }

}
