//
//  SpeechToTextTests.swift
//  SpeechToTextTests
//
//  Created by Glenn Fisher on 11/6/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import XCTest
@testable import WatsonSDK

class SpeechToTextTests: XCTestCase {
    
    private let service = SpeechToText()
    private var inputText: String?
    private let timeout: NSTimeInterval = 30.0
    
    override func setUp() {
        super.setUp()
        if let url = NSBundle(forClass: self.dynamicType).pathForResource("Credentials", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: url) as? Dictionary<String, String> {
                service.setUsernameAndPassword(dict["SpeechToTextUsername"]!, password: dict["SpeechToTextPassword"]!)
            } else {
                XCTFail("Unable to extract dictionary from plist")
            }
        } else {
            XCTFail("Plist file not found")
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWebsockets() {
        let expectation = expectationWithDescription("WebSockets")
        service.transcribe(NSBundle(forClass: self.dynamicType).URLForResource("SpeechSample", withExtension: "flac")!) {
            transcription in
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(timeout) {
            error in XCTAssertNil(error, "Timeout")
        }
    }
    
}
