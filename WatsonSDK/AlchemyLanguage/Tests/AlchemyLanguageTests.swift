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
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
