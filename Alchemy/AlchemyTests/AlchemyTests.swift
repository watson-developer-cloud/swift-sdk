//
//  AlchemyTests.swift
//  AlchemyTests
//
//  Created by Vincent Herrin on 9/27/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import XCTest
@testable import Alchemy
import WatsonCore

class AlchemyTests: XCTestCase {
    private let authentication = WatsonAuthentication(serviceURL: "https://stream.watsonplatform.net/speech-to-text/api", username: "004db54a-c5e0-472b-a6eb-7b106fd31370", password: "o55eeuCST9YU")
    private let timeout: NSTimeInterval = 60.0
  //  private let timeout = 300.0

    var test_text = "this is a silly sentence to test the Node.js SDK"
    var test_html = "<html><head><title>The best SDK Test | AlchemyAPI</title></head><body><h1>Hello World!</h1><p>My favorite language is Javascript</p></body></html>"
    var test_url = "http://www.nytimes.com/2013/07/13/us/politics/a-day-of-friction-notable-even-for-a-fractious-congress.html?_r=0"
   // var test_image = './emaxfpo.jpg';

    
    var service : AlchemyServiceImpl = AlchemyServiceImpl( apiKey: "cc893a51b2703dcbed40e1416b7b6723f4f95f5d3")
    
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
   
    
    func testInvalidAPIKey() {
        // finish this test out
    }
    
    func testURLGetRankedImageKeywords(){
        
         let expectation = expectationWithDescription("URL Get Rank Image")
        
        service.urlGetRankedImageKeywords(test_url, outputMode: Constants.OutputMode.JSON, imagePostMode: Constants.ImagePostMode.Not_Raw, forceShowAll: true, knowledgeGraph: 1,callback: {response, error in
            // add some logic here for testing
            
        })
        
        // FIX TEST
        
        //waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
        // test invalid URL 
        
        // test different output methods
        
    }
    
}
