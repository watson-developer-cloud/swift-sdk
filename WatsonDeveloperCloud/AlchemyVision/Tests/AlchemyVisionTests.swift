/**
 * Copyright IBM Corporation 2015
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import XCTest

@testable import WatsonDeveloperCloud

class AlchemyVisionTests: XCTestCase {
    private let timeout: NSTimeInterval = 120.0
    
    var test_text = "this is a silly sentence to test the Node.js SDK"
    var test_html = "<html><head><title>The best SDK Test | AlchemyAPI</title></head><body><h1>Hello World!</h1><p>My favorite language is Javascript</p></body></html>"
    var testUrl = "http://www.nytimes.com/2013/07/13/us/politics/a-day-of-friction-notable-even-for-a-fractious-congress.html?_r=0"
    var faceTagURL = "http://demo1.alchemyapi.com/images/vision/mother-daughter.jpg"

    var serviceVision: AlchemyVision!
    
    override func setUp() {
        super.setUp()
        if let url = NSBundle(forClass: self.dynamicType).pathForResource("Credentials", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: url) as? Dictionary<String, String> {
                if serviceVision == nil {
                    serviceVision = AlchemyVision(apiKey: dict["AlchemyAPIKey"]!)
                }
            }
        }
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
        let service = AlchemyVision( apiKey: "WRONG")
        
        service.getImageKeywords(VisionConstants.ImageKeywordType.URL, stringURL: testUrl, forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageKeyWords, error in
            XCTAssertEqual(nil, imageKeyWords!.totalTransactions, "Expected result with a total transaction of 0")
            XCTAssertEqual(0,imageKeyWords!.imageKeyWords.count, "Expected result with a total keywords of 0")
            invalidExpectation.fulfill()
        })
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }

    func testURLGetImageKeywords(){
        let emptyExpectation = expectationWithDescription("Empty")
        let validExpectation = expectationWithDescription("Valid")
        
        serviceVision.getImageKeywords(VisionConstants.ImageKeywordType.URL, stringURL: "", forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageKeyWords, error in
            XCTAssertEqual(0,imageKeyWords!.imageKeyWords.count, "Expected result with a total keywords of 0")
            emptyExpectation.fulfill()
        })
        
        serviceVision.getImageKeywords(VisionConstants.ImageKeywordType.URL, stringURL: testUrl, forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageKeyWords, error in
            XCTAssertEqual(1,imageKeyWords!.imageKeyWords.count, "Expected result with a total keywords of 1")
            validExpectation.fulfill()
        })
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
   
  func testFileGetImageKeywords(){
    let emptyExpectation = expectationWithDescription("Empty")
    let validExpectation = expectationWithDescription("Valid")
    
    let fileURL = NSBundle(forClass: self.dynamicType).URLForResource("emaxfpo", withExtension: "jpg")
    let validData = NSData(contentsOfURL: fileURL!)
    let imageFromURL = UIImage(data: validData!)
    XCTAssertNotNil(imageFromURL)
    
    let invalidFromURL = UIImage()
    XCTAssertNotNil(invalidFromURL)

    serviceVision.getImageKeywords(VisionConstants.ImageKeywordType.UIImage, image: invalidFromURL, forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageKeyWords, error in
      XCTAssertEqual(404,error!.code, "Expected result with a total keywords of 0")
      emptyExpectation.fulfill()
    })
    
    serviceVision.getImageKeywords(VisionConstants.ImageKeywordType.UIImage, image: imageFromURL, forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageKeyWords, error in
      XCTAssertEqual(4, imageKeyWords!.totalTransactions, "Expected result with a total transaction of 4")
      XCTAssertLessThan(1,imageKeyWords!.imageKeyWords.count, "Expected result greater than one")
      validExpectation.fulfill()
    })
    
    waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
  }
  
    func testURLRecognizeFaces(){
        let emptyExpectation = expectationWithDescription("Empty")
        let validExpectation = expectationWithDescription("Valid")
        
        serviceVision.recognizeFaces(VisionConstants.ImageFacesType.URL, stringURL: "", forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageFaceTags, error in
            XCTAssertEqual(0,imageFaceTags!.imageFaces.count, "Expected result with a total imagefaces of 0")
            emptyExpectation.fulfill()
        })
        
        serviceVision.recognizeFaces(VisionConstants.ImageFacesType.URL, stringURL: faceTagURL, forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageFaceTags, error in
            XCTAssertEqual(2,imageFaceTags!.imageFaces.count, "Expected result with a total imagefaces of 2")
            validExpectation.fulfill()
        })
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
    
  func testFileRecognizeFaces(){
    let emptyExpectation = expectationWithDescription("Empty")
    let validExpectation = expectationWithDescription("Valid")
    
    let fileURL = NSBundle(forClass: self.dynamicType).URLForResource("mother-daughter", withExtension: "jpg")
    let validData = NSData(contentsOfURL: fileURL!)
    let imageFromURL = UIImage(data: validData!)
    XCTAssertNotNil(fileURL)
    
    let invalidURL = NSURL(string: "http://nowayitworks.comm/")
   // let invalidData = NSData(contentsOfURL: invalidURL!)
    let invalidFromURL = UIImage()
    XCTAssertNotNil(invalidURL)
    
    serviceVision.recognizeFaces(VisionConstants.ImageFacesType.UIImage, image: invalidFromURL, forceShowAll: true, knowledgeGraph: 1, completionHandler: { imageFaceTags, error in
      XCTAssertNotEqual(nil,error, "error should have value")
      emptyExpectation.fulfill()
    })
    
    serviceVision.recognizeFaces(VisionConstants.ImageFacesType.UIImage, image: imageFromURL!, completionHandler: { imageFaceTags, error in
      XCTAssertEqual(4, imageFaceTags!.totalTransactions, "Expected result with a total transaction of 4")
      XCTAssertEqual(2, imageFaceTags!.imageFaces.count, "Expected result with a total keywords of 1")
      validExpectation.fulfill()
    })
    
    waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
  }
  
  func testURLGetImage(){
    let emptyExpectation = expectationWithDescription("Empty")
    let validExpectation = expectationWithDescription("Valid")

    let validURL = "http://www.techcrunch.com/"
    let invalidURL = "http://nowayitworks.comm/"
    
    serviceVision.getImageLink(VisionConstants.ImageLinkType.URL, inputString: invalidURL, completionHandler: { imageLink, error in
      XCTAssertNotEqual ("",imageLink!.url, "Expected url return of what is passed in")
      XCTAssertEqual ("",imageLink!.image, "Expected empty string")
      emptyExpectation.fulfill()
    })
    
    serviceVision.getImageLink(VisionConstants.ImageLinkType.URL, inputString: validURL, completionHandler: { imageLink, error in
      XCTAssertNotEqual(nil, imageLink!.url, "Expect URL")
      XCTAssertNotEqual("", imageLink!.url, "Expect URL")
      XCTAssertNotEqual(nil,imageLink!.image, "Expect image")
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
    
    serviceVision.getImageLink(VisionConstants.ImageLinkType.HTML, inputString: invalidString, completionHandler: { imageLink, error in
      XCTAssertEqual ("",imageLink!.url, "Expected url to be an empty string")
      XCTAssertEqual ("",imageLink!.image, "Expected image to be an empty string")
      emptyExpectation.fulfill()
    })
    
    serviceVision.getImageLink(VisionConstants.ImageLinkType.HTML, inputString: htmlString!, completionHandler: { imageLink, error in
     // XCTAssertNotEqual(nil, imageLink.url, "Expect URL")
      XCTAssertEqual("", imageLink!.url, "Expect empty string")
      XCTAssertEqual("http://www.techcrunch.com/wp-content/uploads/2009/02/cp_1234354872_16947v1-max-250x250.jpg",imageLink!.image, "Expect techcrunch jpg file" )
      validExpectation.fulfill()
    })
    
    waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
  }

}
