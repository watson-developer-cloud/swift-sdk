//
//  DialogTests.swift
//  DialogTests
//
//  Created by Jonathan Ballands on 11/9/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import XCTest
@testable import Dialog

class DialogTests: XCTestCase {
    
    /*
     *  MARK: Properties
     */
    
    private let testService = DialogService()
    
    private let timeout: NSTimeInterval = 60.0
    
    /*
     *  MARK: Lifecycle
     */
    
    override func setUp() {
        super.setUp()
        
        if let url = NSBundle(forClass: self.dynamicType).URLForResource("Test", withExtension: "plist") {
            if let dict = NSDictionary(contentsOfURL: url) as? Dictionary<String, String> {
                testService.setUsernameAndPassword(dict["Username"]!, password: dict["Password"]!)
            } else {
                XCTFail("Unable to extract dictionary from plist")
            }
        } else {
            XCTFail("Plist file not found")
        }
    }
    
    override func tearDown() {
        
        // TODO: Tear down tests...
        
        super.tearDown()
    }
    
    /*
     *  MARK: Tests
     */
    
    func testConverse() {
        
        
        
    }
    
}
