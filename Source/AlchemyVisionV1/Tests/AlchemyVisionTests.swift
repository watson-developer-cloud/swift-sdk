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
    private let timeout: NSTimeInterval = 10.0

    private var car: NSData!
    private var obama: NSData!
    private var sign: NSData!
    private var thomas: NSData!
    private var html: NSURL!
    
    private var htmlContents: String!
    private let htmlImageName = "cp_1234354872_16947v1-max-250x250.jpg"
    
    private let obamaURL = "https://www.whitehouse.gov/sites/whitehouse.gov/files/images/" +
                           "Administration/People/president_official_portrait_lores.jpg"
    private let carURL = "https://raw.githubusercontent.com/watson-developer-cloud/" +
                         "java-sdk/master/src/test/resources/visual_recognition/car.png"
    private let signURL = "https://cdn.rawgit.com/watson-developer-cloud/ios-sdk/master/Source/" +
                          "AlchemyVisionV1/Tests/sign.jpg"
    private let htmlURL = "https://cdn.rawgit.com/watson-developer-cloud/ios-sdk/master/Source" +
                          "/AlchemyVisionV1/Tests/example.html"
    
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
            let car = NSData(contentsOfURL: bundle.URLForResource("car", withExtension: "png")!),
            let obama = NSData(contentsOfURL: bundle.URLForResource("obama", withExtension: "jpg")!),
            let sign = NSData(contentsOfURL: bundle.URLForResource("sign", withExtension: "jpg")!),
            let thomas = NSData(contentsOfURL: bundle.URLForResource("thomas", withExtension: "png")!),
            let html = bundle.URLForResource("example", withExtension: "html")
        else {
            XCTFail("Unable to locate testing resources.")
            return
        }
        
        self.car = car
        self.obama = obama
        self.sign = sign
        self.thomas = thomas
        self.html = html
        
        self.htmlContents = try? String(contentsOfURL: html)
        guard self.htmlContents != nil else {
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
            
            // verify faceTags structure
            XCTAssertEqual(faceTags.status, "OK")
            XCTAssertEqual(faceTags.totalTransactions, 4)
            XCTAssertNil(faceTags.url)
            XCTAssertEqual(faceTags.imageFaces.count, 1)
            let face = faceTags.imageFaces.first
            
            // verify face age
            XCTAssertEqual(face?.age.ageRange, "55-64")
            XCTAssert(face?.age.score >= 0.0)
            XCTAssert(face?.age.score <= 1.0)
            
            // verify face gender
            XCTAssertEqual(face?.gender.gender, "MALE")
            XCTAssert(face?.gender.score >= 0.0)
            XCTAssert(face?.gender.score <= 1.0)
            
            // verify face location
            XCTAssert(face?.height >= 0)
            XCTAssert(face?.height <= 300)
            XCTAssert(face?.width >= 0)
            XCTAssert(face?.width <= 300)
            XCTAssert(face?.positionX >= 0)
            XCTAssert(face?.positionX <= 300)
            XCTAssert(face?.positionY >= 0)
            XCTAssert(face?.positionY <= 300)
            
            // verify face identity (We know Obama is a celebrity and we should get an Identity -> Fore Unwrap)
            XCTAssertEqual(face?.identity!.name, "Barack Obama")
            XCTAssert(face?.identity!.score >= 0.0)
            XCTAssert(face?.identity!.score <= 1.0)
            
            // verify face identity knowledge graph
            XCTAssertNil(face?.identity!.knowledgeGraph)
            
            // verify face identity disambiguation
            XCTAssertEqual(face?.identity!.disambiguated.name, "Barack Obama")
            XCTAssertEqual(face?.identity!.disambiguated.website, "http://www.whitehouse.gov/")
            XCTAssertEqual(face?.identity!.disambiguated.dbpedia, "http://dbpedia.org/resource/Barack_Obama")
            XCTAssertEqual(face?.identity!.disambiguated.yago, "http://yago-knowledge.org/resource/Barack_Obama")
            XCTAssertNil(face?.identity!.disambiguated.opencyc)
            XCTAssertNil(face?.identity!.disambiguated.umbel)
            XCTAssertEqual(face?.identity!.disambiguated.freebase, "http://rdf.freebase.com/ns/m.02mjmr")
            XCTAssertNil(face?.identity!.disambiguated.crunchbase)
            XCTAssert(face?.identity!.disambiguated.subType?.contains("Person") == true)
            XCTAssert(face?.identity!.disambiguated.subType?.contains("Politician") == true)
            XCTAssert(face?.identity!.disambiguated.subType?.contains("President") == true)

            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedImageFaceTagsImage2() {
        let description = "Perform face recognition on an uploaded image."
        let expectation = expectationWithDescription(description)

        alchemyVision.getRankedImageFaceTags(image: obama, knowledgeGraph: true, failure: failWithError) { faceTags in
            
            // verify faceTags structure
            XCTAssertEqual(faceTags.status, "OK")
            XCTAssertEqual(faceTags.totalTransactions, 5)
            XCTAssertNil(faceTags.url)
            XCTAssertEqual(faceTags.imageFaces.count, 1)
            let face = faceTags.imageFaces.first
            
            // verify face age
            XCTAssertEqual(face?.age.ageRange, "55-64")
            XCTAssert(face?.age.score >= 0.0)
            XCTAssert(face?.age.score <= 1.0)
            
            // verify face gender
            XCTAssertEqual(face?.gender.gender, "MALE")
            XCTAssert(face?.gender.score >= 0.0)
            XCTAssert(face?.gender.score <= 1.0)
            
            // verify face location
            XCTAssert(face?.height >= 0)
            XCTAssert(face?.height <= 300)
            XCTAssert(face?.width >= 0)
            XCTAssert(face?.width <= 300)
            XCTAssert(face?.positionX >= 0)
            XCTAssert(face?.positionX <= 300)
            XCTAssert(face?.positionY >= 0)
            XCTAssert(face?.positionY <= 300)
            
            // verify face identity (We know Obama is a celebrity and we should get an Identity -> Fore Unwrap)
            XCTAssertEqual(face?.identity!.name, "Barack Obama")
            XCTAssert(face?.identity!.score >= 0.0)
            XCTAssert(face?.identity!.score <= 1.0)
            
            // verify face identity knowledge graph
            XCTAssertEqual(face?.identity!.knowledgeGraph?.typeHierarchy, "/people/politicians/democrats/barack obama")
            
            // verify face identity disambiguation
            XCTAssertEqual(face?.identity!.disambiguated.name, "Barack Obama")
            XCTAssertEqual(face?.identity!.disambiguated.website, "http://www.whitehouse.gov/")
            XCTAssertEqual(face?.identity!.disambiguated.dbpedia, "http://dbpedia.org/resource/Barack_Obama")
            XCTAssertEqual(face?.identity!.disambiguated.yago, "http://yago-knowledge.org/resource/Barack_Obama")
            XCTAssertNil(face?.identity!.disambiguated.opencyc)
            XCTAssertNil(face?.identity!.disambiguated.umbel)
            XCTAssertEqual(face?.identity!.disambiguated.freebase, "http://rdf.freebase.com/ns/m.02mjmr")
            XCTAssertNil(face?.identity!.disambiguated.crunchbase)
            XCTAssert(face?.identity!.disambiguated.subType?.contains("Person") == true)
            XCTAssert(face?.identity!.disambiguated.subType?.contains("Politician") == true)
            XCTAssert(face?.identity!.disambiguated.subType?.contains("President") == true)
            
            expectation.fulfill()
        }
        waitForExpectations()
    }


    func testGetRankedImageFaceTagsImageWithoutIdentity() {
        let description = "Perform face recognition on an uploaded image with no Celebrity Identity."
        let expectation = expectationWithDescription(description)

        alchemyVision.getRankedImageFaceTags(image: thomas, failure: failWithError) { faceTags in

            // verify faceTags structure
            XCTAssertEqual(faceTags.status, "OK")
            XCTAssertEqual(faceTags.totalTransactions, 4)
            XCTAssertNil(faceTags.url)
            XCTAssertEqual(faceTags.imageFaces.count, 1)
            let face = faceTags.imageFaces.first

            // verify face identity (We know Thomas is a not a celebrity right now -> No Identitiy)
            XCTAssert(face?.identity == nil)

            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedImageFaceTagsURL1() {
        let description = "Perform face recognition on the image at a given URL."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getRankedImageFaceTags(url: obamaURL, failure: failWithError) { faceTags in
            
            // verify faceTags structure
            XCTAssertEqual(faceTags.status, "OK")
            XCTAssertEqual(faceTags.totalTransactions, 4)
            XCTAssertEqual(faceTags.url, self.obamaURL)
            XCTAssertEqual(faceTags.imageFaces.count, 1)
            let face = faceTags.imageFaces.first
            
            // verify face age
            XCTAssertEqual(face?.age.ageRange, "55-64")
            XCTAssert(face?.age.score >= 0.0)
            XCTAssert(face?.age.score <= 1.0)
            
            // verify face gender
            XCTAssertEqual(face?.gender.gender, "MALE")
            XCTAssert(face?.gender.score >= 0.0)
            XCTAssert(face?.gender.score <= 1.0)
            
            // verify face location
            XCTAssert(face?.height >= 0)
            XCTAssert(face?.height <= 300)
            XCTAssert(face?.width >= 0)
            XCTAssert(face?.width <= 300)
            XCTAssert(face?.positionX >= 0)
            XCTAssert(face?.positionX <= 300)
            XCTAssert(face?.positionY >= 0)
            XCTAssert(face?.positionY <= 300)
            
            // verify face identity
            XCTAssertEqual(face?.identity!.name, "Barack Obama")
            XCTAssert(face?.identity!.score >= 0.0)
            XCTAssert(face?.identity!.score <= 1.0)
            
            // verify face identity knowledge graph
            XCTAssertNil(face?.identity!.knowledgeGraph)
            
            // verify face identity disambiguation
            XCTAssertEqual(face?.identity!.disambiguated.name, "Barack Obama")
            XCTAssertEqual(face?.identity!.disambiguated.website, "http://www.whitehouse.gov/")
            XCTAssertEqual(face?.identity!.disambiguated.dbpedia, "http://dbpedia.org/resource/Barack_Obama")
            XCTAssertEqual(face?.identity!.disambiguated.yago, "http://yago-knowledge.org/resource/Barack_Obama")
            XCTAssertNil(face?.identity!.disambiguated.opencyc)
            XCTAssertNil(face?.identity!.disambiguated.umbel)
            XCTAssertEqual(face?.identity!.disambiguated.freebase, "http://rdf.freebase.com/ns/m.02mjmr")
            XCTAssertNil(face?.identity!.disambiguated.crunchbase)
            XCTAssert(face?.identity!.disambiguated.subType?.contains("Person") == true)
            XCTAssert(face?.identity!.disambiguated.subType?.contains("Politician") == true)
            XCTAssert(face?.identity!.disambiguated.subType?.contains("President") == true)
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedImageFaceTagsURL2() {
        let description = "Perform face recognition on the image at a given URL."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getRankedImageFaceTags(url: obamaURL, knowledgeGraph: true, failure: failWithError) { faceTags in
            
            // verify faceTags structure
            XCTAssertEqual(faceTags.status, "OK")
            XCTAssertEqual(faceTags.totalTransactions, 5)
            XCTAssertEqual(faceTags.url, self.obamaURL)
            XCTAssertEqual(faceTags.imageFaces.count, 1)
            let face = faceTags.imageFaces.first
            
            // verify face age
            XCTAssertEqual(face?.age.ageRange, "55-64")
            XCTAssert(face?.age.score >= 0.0)
            XCTAssert(face?.age.score <= 1.0)
            
            // verify face gender
            XCTAssertEqual(face?.gender.gender, "MALE")
            XCTAssert(face?.gender.score >= 0.0)
            XCTAssert(face?.gender.score <= 1.0)
            
            // verify face location
            XCTAssert(face?.height >= 0)
            XCTAssert(face?.height <= 300)
            XCTAssert(face?.width >= 0)
            XCTAssert(face?.width <= 300)
            XCTAssert(face?.positionX >= 0)
            XCTAssert(face?.positionX <= 300)
            XCTAssert(face?.positionY >= 0)
            XCTAssert(face?.positionY <= 300)
            
            // verify face identity (We know Obama is a celebrity and we should get an Identity -> Fore Unwrap)
            XCTAssertEqual(face?.identity!.name, "Barack Obama")
            XCTAssert(face?.identity!.score >= 0.0)
            XCTAssert(face?.identity!.score <= 1.0)
            
            // verify face identity knowledge graph
            XCTAssertEqual(face?.identity!.knowledgeGraph?.typeHierarchy, "/people/politicians/democrats/barack obama")
            
            // verify face identity disambiguation
            XCTAssertEqual(face?.identity!.disambiguated.name, "Barack Obama")
            XCTAssertEqual(face?.identity!.disambiguated.website, "http://www.whitehouse.gov/")
            XCTAssertEqual(face?.identity!.disambiguated.dbpedia, "http://dbpedia.org/resource/Barack_Obama")
            XCTAssertEqual(face?.identity!.disambiguated.yago, "http://yago-knowledge.org/resource/Barack_Obama")
            XCTAssertNil(face?.identity!.disambiguated.opencyc)
            XCTAssertNil(face?.identity!.disambiguated.umbel)
            XCTAssertEqual(face?.identity!.disambiguated.freebase, "http://rdf.freebase.com/ns/m.02mjmr")
            XCTAssertNil(face?.identity!.disambiguated.crunchbase)
            XCTAssert(face?.identity!.disambiguated.subType?.contains("Person") == true)
            XCTAssert(face?.identity!.disambiguated.subType?.contains("Politician") == true)
            XCTAssert(face?.identity!.disambiguated.subType?.contains("President") == true)
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetImageHTMLFile1() {
        let description = "Identify the primary image in an HTML file."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getImage(html: html, failure: failWithError) { imageLinks in
            XCTAssertEqual(imageLinks.status, "OK")
            XCTAssertEqual(imageLinks.url, "")
            XCTAssert(imageLinks.image.containsString(self.htmlImageName))
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetImageHTMLFile2() {
        let description = "Identify the primary image in an HTML file."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getImage(html: html, url: htmlURL, failure: failWithError) { imageLinks in
            XCTAssertEqual(imageLinks.status, "OK")
            XCTAssertEqual(imageLinks.url, self.htmlURL)
            XCTAssert(imageLinks.image.containsString(self.htmlImageName))
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetImageHTMLContents1() {
        let description = "Identify the primary image in an HTML document."
        let expectation = expectationWithDescription(description)

        alchemyVision.getImage(html: htmlContents, failure: failWithError) { imageLinks in
            XCTAssertEqual(imageLinks.status, "OK")
            XCTAssertEqual(imageLinks.url, "")
            XCTAssert(imageLinks.image.containsString(self.htmlImageName))
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetImageHTMLContents2() {
        let description = "Identify the primary image in an HTML document."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getImage(html: htmlContents, url: htmlURL, failure: failWithError) { imageLinks in
            XCTAssertEqual(imageLinks.status, "OK")
            XCTAssertEqual(imageLinks.url, self.htmlURL)
            XCTAssert(imageLinks.image.containsString(self.htmlImageName))
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetImageURL() {
        let description = "Identify the primary image at a given URL."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getImage(url: htmlURL, failure: failWithError) { imageLinks in
            XCTAssertEqual(imageLinks.status, "OK")
            XCTAssertEqual(imageLinks.url, self.htmlURL)
            XCTAssert(imageLinks.image.containsString(self.htmlImageName))
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedImageKeywordsImage1() {
        let description = "Perform image tagging on an uploaded image."
        let expectation = expectationWithDescription(description)

        alchemyVision.getRankedImageKeywords(image: car, failure: failWithError) { imageKeywords in
            
            // verify imageKeywords structure
            XCTAssertEqual(imageKeywords.status, "OK")
            XCTAssertEqual(imageKeywords.url, "")
            XCTAssertEqual(imageKeywords.totalTransactions, 4)
            XCTAssertEqual(imageKeywords.imageKeywords.count, 4)
            
            // verify first keyword
            XCTAssertEqual(imageKeywords.imageKeywords[0].text, "car")
            XCTAssert(imageKeywords.imageKeywords[0].score >= 0.0)
            XCTAssert(imageKeywords.imageKeywords[0].score <= 1.0)
            XCTAssertNil(imageKeywords.imageKeywords[0].knowledgeGraph)
            
            // verify second keyword
            XCTAssertEqual(imageKeywords.imageKeywords[1].text, "race")
            XCTAssert(imageKeywords.imageKeywords[1].score >= 0.0)
            XCTAssert(imageKeywords.imageKeywords[1].score <= 1.0)
            XCTAssertNil(imageKeywords.imageKeywords[1].knowledgeGraph)
            
            // verify third keyword
            XCTAssertEqual(imageKeywords.imageKeywords[2].text, "racing")
            XCTAssert(imageKeywords.imageKeywords[2].score >= 0.0)
            XCTAssert(imageKeywords.imageKeywords[2].score <= 1.0)
            XCTAssertNil(imageKeywords.imageKeywords[2].knowledgeGraph)
            
            // verify fourth keyword
            XCTAssertEqual(imageKeywords.imageKeywords[3].text, "motorsport")
            XCTAssert(imageKeywords.imageKeywords[3].score >= 0.0)
            XCTAssert(imageKeywords.imageKeywords[3].score <= 1.0)
            XCTAssertNil(imageKeywords.imageKeywords[3].knowledgeGraph)
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedImageKeywordsImage2() {
        let description = "Perform image tagging on an uploaded image."
        let expectation = expectationWithDescription(description)

        alchemyVision.getRankedImageKeywords(image: car, forceShowAll: true, knowledgeGraph: true, failure: failWithError) { imageKeywords in
            
            // verify imageKeywords structure
            XCTAssertEqual(imageKeywords.status, "OK")
            XCTAssertEqual(imageKeywords.url, "")
            XCTAssertEqual(imageKeywords.totalTransactions, 5)
            XCTAssertEqual(imageKeywords.imageKeywords.count, 7)
            
            // verify first keyword
            XCTAssertEqual(imageKeywords.imageKeywords[0].text, "car")
            XCTAssert(imageKeywords.imageKeywords[0].score >= 0.0)
            XCTAssert(imageKeywords.imageKeywords[0].score <= 1.0)
            XCTAssertEqual(imageKeywords.imageKeywords[0].knowledgeGraph?.typeHierarchy, "/vehicles/car")
            
            // verify second keyword
            XCTAssertEqual(imageKeywords.imageKeywords[1].text, "race")
            XCTAssert(imageKeywords.imageKeywords[1].score >= 0.0)
            XCTAssert(imageKeywords.imageKeywords[1].score <= 1.0)
            XCTAssertEqual(imageKeywords.imageKeywords[1].knowledgeGraph?.typeHierarchy, "/concepts/factors/characteristics/race")
            
            // verify third keyword
            XCTAssertEqual(imageKeywords.imageKeywords[2].text, "racing")
            XCTAssert(imageKeywords.imageKeywords[2].score >= 0.0)
            XCTAssert(imageKeywords.imageKeywords[2].score <= 1.0)
            XCTAssertNil(imageKeywords.imageKeywords[2].knowledgeGraph)
            
            // verify fourth keyword
            XCTAssertEqual(imageKeywords.imageKeywords[3].text, "motorsport")
            XCTAssert(imageKeywords.imageKeywords[3].score >= 0.0)
            XCTAssert(imageKeywords.imageKeywords[3].score <= 1.0)
            XCTAssertEqual(imageKeywords.imageKeywords[3].knowledgeGraph?.typeHierarchy, "/activities/sports/motorsport")
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedImageKeywordsURL1() {
        let description = "Perform image tagging on the primary image at a given URL."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getRankedImageKeywords(url: carURL, failure: failWithError) { imageKeywords in
            
            // verify imageKeywords structure
            XCTAssertEqual(imageKeywords.status, "OK")
            XCTAssertEqual(imageKeywords.url, self.carURL)
            XCTAssertEqual(imageKeywords.totalTransactions, 4)
            XCTAssertEqual(imageKeywords.imageKeywords.count, 4)
            
            // verify first keyword
            XCTAssertEqual(imageKeywords.imageKeywords[0].text, "car")
            XCTAssert(imageKeywords.imageKeywords[0].score >= 0.0)
            XCTAssert(imageKeywords.imageKeywords[0].score <= 1.0)
            XCTAssertNil(imageKeywords.imageKeywords[0].knowledgeGraph)
            
            // verify second keyword
            XCTAssertEqual(imageKeywords.imageKeywords[1].text, "race")
            XCTAssert(imageKeywords.imageKeywords[1].score >= 0.0)
            XCTAssert(imageKeywords.imageKeywords[1].score <= 1.0)
            XCTAssertNil(imageKeywords.imageKeywords[1].knowledgeGraph)
            
            // verify third keyword
            XCTAssertEqual(imageKeywords.imageKeywords[2].text, "racing")
            XCTAssert(imageKeywords.imageKeywords[2].score >= 0.0)
            XCTAssert(imageKeywords.imageKeywords[2].score <= 1.0)
            XCTAssertNil(imageKeywords.imageKeywords[2].knowledgeGraph)
            
            // verify fourth keyword
            XCTAssertEqual(imageKeywords.imageKeywords[3].text, "motorsport")
            XCTAssert(imageKeywords.imageKeywords[3].score >= 0.0)
            XCTAssert(imageKeywords.imageKeywords[3].score <= 1.0)
            XCTAssertNil(imageKeywords.imageKeywords[3].knowledgeGraph)
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedImageKeywordsURL2() {
        let description = "Perform image tagging on the primary image at a given URL."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getRankedImageKeywords(url: carURL, forceShowAll: true, knowledgeGraph: true, failure: failWithError) { imageKeywords in
            
            // verify imageKeywords structure
            XCTAssertEqual(imageKeywords.status, "OK")
            XCTAssertEqual(imageKeywords.url, self.carURL)
            XCTAssertEqual(imageKeywords.totalTransactions, 5)
            XCTAssertEqual(imageKeywords.imageKeywords.count, 7)
            
            // verify first keyword
            XCTAssertEqual(imageKeywords.imageKeywords[0].text, "car")
            XCTAssert(imageKeywords.imageKeywords[0].score >= 0.0)
            XCTAssert(imageKeywords.imageKeywords[0].score <= 1.0)
            XCTAssertEqual(imageKeywords.imageKeywords[0].knowledgeGraph?.typeHierarchy, "/vehicles/car")
            
            // verify second keyword
            XCTAssertEqual(imageKeywords.imageKeywords[1].text, "race")
            XCTAssert(imageKeywords.imageKeywords[1].score >= 0.0)
            XCTAssert(imageKeywords.imageKeywords[1].score <= 1.0)
            XCTAssertEqual(imageKeywords.imageKeywords[1].knowledgeGraph?.typeHierarchy, "/concepts/factors/characteristics/race")
            
            // verify third keyword
            XCTAssertEqual(imageKeywords.imageKeywords[2].text, "racing")
            XCTAssert(imageKeywords.imageKeywords[2].score >= 0.0)
            XCTAssert(imageKeywords.imageKeywords[2].score <= 1.0)
            XCTAssertNil(imageKeywords.imageKeywords[2].knowledgeGraph)
            
            // verify fourth keyword
            XCTAssertEqual(imageKeywords.imageKeywords[3].text, "motorsport")
            XCTAssert(imageKeywords.imageKeywords[3].score >= 0.0)
            XCTAssert(imageKeywords.imageKeywords[3].score <= 1.0)
            XCTAssertEqual(imageKeywords.imageKeywords[3].knowledgeGraph?.typeHierarchy, "/activities/sports/motorsport")
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedImageSceneTextImage() {
        let description = "Identify text in an uploaded image."
        let expectation = expectationWithDescription(description)

        alchemyVision.getRankedImageSceneText(image: sign, failure: failWithError) { sceneTexts in
            
            // verify sceneTexts structure
            XCTAssertEqual(sceneTexts.status, "OK")
            XCTAssertNil(sceneTexts.url)
            XCTAssertEqual(sceneTexts.totalTransactions, 0)
            XCTAssertEqual(sceneTexts.sceneText, "notice\nincreased\ntrain traffic")
            
            // verify first scene text line
            let line = sceneTexts.sceneTextLines.first
            XCTAssert(line?.confidence >= 0.0)
            XCTAssert(line?.confidence <= 1.0)
            XCTAssert(line?.region.height >= 0)
            XCTAssert(line?.region.height <= 150)
            XCTAssert(line?.region.width >= 0)
            XCTAssert(line?.region.width <= 150)
            XCTAssert(line?.region.x >= 0)
            XCTAssert(line?.region.x <= 500)
            XCTAssert(line?.region.y >= 0)
            XCTAssert(line?.region.y <= 500)
            XCTAssertEqual(line?.text, "notice")
            
            // verify first scene text line words
            let words = line?.words.first
            XCTAssert(words?.confidence >= 0.0)
            XCTAssert(words?.confidence <= 1.0)
            XCTAssert(words?.region.height >= 0)
            XCTAssert(words?.region.height <= 150)
            XCTAssert(words?.region.width >= 0)
            XCTAssert(words?.region.width <= 150)
            XCTAssert(words?.region.x >= 0)
            XCTAssert(words?.region.x <= 500)
            XCTAssert(words?.region.y >= 0)
            XCTAssert(words?.region.y <= 500)
            XCTAssertEqual(words?.text, "notice")
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedImageSceneTextURL() {
        let description = "Identify text in the primary image at a given URL."
        let expectation = expectationWithDescription(description)
        
        alchemyVision.getRankedImageSceneText(url: signURL, failure: failWithError) { sceneTexts in
            
            // verify sceneTexts structure
            XCTAssertEqual(sceneTexts.status, "OK")
            XCTAssertEqual(sceneTexts.url, self.signURL)
            XCTAssertEqual(sceneTexts.totalTransactions, 0)
            XCTAssertEqual(sceneTexts.sceneText, "notice\nincreased\ntrain traffic")
            
            // verify first scene text line
            let line = sceneTexts.sceneTextLines.first
            XCTAssert(line?.confidence >= 0.0)
            XCTAssert(line?.confidence <= 1.0)
            XCTAssert(line?.region.height >= 0)
            XCTAssert(line?.region.height <= 150)
            XCTAssert(line?.region.width >= 0)
            XCTAssert(line?.region.width <= 150)
            XCTAssert(line?.region.x >= 0)
            XCTAssert(line?.region.x <= 500)
            XCTAssert(line?.region.y >= 0)
            XCTAssert(line?.region.y <= 500)
            XCTAssertEqual(line?.text, "notice")
            
            // verify first scene text line words
            let words = line?.words.first
            XCTAssert(words?.confidence >= 0.0)
            XCTAssert(words?.confidence <= 1.0)
            XCTAssert(words?.region.height >= 0)
            XCTAssert(words?.region.height <= 150)
            XCTAssert(words?.region.width >= 0)
            XCTAssert(words?.region.width <= 150)
            XCTAssert(words?.region.x >= 0)
            XCTAssert(words?.region.x <= 500)
            XCTAssert(words?.region.y >= 0)
            XCTAssert(words?.region.y <= 500)
            XCTAssertEqual(words?.text, "notice")
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    // MARK: - Negative Tests
    
    func testGetRankedImageFaceTagsWithInvalidURL() {
        let description = "Perform face recognition at an invalid URL."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        let url = "this-url-is-invalid"
        alchemyVision.getRankedImageFaceTags(url: url, failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
    func testGetImageWithInvalidHTML() {
        let description = "Identify the primary image in an invalid HTML document."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        let html = "this-html-is-invalid"
        alchemyVision.getImage(html: html, failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
    func testGetImageWithInvalidURL() {
        let description = "Identify the primary image at an invalid URL."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        let url = "this-url-is-invalid"
        alchemyVision.getImage(url: url, failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
    func testGetRankedImageKeywordsWithInvalidURL() {
        let description = "Perform image tagging on the primary image at an invalid URL."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        let url = "this-url-is-invalid"
        alchemyVision.getRankedImageKeywords(url: url, failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
    func testGetRankedImageSceneTextWithInvalidURL() {
        let description = "Identify text in the primary image at an invalid URL."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        let url = "this-url-is-invalid"
        alchemyVision.getRankedImageSceneText(url: url, failure: failure, success: failWithResult)
        waitForExpectations()
    }
}
