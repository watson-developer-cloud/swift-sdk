//
//  AlchemyVisionTests.swift
//  AlchemyVisionTests
//
//  Created by Vincent Herrin on 10/4/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import XCTest

@testable import AlchemyVision
import WatsonCore

class AlchemyVisionTests: XCTestCase {
    private let authentication = WatsonAuthentication(serviceURL: "https://stream.watsonplatform.net/speech-to-text/api", username: "004db54a-c5e0-472b-a6eb-7b106fd31370", password: "o55eeuCST9YU")
    private let timeout: NSTimeInterval = 60.0
    
    var test_text = "this is a silly sentence to test the Node.js SDK"
    var test_html = "<html><head><title>The best SDK Test | AlchemyAPI</title></head><body><h1>Hello World!</h1><p>My favorite language is Javascript</p></body></html>"
   // var test_url = "http://www.nytimes.com/2013/07/13/us/politics/a-day-of-friction-notable-even-for-a-fractious-congress.html?_r=0"
    
    //    var test_url = "https://www.google.com/search?q=cat&espv=2&source=lnms&tbm=isch&sa=X&ved=0CAcQ_AUoAWoVChMIuOev14miyAIVEeqACh0mOwhq&biw=1440&bih=805"
        var test_url = "https://www.petfinder.com/wp-content/uploads/2012/11/138190243-cat-massage-632x475.jpg"
    //    var test_image = './emaxfpo.jpg';
    
    
    //var serviceVision : VisionImpl = VisionImpl( apiKey: "c893a51b2703dcbed40e1416b7b6723f4f95f5d3")
    var serviceVision : VisionImpl = VisionImpl( apiKey: "f11453e65d32e72c9b75ac0fb814996326dd80ed") //- not
    
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
    This will test an invalid API key for all three segments of Vision, Language and Data

    func testInvalidAPIKey() {
        
        let expectation = expectationWithDescription("Test Invalid API Key")
        
        let service : VisionImpl = VisionImpl( apiKey: "WRONG")
        
        service.urlGetRankedImageKeywords(test_url, outputMode: AlchemyConstants.OutputMode.XML, forceShowAll: true, knowledgeGraph: 1, callback: { response, resultStatus in
            
            XCTAssertNil(response, "Response is not nil.")
            
            XCTAssertNotNil(resultStatus, "Error is nil.")
            
            XCTAssertEqual(resultStatus.status, "ERROR")
            
            XCTAssertEqual(resultStatus.statusInfo, "invalid-api-key")
            
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }

    func testURLGetRankedImageKeywordsXML(){
        
        let expectation = expectationWithDescription("Test URLGetRankedImageKeywords")
        
        serviceVision.urlGetRankedImageKeywords(test_url, forceShowAll: true, knowledgeGraph: 1, completionHandler: { response in
            
            XCTAssertNotNil(response, "Response is nil.")
            
          //  XCTAssertNotNil(resultStatus, "Error is nil.")
            
            XCTAssertEqual(resultStatus.status, "OK")
            
            XCTAssertEqual(resultStatus.statusInfo, "")
            
            XCTAssertGreaterThan(response.totalTransactions, 3)
            
            XCTAssertEqual(response.imageKeyWords.count, 1)
            
            XCTAssertEqual(response.imageKeyWords[0].text, "person")
            
            XCTAssertGreaterThan(response.imageKeyWords[0].score, 0.90)
            
            // add some logic here for testing
            expectation.fulfill()
        })
    
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
*/
    func testAlamo(){
        
        let expectation = expectationWithDescription("Test URLGetRankedImageKeywords")
        
        serviceVision.urlGetRankedImageKeywords(test_url, forceShowAll: true, knowledgeGraph: 1, completionHandler: { response in
            
            // add some logic here for testing
            expectation.fulfill()
        })

        
        /*
        
        serviceVision.urlGetRankedImageKeywords(test_url, forceShowAll: true, knowledgeGraph: 1, callback: { response, resultStatus in
            
            // add some logic here for testing
            expectation.fulfill()
        })
        */
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    /*
    
    func testURLGetRankedImageKeywordsJSON(){
        
        let expectation = expectationWithDescription("Test URLGetRankedImageKeywords")
        
        serviceVision.urlGetRankedImageKeywords(test_url, outputMode: AlchemyConstants.OutputMode.JSON, forceShowAll: true, knowledgeGraph: 1, callback: { response, resultStatus in
            
            XCTAssertNotNil(response, "Response is nil.")
            
            XCTAssertNotNil(resultStatus, "Error is nil.")
            
            XCTAssertEqual(resultStatus.status, "OK")
            
            XCTAssertEqual(resultStatus.statusInfo, "")
            
            XCTAssertGreaterThan(response.totalTransactions, 3)
            
            XCTAssertEqual(response.imageKeyWords.count, 1)
            
            XCTAssertEqual(response.imageKeyWords[0].text, "person")
            
            XCTAssertGreaterThan(response.imageKeyWords[0].score, 0.90)
            
            // add some logic here for testing
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
*/
    
}
