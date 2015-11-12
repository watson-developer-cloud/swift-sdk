//
//  TextToSpeechTests.swift
//  TextToSpeechTests
//
//  Created by Karl Weinmeister on 11/7/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import XCTest

@testable import TextToSpeech

class TextToSpeechTests: XCTestCase {
    
    // Text to Speech Service
    private let service = TextToSpeech()
    
    /// Timeout for an asynchronous call to return before failing the unit test
    private let timeout: NSTimeInterval = 60.0
    
    override func setUp() {
        super.setUp()
        if let url = NSBundle(forClass: self.dynamicType).URLForResource("TTSTestAuth", withExtension: "plist") {
            if let dict = NSDictionary(contentsOfURL: url) as? Dictionary<String, String> {
                service.setUsernameAndPassword(dict["Username"]!, password: dict["Password"]!)
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
    
    func testListLanguages() {
      
        let expectation = expectationWithDescription("Get Voices")
        
        service.listVoices({
            voices, error in
            
            print(voices)
            
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testSynthesize() {
        
        
        service.synthesize("Hello there!", oncompletion: {
            data, error in
                // service.playAudio(engine, data: data)
           
        })
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
