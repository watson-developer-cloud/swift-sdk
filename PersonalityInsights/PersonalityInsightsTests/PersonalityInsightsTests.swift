//
//  PersonalityInsightsTests.swift
//  PersonalityInsightsTests
//
//  Created by Karl Weinmeister on 10/27/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import XCTest
@testable import PersonalityInsights

class PersonalityInsightsTests: XCTestCase {
    
    /// Language translation service
    private let service = PersonalityInsights()
    private var inputText:String?
    /// Timeout for an asynchronous call to return before failing the unit test
    private let timeout: NSTimeInterval = 30.0
    
    override func setUp() {
        super.setUp()
        if let url = NSBundle(forClass: self.dynamicType).URLForResource("PersonalityInsightsTests", withExtension: "plist") {
            if let dict = NSDictionary(contentsOfURL: url) as? Dictionary<String, String> {
                service.setUsernameAndPassword(dict["Username"]!, password: dict["Password"]!)
                inputText=dict["Input Text"]
            } else {
                XCTFail("Unable to extract dictionary from plist")
            }
        } else {
            XCTFail("Plist file not found")
        }
    }
    
    func testProfile() {
        let notEnoughWords = expectationWithDescription("NotEnoughWords")
        let valid = expectationWithDescription("Valid")
        
        let text = "Call me Ishmael. Some years ago-never mind how long precisely-having little or no money in my purse, and nothing particular to interest me on shore, I thought I would sail about a little and see the watery part of the world. It is a way I have of driving off the spleen and regulating the circulation. Whenever I find myself growing grim about the mouth; whenever it is a damp, drizzly November in my soul; whenever I find myself involuntarily pausing before coffin warehouses, and bringing up the rear of every funeral I meet; and especially whenever my hypos get such an upper hand of me, that it requires a strong moral principle to prevent me from deliberately stepping into the street, and methodically knocking people's hats off-then, I account it high time to get to sea as soon as I can."
        
        service.getProfile(text, callback:{(profile:Profile?) in
            notEnoughWords.fulfill()
        })

        service.getProfile(inputText!, callback:{(profile:Profile?) in
            valid.fulfill()
        })
        
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
}
