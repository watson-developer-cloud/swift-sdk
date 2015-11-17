//
//  AlchemyLanguageTests.swift
//  AlchemyLanguageTests
//
//  Created by Ruslan Ardashev on 11/4/15.
//  Copyright © 2015 ibm.mil. All rights reserved.
//

import XCTest
@testable import WatsonSDK

class AlchemyLanguageTests: XCTestCase {
    
    // timing
    private let timeout: NSTimeInterval = 60.0
    
    // main instance
    let instance = AlchemyLanguage()
    var apiKeyNotSet: Bool { return instance._apiKey == nil }
    
    // test strings
    var test_html = "<html><head><title>The best SDK Test | AlchemyAPI</title></head><body><h1>Hello World!</h1><p>My favorite language is Javascript</p></body></html>"
    
    
    // setup, teardown
    override func setUp() {
        
        super.setUp()
        
        let bundle = NSBundle(forClass: self.dynamicType)
        
        if let url = bundle.pathForResource("Credentials", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: url) as? [String : String]
            where apiKeyNotSet {
                
                instance._apiKey = dict["AlchemyAPIKey"]!
                
        }
        
    }
    
    // called after the invocation of each test method in the class
    override func tearDown() { super.tearDown() }
    
    
    // tests
    func testHTMLGetAuthor() {
        
        let validExpectation = expectationWithDescription("Valid")
        
        instance.getAuthor(requestType: .HTML,
            html: test_html,
            url: nil) {
                
            (error, documentAuthor) in
                
                XCTAssertNotNil(documentAuthor)
                XCTAssertNotNil(documentAuthor.author)
                
                if let author = documentAuthor.author {
                    
                    print("Success HTMLGetAuthor, author: \(author)")
                    
                }
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidHTMLGetAuthor() {
        
        
        
    }
    
    func testURLGetAuthor() {
        
        
        
    }
    
    func testInvalidURLGetAuthor() {
        
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
