/************************************************************************/
/*                                                                      */
/* IBM Confidential                                                     */
/* OCO Source Materials                                                 */
/*                                                                      */
/* (C) Copyright IBM Corp. 2001, 2016                                   */
/*                                                                      */
/* The source code for this program is not published or otherwise       */
/* divested of its trade secrets, irrespective of what has been         */
/* deposited with the U.S. Copyright Office.                            */
/*                                                                      */
/************************************************************************/

import XCTest
import WatsonDeveloperCloud

class ConversationHelperTests: XCTestCase {
    let timeout: NSTimeInterval = 30.0
    let serviceURL = "http://wea-orchestratorv2.mybluemix.net/conversation"
    let workspaceID = "pizza"
    let username = "username"
    let password = "password"
    let ttsUser = "e08066f7-a27f-4732-8d10-ac7895d0a9b4"
    let ttsPassword = "bXNBDOHvKUXE"
    let sttUser = "551a4699-afd9-4552-8ced-2eaf4ab096fb"
    let sttPassword = "MMXJ9hA0Ryfg"
    
    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
    }
    
    func waitForExpectations() {
        waitForExpectationsWithTimeout(timeout) { error in
            XCTAssertNil(error, "Timeout.")
        }
    }
    
    func testSendText() {
        let description = "Send a text message."
        let expectation = expectationWithDescription(description)
        
        let conversationBuilder = ConversationBuilder()
        conversationBuilder.dialogPath(serviceURL, workspaceId: workspaceID)
        conversationBuilder.dialogCredentials(username, password: password)
        let conversation = conversationBuilder.build()
        
        let message = "Hello?"
        
        conversation.sendText(message) { response, error in
            XCTAssert(response != nil)
            XCTAssertNil(error)
            
            /*XCTAssertNotNil(response?.intents)
             XCTAssertGreaterThan(response!.intents!.count, 0)
             response!.intents!.forEach { intent in
             XCTAssertNotNil(intent.intentID)
             XCTAssertNotNil(intent.confidence)
             XCTAssertGreaterThanOrEqual(intent.confidence!, 0.0)
             XCTAssertLessThanOrEqual(intent.confidence!, 1.0)
             }
             
             XCTAssertNotNil(response?.entities)
             XCTAssertGreaterThan(response!.entities!.count, 0)
             response!.entities?.forEach { entity in
             XCTAssertNotNil(entity.entityID)
             XCTAssertNotNil(entity.value)
             XCTAssertNotNil(entity.location)
             XCTAssertGreaterThan(entity.location!.count, 0)
             }*/
            
            XCTAssertNotNil(response?.output)
            let expectedResponse = "Hi, my name is Watson."
            
            var output = self.parseResponse(response!)
            XCTAssertEqual(output[0], expectedResponse)
            
            /*XCTAssertNotNil(response?.tags)
             XCTAssertGreaterThan(response!.tags!.count, 0)*/
            
            XCTAssertNotNil(response?.context)
            XCTAssertGreaterThan(response!.context!.count, 0)
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testSendTextWithContext() {
        let description = "Send a text message."
        let expectation = expectationWithDescription(description)
        
        var context = [String:String]()
        context["conversation_id"] = "956a6211-dcb3-4257-8dff-fc047826b3bb"
        
        //let conversation = Conversation(serviceURL: serviceURL, workspaceID: workspaceID, username: username, password: password, ttsUser: ttsUser, ttsPassword: ttsPassword)
        let conversationBuilder = ConversationBuilder()
        conversationBuilder.dialogPath(serviceURL, workspaceId: workspaceID)
        conversationBuilder.dialogCredentials(username, password: password)
        let conversation = conversationBuilder.build()
        
        let message = "Hello?"
        
        conversation.sendText(message, context: context) { response, error in
            XCTAssert(response != nil)
            XCTAssertNil(error)
            
            /*XCTAssertNotNil(response?.intents)
             XCTAssertGreaterThan(response!.intents!.count, 0)
             response!.intents!.forEach { intent in
             XCTAssertNotNil(intent.intentID)
             XCTAssertNotNil(intent.confidence)
             XCTAssertGreaterThanOrEqual(intent.confidence!, 0.0)
             XCTAssertLessThanOrEqual(intent.confidence!, 1.0)
             }
             
             XCTAssertNotNil(response?.entities)
             XCTAssertGreaterThan(response!.entities!.count, 0)
             response!.entities?.forEach { entity in
             XCTAssertNotNil(entity.entityID)
             XCTAssertNotNil(entity.value)
             XCTAssertNotNil(entity.location)
             XCTAssertGreaterThan(entity.location!.count, 0)
             }*/
            
            XCTAssertNotNil(response?.output)
            let expectedResponse = "Hi, how are you today?"
            
            var output = self.parseResponse(response!)
            XCTAssertEqual(output[0], expectedResponse)
            
            /*XCTAssertNotNil(response?.tags)
             XCTAssertGreaterThan(response!.tags!.count, 0)*/
            
            XCTAssertGreaterThan(response!.context!.count, 0)
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testErrorOnNonexistantPath() {
        let description = "Should return 404 when path doesn't exist."
        let expectation = expectationWithDescription(description)
        
        //let conversation = Conversation(serviceURL: serviceURL, workspaceID: "pizza/cow",
        //    username: username, password: password, ttsUser: ttsUser, ttsPassword: ttsPassword)
        let conversationBuilder = ConversationBuilder()
        conversationBuilder.dialogPath(serviceURL, workspaceId: "pizza/cow")
        conversationBuilder.dialogCredentials(username, password: password)
        let conversation = conversationBuilder.build()
        
        let message = "Hello?"
        
        conversation.sendText(message) { response, error in
            XCTAssertNotNil(error)
            XCTAssertNotNil(error?.userInfo[404])
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testTextConversation() {
        // test back-and-forth with the service
        // be sure to modify context (context/tags) between a response and subsequent request
    }
    
    func testCustomAuthStrategy() {
        let description = "Send a text message."
        let expectation = expectationWithDescription(description)
        
        let myAuth = BasicAuthenticationStrategy(
            tokenURL   : serviceURL,
            serviceURL : serviceURL,
            username   : username,
            password   : password)
        
        let conversationBuilder = ConversationBuilder()
        conversationBuilder.dialogPath(serviceURL, workspaceId: workspaceID)
        conversationBuilder.dialogAuthenticationStrategy(myAuth)
        let conversation = conversationBuilder.build()
        
        let message = "Hello?"
        
        conversation.sendText(message) { response, error in
            XCTAssert(response != nil)
            XCTAssertNil(error)
            
            XCTAssertNotNil(response?.output)
            let expectedResponse = "Hi, my name is Watson."
            
            var output = self.parseResponse(response!)
            XCTAssertEqual(output[0], expectedResponse)
            
            XCTAssertNotNil(response?.context)
            XCTAssertGreaterThan(response!.context!.count, 0)
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testDiscreteVoice() {
        let description = "Should return the text of an audio file"
        let expectation = expectationWithDescription(description)
        
        let conversationBuilder = ConversationBuilder()
        conversationBuilder.sttCredentials(sttUser, password: sttPassword)
        let conversation = conversationBuilder.build()
        
        let bundle = NSBundle(forClass: self.dynamicType)
        guard let file = bundle.URLForResource("WhereIsThePool", withExtension: "wav") else {
            XCTFail("Unable to locate file")
            return
        }
        
        let failure = { (error: NSError) in
            XCTFail("An error has occurred: \(error)")
        }
        
        let sttOptions = SpeechToTextOptions.init(contentType: SpeechToTextOptions.AudioType.WAV)
        
        conversation.sendVoiceDiscrete(file, settings: sttOptions, failureHandler: failure) { results in
            let lastResult = results.lastObject as! ConversationSpeechToTextResultWrapper
            if lastResult.final == true {
                XCTAssertEqual(lastResult.alternatives[0].transcript, "where is the pool ")
                expectation.fulfill()
            }
            
        }
        waitForExpectations()
    }
    
    func testSynthesize() {
        let description = "Should return an audio synthesization of the submitted text"
        let expectation = expectationWithDescription(description)
        
        //let conversation = Conversation(serviceURL: serviceURL, workspaceID: "pizza", username: username, password: password, ttsUser: ttsUser, ttsPassword: ttsPassword)
        
        let conversationBuilder = ConversationBuilder()
        conversationBuilder.ttsCredentials(ttsUser, password: ttsPassword)
        let conversation = conversationBuilder.build()
        
        let message = "Where is the pool?"
        
        conversation.synthesizeText(message) { data, error in
            XCTAssert(data != nil)
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testSendTextPerformance() {
        self.measureBlock { self.testSendText() }
    }
    
    /*func testSendDiscreteVoicePerformance() {
     self.measureBlock { self.testDiscreteVoice() }
     }*/
    
    func testSynthesizePerformance() {
        self.measureBlock { self.testSynthesize() }
    }
    
    func testTextConversationPerformance() {
        self.measureBlock { self.testTextConversation() }
    }
    
    // helper function to parse the output structure from the wea response
    func parseResponse(weaResponse:WEAResponse)->[String] {
        var output:[String] = []
        var response:[String:AnyObject] = weaResponse.output!["response"] as! [String : AnyObject]
        let responses:[[String:AnyObject]] = response["responses"] as! [[String:AnyObject]]
        
        for responseMap in responses {
            output.append(responseMap["text"] as! String)
        }
        
        return output;
    }
}
