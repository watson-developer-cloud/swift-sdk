//
//  TextToSpeechTests.swift
//  TextToSpeechTests
//
//  Created by Karl Weinmeister on 11/7/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import XCTest
import TextToSpeech
@testable import TextToSpeech

class TextToSpeechTests: XCTestCase {
    
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
       // let service = TextToSpeech()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let service = TextToSpeech()
        service.synthesize("Hello there!")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
