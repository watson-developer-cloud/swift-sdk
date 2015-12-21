/**
 * Copyright IBM Corporation 2015
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
@testable import WatsonDeveloperCloud

class DialogTests: XCTestCase {
    
    // MARK: - Parameters and constants
    
    // the Dialog service
    var service: Dialog!

    // the Dialog application that will be created for testing
    let dialogName = "pizza-watsonsdk-ios"
    var dialogID: Dialog.DialogID!
    
    // the Dialog file that will be used to create the application
    let dialogFileName = "pizza_sample"
    let dialogFileType = "xml"
    var dialogFile: NSURL! = nil
    
    // the initial node and response from Watson
    let initialNode = "OUTPUT(200000)"
    let initialResponse = "Hi, I\'m Watson! I can help you order a pizza, " +
                          "what size would you like?"
    let initialResponse2 = "Hi, I\'m Watson! I can help you order a pizza through my " +
                           "convenient Swift SDK! What size would you like?"
    
    // the second response from Watson (i.e. after specifying size of pizza)
    let node2 = "OUTPUT(200022)"
    let response2 = "What toppings are you in the mood for? (Limit 4)"
    
    // the conversation parameters
    var conversationID: Int!
    var clientID: Int!
    let input = "I would like a medium, please."
    let response = "What toppings are you in the mood for? (Limit 4)"
    
    // the profile parameters
    let parameterName = "size"
    let parameters = ["size": "Small"]
    
    // invalid parameters for negative tests
    let invalidDialogID = "9354b734-d5b2-4fd3-bee0-e38adbcab575"
    let invalidConversationID = 177530
    let invalidClientID = 170351
    
    // timeout for asynchronous completion handlers
    private let timeout: NSTimeInterval = 30.0
    
    // MARK: - Dialog Tests
    
    /// Test the Dialog service by executing each operation with valid parameters.
    func testDialog() {
        
        // delete any Dialog applications with the same name as our testing application
        deleteConflictingDialogApp()
        
        // load the Dialog file to be used for creating the application
        loadDialogFile()
        
        // create the Dialog application
        createDialogApp()
        
        // ensure Dialog application is created before sending queries
        sleep(3)
        
        // verify the content of the initial response node
        verifyInitialNode(initialResponse)
        
        // update and verify changes to the initial node
        // (changes should be reset by uploadDialogFile())
        updateInitialNode(initialResponse2)
        verifyInitialNode(initialResponse2)
        
        // verify list of Dialog applications to ensure our application was created
        verifyListOfDialogApplications()
        
        // download the Dialog file in various formats
        // (note: each file is immediately deleted to avoid naming conflicts)
        downloadDialogFile()
        downloadDialogFile(.OctetStream)
        downloadDialogFile(.WDSJSON)
        downloadDialogFile(.WDSXML)
        
        // upload the original Dialog file to reset the application
        uploadDialogFile()
        
        // verify successful upload/reset
        verifyInitialNode(initialResponse)
        
        // converse with the Dialog application
        startConversation()
        continueConversation()
        
        // get all conversation session history
        // getAllConversationHistory()
        
        // associate profile parameters with this client
        setProfileParameters()
        
        // verify profile parameters for this client
        verifyProfileParameters()
        
        // verify the first profile parameter for this client
        verifyProfileParameter()
        
        // verify error conditions
        executeNegativeTests()
        
        // delete the Dialog application
        deleteDialogApp()
        
    }
    
    /// Test the Dialog service by executing each operation with invalid parameters.
    func executeNegativeTests() {
        
        // invoke getContent() with an invalid Dialog ID
        getContentInvalidDialogID()
        
        // invoke updateContent() with an invalid Dialog ID
        updateContentInvalidDialogID()
        
        // invoke updateContent() with invalid content
        updateContentInvalidContent()
        
        // invoke createDialog() with a name that is too long
        createDialogWithLongName()
        
        // invoke createDialog() with a file that doesn't exist
        createDialogWithoutFile()
        
        // invoke createDialog() with an invalid file
        createDialogWithInvalidFile()
        
        // invoke deleteDialog() with an invalid Dialog ID
        deleteDialogWithInvalidDialogID()
        
        // invoke getDialogFile() with an invalid Dialog ID
        downloadDialogFileWithInvalidDialogID()
        
        // invoke updateDialog() with invalid Dialog ID
        updateDialogWithInvalidDialogID()
        
        // invoke updateDialog() with a file that doesn't exist
        updateDialogWithoutFile()
        
        // invoke updateDialog() with an invalid file
        updateDialogWithInvalidFile()
        
        // invoke converse() with an invalid Dialog ID
        startConversationInvalidDialogID()
        
        // invoke converse() with an invalid Conversation ID and Client ID
        startConversationInvalidConversationIDAndClientID()
        
        // invoke converse() with unexpected input on initial response
        startConversationUnexpectedInput()
        
        // invoke getProfile() with an invalid Dialog ID
        getProfileWithInvalidDialogID()
        
        // invoke getProfile() with an invalid Client ID
        getProfileWithInvalidClientID()
        
        // invoke getProfile() with invalid profile parameter names
        getProfileWithInvalidParameterNames()
        
        // invoke updateProfile() with an invalid Dialog ID
        updateProfileWithInvalidDialogID()
        
        // invoke updateProfile() with an invalid Client ID
        updateProfileWithInvalidClientID()
        
        // Invoke updateProfile() with invalid profile parameters
        updateProfileWithInvalidParameterNames()
        
    }
    
    // MARK: - Helper functions
    
    /// Load credentials and instantiate Dialog service
    override func setUp() {
        super.setUp()
        
        // identify credentials file
        let bundle = NSBundle(forClass: self.dynamicType)
        guard let url = bundle.pathForResource("Credentials", ofType: "plist") else {
            XCTFail("Unable to locate credentials file.")
            return
        }
        
        // load credentials from file
        let dict = NSDictionary(contentsOfFile: url)
        guard let credentials = dict as? Dictionary<String, String> else {
            XCTFail("Unable to read credentials file.")
            return
        }
        
        // read Dialog username
        guard let username = credentials["DialogUsername"] else {
            XCTFail("Unable to read Dialog username.")
            return
        }
        
        // read Dialog password
        guard let password = credentials["DialogPassword"] else {
            XCTFail("Unable to read Dialog password.")
            return
        }
        
        // instantiate the service
        if service == nil {
            service = Dialog(username: username, password: password)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /// Wait for an expectation to be fulfilled.
    func waitForExpectation() {
        waitForExpectationsWithTimeout(timeout) { error in
            XCTAssertNil(error, "Timeout.")
        }
    }
    
    // MARK: - Positive tests
    
    /// Delete any Dialog applications with the same name as our testing application.
    /// (This will prevent naming conflicts from any previously unsuccessful tests.)
    func deleteConflictingDialogApp() {
        let description = "Deleting any conflicting Dialog applications."
        let expectation = expectationWithDescription(description)
        
        // get existing Dialog applications
        service.getDialogs() { dialogs, error in
            
            // verify expected response
            XCTAssertNotNil(dialogs)
            XCTAssertNil(error)
            
            // delete any Dialog applications with a conflicting name
            let conflicts = dialogs?.filter { $0.name == self.dialogName }
            if let conflicts = conflicts {
                conflicts.forEach() { dialog in
                    self.service.deleteDialog(dialog.dialogID!) { error in
                        
                        // verify expected response
                        XCTAssertNil(error)
                        
                        expectation.fulfill()
                    }
                }
                if conflicts.count == 0 {
                    expectation.fulfill()
                }
            }
        }
        waitForExpectation()
    }
    
    /// Load the Dialog file to be used for creating the application.
    func loadDialogFile() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let dialogPath = bundle.pathForResource(dialogFileName, ofType: dialogFileType)
        XCTAssertNotNil(dialogPath, "Dialog File cannot be found.")
        dialogFile = NSURL(fileURLWithPath: dialogPath!)
        XCTAssertNotNil(dialogFile, "Dialog File could not be loaded.")
    }
    
    /// Create the Dialog application.
    func createDialogApp() {
        let description = "Creating Dialog application."
        let expectation = expectationWithDescription(description)

        // load Dialog file
        XCTAssertNotNil(dialogFile, "Dialog file not found.")
        guard let dialogFile = dialogFile else {
            return
        }
        
        // create Dialog application
        service.createDialog(dialogName, fileURL: dialogFile) { dialogID, error in
            
            // verify expected response
            XCTAssertNotNil(dialogID)
            XCTAssertNil(error)
            
            // store Dialog ID for subsequent operations
            self.dialogID = dialogID
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    /// Verify the content of the initial response node
    func verifyInitialNode(initialResponse: String) {
        let description = "Verifying the content of the initial node."
        let expectation = expectationWithDescription(description)
        
        // retrieve all nodes
        service.getContent(dialogID) { nodes, error in
            
            // verify expected response
            XCTAssertNotNil(nodes)
            XCTAssertNil(error)
            
            // verify initial node
            for node in nodes! {
                let nodeMatch = (node.node == self.initialNode)
                let responseMatch = (node.content == initialResponse)
                if nodeMatch && responseMatch {
                    expectation.fulfill()
                    break
                }
            }
            
        }
        waitForExpectation()
    }
    
    /// Update the message for the initial node.
    func updateInitialNode(initialResponse: String) {
        let description = "Updating the message associated with the initial node."
        let expectation = expectationWithDescription(description)
        
        // define the updates to the initial node
        let nodes = [Dialog.Node(content: initialResponse, node: initialNode)]
        
        // update the initial node
        service.updateContent(dialogID, nodes: nodes) { error in
            
            // verify expected response
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    /// Verify list of Dialog applications to ensure our application was created
    func verifyListOfDialogApplications() {
        let description = "Check the list of Dialog applications for our testing app."
        let expectation = expectationWithDescription(description)
        
        // list the Dialog applications associated with the service instance
        service.getDialogs() { dialogs, error in
            
            // verify expected response
            XCTAssertNotNil(dialogs)
            XCTAssertNil(error)
            
            // verify that our Dialog application is among those listed
            for dialog in dialogs! {
                let nameMatch = (dialog.name == self.dialogName)
                let idMatch = (dialog.dialogID == self.dialogID)
                if nameMatch && idMatch {
                    expectation.fulfill()
                }
            }
        }
        waitForExpectation()
    }
    
    /// Download the Dialog file associated with our testing application
    func downloadDialogFile(format: MediaType? = nil) {
        let description = "Downloading the Dialog file for our testing app."
        let expectation = expectationWithDescription(description)
        
        // download the Dialog file
        service.getDialogFile(dialogID, format: format) { file, error in
            
            // verify expected response
            XCTAssertNotNil(file)
            XCTAssertNil(error)
            
            // delete the downloaded file to prevent naming conflicts
            let fileMgr = NSFileManager.defaultManager()
            do {
                try fileMgr.removeItemAtURL(file!)
            } catch {
                XCTFail("Unable to delete downloaded Dialog file.")
            }
            
            expectation.fulfill()
        }
        waitForExpectation()
    }

    /// Upload the original Dialog file to reset the application.
    func uploadDialogFile() {
        let description = "Uploading the original Dialog file to reset application."
        let expectation = expectationWithDescription(description)
        
        // upload the Dialog file
        service.updateDialog(dialogID, fileURL: dialogFile, fileType: .WDSXML) {
            error in
            
            // verify expected response
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    /// Start a conversation with the Dialog application.
    func startConversation() {
        let description = "Start a conversation with the Dialog application."
        let expectation = expectationWithDescription(description)
        
        // start a new conversation
        service.converse(dialogID) { response, error in
            
            // verify expected response
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            
            // save conversation parameters
            self.conversationID = response?.conversationID
            self.clientID = response?.clientID
            
            // ensure initial response is as expected
            if response?.response![0] == self.initialResponse {
                expectation.fulfill()
            }
        }
        waitForExpectation()
    }
    
    /// Continue a conversation with the Dialog application.
    func continueConversation() {
        let description = "Continue the conversation with the Dialog application."
        let expectation = expectationWithDescription(description)
        
        // continue conversation
        service.converse(dialogID, conversationID: conversationID,
            clientID: clientID, input: input) { response, error in
            
            // verify expected response
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            
            // ensure response is as expected
            if response?.response![1] == self.response2 {
                expectation.fulfill()
            }
        }
        waitForExpectation()
    }
    
    // TODO: Get all conversation session history.
    
    /// Associate profile parameters with this client.
    func setProfileParameters() {
        let description = "Associating profile parameters with this client."
        let expectation = expectationWithDescription(description)
        
        // set profile variables
        service.updateProfile(dialogID, clientID: clientID, parameters: parameters) {
            error in
            
            // verify expected response
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    /// Verify all profile parameters for this client.
    func verifyProfileParameters() {
        let description = "Verifying profile parameters with this client."
        let expectation = expectationWithDescription(description)
        
        // get all profile parameters
        service.getProfile(dialogID, clientID: clientID) { parameters, error in
            
            // verify expected response
            XCTAssertNotNil(parameters)
            XCTAssertNil(error)
            
            // ensure parameters are as expected
            for parameter in parameters! {
                let returnedValue = parameter.value!
                let setValue = self.parameters[parameter.name!]
                let parameterMatch = returnedValue == setValue
                XCTAssert(parameterMatch)
            }

            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    /// Verify the first profile parameter for this client.
    func verifyProfileParameter() {
        let description = "Verifying the first profile parameter for this client."
        let expectation = expectationWithDescription(description)
        
        // get first profile parameter
        service.getProfile(dialogID, clientID: clientID, names: [parameterName]) {
            parameters, error in
            
            // verify expected response
            XCTAssertNotNil(parameters)
            XCTAssertNil(error)
            
            // ensure parameter is as expected
            for parameter in parameters! {
                let returnedValue = parameter.value!
                let setValue = self.parameters[parameter.name!]
                let parameterMatch = returnedValue == setValue
                XCTAssert(parameterMatch)
            }
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    /// Delete the Dialog application.
    func deleteDialogApp() {
        let description = "Deleting the Dialog application created for testing."
        let expectation = expectationWithDescription(description)
        
        // load Dialog ID
        guard let dialogID = dialogID else {
            XCTFail("No Dialog application to delete.")
            return
        }
        
        // delete Dialog application
        service.deleteDialog(dialogID) { error in
            
            // verify expected response
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // MARK: - Negative Tests
    
    // Invoke getContent() with an invalid Dialog ID
    func getContentInvalidDialogID() {
        let description = "Try to get the content for each node using an invalid Dialog ID."
        let expectation = expectationWithDescription(description)

        // get content
        service.getContent(invalidDialogID) { nodes, error in
            
            // verify expected response
            XCTAssertNil(nodes)
            XCTAssertNotNil(error)
            
            // ensure error is as expected
            XCTAssert(error!.code == 404)
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // Invoke updateContent() with an invalid Dialog ID
    func updateContentInvalidDialogID() {
        let description = "Try to update the content for nodes using an invalid Dialog ID."
        let expectation = expectationWithDescription(description)
        
        // define the updates to the initial node
        let nodes = [Dialog.Node(content: initialResponse, node: initialNode)]
        
        // update the initial node
        service.updateContent(invalidDialogID, nodes: nodes) { error in
            
            // verify expected response
            XCTAssertNotNil(error)
            
            // ensure error is as expected
            XCTAssert(error!.code == 404)
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // Invoke updateContent() with invalid content
    func updateContentInvalidContent() {
        let description = "Try to update the initial node with invalid content."
        let expectation = expectationWithDescription(description)
        
        // define an empty node
        let nodes = [Dialog.Node(content: initialNode, node: initialResponse)]
        
        // update the node
        service.updateContent(dialogID, nodes: nodes) { error in
            
            // verify expected response
            XCTAssertNotNil(error)
            
            // ensure error is as expected
            XCTAssert(error!.code == 422)
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // Invoke createDialog() with a name that is too long
    func createDialogWithLongName() {
        let description = "Try to create a Dialog with a very long name."
        let expectation = expectationWithDescription(description)
        
        // define the long name
        var longDialogName = dialogName
        for _ in 1...100 {
            longDialogName += dialogName
        }
        
        // create Dialog application
        service.createDialog(longDialogName, fileURL: dialogFile) { dialogID, error in
            
            // verify expected response
            XCTAssertNil(dialogID)
            XCTAssertNotNil(error)
            
            // ensure error is as expected
            XCTAssert(error!.code == 422)
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // Invoke createDialog() with a file that doesn't exist
    func createDialogWithoutFile() {
        let description = "Try to create a Dialog with a Dialog file that doesn't exist."
        let expectation = expectationWithDescription(description)
        
        // define file path
        let manager = NSFileManager.defaultManager()
        let directoryURL = manager.URLsForDirectory(.DocumentDirectory,
            inDomains: .UserDomainMask)[0]
        let pathComponent = "invalidFile.json"
        let fileURL = directoryURL.URLByAppendingPathComponent(pathComponent)
        
        // create Dialog application
        service.createDialog(dialogName, fileURL: fileURL) { dialogID, error in
            
            // verify expected response
            XCTAssertNil(dialogID)
            XCTAssertNotNil(error)
            
            // ensure error is as expected
            XCTAssert(error!.code == -6008)
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // Invoke createDialog() with an invalid file
    func createDialogWithInvalidFile() {
        let description = "Try to create a Dialog with an invalid Dialog file."
        let expectation = expectationWithDescription(description)
        
        // define file path
        let manager = NSFileManager.defaultManager()
        let directoryURL = manager.URLsForDirectory(.DocumentDirectory,
            inDomains: .UserDomainMask)[0]
        let pathComponent = "invalidFile.json"
        let fileURL = directoryURL.URLByAppendingPathComponent(pathComponent)
        let file = fileURL.path!
        
        // write to the file
        do {
            let contents = "{ \"Hello\": \"World\" }"
            try contents.writeToFile(file, atomically: true,
                encoding: NSUTF8StringEncoding)
        } catch {
            XCTFail("Unable to create file.")
        }
        
        // create Dialog application
        service.createDialog(dialogName, fileURL: fileURL) { dialogID, error in
            
            // verify expected response
            XCTAssertNil(dialogID)
            XCTAssertNotNil(error)
            
            // ensure error is as expected
            XCTAssert(error!.code == 400)
            
            expectation.fulfill()
        }
        waitForExpectation()
        
        // delete the file to prevent conflicts
        do {
            try manager.removeItemAtURL(fileURL)
        } catch {
            XCTFail("Unable to delete invalid Dialog file.")
        }
    }
    
    // Invoke deleteDialog() with an invalid Dialog ID
    func deleteDialogWithInvalidDialogID() {
        let description = "Try to delete a Dialog using an invalid Dialog ID."
        let expectation = expectationWithDescription(description)
        
        // delete Dialog application
        service.deleteDialog(invalidDialogID) { error in
            
            // verify expected response
            XCTAssertNotNil(error)
            
            // ensure error is as expected
            XCTAssert(error!.code == 404)
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // Invoke getDialogFile() with an invalid Dialog ID
    func downloadDialogFileWithInvalidDialogID() {
        let description = "Try to download the Dialog file using an invalid Dialog ID."
        let expectation = expectationWithDescription(description)
        
        // download the Dialog file
        service.getDialogFile(invalidDialogID) { file, error in
            
            // verify expected response
            XCTAssertNotNil(file)
            XCTAssertNotNil(error)
            
            // ensure error is as expected
            XCTAssert(error!.code == 404)
            
            // delete the downloaded file to prevent conflicts
            do {
                let manager = NSFileManager.defaultManager()
                try manager.removeItemAtURL(file!)
            } catch {
                XCTFail("Unable to delete downloaded Dialog file.")
            }
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // Invoke updateDialog() with invalid Dialog ID
    func updateDialogWithInvalidDialogID() {
        let description = "Try to update a Dialog using an invalid Dialog ID."
        let expectation = expectationWithDescription(description)
        
        // upload the Dialog file
        service.updateDialog(invalidDialogID, fileURL: dialogFile, fileType: .WDSXML) {
            error in
            
            // verify expected response
            XCTAssertNotNil(error)
            
            // ensure error is as expected
            XCTAssert(error!.code == 404)
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // Invoke updateDialog() with a file that doesn't exist
    func updateDialogWithoutFile() {
        let description = "Try to update a Dialog with a Dialog file that doesn't exist."
        let expectation = expectationWithDescription(description)
        
        // define file path
        let manager = NSFileManager.defaultManager()
        let directoryURL = manager.URLsForDirectory(.DocumentDirectory,
            inDomains: .UserDomainMask)[0]
        let pathComponent = "invalidFile.json"
        let fileURL = directoryURL.URLByAppendingPathComponent(pathComponent)
        
        // upload the Dialog file
        service.updateDialog(dialogID, fileURL: fileURL, fileType: .WDSJSON) { error in
            
            // verify expected response
            XCTAssertNotNil(error)
            
            // ensure error is as expected
            XCTAssert(error!.code == 400)
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // Invoke updateDialog() with an invalid file
    func updateDialogWithInvalidFile() {
        let description = "Try to update a Dialog with an invalid Dialog file."
        let expectation = expectationWithDescription(description)
        
        // define file path
        let manager = NSFileManager.defaultManager()
        let directoryURL = manager.URLsForDirectory(.DocumentDirectory,
            inDomains: .UserDomainMask)[0]
        let pathComponent = "invalidFile.json"
        let fileURL = directoryURL.URLByAppendingPathComponent(pathComponent)
        let file = fileURL.path!
        
        // write to the file
        do {
            let contents = "{ \"Hello\": \"World\" }"
            try contents.writeToFile(file, atomically: true,
                encoding: NSUTF8StringEncoding)
        } catch {
            XCTFail("Unable to create file.")
        }
        
        // upload the Dialog file
        service.updateDialog(dialogID, fileURL: fileURL, fileType: .WDSJSON) { error in
            
            // verify expected response
            XCTAssertNotNil(error)
            
            // ensure error is as expected
            XCTAssert(error!.code == 400)
            
            expectation.fulfill()
        }
        waitForExpectation()
        
        // delete the file to prevent conflicts
        do {
            try manager.removeItemAtURL(fileURL)
        } catch {
            XCTFail("Unable to delete invalid Dialog file.")
        }
    }
    
    // TODO: Write negative test for getConversation()
    
    // Invoke converse() with an invalid Dialog ID
    func startConversationInvalidDialogID() {
        let description = "Try to converse with an invalid Dialog ID."
        let expectation = expectationWithDescription(description)
        
        // start a new conversation
        service.converse(invalidDialogID) { response, error in
            
            // verify expected response
            XCTAssertNil(response)
            XCTAssertNotNil(error)
            
            // ensure error is as expected
            XCTAssert(error!.code == 404)
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // Invoke converse() with an invalid Conversation ID and Client ID
    func startConversationInvalidConversationIDAndClientID() {
        let description = "Try to converse with an invalid Conversation ID and Client ID."
        let expectation = expectationWithDescription(description)
        
        // start a new conversation
        service.converse(dialogID, conversationID: invalidConversationID,
            clientID: invalidClientID) { response, error in
                
            // verify expected response
            XCTAssertNil(response)
            XCTAssertNotNil(error)
                
            // ensure error is as expected
            XCTAssert(error!.code == 404)
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // Invoke converse() with unexpected input on initial response
    func startConversationUnexpectedInput() {
        let description = "Try to start a conversation with unexpected input."
        let expectation = expectationWithDescription(description)
        
        // start a new conversation
        service.converse(dialogID, input: input) { response, error in
            
            // verify expected response
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            
            // ensure initial response is as expected
            if response?.response![0] == self.initialResponse {
                expectation.fulfill()
            }
        }
        waitForExpectation()
    }
    
    // Invoke getProfile() with an invalid Dialog ID
    func getProfileWithInvalidDialogID() {
        let description = "Try to get a client's profile using an invalid Dialog ID."
        let expectation = expectationWithDescription(description)
        
        // get all profile parameters
        service.getProfile(invalidDialogID, clientID: clientID) { parameters, error in
            
            // verify expected response
            XCTAssertNil(parameters)
            XCTAssertNotNil(error)
            
            // ensure error is as expected
            XCTAssert(error!.code == 404)
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // Invoke getProfile() with an invalid Client ID
    func getProfileWithInvalidClientID() {
        let description = "Try to get a client's profile using an invalid Client ID."
        let expectation = expectationWithDescription(description)
        
        // get all profile parameters
        service.getProfile(dialogID, clientID: invalidClientID) { parameters, error in
            
            // verify expected response
            XCTAssertNotNil(parameters)
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // Invoke getProfile() with invalid profile parameter names
    func getProfileWithInvalidParameterNames() {
        let description = "Try to get a client's profile using invalid parameter names."
        let expectation = expectationWithDescription(description)
        
        // invalid profile parameter names
        let invalidNames = ["Hello", "World"]
        
        // get invalid profile parameters
        service.getProfile(dialogID, clientID: clientID, names: invalidNames) {
            parameters, error in
            
            // verify expected response
            XCTAssertNil(parameters)
            XCTAssertNotNil(error)
            
            // ensure error is as expected
            XCTAssert(error!.code == 422)
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // Invoke updateProfile() with an invalid Dialog ID
    func updateProfileWithInvalidDialogID() {
        let description = "Try to update a client's profile using an invalid Dialog ID."
        let expectation = expectationWithDescription(description)
        
        // set profile parameters
        service.updateProfile(invalidDialogID, clientID: clientID,
            parameters: parameters) { error in
                
            // verify expected response
            XCTAssertNotNil(error)
            
            // ensure error is as expected
            XCTAssert(error!.code == 404)
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // Invoke updateProfile() with an invalid Client ID
    func updateProfileWithInvalidClientID() {
        let description = "Try to update a client's profile using an invalid Client ID."
        let expectation = expectationWithDescription(description)
        
        // set profile parameters
        service.updateProfile(dialogID, clientID: invalidClientID,
            parameters: parameters) { error in
                
            // verify expected response
            XCTAssertNil(error)
                
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // Invoke updateProfile() with invalid profile parameters
    func updateProfileWithInvalidParameterNames() {
        let description = "Try to update a client's profile using invalid parameter names."
        let expectation = expectationWithDescription(description)
        
        // invalid profile parameters
        let invalidParameters = ["Hello": "World"]
        
        // update invalid profile parameters
        service.updateProfile(dialogID, clientID: clientID,
            parameters: invalidParameters) { error in
            
            // verify expected response
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
}