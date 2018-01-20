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
import Foundation
import DialogV1

class DialogTests: XCTestCase {

    private var dialog: Dialog!
    private let prefix = "swift-sdk-unit-test-"
    private var dialogID: DialogID?
    private var dialogName: String?

    // MARK: - Test Configuration

	private func generateRandomNumber(max: UInt32) -> Int {
		#if os(Linux)
			return Int(rand() % Int32(max))
		#else
			return Int(arc4random_uniform(max))
		#endif
	}

    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateDialog()
        lookupDialog()
    }

    static var allTests: [(String, (DialogTests) -> () throws -> Void)] {
        return [
// All tests disabled -- Dialog service has been deprecated
//            ("testGetDialogs", testGetDialogs),
//            ("testCreateDelete", testCreateDelete),
//            ("testGetDialogFile", testGetDialogFile),
//            ("testGetDialogFileOctetStream", testGetDialogFileOctetStream),
//            ("testGetDialogFileJSON", testGetDialogFileJSON),
//            ("testGetDialogFileXML", testGetDialogFileXML),
//            ("testUpdateDialog", testUpdateDialog),
//            ("testGetContent", testGetContent),
//            ("testUpdateContent", testUpdateContent),
//            ("testGetConversationHistory", testGetConversationHistory),
//            ("testGetConversationHistoryWithOffset", testGetConversationHistoryWithOffset),
//            ("testGetConversationHistoryWithLimit", testGetConversationHistoryWithLimit),
//            ("testConverse", testConverse),
//            ("testGetProfile", testGetProfile),
//            ("testUpdateNewProfile", testUpdateNewProfile),
//            ("testUpdateExistingProfile", testUpdateExistingProfile),
//            ("testCreateDialogWithInvalidFile", testCreateDialogWithInvalidFile),
//            ("testCreateDialogWithConflictingName", testCreateDialogWithConflictingName),
//            ("testCreateDialogWithLongName", testCreateDialogWithLongName),
//            ("testCreateDialogWithNonexistentFile", testCreateDialogWithNonexistentFile),
//            ("testDeleteInvalidDialogID", testDeleteInvalidDialogID),
//            ("testGetDialogFileForInvalidDialogID", testGetDialogFileForInvalidDialogID),
//            ("testUpdateDialogWithInvalidFile", testUpdateDialogWithInvalidFile),
//            ("testUpdateDialogWithNonexistentFile", testUpdateDialogWithNonexistentFile),
//            ("testUpdateDialogForInvalidDialogID", testUpdateDialogForInvalidDialogID),
//            ("testGetContentForInvalidDialogID", testGetContentForInvalidDialogID),
//            ("testUpdateContentInvalid", testUpdateContentInvalid),
//            ("testUpdateContentForInvalidDialogID", testUpdateContentForInvalidDialogID),
//            ("testGetConversationHistoryForInvalidDialogID", testGetConversationHistoryForInvalidDialogID),
//            ("testConverseWithInvalidDialogID", testConverseWithInvalidDialogID),
//            ("testConverseWithInvalidIDs", testConverseWithInvalidIDs),
//            ("testGetProfileWithInvalidDialogID", testGetProfileWithInvalidDialogID),
//            ("testGetProfileWithInvalidClientID", testGetProfileWithInvalidClientID),
//            ("testGetProfileWithInvalidParameterNames", testGetProfileWithInvalidParameterNames),
//            ("testUpdateProfileWithInvalidDialogID", testUpdateProfileWithInvalidDialogID),
//            ("testUpdateProfileWithInvalidClientID", testUpdateProfileWithInvalidClientID)
        ]
    }

    /** Instantiate Dialog. */
    func instantiateDialog() {
        let username = Credentials.DialogUsername
        let password = Credentials.DialogPassword
        dialog = Dialog(username: username, password: password)
        dialog.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        dialog.defaultHeaders["X-Watson-Test"] = "true"
    }

    /** Look up (or create) the test dialog application. */
    func lookupDialog() {
        let description = "Look up (or create) the test dialog application."
        let expectation = self.expectation(description: description)

        let failure = { (error: Error) in
            XCTFail("Failed to list the dialog applications.")
        }

        dialog.getDialogs(failure: failure) { dialogs in
            for dialog in dialogs {
                if dialog.name.hasPrefix(self.prefix) {
                    self.dialogID = dialog.dialogID
                    self.dialogName = dialog.name
                    expectation.fulfill()
                    return
                }
            }
            expectation.fulfill()
        }
        waitForExpectations()

        if (self.dialogID == nil) || (self.dialogName == nil) {
            createDialog()
        }
    }

    /** Create the test dialog application. */
    func createDialog() {
        let description = "Create the test dialog application."
        let expectation = self.expectation(description: description)

        let dialogName = createDialogName()

        guard let fileURL = loadDialogFile(name: "pizza_sample", withExtension: "xml") else {
            XCTFail("Failed to load dialog file.")
            return
        }

        let failure = { (error: Error) in
            XCTFail("Failed to create the test dialog application.")
        }

        dialog.createDialog(withName: dialogName, fromFile: fileURL, failure: failure) { id in
            self.dialogID = id
            self.dialogName = dialogName
            expectation.fulfill()
        }
        waitForExpectations()
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

    // MARK: - Helper Functions

    /** Generate a random alpha-numeric string. (Courtesy of Dschee on StackOverflow.) */
    func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyz0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""

        for _ in (0..<length) {
            let randomNum = generateRandomNumber(max: allowedCharsCount)
            let newCharacter = allowedChars[allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)]
            randomString += String(newCharacter)
        }

        return randomString
    }

    /** Generate the name for a dialog application. */
    func createDialogName() -> String {
        return prefix + randomAlphaNumericString(length: 5)
    }

    /** Load a dialog file. */
    func loadDialogFile(name: String, withExtension: String) -> URL? {

        #if os(iOS)
            let bundle = Bundle(for: type(of: self))
            guard let url = bundle.url(forResource: name, withExtension: withExtension) else {
                return nil
            }
        #else
            let url = URL(fileURLWithPath: "Tests/DialogV1Tests/"+name+"."+withExtension)
        #endif

        return url
    }

    // MARK: - Positive Tests - Content Operations

    /** List the dialog applications associated with this service instance. */
    func testGetDialogs() {
        let description = "List the dialog applications associated with this service instance."
        let expectation = self.expectation(description: description)

        dialog.getDialogs(failure: failWithError) { dialogs in
            for dialog in dialogs {
                let idMatch = (dialog.dialogID == self.dialogID)
                let nameMatch = (dialog.name == self.dialogName)
                if idMatch && nameMatch {
                    expectation.fulfill()
                    return
                }
            }
            XCTFail("Could not retrieve the test dialog application.")
        }
        waitForExpectations()
    }

    /** Create and delete a dialog application. */
    func testCreateDelete() {
        let description1 = "Create a dialog application."
        let expectation1 = self.expectation(description: description1)
        var dialogID: DialogID?

        let dialogName = createDialogName()
        guard let fileURL = loadDialogFile(name: "pizza_sample", withExtension: "xml") else {
            XCTFail("Failed to load dialog file.")
            return
        }

        dialog.createDialog(withName: dialogName, fromFile: fileURL, failure: failWithError) { id in
            dialogID = id
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Delete the dialog application."
        let expectation2 = self.expectation(description: description2)

        dialog.deleteDialog(withID: dialogID!, failure: failWithError) {
            expectation2.fulfill()
        }
        waitForExpectations()
    }

    /** Download the dialog file associated with the test application. */
    func getDialogFile(format: DialogV1.Format? = nil) {
        let description = "Download the dialog file associated with the test application."
        let expectation = self.expectation(description: description)

        dialog.getDialogFile(fromDialogID: dialogID!, inFormat: format, failure: failWithError) { file in
            let fileManager = FileManager.default
            XCTAssertTrue(fileManager.fileExists(atPath: file.path))
            XCTAssertTrue(self.verifyFiletype(format: format, url: file))
            try! fileManager.removeItem(at: file)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Verify the filetype (extension) of a downloaded dialog file. */
    func verifyFiletype(format: DialogV1.Format?, url: URL) -> Bool {
        var filetype = ".mct"
        if let format = format {
            switch format {
            case .octetStream: filetype = ".mct"
            case .wdsJSON: filetype = ".json"
            case .wdsXML: filetype = ".xml"
            }
        }
        return url.path.hasSuffix(filetype)
    }

    /** Download the dialog file associated with the test application. */
    func testGetDialogFile() {
        getDialogFile()
    }

    /** Download the dialog file associated with the test application in OctetStream format. */
    func testGetDialogFileOctetStream() {
        getDialogFile(format: .octetStream)
    }

    /** Download the dialog file associated with the test application in JSON format. */
    func testGetDialogFileJSON() {
        getDialogFile(format: .wdsJSON)
    }

    /** Download the dialog file associated with the test application in XML format. */
    func testGetDialogFileXML() {
        getDialogFile(format: .wdsXML)
    }

    // Disabled test, failing with `Failed to import file. Possibly due to corrupt or invalid file
    // or system error. - Given final block not properly padded`
    /** Update the dialog application. */
    func testUpdateDialog() {
        let description = "Update the dialog application."
        let expectation = self.expectation(description: description)

        guard let fileURL = loadDialogFile(name: "pizza_sample", withExtension: "xml") else {
            XCTFail("Failed to load dialog file.")
            return
        }

        dialog.updateDialog(withID: dialogID!, fromFile: fileURL, failure: failWithError) {
            expectation.fulfill()
        }
        waitForExpectations()
    }

    // Disabled test, failing with `Failed to find the expected initial node.`
    /** Get the content for each node associated with the dialog application. */
    func testGetContent() {
        let description = "Get the content for each node."
        let expectation = self.expectation(description: description)

        let initialNode = "OUTPUT(200000)"
        let initialResponse = "Hi, I\'m Watson! I can help you order a pizza, " +
                              "what size would you like?"

        dialog.getContent(fromDialogID: dialogID!, failure: failWithError) { nodes in
            for node in nodes {
                let nodeMatch = (node.node == initialNode)
                let contentMatch = (node.content == initialResponse)
                if nodeMatch && contentMatch {
                    expectation.fulfill()
                    return
                }
            }
            XCTFail("Failed to find the expected initial node.")
        }
        waitForExpectations()
    }

    /** Update the content for the initial node. */
    func testUpdateContent() {
        let description = "Update the content for the initial node."
        let expectation = self.expectation(description: description)

        let initialNode = "OUTPUT(200000)"
        let newGreeting = "Hi, I\'m Watson! I can help you order a pizza through my " +
                          "convenient Swift SDK! What size would you like?"

        let newNode = DialogV1.Node(content: newGreeting, node: initialNode)

        dialog.updateContent(fromDialogID: dialogID!, forNodes: [newNode], failure: failWithError) {
            expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Positive Tests - Conversation Operations

    /** Get conversation history. */
    func testGetConversationHistory() {
        let description1 = "Start a conversation with the dialog application."
        let expectation1 = self.expectation(description: description1)

        let response1 = "Hi, I\'m Watson! I can help you order a pizza through my " +
                        "convenient Swift SDK! What size would you like?"
        let startTime = Date()
        var conversationID: Int?
        var clientID: Int?

        dialog.converse(withDialogID: dialogID!, failure: failWithError) { response in
            XCTAssertEqual(response.response.last, response1)
            conversationID = response.conversationID
            clientID = response.clientID
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Continue a conversation with the dialog application."
        let expectation2 = self.expectation(description: description2)

        let response2 = "What toppings are you in the mood for? (Limit 4)"

        dialog.converse(withDialogID: dialogID!, withConversationID: conversationID!, clientID: clientID!, input: "large", failure: failWithError) {
            response in
            XCTAssertEqual(response.response.last, response2)
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Get conversation history."
        let expectation3 = self.expectation(description: description3)

        let bufferOffset = 10.0
        let sydneyOffset = abs(NSTimeZone(name: "Australia/Sydney")!.secondsFromGMT)
        let localOffset = abs(NSTimeZone.local.secondsFromGMT())
        let serverOffset = TimeInterval(sydneyOffset + localOffset)
        let dateFrom = Date(timeInterval: serverOffset - bufferOffset, since: startTime)
        let dateTo = Date(timeIntervalSinceNow: serverOffset + bufferOffset)

        dialog.getConversationHistory(fromDialogID: dialogID!, from: dateFrom, to: dateTo, failure: failWithError) {
            conversations in
            XCTAssertGreaterThanOrEqual(conversations.count, 1)
            XCTAssertEqual(conversations.last?.messages.count, 3)
            XCTAssertEqual(conversations.last?.profile["size"], "Large")
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    /** Get conversation history with an offset. */
    func testGetConversationHistoryWithOffset() {
        let description1 = "Start a conversation with the dialog application."
        let expectation1 = self.expectation(description: description1)

        let response1 = "Hi, I\'m Watson! I can help you order a pizza through my " +
                        "convenient Swift SDK! What size would you like?"
        let startTime = Date()
        var conversationID: Int?
        var clientID: Int?

        dialog.converse(withDialogID: dialogID!, failure: failWithError) { response in
            XCTAssertEqual(response.response.last, response1)
            conversationID = response.conversationID
            clientID = response.clientID
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Continue a conversation with the dialog application."
        let expectation2 = self.expectation(description: description2)

        let response2 = "What toppings are you in the mood for? (Limit 4)"

        dialog.converse(withDialogID: dialogID!, withConversationID: conversationID!, clientID: clientID!, input: "large", failure: failWithError) {
            response in
            XCTAssertEqual(response.response.last, response2)
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Get conversation history with an offset."
        let expectation3 = self.expectation(description: description3)

        let bufferOffset = 10.0
        let sydneyOffset = abs(NSTimeZone(name: "Australia/Sydney")!.secondsFromGMT)
        let localOffset = abs(NSTimeZone.local.secondsFromGMT())
        let serverOffset = TimeInterval(sydneyOffset + localOffset)
        let dateFrom = Date(timeInterval: serverOffset - bufferOffset, since: startTime)
        let dateTo = Date(timeIntervalSinceNow: serverOffset + bufferOffset)

        let offset = 1000
        dialog.getConversationHistory(fromDialogID: dialogID!, from: dateFrom, to: dateTo, offset: offset, failure: failWithError) {
            conversations in
            XCTAssertEqual(conversations.count, 0)
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    // Disabled test, failing the XCTAssertEqual
    /** Get conversation history with a limit. */
    func testGetConversationHistoryWithLimit() {
        let description1 = "Start a conversation with the dialog application."
        let expectation1 = self.expectation(description: description1)

        let response1 = "Hi, I\'m Watson! I can help you order a pizza, what size would you like?"
        let startTime = Date()
        var conversationID: Int?
        var clientID: Int?

        dialog.converse(withDialogID: dialogID!, failure: failWithError) { response in
            XCTAssertEqual(response.response.last, response1)
            conversationID = response.conversationID
            clientID = response.clientID
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Continue a conversation with the dialog application."
        let expectation2 = self.expectation(description: description2)

        let response2 = "What toppings are you in the mood for? (Limit 4)"

        dialog.converse(withDialogID: dialogID!, withConversationID: conversationID!, clientID: clientID!, input: "large", failure: failWithError) {
            response in
            XCTAssertEqual(response.response.last, response2)
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Get conversation history with a limit."
        let expectation3 = self.expectation(description: description3)

        let bufferOffset = 10.0
        let sydneyOffset = abs(NSTimeZone(name: "Australia/Sydney")!.secondsFromGMT)
        let localOffset = abs(NSTimeZone.local.secondsFromGMT())
        let serverOffset = TimeInterval(sydneyOffset + localOffset)
        let dateFrom = Date(timeInterval: serverOffset - bufferOffset, since: startTime)
        let dateTo = Date(timeIntervalSinceNow: serverOffset + bufferOffset)

        let limit = 0
        dialog.getConversationHistory(fromDialogID: dialogID!, from: dateFrom, to: dateTo, limit: limit, failure: failWithError) {
            conversations in
            // XCTAssertEqual(conversations.count, 0)
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    /** Converse with the dialog application. */
    func testConverse() {
        let description1 = "Start a conversation with the dialog application."
        let expectation1 = self.expectation(description: description1)

        let response1 = "Hi, I\'m Watson! I can help you order a pizza through my " +
                        "convenient Swift SDK! What size would you like?"
        var conversationID: Int?
        var clientID: Int?

        dialog.converse(withDialogID: dialogID!, failure: failWithError) { response in
            XCTAssertEqual(response.response.last, response1)
            conversationID = response.conversationID
            clientID = response.clientID
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Continue a conversation with the dialog application."
        let expectation2 = self.expectation(description: description2)

        let response2 = "What toppings are you in the mood for? (Limit 4)"

        dialog.converse(
            withDialogID: dialogID!,
            withConversationID: conversationID!,
            clientID: clientID!,
            input: "large",
            failure: failWithError)
        {
            response in
            XCTAssertEqual(response.response.last, response2)
            expectation2.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Positive Tests - Profile Operations

    /** Retrieve a client's profile variables. */
    func testGetProfile() {
        let description1 = "Start a conversation with the dialog application."
        let expectation1 = self.expectation(description: description1)

        var conversationID: Int?
        var clientID: Int?

        dialog.converse(withDialogID: dialogID!, failure: failWithError) { response in
            conversationID = response.conversationID
            clientID = response.clientID
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Continue a conversation with the dialog application."
        let expectation2 = self.expectation(description: description2)

        dialog.converse(
            withDialogID: dialogID!,
            withConversationID: conversationID!,
            clientID: clientID!,
            input: "large",
            failure: failWithError)
        {
            response in
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Retrieve the client's profile variables."
        let expectation3 = self.expectation(description: description3)

        dialog.getProfile(fromDialogID: dialogID!, withClientID: clientID!, failure: failWithError) { profile in
            XCTAssertNil(profile.clientID)
            XCTAssertEqual(profile.parameters.first?.name, "size")
            XCTAssertEqual(profile.parameters.first?.value, "Large")
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    /** Update a new client's profile variables. */
    func testUpdateNewProfile() {
        let description = "Update a new client's profile variables."
        let expectation = self.expectation(description: description)

        dialog.updateProfile(fromDialogID: dialogID!, parameters: ["size": "Large"], failure: failWithError) {
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Update an existing client's profile variables. */
    func testUpdateExistingProfile() {
        let description1 = "Start a conversation with the dialog application."
        let expectation1 = self.expectation(description: description1)

        var clientID: Int?

        dialog.converse(withDialogID: dialogID!, failure: failWithError) { response in
            clientID = response.clientID
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Update an existing client's profile variables."
        let expectation2 = self.expectation(description: description2)

        dialog.updateProfile(
            fromDialogID: dialogID!,
            withClientID: clientID!,
            parameters: ["size": "Large"],
            failure: failWithError)
        {
            expectation2.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Negative Tests - Content Operations

    /** Create a dialog application with an invalid dialog file. */
    func testCreateDialogWithInvalidFile() {
        let description = "Create a dialog application with an invalid dialog file."
        let expectation = self.expectation(description: description)

        let dialogName = createDialogName()

        guard let fileURL = loadDialogFile(name: "pizza_sample_invalid", withExtension: "xml") else {
            XCTFail("Failed to load invalid dialog file.")
            return
        }

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        dialog.createDialog(withName: dialogName, fromFile: fileURL, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Create a dialog with a conflicting name. */
    func testCreateDialogWithConflictingName() {
        let description = "Create a dialog with a conflicting name."
        let expectation = self.expectation(description: description)

        guard let fileURL = loadDialogFile(name: "pizza_sample", withExtension: "xml") else {
            XCTFail("Failed to load dialog file.")
            return
        }

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        dialog.createDialog(withName: dialogName!, fromFile: fileURL, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Create a dialog with a name that is too long. */
    func testCreateDialogWithLongName() {
        let description = "Create a dialog with a long name."
        let expectation = self.expectation(description: description)

        let longName = createDialogName() + randomAlphaNumericString(length: 10)

        guard let fileURL = loadDialogFile(name: "pizza_sample", withExtension: "xml") else {
            XCTFail("Failed to load dialog file.")
            return
        }

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        dialog.createDialog(withName: longName, fromFile: fileURL, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    // Disabled test, failed with `negative test returned a result.`
    /** Create a dialog with a file that does not exist. */
    func testCreateDialogWithNonexistentFile() {
        let description = "Create a dialog with a file that does not exist."
        let expectation = self.expectation(description: description)

        let dialogName = createDialogName()

        let fileURL = URL(fileURLWithPath: "/this/is/an/invalid/path.json")

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        dialog.createDialog(withName: dialogName, fromFile: fileURL, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Delete a dialog that doesn't exist. */
    func testDeleteInvalidDialogID() {
        let description = "Delete a dialog that doesn't exist."
        let expectation = self.expectation(description: description)

        let invalidID = "this-id-does-not-exist"
        let failure = { (error: Error) in
            expectation.fulfill()
        }

        dialog.deleteDialog(withID: invalidID, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Get the dialog file for a dialog that doesn't exist. */
    func testGetDialogFileForInvalidDialogID() {
        let description = "Get the dialog file for a dialog that doesn't exist."
        let expectation = self.expectation(description: description)

        let invalidID = "this-id-does-not-exist"
        let failure = { (error: Error) in
            expectation.fulfill()
        }

        dialog.getDialogFile(fromDialogID: invalidID, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Upload an invalid dialog file. */
    func testUpdateDialogWithInvalidFile() {
        let description = "Upload an invalid dialog file."
        let expectation = self.expectation(description: description)

        guard let fileURL = loadDialogFile(name: "pizza_sample_invalid", withExtension: "xml") else {
            XCTFail("Failed to load invalid dialog file.")
            return
        }

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        dialog.updateDialog(withID: dialogID!, fromFile: fileURL, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Update a dialog with a file that does not exist. */
    func testUpdateDialogWithNonexistentFile() {
        let description = "Update a dialog with a file that does not exist."
        let expectation = self.expectation(description: description)

        let fileURL = URL(fileURLWithPath: "/this/is/an/invalid/path.json")

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        dialog.updateDialog(withID: dialogID!, fromFile: fileURL, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Update a dialog that doesn't exist. */
    func testUpdateDialogForInvalidDialogID() {
        let description = "Update a dialog that doesn't exist."
        let expectation = self.expectation(description: description)

        let invalidID = "this-id-does-not-exist"

        guard let fileURL = loadDialogFile(name: "pizza_sample", withExtension: "xml") else {
            XCTFail("Failed to load dialog file.")
            return
        }

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        dialog.updateDialog(withID: invalidID, fromFile: fileURL, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Get the content for each node of a dialog application that doesn't exist. */
    func testGetContentForInvalidDialogID() {
        let description = "Retrieve the content from nodes "
        let expectation = self.expectation(description: description)

        let invalidID = "this-id-does-not-exist"

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        dialog.getContent(fromDialogID: invalidID, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Update invalid content for a node of the dialog application. */
    func testUpdateContentInvalid() {
        let description = "Update invalid content for a node of the dialog application."
        let expectation = self.expectation(description: description)

        let nodes = [DialogV1.Node(content: "this-is-invalid", node: "this-is-invalid")]

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        dialog.updateContent(fromDialogID: dialogID!, forNodes: nodes, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Update content for a dialog that doesn't exist. */
    func testUpdateContentForInvalidDialogID() {
        let description = "Update content for a dialog that doesn't exist."
        let expectation = self.expectation(description: description)

        let invalidID = "this-id-does-not-exist"

        let nodes = [DialogV1.Node(content: "", node: "")]

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        dialog.updateContent(fromDialogID: invalidID, forNodes: nodes, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    // MARK: - Negative Tests - Conversation Operations

    /** Get conversation history for a dialog that doesn't exit. */
    func testGetConversationHistoryForInvalidDialogID() {
        let description = "Get the conversation history for a dialog that doesn't exist."
        let expectation = self.expectation(description: description)

        let invalidID = "this-id-does-not-exist"

        let sydneyOffset = abs(NSTimeZone(name: "Australia/Sydney")!.secondsFromGMT)
        let localOffset = abs(NSTimeZone.local.secondsFromGMT())
        let serverOffset = sydneyOffset + localOffset
        let dateFromOffset: TimeInterval = -120.0 + Double(serverOffset)
        let dateToOffset: TimeInterval = 120 + Double(serverOffset)
        let dateFrom = Date(timeIntervalSinceNow: dateFromOffset)
        let dateTo = Date(timeIntervalSinceNow: dateToOffset)

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        dialog.getConversationHistory(
            fromDialogID: invalidID,
            from: dateFrom,
            to: dateTo,
            failure: failure,
            success: failWithResult
        )
        waitForExpectations()
    }

    /** Converse with a dialog application that doesn't exist.  */
    func testConverseWithInvalidDialogID() {
        let description = "Converse with a dialog application that doesn't exist."
        let expectation = self.expectation(description: description)

        let invalidID = "this-id-does-not-exist"

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        dialog.converse(withDialogID: invalidID, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Converse with a dialog application using an invalid conversation id and client id. */
    func testConverseWithInvalidIDs() {
        let description = "Converse with a dialog application using invalid ids."
        let expectation = self.expectation(description: description)

        let invalidConversationID = 0
        let invalidClientID = 0

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        dialog.converse(
            withDialogID: dialogID!,
            withConversationID: invalidConversationID,
            clientID: invalidClientID,
            input: "large",
            failure: failure,
            success: failWithResult
        )
        waitForExpectations()
    }

    // MARK: - Negative Tests - Profile Operations

    /** Retrieve a client's profile variables for a dialog that doesn't exist. */
    func testGetProfileWithInvalidDialogID() {

        let description = "Retrieve a client's profile variables for a dialog that doesn't exist."
        let expectation = self.expectation(description: description)

        let invalidID = "this-id-does-not-exist"
        let invalidClientID = 0
        let failure = { (error: Error) in
            expectation.fulfill()
        }

        dialog.getProfile(
            fromDialogID: invalidID,
            withClientID: invalidClientID,
            failure: failure,
            success: failWithResult
        )
        waitForExpectations()
    }

    /** Retrieve a client's profile variables using an invalid client id. */
    func testGetProfileWithInvalidClientID() {
        let description = "Retrieve the client's profile variables using an invalid client id."
        let expectation = self.expectation(description: description)

        let invalidClientID = 0

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        dialog.getProfile(
            fromDialogID: dialogID!,
            withClientID: invalidClientID,
            failure: failure,
            success: failWithResult
        )
        waitForExpectations()
    }

    /** Retrieve a client's profile using invalid profile parameters. */
    func testGetProfileWithInvalidParameterNames() {
        let description1 = "Start a conversation with the dialog application."
        let expectation1 = self.expectation(description: description1)

        var clientID: Int?

        dialog.converse(withDialogID: dialogID!, failure: failWithError) { response in
            clientID = response.clientID
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Retrieve the client's profile using invalid profile parameters."
        let expectation2 = self.expectation(description: description2)

        let invalidParameters = ["these", "parameter", "names", "do", "not", "exist"]

        let failure = { (error: Error) in
            expectation2.fulfill()
        }

        dialog.getProfile(
            fromDialogID: dialogID!,
            withClientID: clientID!,
            names: invalidParameters,
            failure: failure,
            success: failWithResult
        )
        waitForExpectations()
    }

    /** Update a client's profile variables using an invalid dialog id. */
    func testUpdateProfileWithInvalidDialogID() {
        let description = "Update the client's profile variables using an invalid dialog id."
        let expectation = self.expectation(description: description)

        let invalidID = "this-id-does-not-exist"

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        dialog.updateProfile(
            fromDialogID: invalidID,
            parameters: ["size": "Large"],
            failure: failure,
            success: failWithResult
        )
        waitForExpectations()
    }

    /** Update a client's profile using an invalid client id. */
    func testUpdateProfileWithInvalidClientID() {
        let description = "Update a client's profile using an invalid client id."
        let expectation = self.expectation(description: description)

        let invalidID = 0

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        dialog.updateProfile(
            fromDialogID: dialogID!,
            withClientID: invalidID,
            parameters: ["size": "Large"],
            failure: failure,
            success: failWithResult
        )
        waitForExpectations()
    }
}
