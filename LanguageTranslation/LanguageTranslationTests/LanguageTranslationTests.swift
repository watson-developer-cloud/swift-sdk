//
//  LanguageTranslationSDKTests.swift
//  LanguageTranslationSDKTests
//
//  Created by Karl Weinmeister on 9/3/15.
//  Copyright (c) 2015 IBM MIL. All rights reserved.
//

import UIKit
import XCTest
import LanguageTranslation

//TODO: Add test cases for auth issues

class LanguageTranslationTests: XCTestCase {
    private let timeout = 15.0
    //TODO: Move credentials to plist temporarily
    //TODO: Before release, change credentials to use <insert-username-here>
    private var service : LanguageTranslation = LanguageTranslation(username:"5aa00deb-96c9-4606-9765-5f590912f3ee",password:"eXUSONytMoDy")

    func testIdentifiableLanguages() {
        let expectation = expectationWithDescription("Identifiable Languages")

        service.getIdentifiableLanguages({(languages:[Language]) in
            XCTAssertEqual(languages.count,62,"Expected 62 identifiable languages")
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }

    //TODO: Test case currently failing due to error "no text being passed in" - need to investigate
    func testTranslation() {
        //TODO: Add additional test cases for missing inputs, wrong languages, etc.
        let expectation = expectationWithDescription("Translation")
        
        service.translate("Hello",sourceLanguage:"en",targetLanguage:"es",callback:{(textResult:[String]?) in
            if let text = textResult {
                if (text.isEmpty) {
                    XCTAssertFalse(text.isEmpty,"Expected at least 1 translated string")
                }
                else {
                    let translatedText = text.first!
                    XCTAssertEqual(translatedText,"hola","Expected hello to translate to hola")
                }
            }
            else {
                XCTAssertNotNil(textResult,"Expected non-nil translated text array")
            }
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
 
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
