/**
 * Copyright IBM Corporation 2015
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import XCTest
@testable import WatsonDeveloperCloud

class LanguageTranslationTests: XCTestCase {
    /// Language translation service
    private var service: LanguageTranslation!
    
    /// Timeout for an asynchronous call to return before failing the unit test
    private let timeout: NSTimeInterval = 60.0
    
    override func setUp() {
        super.setUp()
        if let url = NSBundle(forClass: self.dynamicType).pathForResource("Credentials", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: url) as? Dictionary<String, String> {
                    let username = dict["LanguageTranslationUsername"]!
                    let password = dict["LanguageTranslationPassword"]!
                    if service == nil {
                        service = LanguageTranslation(username: username, password: password)
                    }
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
        
          service.getIdentifiableLanguages({(languages:[LanguageTranslation.IdentifiableLanguage]?, error) in
            XCTAssertNotNil(languages,"Expected non-nil array of identifiable languages to be returned")
            XCTAssertGreaterThan(languages!.count,0,"Expected at least 1 identifiable language to be returned")
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    func testIdentify() {
        let emptyExpectation = expectationWithDescription("Empty")
        let validExpectation = expectationWithDescription("Valid")
        
        service.identify("") { languages, error in
            XCTAssertNil(languages, "Expected empty result when passing in an empty string to identify()")
            emptyExpectation.fulfill()
        }
        
        service.identify("hola") { languages, error in
            if let firstLanguage = languages?.first {
                XCTAssertEqual(firstLanguage.language,"es", "Expected 'hola' to be identified as 'es' language")
            }
            else {
                XCTFail("Identified languages returned empty array")
            }
            validExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    func testTranslation() {
        let sourceTargetExpectation = expectationWithDescription("Source and Target Translation")
        let modelExpectation = expectationWithDescription("Model Translation")
        
        service.translate(["Hello","House"],source:"en",target:"es") { text, error in
            
            XCTAssertNotNil(text, "Expected non-empty array to be returned")
            XCTAssertEqual(text!.first!,"Hola","Expected hello to translate to hola")
            XCTAssertEqual(text!.last!,"Casa","Expected house to translate to casa")
            sourceTargetExpectation.fulfill()
        }
        
        service.translate(["Hello"],modelID:"en-es") { text, error in
            
            XCTAssertNotNil(text, "Expected non-empty array to be returned")
            XCTAssertEqual(text!.first!,"Hola","Expected hello to translate to Hola")
            modelExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    func testGetModels() {
        let allExpectation = expectationWithDescription("Get All Models")
        let sourceExpectation = expectationWithDescription("Get Models by Source")
        let targetExpectation = expectationWithDescription("Get Models by Target")
        let defaultModelExpectation = expectationWithDescription("Get Models by Default")
        
        service.getModels() { models, error in
            XCTAssertGreaterThan(models!.count,0,"Expected at least 1 model to be returned")
            allExpectation.fulfill()
        }
        
        service.getModels("es") { models, error in
            XCTAssertEqual(models!.count,3,"Expected exactly 3 models to be returned")
            sourceExpectation.fulfill()
        }
        
        service.getModels(target:"pt") { models, error in
            XCTAssertNotNil(models, "Expected models to be returned")
            XCTAssertEqual(models!.count,2,"Expected exactly 2 models to be returned")
            targetExpectation.fulfill()
        }
        
        service.getModels(defaultModel:true) { models, error in
            XCTAssertNotNil(models, "Expected models to be returned")
            XCTAssertGreaterThanOrEqual(models!.count, 8, "Expected at least 8 models to be returned")
            defaultModelExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    func testCreateModel() {
        let creationDescription = "Create a model."
        let creationExpectation = expectationWithDescription(creationDescription)
        let deletionDescription = "Delete the model."
        let deletionExpectation = expectationWithDescription(deletionDescription)
        
        let fileURL = NSBundle(forClass: self.dynamicType).URLForResource("glossary", withExtension: "tmx")
        print("URL: " + fileURL!.URLString)
        XCTAssertNotNil(fileURL)
        
        service.createModel("en-es", name: "custom-english-to-spanish", fileKey: "forced_glossary", fileURL: fileURL!) { model, error in
            
            XCTAssertNotNil(model, "Expected non-nil model to be returned.")
            Log.sharedLogger.error("\(error)")
            creationExpectation.fulfill()
            
            // Add a small delay so the model is ready for delete.  This is not a normal flow of create and delete immediately
            // so this is only a testing issue
            sleep(3)
            
            self.service.deleteModel(model!) { error in
                XCTAssertNil(error)
                deletionExpectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    func testDeleteModel() {
        let unauthorizedDeleteExpectation = expectationWithDescription("Unauthorized expectation")
        let missingDeleteExpectation = expectationWithDescription("Missing delete expectation")
        
        service.deleteModel("en-es") { error in
            XCTAssertNotNil(error, "Expected unauthorized exception when trying to delete an IBM model")
            unauthorizedDeleteExpectation.fulfill()
        }
        
        service.deleteModel("qwerty") { error in
            XCTAssertNotNil(error!,"Expected missing delete exception when trying to delete a nonexistent model")
            missingDeleteExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    func testGetModel() {
        let expectation1 = expectationWithDescription("Missing model")
        let expectation2 = expectationWithDescription("Valid model")
        
        service.getModel("MISSING_MODEL_ID") { model, error in
            XCTAssertNil(model,"Expected no model to be return for invalid id")
            expectation1.fulfill()
        }
        
        service.getModel("en-es") { model, error in
            guard let model = model else {
                XCTFail("Expected non-nil model to be returned")
                return
            }
            XCTAssertEqual(model.modelID,"en-es","Expected to get en-es model")
            expectation2.fulfill()
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
}
