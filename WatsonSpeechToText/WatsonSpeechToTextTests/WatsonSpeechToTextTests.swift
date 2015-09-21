//
//  WatsonSpeechToTextTests.swift
//  WatsonSpeechToTextTests
//
//  Created by Glenn R. Fisher on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import XCTest
@testable import WatsonSpeechToText

class WatsonSpeechToTextTests: XCTestCase {
    
    // todo: remove authentication credentials
    private let stt = WatsonSpeechToText(username: "004db54a-c5e0-472b-a6eb-7b106fd31370", password: "o55eeuCST9YU")
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
    
    /**
    Test WatsonSpeechToText by ensuring that transcribeFile() does not return a nil transcription string for a known audio file.
    */
    func testTranscribeFileForNonNilResults() {
        
        let expectation = expectationWithDescription("Testing WatsonSpeechToText.transcribeFile() to ensure non-nil results.")
        
        let file = NSBundle(forClass: self.dynamicType).URLForResource("SpeechSample", withExtension: "flac")
        stt.transcribeFile(file!) {
            transcription, error in
            XCTAssertNotNil(transcription, "Transcription is null.")
            XCTAssertNil(error, "Error is not null.")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(timeout) {
            error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
    /**
    Test WatsonSpeechToText by ensuring that transcribeFile() returns the expected transcription for a known audio file.
    */
    func testTranscribeFileForTranscription() {
        
        let expectation = expectationWithDescription("Testing WatsonSpeechToText.transcribeFile() to ensure matching transcription with sample file.")

        let file = NSBundle(forClass: self.dynamicType).URLForResource("SpeechSample", withExtension: "flac")
        stt.transcribeFile(file!) {
            transcription, error in
            
            XCTAssertNotNil(transcription, "Transcription is nil.")
            XCTAssertNil(error, "Error is not nil.")
            
            guard let transcription = transcription else {
                expectation.fulfill()
                return
            }
            
            let match = (transcription == "several tornadoes touch down as a line of severe thunderstorms swept through Colorado on Sunday ")
            XCTAssert(match, "Transcription result does not match expectation.")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(timeout) {
            error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
    /**
    Test WatsonSpeechToText by ensuring that transcribeData() does not return a nil transcription string for known audio data.
    */
    func testTranscribeDataForNonNilResults() {
        
        let expectation = expectationWithDescription("Testing WatsonSpeechToText.transcribeData() to ensure non-nil results.")
        
        let file = NSBundle(forClass: self.dynamicType).URLForResource("SpeechSample", withExtension: "flac")
        let data = NSData(contentsOfURL: file!)!
        stt.transcribeData(data, contentType: "audio/flac") {
            transcription, error in
            XCTAssertNotNil(transcription, "Transcription is nil.")
            XCTAssertNil(error, "Error is not nil.")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(timeout) {
            error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
    /**
    Test WatsonSpeechToText by ensuring that transcribeData() returns the expected transcription for known audio data.
    */
    func testTranscribeDataForTranscription() {
        
        let expectation = expectationWithDescription("Testing WatsonSpeechToText.transcribeData() to ensure matching transcription with sample audio data.")
        
        let file = NSBundle(forClass: self.dynamicType).URLForResource("SpeechSample", withExtension: "flac")
        let data = NSData(contentsOfURL: file!)!
        stt.transcribeData(data, contentType: "audio/flac") {
            transcription, error in
            
            XCTAssertNotNil(transcription, "Transcription is nil.")
            XCTAssertNil(error, "Error is not nil.")
            
            guard let transcription = transcription else {
                expectation.fulfill()
                return
            }
            
            let match = (transcription == "several tornadoes touch down as a line of severe thunderstorms swept through Colorado on Sunday ")
            XCTAssert(match, "Transcription result does not match expectation.")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(timeout) {
            error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
}
