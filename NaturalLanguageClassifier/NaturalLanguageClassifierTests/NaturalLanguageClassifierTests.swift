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
    
    service.getClassifiers({(classifiers:[Classifiers]?) in
      XCTAssertGreaterThan((classifiers!.count),0,"Expected at least 1 model to be returned")
      positiveExpectation.fulfill()
    })

    
    waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
  }
  
}
