//
//  TextToSpeechTests.swift
//  TextToSpeechTests
//
//  Created by Karl Weinmeister on 11/7/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import XCTest

@testable import WatsonSDK

class TextToSpeechTests: XCTestCase {
    
    // Text to Speech Service
    private let service = TextToSpeech()
    private let audioEngine = AVAudioEngine()
    
    /// Timeout for an asynchronous call to return before failing the unit test
    private let timeout: NSTimeInterval = 20.0
    
    override func setUp() {
        super.setUp()
        if let url = NSBundle(forClass: self.dynamicType).pathForResource("Credentials", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: url) as? Dictionary<String, String> {
                service.setUsernameAndPassword(dict["TextToSpeechUsername"]!, password: dict["TextToSpeechPassword"]!)
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
      
        let voicesExpectation = expectationWithDescription("Get Voices")
        
        service.listVoices({
            voices, error in
            
            XCTAssertGreaterThan(voices.count, 6, "Expected at least 6 voices to be returned");
            
            voicesExpectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testSynthesize() {
        
        let synthExpectation = expectationWithDescription("Synthesize Audio")
        
        let testString = "All the problems of the world could be solved if men were only willing to think."
        
        service.synthesize(testString, oncompletion: {
            data, error in
            
                XCTAssertNotNil(data)
                XCTAssertGreaterThan(data!.length, 100, "Expecting the decompressed audio to be more than 100 bytes")
            
                synthExpectation.fulfill()
                
                // service.playAudio(engine, data: data)
           
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testSynthAndPlay() {
        
        let playExpectation = expectationWithDescription("Synthesize Audio")
        
        let testString = "All the problems of the world could be solved if men were only willing to think."
        
        service.synthesize(testString, oncompletion: {
            data, error in
            
            if let data = data {
            self.service.playAudio(self.audioEngine, data: data,
                oncompletion:
                {
                    error in
                    
                    playExpectation.fulfill()
            
                })
            }
            
            
            // service.playAudio(engine, data: data)
            
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
