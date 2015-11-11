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
  
  func testGetClassifier() {
    let expectationValid = expectationWithDescription("Valid Expected")
    let expectationInvalid = expectationWithDescription("Invalid Expect")
    
    service.getClassifier("MISSING_CLASSIFIER_ID", completionHandler:{(classifier:Classifier?) in
      XCTAssertNil(classifier,"Expected no classifier to be return for invalid id")
      expectationInvalid.fulfill()
    })
    
    // todo use create to get id then delete the classifier afterwards.  All api calls need to be in place first
    service.getClassifier("CEADDEx6-nlc-1114", completionHandler:{(classifier:Classifier?) in
      guard let classifier = classifier else {
        XCTFail("Expected non-nil model to be returned")
        return
      }
      XCTAssertEqual(classifier.id,"CEADDEx6-nlc-1114","Expected to get id requested in classifier")
      expectationValid.fulfill()
    })
    
    waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
  }
  
  
}
