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
import DialogV1

class DialogTests: XCTestCase {

    private var dialog: Dialog!
    private let prefix = "swift-sdk-unit-test-"
    private var dialogID: DialogID?
    private var dialogName: String?
    private let timeout: NSTimeInterval = 10.0

    // MARK: - Test Configuration

    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateDialog()
        lookupDialog()
    }

    /** Instantiate Dialog. */
    func instantiateDialog() {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard
            let file = bundle.pathForResource("Credentials", ofType: "plist"),
            let credentials = NSDictionary(contentsOfFile: file) as? [String: String],
            let username = credentials["DialogUsername"],
            let password = credentials["DialogPassword"]
        else {
            XCTFail("Unable to read credentials.")
            return
        }
        dialog = Dialog(username: username, password: password)
    }

    /** Look up (or create) the test dialog application. */
    func lookupDialog() {
        let description = "Look up (or create) the test dialog application."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTFail("Failed to list the dialog applications.")
        }
        
        dialog.getDialogs(failure) { dialogs in
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
        let expectation = expectationWithDescription(description)
        
        let dialogName = createDialogName()
        
        guard let fileURL = loadDialogFile("pizza_sample", withExtension: "xml") else {
            XCTFail("Failed to load dialog file.")
            return
        }
        
        let failure = { (error: NSError) in
            XCTFail("Failed to create the test dialog application.")
        }

        dialog.createDialog(dialogName, fileURL: fileURL, failure: failure) { id in
            self.dialogID = id
            self.dialogName = dialogName
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Fail false negatives. */
    func failWithError(error: NSError) {
        XCTFail("Positive test failed with error: \(error)")
    }

    /** Fail false positives. */
    func failWithResult<T>(result: T) {
        XCTFail("Negative test returned a result.")
    }

    /** Wait for expectation */
    func waitForExpectations() {
        waitForExpectationsWithTimeout(timeout) { error in
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
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let newCharacter = allowedChars[allowedChars.startIndex.advancedBy(randomNum)]
            randomString += String(newCharacter)
        }

        return randomString
    }

    /** Generate the name for a dialog application. */
    func createDialogName() -> String {
        return prefix + randomAlphaNumericString(5)
    }

    /** Load a dialog file. */
    func loadDialogFile(name: String, withExtension: String) -> NSURL? {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard let url = bundle.URLForResource(name, withExtension: withExtension) else {
            return nil
        }
        return url
    }

    // MARK: - Positive Tests - Content Operations

    /** List the dialog applications associated with this service instance. */
    func testGetDialogs() {
        let description = "List the dialog applications associated with this service instance."
        let expectation = expectationWithDescription(description)

        dialog.getDialogs(failWithError) { dialogs in
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
        let expectation1 = expectationWithDescription(description1)
        var dialogID: DialogID?
        
        let dialogName = createDialogName()
        guard let fileURL = loadDialogFile("pizza_sample", withExtension: "xml") else {
            XCTFail("Failed to load dialog file.")
            return
        }
        
        dialog.createDialog(dialogName, fileURL: fileURL, failure: failWithError) { id in
            dialogID = id
            expectation1.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Delete the dialog application."
        let expectation2 = expectationWithDescription(description2)
        
        dialog.deleteDialog(dialogID!, failure: failWithError) {
            expectation2.fulfill()
        }
        waitForExpectations()
    }

    /** Download the dialog file associated with the test application. */
    func getDialogFile(format: DialogV1.Format? = nil) {
        let description = "Download the dialog file associated with the test application."
        let expectation = expectationWithDescription(description)
        
        dialog.getDialogFile(dialogID!, format: format, failure: failWithError) { file in
            let fileManager = NSFileManager.defaultManager()
            XCTAssertTrue(fileManager.fileExistsAtPath(file.path!))
            XCTAssertTrue(self.verifyFiletype(format, url: file))
            try! fileManager.removeItemAtURL(file)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Verify the filetype (extension) of a downloaded dialog file. */
    func verifyFiletype(format: DialogV1.Format?, url: NSURL) -> Bool {
        var filetype = ".mct"
        if let format = format {
            switch format {
            case .OctetStream: filetype = ".mct"
            case .WDSJSON: filetype = ".json"
            case .WDSXML: filetype = ".xml"
            }
        }
        return url.path!.hasSuffix(filetype)
    }

    /** Download the dialog file associated with the test application. */
    func testGetDialogFile() {
        getDialogFile()
    }

    /** Download the dialog file associated with the test application in OctetStream format. */
    func testGetDialogFileOctetStream() {
        getDialogFile(.OctetStream)
    }

    /** Download the dialog file associated with the test application in JSON format. */
    func testGetDialogFileJSON() {
        getDialogFile(.WDSJSON)
    }

    /** Download the dialog file associated with the test application in XML format. */
    func testGetDialogFileXML() {
        getDialogFile(.WDSXML)
    }

    /** Update the dialog application. */
    func testUpdateDialog() {
        let description = "Update the dialog application."
        let expectation = expectationWithDescription(description)

        guard let fileURL = loadDialogFile("pizza_sample", withExtension: "xml") else {
            XCTFail("Failed to load dialog file.")
            return
        }

        dialog.updateDialog(dialogID!, fileURL: fileURL, failure: failWithError) {
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Get the content for each node associated with the dialog application. */
    func testGetContent() {
        let description = "Get the content for each node."
        let expectation = expectationWithDescription(description)

        let initialNode = "OUTPUT(200000)"
        let initialResponse = "Hi, I\'m Watson! I can help you order a pizza, " +
                              "what size would you like?"

        dialog.getContent(dialogID!, failure: failWithError) { nodes in
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
        let expectation = expectationWithDescription(description)

        let initialNode = "OUTPUT(200000)"
        let newGreeting = "Hi, I\'m Watson! I can help you order a pizza through my " +
                          "convenient Swift SDK! What size would you like?"

        let newNode = DialogV1.Node(content: newGreeting, node: initialNode)

        dialog.updateContent(dialogID!, nodes: [newNode], failure: failWithError) {
            expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Positive Tests - Conversation Operations

    /** Get conversation history. */
    func testGetConversationHistory() {
        let description1 = "Start a conversation with the dialog application."
        let expectation1 = expectationWithDescription(description1)
        
        let response1 = "Hi, I\'m Watson! I can help you order a pizza, what size would you like?"
        let startTime = NSDate()
        var conversationID: Int?
        var clientID: Int?

        dialog.converse(dialogID!, failure: failWithError) { response in
            XCTAssertEqual(response.response.last, response1)
            conversationID = response.conversationID
            clientID = response.clientID
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Continue a conversation with the dialog application."
        let expectation2 = expectationWithDescription(description2)

        let response2 = "What toppings are you in the mood for? (Limit 4)"

        dialog.converse(dialogID!, conversationID: conversationID!, clientID: clientID!, input: "large", failure: failWithError) {
            response in
            XCTAssertEqual(response.response.last, response2)
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Get conversation history."
        let expectation3 = expectationWithDescription(description3)

        let bufferOffset = 10.0
        let sydneyOffset = abs(NSTimeZone(name: "Australia/Sydney")!.secondsFromGMT)
        let localOffset = abs(NSTimeZone.localTimeZone().secondsFromGMT)
        let serverOffset = NSTimeInterval(sydneyOffset + localOffset)
        let dateFrom = NSDate(timeInterval: serverOffset - bufferOffset, sinceDate: startTime)
        let dateTo = NSDate(timeIntervalSinceNow: serverOffset + bufferOffset)

        dialog.getConversationHistory(dialogID!, dateFrom: dateFrom, dateTo: dateTo, failure: failWithError) {
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
        let expectation1 = expectationWithDescription(description1)

        let response1 = "Hi, I\'m Watson! I can help you order a pizza, what size would you like?"
        let startTime = NSDate()
        var conversationID: Int?
        var clientID: Int?

        dialog.converse(dialogID!, failure: failWithError) { response in
            XCTAssertEqual(response.response.last, response1)
            conversationID = response.conversationID
            clientID = response.clientID
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Continue a conversation with the dialog application."
        let expectation2 = expectationWithDescription(description2)

        let response2 = "What toppings are you in the mood for? (Limit 4)"

        dialog.converse(dialogID!, conversationID: conversationID!, clientID: clientID!, input: "large", failure: failWithError) {
            response in
            XCTAssertEqual(response.response.last, response2)
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Get conversation history with an offset."
        let expectation3 = expectationWithDescription(description3)

        let bufferOffset = 10.0
        let sydneyOffset = abs(NSTimeZone(name: "Australia/Sydney")!.secondsFromGMT)
        let localOffset = abs(NSTimeZone.localTimeZone().secondsFromGMT)
        let serverOffset = NSTimeInterval(sydneyOffset + localOffset)
        let dateFrom = NSDate(timeInterval: serverOffset - bufferOffset, sinceDate: startTime)
        let dateTo = NSDate(timeIntervalSinceNow: serverOffset + bufferOffset)

        let offset = 1000
        dialog.getConversationHistory(dialogID!, dateFrom: dateFrom, dateTo: dateTo, offset: offset, failure: failWithError) {
            conversations in
            XCTAssertEqual(conversations.count, 0)
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    /** Get conversation history with a limit. */
    func testGetConversationHistoryWithLimit() {
        let description1 = "Start a conversation with the dialog application."
        let expectation1 = expectationWithDescription(description1)

        let response1 = "Hi, I\'m Watson! I can help you order a pizza, what size would you like?"
        let startTime = NSDate()
        var conversationID: Int?
        var clientID: Int?

        dialog.converse(dialogID!, failure: failWithError) { response in
            XCTAssertEqual(response.response.last, response1)
            conversationID = response.conversationID
            clientID = response.clientID
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Continue a conversation with the dialog application."
        let expectation2 = expectationWithDescription(description2)

        let response2 = "What toppings are you in the mood for? (Limit 4)"

        dialog.converse(dialogID!, conversationID: conversationID!, clientID: clientID!, input: "large", failure: failWithError) {
            response in
            XCTAssertEqual(response.response.last, response2)
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Get conversation history with a limit."
        let expectation3 = expectationWithDescription(description3)

        let bufferOffset = 10.0
        let sydneyOffset = abs(NSTimeZone(name: "Australia/Sydney")!.secondsFromGMT)
        let localOffset = abs(NSTimeZone.localTimeZone().secondsFromGMT)
        let serverOffset = NSTimeInterval(sydneyOffset + localOffset)
        let dateFrom = NSDate(timeInterval: serverOffset - bufferOffset, sinceDate: startTime)
        let dateTo = NSDate(timeIntervalSinceNow: serverOffset + bufferOffset)

        let limit = 0
        dialog.getConversationHistory(dialogID!, dateFrom: dateFrom, dateTo: dateTo, limit: limit, failure: failWithError) {
            conversations in
            // XCTAssertEqual(conversations.count, 0)
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    /** Converse with the dialog application. */
    func testConverse() {
        let description1 = "Start a conversation with the dialog application."
        let expectation1 = expectationWithDescription(description1)

        let response1 = "Hi, I\'m Watson! I can help you order a pizza, what size would you like?"
        var conversationID: Int?
        var clientID: Int?

        dialog.converse(dialogID!, failure: failWithError) { response in
            XCTAssertEqual(response.response.last, response1)
            conversationID = response.conversationID
            clientID = response.clientID
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Continue a conversation with the dialog application."
        let expectation2 = expectationWithDescription(description2)

        let response2 = "What toppings are you in the mood for? (Limit 4)"

        dialog.converse(
            dialogID!,
            conversationID: conversationID!,
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
        let expectation1 = expectationWithDescription(description1)

        var conversationID: Int?
        var clientID: Int?

        dialog.converse(dialogID!, failure: failWithError) { response in
            conversationID = response.conversationID
            clientID = response.clientID
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Continue a conversation with the dialog application."
        let expectation2 = expectationWithDescription(description2)

        dialog.converse(
            dialogID!,
            conversationID: conversationID!,
            clientID: clientID!,
            input: "large",
            failure: failWithError)
        {
            response in
            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Retrieve the client's profile variables."
        let expectation3 = expectationWithDescription(description3)

        dialog.getProfile(dialogID!, clientID: clientID!, failure: failWithError) { profile in
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
        let expectation = expectationWithDescription(description)

        dialog.updateProfile(dialogID!, parameters: ["size": "Large"], failure: failWithError) {
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Update an existing client's profile variables. */
    func testUpdateExistingProfile() {
        let description1 = "Start a conversation with the dialog application."
        let expectation1 = expectationWithDescription(description1)

        var clientID: Int?

        dialog.converse(dialogID!, failure: failWithError) { response in
            clientID = response.clientID
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Update an existing client's profile variables."
        let expectation2 = expectationWithDescription(description2)

        dialog.updateProfile(
            dialogID!,
            clientID: clientID!,
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
        let expectation = expectationWithDescription(description)

        let dialogName = createDialogName()

        guard let fileURL = loadDialogFile("pizza_sample_invalid", withExtension: "xml") else {
            XCTFail("Failed to load invalid dialog file.")
            return
        }

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }

        dialog.createDialog(dialogName, fileURL: fileURL, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Create a dialog with a conflicting name. */
    func testCreateDialogWithConflictingName() {
        let description = "Create a dialog with a conflicting name."
        let expectation = expectationWithDescription(description)

        guard let fileURL = loadDialogFile("pizza_sample", withExtension: "xml") else {
            XCTFail("Failed to load dialog file.")
            return
        }

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 409)
            expectation.fulfill()
        }

        dialog.createDialog(dialogName!, fileURL: fileURL, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Create a dialog with a name that is too long. */
    func testCreateDialogWithLongName() {
        let description = "Create a dialog with a long name."
        let expectation = expectationWithDescription(description)

        let longName = createDialogName() + randomAlphaNumericString(10)

        guard let fileURL = loadDialogFile("pizza_sample", withExtension: "xml") else {
            XCTFail("Failed to load dialog file.")
            return
        }

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 422)
            expectation.fulfill()
        }

        dialog.createDialog(longName, fileURL: fileURL, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Create a dialog with a file that does not exist. */
    func testCreateDialogWithNonexistentFile() {
        let description = "Create a dialog with a file that does not exist."
        let expectation = expectationWithDescription(description)

        let dialogName = createDialogName()

        let fileURL = NSURL(fileURLWithPath: "/this/is/an/invalid/path.json")

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 0)
            expectation.fulfill()
        }

        dialog.createDialog(dialogName, fileURL: fileURL, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Delete a dialog that doesn't exist. */
    func testDeleteInvalidDialogID() {
        let description = "Delete a dialog that doesn't exist."
        let expectation = expectationWithDescription(description)

        let invalidID = "this-id-does-not-exist"
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }

        dialog.deleteDialog(invalidID, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Get the dialog file for a dialog that doesn't exist. */
    func testGetDialogFileForInvalidDialogID() {
        let description = "Get the dialog file for a dialog that doesn't exist."
        let expectation = expectationWithDescription(description)

        let invalidID = "this-id-does-not-exist"
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }

        dialog.getDialogFile(invalidID, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Upload an invalid dialog file. */
    func testUpdateDialogWithInvalidFile() {
        let description = "Upload an invalid dialog file."
        let expectation = expectationWithDescription(description)

        guard let fileURL = loadDialogFile("pizza_sample_invalid", withExtension: "xml") else {
            XCTFail("Failed to load invalid dialog file.")
            return
        }

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }

        dialog.updateDialog(dialogID!, fileURL: fileURL, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Update a dialog with a file that does not exist. */
    func testUpdateDialogWithNonexistentFile() {
        let description = "Update a dialog with a file that does not exist."
        let expectation = expectationWithDescription(description)

        let fileURL = NSURL(fileURLWithPath: "/this/is/an/invalid/path.json")

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 0)
            expectation.fulfill()
        }

        dialog.updateDialog(dialogID!, fileURL: fileURL, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Update a dialog that doesn't exist. */
    func testUpdateDialogForInvalidDialogID() {
        let description = "Update a dialog that doesn't exist."
        let expectation = expectationWithDescription(description)

        let invalidID = "this-id-does-not-exist"

        guard let fileURL = loadDialogFile("pizza_sample", withExtension: "xml") else {
            XCTFail("Failed to load dialog file.")
            return
        }

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }

        dialog.updateDialog(invalidID, fileURL: fileURL, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Get the content for each node of a dialog application that doesn't exist. */
    func testGetContentForInvalidDialogID() {
        let description = "Retrieve the content from nodes "
        let expectation = expectationWithDescription(description)

        let invalidID = "this-id-does-not-exist"

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }

        dialog.getContent(invalidID, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Update invalid content for a node of the dialog application. */
    func testUpdateContentInvalid() {
        let description = "Update invalid content for a node of the dialog application."
        let expectation = expectationWithDescription(description)

        let nodes = [DialogV1.Node(content: "this-is-invalid", node: "this-is-invalid")]

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 422)
            expectation.fulfill()
        }

        dialog.updateContent(dialogID!, nodes: nodes, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Update content for a dialog that doesn't exist. */
    func testUpdateContentForInvalidDialogID() {
        let description = "Update content for a dialog that doesn't exist."
        let expectation = expectationWithDescription(description)

        let invalidID = "this-id-does-not-exist"

        let nodes = [DialogV1.Node(content: "", node: "")]

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }

        dialog.updateContent(invalidID, nodes: nodes, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    // MARK: - Negative Tests - Conversation Operations

    /** Get conversation history for a dialog that doesn't exit. */
    func testGetConversationHistoryForInvalidDialogID() {
        let description = "Get the conversation history for a dialog that doesn't exist."
        let expectation = expectationWithDescription(description)

        let invalidID = "this-id-does-not-exist"

        let sydneyOffset = abs(NSTimeZone(name: "Australia/Sydney")!.secondsFromGMT)
        let localOffset = abs(NSTimeZone.localTimeZone().secondsFromGMT)
        let serverOffset = sydneyOffset + localOffset
        let dateFromOffset: NSTimeInterval = -120.0 + Double(serverOffset)
        let dateToOffset: NSTimeInterval = 120 + Double(serverOffset)
        let dateFrom = NSDate(timeIntervalSinceNow: dateFromOffset)
        let dateTo = NSDate(timeIntervalSinceNow: dateToOffset)

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }

        dialog.getConversationHistory(
            invalidID,
            dateFrom: dateFrom,
            dateTo: dateTo,
            failure: failure,
            success: failWithResult
        )
        waitForExpectations()
    }

    /** Converse with a dialog application that doesn't exist.  */
    func testConverseWithInvalidDialogID() {
        let description = "Converse with a dialog application that doesn't exist."
        let expectation = expectationWithDescription(description)

        let invalidID = "this-id-does-not-exist"

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }

        dialog.converse(invalidID, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Converse with a dialog application using an invalid conversation id and client id. */
    func testConverseWithInvalidIDs() {
        let description = "Converse with a dialog application using invalid ids."
        let expectation = expectationWithDescription(description)

        let invalidConversationID = 0
        let invalidClientID = 0

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }

        dialog.converse(
            dialogID!,
            conversationID: invalidConversationID,
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
        let expectation = expectationWithDescription(description)

        let invalidID = "this-id-does-not-exist"
        let invalidClientID = 0
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }

        dialog.getProfile(
            invalidID,
            clientID: invalidClientID,
            failure: failure,
            success: failWithResult
        )
        waitForExpectations()
    }

    /** Retrieve a client's profile variables using an invalid client id. */
    func testGetProfileWithInvalidClientID() {
        let description = "Retrieve the client's profile variables using an invalid client id."
        let expectation = expectationWithDescription(description)

        let invalidClientID = 0

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }

        dialog.getProfile(
            dialogID!,
            clientID: invalidClientID,
            failure: failure,
            success: failWithResult
        )
        waitForExpectations()
    }

    /** Retrieve a client's profile using invalid profile parameters. */
    func testGetProfileWithInvalidParameterNames() {
        let description1 = "Start a conversation with the dialog application."
        let expectation1 = expectationWithDescription(description1)

        var clientID: Int?

        dialog.converse(dialogID!, failure: failWithError) { response in
            clientID = response.clientID
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Retrieve the client's profile using invalid profile parameters."
        let expectation2 = expectationWithDescription(description2)

        let invalidParameters = ["these", "parameter", "names", "do", "not", "exist"]

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 422)
            expectation2.fulfill()
        }

        dialog.getProfile(
            dialogID!,
            clientID: clientID!,
            names: invalidParameters,
            failure: failure,
            success: failWithResult
        )
        waitForExpectations()
    }

    /** Update a client's profile variables using an invalid dialog id. */
    func testUpdateProfileWithInvalidDialogID() {
        let description = "Update the client's profile variables using an invalid dialog id."
        let expectation = expectationWithDescription(description)

        let invalidID = "this-id-does-not-exist"

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }

        dialog.updateProfile(
            invalidID,
            parameters: ["size": "Large"],
            failure: failure,
            success: failWithResult
        )
        waitForExpectations()
    }

    /** Update a client's profile using an invalid client id. */
    func testUpdateProfileWithInvalidClientID() {
        let description = "Update a client's profile using an invalid client id."
        let expectation = expectationWithDescription(description)

        let invalidID = 0

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }

        dialog.updateProfile(
            dialogID!,
            clientID: invalidID,
            parameters: ["size": "Large"],
            failure: failure,
            success: failWithResult
        )
        waitForExpectations()
    }
}
