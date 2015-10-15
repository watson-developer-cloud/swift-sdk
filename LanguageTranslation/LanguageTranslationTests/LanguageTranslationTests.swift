//
//  LanguageTranslationTests.swift
//  LanguageTranslationTests
//
//  Created by Karl Weinmeister on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import XCTest
import UIKit
@testable import LanguageTranslation

class LanguageTranslationTests: XCTestCase {
    
    private let timeout = 60.0
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
    
    func testIdentifiableLanguagesNEW() {
        let expectation = expectationWithDescription("Identifiable Languages")
        
        service.getIdentifiableLanguagesNew({(languages:[Language]?) in
            XCTAssertNotNil(languages,"Expected non-nil array of identifiable languages to be returned")
            XCTAssertGreaterThan(languages!.count,0,"Expected at least 1 identifiable language to be returned")
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    func testIdentifiableLanguages() {
        let expectation = expectationWithDescription("Identifiable Languages")
        
        service.getIdentifiableLanguages({(languages:[Language]?) in
            XCTAssertNotNil(languages,"Expected non-nil array of identifiable languages to be returned")
            XCTAssertGreaterThan(languages!.count,0,"Expected at least 1 identifiable language to be returned")
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    func testIdentify() {
        let nilExpectation = expectationWithDescription("Nil")
        let validExpectation = expectationWithDescription("Valid")
        
        service.identify("", callback:{(language:String?) in
            XCTAssertNil(language, "Expected nil result when passing in an empty string to identify()")
            nilExpectation.fulfill()
        })
        
        service.identify("hola", callback:{(language:String?) in
            XCTAssertEqual(language!,"es","Expected 'hola' to be identified as 'es' language")
            validExpectation.fulfill()
        })

        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    func testTranslation() {
        let expectation = expectationWithDescription("Translation")

        service.translate(["Hello"],source:"en",target:"es",callback:{(text:[String]?) in
            XCTAssertEqual(text!.first!,"Hola","Expected hello to translate to Hola")
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }

    func testGetModels() {
        let expectation = expectationWithDescription("Get Models")
        
        service.getModels(callback:{(models:[TranslationModel?]?) in
            XCTAssertGreaterThan(models!.count,0,"Expected at least 1 model to be returned")
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }

    
//    func testCreateModel() {
////        let expectation1 = expectationWithDescription("Invalid parameters")
//        let expectation2 = expectationWithDescription("Valid parameters")
//        
////        service.createModel("blah", name: "blah", forcedGlossaryPath: "blah", callback:{(modelID:String?) in
////            XCTAssertNil(modelID,"Expected no model to be return for invalid parameters")
////            expectation1.fulfill()
////        })
//
//        let path = "/users/kweinmeister/Documents/Xcode/Watson-iOS-SDK/LanguageTranslation/LanguageTranslationTests/glossary.tmx"
//        service.createModel("en-es", name: "custom-english-to-spanish", forcedGlossaryPath: path, callback:{(modelID:String?) in
//            XCTAssertNotNil(modelID, "Model ID returned by create model should not be nil")
//            expectation2.fulfill()
//        })
//
//        
//        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
//    }
    
    
    func testGetModel() {
        let expectation1 = expectationWithDescription("Missing model")
        let expectation2 = expectationWithDescription("Valid model")

        service.getModel("MISSING_MODEL_ID", callback:{(model:TranslationModel?) in
            XCTAssertNil(model,"Expected no model to be return for invalid id")
            expectation1.fulfill()
        })

        service.getModel("en-es", callback:{(model:TranslationModel?) in
            XCTAssertEqual(model!.modelID,"en-es","Expected to get en-es model")
            expectation2.fulfill()
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    
}
