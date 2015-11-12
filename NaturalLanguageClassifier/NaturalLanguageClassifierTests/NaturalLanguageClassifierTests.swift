//
//  NaturalLanguageClassifierTests.swift
//  NaturalLanguageClassifierTests
//
//  Created by Vincent Herrin on 11/7/15.
//  Copyright © 2015 IBM. All rights reserved.
//

import XCTest
@testable import NaturalLanguageClassifier

class NaturalLanguageClassifierTests: XCTestCase {
  
  /// Language translation service
  private let service = NaturalLanguageClassifier()
  
  private let classifierIdInstance = "F7EECBx7-nlc-126"
  
  /// Timeout for an asynchronous call to return before failing the unit test
  private let timeout: NSTimeInterval = 60.0
  
    override func setUp() {
      super.setUp()
      if let url = NSBundle(forClass: self.dynamicType).URLForResource("NLCTest", withExtension: "plist") {
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
    
  func testGetClassifiers() {
    let positiveExpectation = expectationWithDescription("Get All Classifiers")
    //let negativeExpectation = expectationWithDescription("Get Models by Default")
    
    service.getClassifiers({(classifiers:[Classifier]?) in
      XCTAssertGreaterThan((classifiers!.count),0,"Expected at least 1 model to be returned")
      positiveExpectation.fulfill()
    })

    
    waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
  }
  
  func testDeleteClassifier() {
    let authorizedDeleteExpectation = expectationWithDescription("Unauthorized expectation")
    let missingDeleteExpectation = expectationWithDescription("Missing delete expectation")
    
    service.deleteClassifier("Non-existance", completionHandler:{(classifier:Bool?) in
      XCTAssertFalse(classifier!,"Expected missing delete exception when trying to delete a nonexistent model")
      missingDeleteExpectation.fulfill()
    })
    
    service.deleteClassifier(self.classifierIdInstance, completionHandler:{(classifier:Bool?) in
      XCTAssertTrue(classifier!,"Expected missing delete exception when trying to delete a nonexistent model")
      authorizedDeleteExpectation.fulfill()
    })
    
    waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
  }
  
  func testGetClassifier() {
    let expectationValid = expectationWithDescription("Valid Expected")
    let expectationInvalid = expectationWithDescription("Invalid Expect")
    
    service.getClassifier("MISSING_CLASSIFIER_ID", completionHandler:{(classifier:Classifier?) in
      XCTAssertNil(classifier,"Expected no classifier to be return for invalid id")
      expectationInvalid.fulfill()
    })
    
    // todo use create to get id then delete the classifier afterwards.  All api calls need to be in place first
    service.getClassifier(self.classifierIdInstance, completionHandler:{(classifier:Classifier?) in
      guard let classifier = classifier else {
        XCTFail("Expected non-nil model to be returned")
        return
      }
      XCTAssertEqual(classifier.id, self.classifierIdInstance,"Expected to get id requested in classifier")
      expectationValid.fulfill()
    })
    
    waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
  }
  
  func testClassify() {
    let expectationValid = expectationWithDescription("Valid Expected")
    let expectationInvalid = expectationWithDescription("Invalid Expect")
    
    service.classify("MISSING_CLASSIFIER_ID", text: "is it sunny?", completionHandler:{(classification:Classification?) in
      XCTAssertNil(classification,"Expected no classifier to be return for invalid id")
      expectationInvalid.fulfill()
    })
    
    // please note this test expects the classifier to be ready
    service.classify(self.classifierIdInstance, text: "is it sunny?", completionHandler:{(classification:Classification?) in
      guard let classification = classification else {
        XCTFail("Expected non-nil model to be returned")
        expectationValid.fulfill()
        return
      }
      XCTAssertEqual(classification.id, self.classifierIdInstance,"Expected to get id requested in classifier")
      XCTAssertLessThan(1, (classification.classes!.count) as Int,"Expected to get more than one class")
      expectationValid.fulfill()
    })
    
    waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
  }
  
  //TODO: this test is not functional since the API is not working as of yet
  func testCreateClassifier() {
    let expectationValid = expectationWithDescription("Valid Expected")
    
    
    let fileURL = NSBundle(forClass: self.dynamicType).URLForResource("weather_data_train", withExtension: "csv")
    XCTAssertNotNil(fileURL)
    
    let invalidURL = NSURL(string: "http://nowayitworks.comm/")
    XCTAssertNotNil(invalidURL)
    
    
    // todo use create to get id then delete the classifier afterwards.  All api calls need to be in place first
    service.createClassifier("newName", trainerURL: fileURL!, completionHandler:{(classifier:Classifier?) in
        expectationValid.fulfill()
      })

      waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
  }
  
}
