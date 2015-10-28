//
//  LanguageTranslationTests.swift
//  LanguageTranslationTests
//
//  Created by Karl Weinmeister on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import XCTest
@testable import LanguageTranslation

class LanguageTranslationTests: XCTestCase {
    /// Language translation service
    private let service = LanguageTranslation()
    
    /// Timeout for an asynchronous call to return before failing the unit test
    private let timeout: NSTimeInterval = 60.0
    
    override func setUp() {
        super.setUp()
        if let url = NSBundle(forClass: self.dynamicType).URLForResource("Test", withExtension: "plist") {
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
    
    func testIdentifiableLanguages() {
        let expectation = expectationWithDescription("Identifiable Languages")
        
        service.getIdentifiableLanguages({(languages:[IdentifiableLanguage]?) in
            XCTAssertNotNil(languages,"Expected non-nil array of identifiable languages to be returned")
            XCTAssertGreaterThan(languages!.count,0,"Expected at least 1 identifiable language to be returned")
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    func testIdentify() {
        let emptyExpectation = expectationWithDescription("Empty")
        let validExpectation = expectationWithDescription("Valid")
        
        service.identify("", callback:{(languages:[IdentifiedLanguage]) in
            XCTAssertEqual(0,languages.count, "Expected empty result when passing in an empty string to identify()")
            emptyExpectation.fulfill()
        })
        
        service.identify("hola", callback:{(languages:[IdentifiedLanguage]) in
            if let firstLanguage = languages.first {
                XCTAssertEqual(firstLanguage.language,"es", "Expected 'hola' to be identified as 'es' language")
            }
            else {
                XCTFail("Identified languages returned empty array")
            }
            validExpectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    func testTranslation() {
        let sourceTargetExpectation = expectationWithDescription("Source and Target Translation")
        let modelExpectation = expectationWithDescription("Model Translation")
        
        service.translate(["Hello","House"],source:"en",target:"es",callback:{(text:[String]) in
            if text.isEmpty {
                XCTFail("Expected non-empty array to be returned")
                return
            }
            XCTAssertEqual(text.first!,"Hola","Expected hello to translate to hola")
            XCTAssertEqual(text.last!,"Casa","Expected house to translate to casa")
            sourceTargetExpectation.fulfill()
        })
        
        service.translate(["Hello"],modelID:"en-es",callback:{(text:[String]) in
            if text.isEmpty {
                XCTFail("Expected non-empty array to be returned")
                return
            }
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
        let deleteExpectation = self.expectationWithDescription("Delete model")
        
        let fileURL = NSBundle(forClass: self.dynamicType).URLForResource("glossary", withExtension: "tmx")
        print("URL: " + fileURL!.URLString)
        XCTAssertNotNil(fileURL)
        
        service.createModel("en-es", name: "custom-english-to-spanish", fileKey: "forced_glossary", fileURL: fileURL!, callback:{(model:TranslationModel?) in
            guard let model = model else {
                XCTFail("Expected non-nil model to be returned")
//                deleteExpectation.fulfill()
                return
            }
            
            //Delete model after creating it
            self.service.deleteModel(model.modelID!, callback:{response in
                deleteExpectation.fulfill()
            })
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    func testDeleteModel() {
        let unauthorizedDeleteExpectation = expectationWithDescription("Unauthorized expectation")
        let missingDeleteExpectation = expectationWithDescription("Missing delete expectation")
        
        service.deleteModel("en-es", callback:{(modelDeleted:Bool?) in
            XCTAssertFalse(modelDeleted!,"Expected unauthorized exception when trying to delete an IBM model")
            unauthorizedDeleteExpectation.fulfill()
        })
        
        service.deleteModel("qwerty", callback:{(modelDeleted:Bool?) in
            XCTAssertFalse(modelDeleted!,"Expected missing delete exception when trying to delete a nonexistent model")
            missingDeleteExpectation.fulfill()
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
            guard let model = model else {
                XCTFail("Expected non-nil model to be returned")
                return
            }
            XCTAssertEqual(model.modelID,"en-es","Expected to get en-es model")
            expectation2.fulfill()
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
}