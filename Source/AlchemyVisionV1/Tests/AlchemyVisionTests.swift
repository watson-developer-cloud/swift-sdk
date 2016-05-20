/**
 * Copyright IBM Corporation 2016
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
import AlchemyVisionV1

class AlchemyVisionTests: XCTestCase {
    
    private var alchemyVision: AlchemyVision!
    private let timeout: NSTimeInterval = 30.0

    private var car: NSURL!
    private var obama: NSURL!
    private var sign: NSURL!
    private var html: String!
    
    private let obamaURL = "https://www.whitehouse.gov/sites/whitehouse.gov/files/images/" +
                           "Administration/People/president_official_portrait_lores.jpg"
    private let carURL = "https://raw.githubusercontent.com/watson-developer-cloud/" +
                         "java-sdk/master/src/test/resources/visual_recognition/car.png"
    private let signURL = "https://raw.githubusercontent.com/watson-developer-cloud/java-sdk/" +
                          "master/src/test/resources/visual_recognition/open.png"
    private let htmlURL = "https://raw.githubusercontent.com/watson-developer-cloud/ios-sdk/" +
                          "master/WatsonDeveloperCloud/AlchemyVision/Tests/example.html"
    
    // MARK: - Test Configuration
    
    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateAlchemyVision()
        loadResources()
    }
    
    /** Instantiate Alchemy Vision. */
    func instantiateAlchemyVision() {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard
            let file = bundle.pathForResource("Credentials", ofType: "plist"),
            let credentials = NSDictionary(contentsOfFile: file) as? [String: String],
            let apiKey = credentials["AlchemyAPIKey"]
        else {
            XCTFail("Unable to read credentials.")
            return
        }
        alchemyVision = AlchemyVision(apiKey: apiKey)
    }
    
    /** Load image files with class examples and test images. */
    func loadResources() {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard
            let car = bundle.URLForResource("car", withExtension: "png"),
            let obama = bundle.URLForResource("obama", withExtension: "jpg"),
            let sign = bundle.URLForResource("sign", withExtension: "jpg"),
            let html = bundle.URLForResource("example", withExtension: "html")
        else {
            XCTFail("Unable to locate testing resources.")
            return
        }
        
        self.car = car
        self.obama = obama
        self.sign = sign
        self.html = try? String(contentsOfURL: html)
        guard self.html != nil else {
            XCTFail("Unable to load html example as String.")
            return
        }
    }
    
    /** Fail false negatives. */
    func failWithError(error: NSError) {
        XCTFail("Positive test failed with error: \(error)")
    }
    
    /** Fail false positives. */
    func failWithResult<T>(result: T) {
        XCTFail("Negative test returned a result.")
    }
    
    /** Wait for expectations. */
    func waitForExpectations() {
        waitForExpectationsWithTimeout(timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
    // MARK: - Positive Tests
    
    func testGetRankedImageFaceTagsImage1() {
        let description = "Perform face recognition on an uploaded image."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getRankedImageFaceTags(image: obama, failure: failWithError) { faceTags in
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedImageFaceTagsImage2() {
        let description = "Perform face recognition on an uploaded image."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getRankedImageFaceTags(image: obama, knowledgeGraph: true, failure: failWithError) { faceTags in
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedImageFaceTagsURL1() {
        let description = "Perform face recognition on the image at a given URL."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getRankedImageFaceTags(url: obamaURL, failure: failWithError) { faceTags in
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedImageFaceTagsURL2() {
        let description = "Perform face recognition on the image at a given URL."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getRankedImageFaceTags(url: obamaURL, knowledgeGraph: true, failure: failWithError) { faceTags in
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetImageHTML1() {
        let description = "Identify the primary image in an HTML document."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getImage(html: html, failure: failWithError) { imageLinks in
            XCTFail("Need to check for `content-is-empty` failure.")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetImageHTML2() {
        let description = "Identify the primary image in an HTML document."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getImage(html: html, url: htmlURL, failure: failWithError) { imageLinks in
            XCTFail("Need to check for `content-is-empty` failure.")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetImageURL() {
        let description = "Identify the primary image at a given URL."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getImage(url: htmlURL, failure: failWithError) { imageLinks in
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedImageKeywordsImage1() {
        let description = "Perform image tagging on an uploaded image."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getRankedImageKeywords(image: car, failure: failWithError) { imageKeywords in
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedImageKeywordsImage2() {
        let description = "Perform image tagging on an uploaded image."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getRankedImageKeywords(image: car, forceShowAll: true, knowledgeGraph: true, failure: failWithError) { imageKeywords in
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedImageKeywordsURL1() {
        let description = "Perform image tagging on the primary image at a given URL."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getRankedImageKeywords(url: carURL, failure: failWithError) { imageKeywords in
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedImageKeywordsURL2() {
        let description = "Perform image tagging on the primary image at a given URL."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getRankedImageKeywords(url: carURL, forceShowAll: true, knowledgeGraph: true, failure: failWithError) { imageKeywords in
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedImageSceneTextImage() {
        let description = "Identify text in an uploaded image."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getRankedImageSceneText(image: sign, failure: failWithError) { sceneTexts in
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedImageSceneTextURL() {
        let description = "Identify text in the primary image at a given URL."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getRankedImageSceneText(url: signURL, failure: failWithError) { sceneTexts in
            expectation.fulfill()
        }
        waitForExpectations()
    }
}
