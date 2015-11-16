//
//  AlchemyVisionTests.swift
//  AlchemyVisionTests
//
//  Created by Vincent Herrin on 10/4/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import XCTest

@testable import WatsonSDK

class AlchemyVisionTests: XCTestCase {
    private let timeout: NSTimeInterval = 60.0
    
    var test_text = "this is a silly sentence to test the Node.js SDK"
    var test_html = "<html><head><title>The best SDK Test | AlchemyAPI</title></head><body><h1>Hello World!</h1><p>My favorite language is Javascript</p></body></html>"
    var testUrl = "http://www.nytimes.com/2013/07/13/us/politics/a-day-of-friction-notable-even-for-a-fractious-congress.html?_r=0"
    var faceTagURL = "http://demo1.alchemyapi.com/images/vision/mother-daughter.jpg"

    let serviceVision = VisionImpl()
    
    override func setUp() {
        super.setUp()
        if let url = NSBundle(forClass: self.dynamicType).pathForResource("Credentials", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: url) as? Dictionary<String, String> {
                serviceVision._apiKey = dict["AlchemyVisionAPIKey"]!
            }
        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
    This will test an invalid API key for all three segments of Vision, Language and Data
    */
    func testInvalidAPIKey() {
        let invalidExpectation = expectationWithDescription("Invalid API key")
        let service : VisionImpl = VisionImpl( apiKey: "WRONG")
        
        service.getImageKeywords(VisionConstants.ImageKeywordType.URL, stringURL: testUrl, forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageKeyWords in
            XCTAssertEqual(nil, imageKeyWords.totalTransactions, "Expected result with a total transaction of 0")
            XCTAssertEqual(0,imageKeyWords.imageKeyWords.count, "Expected result with a total keywords of 0")
            invalidExpectation.fulfill()
        })
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }

    func testURLGetImageKeywords(){
        let emptyExpectation = expectationWithDescription("Empty")
        let validExpectation = expectationWithDescription("Valid")
        
        serviceVision.getImageKeywords(VisionConstants.ImageKeywordType.URL, stringURL: "", forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageKeyWords in
            XCTAssertEqual(0,imageKeyWords.imageKeyWords.count, "Expected result with a total keywords of 0")
            emptyExpectation.fulfill()
        })
        
        serviceVision.getImageKeywords(VisionConstants.ImageKeywordType.URL, stringURL: testUrl, forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageKeyWords in
            XCTAssertEqual(1,imageKeyWords.imageKeyWords.count, "Expected result with a total keywords of 1")
            validExpectation.fulfill()
        })
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
   
  func testFileGetImageKeywords(){
    let emptyExpectation = expectationWithDescription("Empty")
    let validExpectation = expectationWithDescription("Valid")
    
    let fileURL = NSBundle(forClass: self.dynamicType).URLForResource("emaxfpo", withExtension: "jpg")
    XCTAssertNotNil(fileURL)
    
    let invalidURL = NSURL(string: "http://nowayitworks.comm/")
    XCTAssertNotNil(invalidURL)
    
    serviceVision.getImageKeywords(VisionConstants.ImageKeywordType.FILE, fileURL: invalidURL, forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageKeyWords in
      XCTAssertEqual(0,imageKeyWords.imageKeyWords.count, "Expected result with a total keywords of 0")
      emptyExpectation.fulfill()
    })
    
    serviceVision.getImageKeywords(VisionConstants.ImageKeywordType.FILE, fileURL: fileURL, forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageKeyWords in
      XCTAssertEqual(4, imageKeyWords.totalTransactions, "Expected result with a total transaction of 4")
      XCTAssertLessThan(1,imageKeyWords.imageKeyWords.count, "Expected result greater than one")
      validExpectation.fulfill()
    })
    
    waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
  }
  
    func testURLRecognizeFaces(){
        let emptyExpectation = expectationWithDescription("Empty")
        let validExpectation = expectationWithDescription("Valid")
        
        serviceVision.recognizeFaces(VisionConstants.ImageFacesType.URL, stringURL: "", forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageFaceTags in
            XCTAssertEqual(0,imageFaceTags.ImageFaces.count, "Expected result with a total imagefaces of 0")
            emptyExpectation.fulfill()
        })
        
        serviceVision.recognizeFaces(VisionConstants.ImageFacesType.URL, stringURL: faceTagURL, forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageFaceTags in
            XCTAssertEqual(2,imageFaceTags.ImageFaces.count, "Expected result with a total imagefaces of 2")
            validExpectation.fulfill()
        })
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
  func testFileRecognizeFaces(){
    let emptyExpectation = expectationWithDescription("Empty")
    let validExpectation = expectationWithDescription("Valid")
    
    let fileURL = NSBundle(forClass: self.dynamicType).URLForResource("mother-daughter", withExtension: "jpg")
    XCTAssertNotNil(fileURL)
    
    let invalidURL = NSURL(string: "http://nowayitworks.comm/")
    XCTAssertNotNil(invalidURL)
    
    
    serviceVision.recognizeFaces(VisionConstants.ImageFacesType.FILE, fileURL: invalidURL!, forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageFaceTags in
      XCTAssertEqual(0,imageFaceTags.ImageFaces.count, "Expected result with a total keywords of 0")
      emptyExpectation.fulfill()
    })
    
    serviceVision.recognizeFaces(VisionConstants.ImageFacesType.FILE, fileURL: fileURL!, completionHandler: { imageFaceTags in
      XCTAssertEqual(4, imageFaceTags.totalTransactions, "Expected result with a total transaction of 4")
      XCTAssertEqual(2, imageFaceTags.ImageFaces.count, "Expected result with a total keywords of 1")
      validExpectation.fulfill()
    })
    
    waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
  }
  
  func testURLGetImage(){
    let emptyExpectation = expectationWithDescription("Empty")
    let validExpectation = expectationWithDescription("Valid")

    let validURL = "http://www.techcrunch.com/"
    let invalidURL = "http://nowayitworks.comm/"
    
    serviceVision.getImageLink(VisionConstants.ImageLinkType.URL, inputString: invalidURL, completionHandler: { imageLink in
      XCTAssertNotEqual ("",imageLink.url, "Expected url return of what is passed in")
      XCTAssertEqual ("",imageLink.image, "Expected empty string")
      emptyExpectation.fulfill()
    })
    
    serviceVision.getImageLink(VisionConstants.ImageLinkType.URL, inputString: validURL, completionHandler: { imageLink in
      XCTAssertNotEqual(nil, imageLink.url, "Expect URL")
      XCTAssertNotEqual("", imageLink.url, "Expect URL")
      XCTAssertNotEqual(nil,imageLink.image, "Expect image")
      validExpectation.fulfill()
    })
    
    waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
  }
  
  func testHTMLGetImage(){
    let emptyExpectation = expectationWithDescription("Empty")
    let validExpectation = expectationWithDescription("Valid")
    
    let fileURL = NSBundle(forClass: self.dynamicType).pathForResource("example", ofType: "html")
    XCTAssertNotNil(fileURL)
    
    let htmlString = try? String(contentsOfFile: fileURL!, encoding: NSUTF8StringEncoding)
    let invalidString = "http://nowayitworks.comm/"
    
    serviceVision.getImageLink(VisionConstants.ImageLinkType.HTML, inputString: invalidString, completionHandler: { imageLink in
      XCTAssertEqual ("",imageLink.url, "Expected url to be an empty string")
      XCTAssertEqual ("",imageLink.image, "Expected image to be an empty string")
      emptyExpectation.fulfill()
    })
    
    serviceVision.getImageLink(VisionConstants.ImageLinkType.HTML, inputString: htmlString!, completionHandler: { imageLink in
     // XCTAssertNotEqual(nil, imageLink.url, "Expect URL")
      XCTAssertEqual("", imageLink.url, "Expect empty string")
      XCTAssertEqual("http://www.techcrunch.com/wp-content/uploads/2009/02/cp_1234354872_16947v1-max-250x250.jpg",imageLink.image, "Expect techcrunch jpg file" )
      validExpectation.fulfill()
    })
    
    waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
  }

}
