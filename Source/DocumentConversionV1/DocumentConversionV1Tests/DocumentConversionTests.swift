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
import DocumentConversionV1

class DocumentConversionTests: XCTestCase {
    
    private var service: DocumentConversion!
    private var badService: DocumentConversion!
    private let timeout: NSTimeInterval = 5.0
    
    private var testDocument: NSURL!
    private var testPng: NSURL!
    
    private var textConfig: NSURL!
    private var htmlConfig: NSURL!
    private var answerUnitsConfig: NSURL!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let bundle = NSBundle(forClass: self.dynamicType)
        if let url = bundle.pathForResource("Credentials", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: url) as? Dictionary<String, String> {
                let username = dict["DocumentConversionUsername"]!
                let password = dict["DocumentConversionPassword"]!
                if service == nil {
                    service = DocumentConversion(username: username, password: password, version: "2015-12-15")
                }
                if badService == nil {
                    badService = DocumentConversion(username: username, password: password, version: "BEES!!!")
                }
            } else {
                XCTFail("Unable to extract dictionary from plist")
            }
        } else {
            XCTFail("Plist file not found")
        }
        
        if let htmlUrl = bundle.URLForResource("arsArticle", withExtension: "html") {
            testDocument = htmlUrl
        } else {
            XCTFail("Test article not found")
        }
        
        if let pngUrl = bundle.URLForResource("car", withExtension: "png") {
            testPng = pngUrl
        } else {
            XCTFail("Test png not found")
        }
        
        if let config1 = bundle.URLForResource("testConfigText", withExtension: ".json") {
            textConfig = config1
        } else {
            XCTFail("Text configuration file not found")
        }
        
        if let config2 = bundle.URLForResource("testConfigHtml", withExtension: ".json") {
            htmlConfig = config2
        } else {
            XCTFail("HTML configuration file not found")
        }
        
        if let config3 = bundle.URLForResource("testConfigAU", withExtension: ".json") {
            answerUnitsConfig = config3
        } else {
            XCTFail("Answer Units configuration file not found")
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
    
    /// Positive Unit Tests
    
    func testConvertToText() {
        let description = "Convert a document to only its text pieces"
        let expectation = expectationWithDescription(description)
        
        service.convertDocument(textConfig, document: testDocument, failure: failWithError) { text in
            XCTAssertNotNil(text, "Response should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testConvertToHtml() {
        let description = "Convert a document to html"
        let expectation = expectationWithDescription(description)
        
        service.convertDocument(htmlConfig, document: testDocument, failure: failWithError) { text in
            XCTAssertNotNil(text, "Response should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testConvertToTextCreateConfig() {
        let description = "Convert a document to only its text pieces"
        let expectation = expectationWithDescription(description)
        
        do{
            try service.convertDocument(service.writeConfig(ReturnType.Text), document: testDocument,
                failure: failWithError) { text in
                    XCTAssertNotNil(text, "Response should not be nil")
                    expectation.fulfill()
            }
        } catch {
            XCTFail("Could not write config file")
        }
        waitForExpectations()
    }
    
    func testConvertToAnswerUnits() {
        let description = "Convert a document to an answer unit object"
        let expectation = expectationWithDescription(description)
        
        service.convertDocument(answerUnitsConfig, document: testDocument, failure: failWithError) {
            text in
            do {
                let responseObject = try self.service.deserializeAnswerUnits(text)
                XCTAssertNotNil(responseObject.sourceDocId, "Source ID should not be nil")
                XCTAssertNotNil(responseObject.timestamp, "Timestamp should not be nil")
                XCTAssertNotNil(responseObject.detectedMediaType, "DetectedMediaType should not be nil")
                if let metadata = responseObject.metadata {
                    for entry in metadata {
                        XCTAssertNotNil(entry.content, "Content should not be nil")
                        XCTAssertNotNil(entry.name, "Name should not be nil")
                    }
                }
                if let answerUnits = responseObject.answerUnits {
                    for unit in answerUnits {
                        XCTAssertNotNil(unit.id, "Id should not be nil")
                        XCTAssertNotNil(unit.type, "Type should not be nil")
                        XCTAssertNotNil(unit.parentId, "ParentId should not be nil")
                        XCTAssertNotNil(unit.title, "Title should not be nil")
                        XCTAssertNotNil(unit.direction, "Direction should not be nil")
                        XCTAssertNotNil(unit.content, "Content should not be nil")
                        XCTAssertNotNil(unit.content?[0].mediaType, "Media type should not be nil")
                        XCTAssertNotNil(unit.content?[0].text, "Text should not be nil")
                    }
                }
                expectation.fulfill()
            } catch {
                XCTFail()
            }
        }
        waitForExpectations()
    }
    
    /// Negative Unit Tests
    func testInvalidVersion() {
        let description = "Use an invalid version"
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        badService.convertDocument(answerUnitsConfig, document: testDocument,
                                failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
    func testInvalidFileType() {
        let description = "Use an invalid file type"
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            print("hello")
            XCTAssertEqual(error.code, 415)
            expectation.fulfill()
        }
        
        service.convertDocument(answerUnitsConfig, document: testPng,
                                failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
}
