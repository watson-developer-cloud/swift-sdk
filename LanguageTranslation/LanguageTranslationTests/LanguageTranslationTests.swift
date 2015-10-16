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
    
    func testIdentifiableLanguages() {
        let expectation = expectationWithDescription("Identifiable Languages")
        
        service.getIdentifiableLanguages({(languages:[Language]?) in
            XCTAssertNotNil(languages,"Expected non-nil array of identifiable languages to be returned")
            XCTAssertGreaterThan(languages!.count,0,"Expected at least 1 identifiable language to be returned")
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
//    func testIdentify() {
//        let nilExpectation = expectationWithDescription("Nil")
//        let validExpectation = expectationWithDescription("Valid")
//        
//        service.identify("", callback:{(language:String?) in
//            XCTAssertNil(language, "Expected nil result when passing in an empty string to identify()")
//            nilExpectation.fulfill()
//        })
//        
//        service.identify("hola", callback:{(language:String?) in
//            XCTAssertEqual(language!,"es","Expected 'hola' to be identified as 'es' language")
//            validExpectation.fulfill()
//        })
//
//        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
//    }
    
    func testTranslation() {
        let sourceTargetExpectation = expectationWithDescription("Source and Target Translation")
        let modelExpectation = expectationWithDescription("Model Translation")

        service.translate(["Hello"],source:"en",target:"es",callback:{(text:[String]) in
            XCTAssertEqual(text.first!,"Hola","Expected hello to translate to Hola")
            sourceTargetExpectation.fulfill()
        })

        service.translate(["Hello"],modelID:"en-es",callback:{(text:[String]) in
            XCTAssertEqual(text.first!,"Hola","Expected hello to translate to Hola")
            modelExpectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }

    func testGetModels() {
        let allExpectation = expectationWithDescription("Get All Models")
        let sourceExpectation = expectationWithDescription("Get Models by Source")
        let targetExpectation = expectationWithDescription("Get Models by Target")
        let defaultModelExpectation = expectationWithDescription("Get Models by Default")
        
        service.getModels(callback:{(models:[TranslationModel]) in
            XCTAssertGreaterThan(models.count,0,"Expected at least 1 model to be returned")
            allExpectation.fulfill()
        })

        service.getModels("es", callback:{(models:[TranslationModel]) in
            XCTAssertEqual(models.count,3,"Expected exactly 3 models to be returned")
            sourceExpectation.fulfill()
        })

        service.getModels(target:"pt", callback:{(models:[TranslationModel]) in
            XCTAssertEqual(models.count,2,"Expected exactly 2 models to be returned")
            targetExpectation.fulfill()
        })
        
        
        service.getModels(defaultModel:true, callback:{(models:[TranslationModel]) in
            XCTAssertEqual(models.count,8,"Expected exactly 8 models to be returned")
            defaultModelExpectation.fulfill()
        })

        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }

    
    func testCreateModel() {
        let expectation2 = expectationWithDescription("Valid parameters")

        let testBundle = NSBundle(forClass: self.dynamicType)
        let fileURL = testBundle.URLForResource("glossary", withExtension: "tmx")
        XCTAssertNotNil(fileURL)

        service.createModel("en-es", name: "custom-english-to-spanish", fileKey: "forced_glossary", fileURL: fileURL!, callback:{ response in
            //XCTAssertNotNil(modelID, "Model ID returned by create model should not be nil")
            expectation2.fulfill()
        })

        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    
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
