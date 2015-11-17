//
//  DialogTests.swift
//  DialogTests
//
//  Created by Jonathan Ballands on 11/9/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import XCTest
@testable import WatsonSDK

class DialogTests: XCTestCase {
    
    /*
     *  MARK: Properties
     */
    
    private let testService = DialogService()
    
    private let timeout: NSTimeInterval = 60.0
    
    private var dialogId: String?
    
    /*
     *  MARK: Lifecycle
     */
    
    override func setUp() {
        super.setUp()
        
        if let url = NSBundle(forClass: self.dynamicType).pathForResource("Credentials", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: url) as? Dictionary<String, String> {
                self.testService.setUsernameAndPassword(dict["DialogUsername"]!, password: dict["DialogPassword"]!)
                self.dialogId = dict["DialogID"]
            } else {
                XCTFail("Unable to extract dictionary from plist")
            }
        } else {
            XCTFail("Plist file not found")
        }

    }
    
    /*
     *  MARK: Tests
     */
    
    func testConverse() {
        
        guard let dId = self.dialogId else {
            XCTFail("There was no dialogId")
            return
        }
        
        var conversationId: Int? = nil
        var clientId: Int? = nil
        
        let expectation1 = expectationWithDescription("Converse")
        
        testService.converse(dId, callback: {(conversation: Conversation?) in
            
            XCTAssertNotNil(conversation)
            XCTAssertEqual(conversation?.confidence, 0)
            XCTAssertEqual(conversation?.input, "")
            XCTAssertEqual(conversation?.response?.count, 1)
            XCTAssertEqual(conversation?.response?[0], "Hello, I'm willow, how are you today?")
            
            clientId = conversation?.clientId
            conversationId = conversation?.conversationId
            
            expectation1.fulfill()
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
        let expectation2 = expectationWithDescription("Converse")
        
        testService.converse(dId, input: "What type of furniture is there?", clientId: clientId, conversationId: conversationId, callback: {(conversation: Conversation?) in
            
            XCTAssertNotNil(conversation)
            XCTAssertEqual(conversation?.confidence, 0)
            XCTAssertEqual(conversation?.input, "What type of furniture is there?")
            XCTAssertEqual(conversation?.response?.count, 1)
            XCTAssertEqual(conversation?.response?[0], "We have Tables and Vases")
            
            clientId = conversation?.clientId
            conversationId = conversation?.conversationId
            
            expectation2.fulfill()
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
}
