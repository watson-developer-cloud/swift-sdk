//
//  SpeechToTextTests.swift
//  SpeechToTextTests
//
//  Created by Glenn Fisher on 11/6/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import XCTest
@testable import SpeechToText

class SpeechToTextTests: XCTestCase {
    
    /// Timeout for an asynchronous call to return before failing the unit test
    private let timeout: NSTimeInterval = 60.0
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testWebsockets() {
        let expectation = expectationWithDescription("WebSockets")
        let service = SpeechToText(username: "***REMOVED***", password: "***REMOVED***")
        service.transcribe(NSBundle(forClass: self.dynamicType).URLForResource("SpeechSample", withExtension: "flac")!) {
            transcription in
            expectation.fulfill()
        }
        // sleep(2)
        waitForExpectationsWithTimeout(timeout) {
            error in XCTAssertNil(error, "Timeout")
        }
    }
    
}
