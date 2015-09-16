//
//  WatsonLanguageTranslationTests.swift
//  WatsonLanguageTranslationTests
//
//  Created by Glenn Fisher on 9/16/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import XCTest
@testable import WatsonLanguageTranslation

class WatsonLanguageTranslationTests: XCTestCase {
    
    private let timeout = 300.0
    //TODO: Move credentials to plist temporarily
    //TODO: Before release, change credentials to use <insert-username-here>
    private var service : LanguageTranslation = LanguageTranslation(username:"5aa00deb-96c9-4606-9765-5f590912f3ee",password:"eXUSONytMoDy")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIdentifiableLanguages() {
        let expectation = expectationWithDescription("Identifiable Languages")
        
        service.getIdentifiableLanguages({(languages:[Language]) in
            XCTAssertEqual(languages.count,62,"Expected 62 identifiable languages")
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    func testIdentify() {
        let expectation = expectationWithDescription("Identify")
        
        service.identify("hola", callback:{(language:String?) in
            if let lang = language {
                XCTAssertEqual(lang,"es","Expected 'hola' to be identified as 'es' language")
                expectation.fulfill()
            } else { XCTAssertNotNil(language, "Expected valid language result") }
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
                    XCTAssertEqual(translatedText,"Hola","Expected hello to translate to Hola")
                }
            }
            else {
                XCTAssertNotNil(textResult,"Expected non-nil translated text array")
            }
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
}
