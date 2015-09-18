//
//  WatsonTextToSpeechTests.swift
//  WatsonTextToSpeechTests
//
//  Created by Robert Dickerson on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import XCTest
@testable import WatsonTextToSpeech

class WatsonTextToSpeechTests: XCTestCase {
    
    private let timeout = 300.0
    private var service : WatsonTextToSpeechService = WatsonTextToSpeechService(username:"76b77f2f-a0ea-49a7-ad34-53b5636326ec",password:"ggzipaZ7L3o0")

    
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
        //self.measureBlock {
            // Put the code you want to measure the time of here.
        //}
    }
    
    //
    func testSay() {
        
        let voice = service.getDefaultVoice()
        voice.say("Hello", completion: {
            error in
                XCTAssertNil(error)
        })
        
    }
    
    func testSayDid() {
        
        let voice = service.getDefaultVoice()
        voice.say("Hello")

    }
    
    func testPrepareToSay() {
        
        let voice = service.getDefaultVoice()
        voice.prepareToSay("Hello")
        
    }
    
    func testGetGermanVoice() {
        
        let voice = service.getVoiceByType( .Male, language: .German)
        voice.say( "Guten Tag")
        
    }
    
}
