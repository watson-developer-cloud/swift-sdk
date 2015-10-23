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
    private let timeout: NSTimeInterval = 60.0
    
    var test_text = "this is a silly sentence to test the Node.js SDK"
    var test_html = "<html><head><title>The best SDK Test | AlchemyAPI</title></head><body><h1>Hello World!</h1><p>My favorite language is Javascript</p></body></html>"
    var testUrl = "http://www.nytimes.com/2013/07/13/us/politics/a-day-of-friction-notable-even-for-a-fractious-congress.html?_r=0"
    var faceTagURL = "http://demo1.alchemyapi.com/images/vision/mother-daughter.jpg"
    
    
    //    var test_url = "https://www.google.com/search?q=cat&espv=2&source=lnms&tbm=isch&sa=X&ved=0CAcQ_AUoAWoVChMIuOev14miyAIVEeqACh0mOwhq&biw=1440&bih=805"
    //    var test_url = "https://www.petfinder.com/wp-content/uploads/2012/11/138190243-cat-massage-632x475.jpg"
    //    var test_image = './emaxfpo.jpg';
    

    var serviceVision = VisionImpl( apiKey: "")
    
    override func setUp() {
        super.setUp()
        if let url = NSBundle(forClass: self.dynamicType).URLForResource("VisionTest", withExtension: "plist") {
            if let dict = NSDictionary(contentsOfURL: url) as? Dictionary<String, String> {
                serviceVision.setAPIKey(dict["apikey"]!)
            }
        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**a
    This will test an invalid API key for all three segments of Vision, Language and Data
    */
    func testInvalidAPIKey() {
        let invalidExpectation = expectationWithDescription("Invalid API key")
        let service : VisionImpl = VisionImpl( apiKey: "WRONG")
        
        service.urlGetRankedImageKeywords(testUrl, forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageKeyWords in
            XCTAssertEqual(0, imageKeyWords.totalTransactions, "Expected result with a total transaction of 0")
            XCTAssertEqual(0,imageKeyWords.imageKeyWords.count, "Expected result with a total keywords of 0")
            invalidExpectation.fulfill()
        })
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }

    func testURLGetRankedImageKeywords(){
        
        let emptyExpectation = expectationWithDescription("Empty")
        let validExpectation = expectationWithDescription("Valid")
        
        serviceVision.urlGetRankedImageKeywords("", forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageKeyWords in
            XCTAssertEqual(0,imageKeyWords.imageKeyWords.count, "Expected result with a total keywords of 0")
            emptyExpectation.fulfill()
        })
        
        serviceVision.urlGetRankedImageKeywords(testUrl, forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageKeyWords in
            XCTAssertEqual(1,imageKeyWords.imageKeyWords.count, "Expected result with a total keywords of 1")
            validExpectation.fulfill()
        })
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
   
    func testImageGetRankedImageKeywords(){
        
        let emptyExpectation = expectationWithDescription("Empty")
        let validExpectation = expectationWithDescription("Valid")
        
        let fileURL = NSBundle(forClass: self.dynamicType).URLForResource("emaxfpo", withExtension: "jpg")
        XCTAssertNotNil(fileURL)

        let invalidURL = NSURL(string: "http://nowayitworks.comm/")
        XCTAssertNotNil(invalidURL)
 
        serviceVision.imageGetRankedImageKeywords(invalidURL!, forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageKeyWords in
            XCTAssertEqual(0,imageKeyWords.imageKeyWords.count, "Expected result with a total keywords of 0")
            emptyExpectation.fulfill()
        })
        
        serviceVision.imageGetRankedImageKeywords(fileURL!, completionHandler: { imageKeyWords in
            XCTAssertEqual(4, imageKeyWords.totalTransactions, "Expected result with a total transaction of 4")
            XCTAssertEqual(1,imageKeyWords.imageKeyWords.count, "Expected result with a total keywords of 1")
            validExpectation.fulfill()
        })

        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
    func testURLGetRankedImageFaceTags(){
        
        let emptyExpectation = expectationWithDescription("Empty")
        let validExpectation = expectationWithDescription("Valid")
        
        serviceVision.urlGetRankedImageFaceTags("", forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageFaceTags in
            XCTAssertEqual(0,imageFaceTags.ImageFaces.count, "Expected result with a total imagefaces of 0")
            emptyExpectation.fulfill()
        })
        
        serviceVision.urlGetRankedImageFaceTags(faceTagURL, forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageFaceTags in
            XCTAssertEqual(2,imageFaceTags.ImageFaces.count, "Expected result with a total imagefaces of 2")
            validExpectation.fulfill()
        })
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    

}
