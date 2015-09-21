//
//  WatsonCoreTests.swift
//  WatsonCoreTests
//
//  Created by Glenn R. Fisher on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import XCTest
@testable import WatsonCore

class WatsonCoreTests: XCTestCase {
    
    // todo: remove authentication credentials
    private let authentication = WatsonAuthentication(serviceURL: "https://stream.watsonplatform.net/speech-to-text/api", username: "004db54a-c5e0-472b-a6eb-7b106fd31370", password: "o55eeuCST9YU")
    private let timeout: NSTimeInterval = 60.0
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    /**
    Test WatsonAuthentication by ensuring a 200 response from a Watson Speech to Text endpoint that requires authentication.
    */
    func testAuthentication() {
        
        let expectation = expectationWithDescription("WatsonAuthentication")
        
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfiguration, delegate: authentication, delegateQueue: nil)
        let endpoint = "https://stream.watsonplatform.net/speech-to-text/api/v1/recognize"
        let url = NSURL(string: endpoint)
        if let url = url {
            let dataTask = session.dataTaskWithURL(url) {
                data, response, error in
                let statusCode = (response as? NSHTTPURLResponse)?.statusCode
                XCTAssert(statusCode == 200, "Status code not 200. (Check credentials.)")
                expectation.fulfill()
            }
            dataTask.resume()
        }
        
        waitForExpectationsWithTimeout(timeout) {
            error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
}
