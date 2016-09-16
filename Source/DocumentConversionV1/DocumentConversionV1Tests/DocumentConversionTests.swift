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
    
    private var documentConversion: DocumentConversion!
    private let timeout: NSTimeInterval = 5.0
    
    private var testDocument: NSURL!
    private var testPng: NSURL!
    
    private var textConfig: NSURL!
    private var htmlConfig: NSURL!
    private var answerUnitsConfig: NSURL!
    
    override func setUp() {
        super.setUp()
        instantiateDocumentConversion()
        loadResources()
    }
    
    func instantiateDocumentConversion() {
        let username = Credentials.DocumentConversionUsername
        let password = Credentials.DocumentConversionPassword
        let version = "2015-12-15"
        documentConversion = DocumentConversion(username: username, password: password, version: version)
    }
    
    func loadResources() {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard
            let htmlUrl = bundle.URLForResource("arsArticle", withExtension: "html"),
            let pngUrl = bundle.URLForResource("car", withExtension: "png"),
            let config1 = bundle.URLForResource("testConfigText", withExtension: ".json"),
            let config2 = bundle.URLForResource("testConfigHtml", withExtension: ".json"),
            let config3 = bundle.URLForResource("testConfigAU", withExtension: ".json")
            else
        {
            XCTFail("One or more resources could not be loaded.")
            return
        }
        
        testDocument = htmlUrl
        testPng = pngUrl
        textConfig = config1
        htmlConfig = config2
        answerUnitsConfig = config3
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
    
    func testConvertToText() {
        let description = "Convert a document to only its text pieces"
        let expectation = expectationWithDescription(description)
        
        documentConversion.convertDocument(textConfig, document: testDocument, failure: failWithError) { text in
            XCTAssertNotNil(text, "Response should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testConvertToHtml() {
        let description = "Convert a document to html"
        let expectation = expectationWithDescription(description)
        
        documentConversion.convertDocument(htmlConfig, document: testDocument, failure: failWithError) { text in
            XCTAssertNotNil(text, "Response should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testConvertToTextCreateConfig() {
        let description = "Convert a document to only its text pieces"
        let expectation = expectationWithDescription(description)
        
        do{
            try documentConversion.convertDocument(documentConversion.writeConfig(ReturnType.Text), document: testDocument,
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
        
        documentConversion.convertDocument(answerUnitsConfig, document: testDocument, failure: failWithError) {
            text in
            do {
                let responseObject = try self.documentConversion.deserializeAnswerUnits(text)
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
    
    // MARK: - Negative Tests
    
    func testInvalidVersion() {
        let description = "Use an invalid version"
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        let username = Credentials.DocumentConversionUsername
        let password = Credentials.DocumentConversionPassword
        let version = "invalid-version"
        documentConversion = DocumentConversion(username: username, password: password, version: version)
        
        documentConversion.convertDocument(
            answerUnitsConfig,
            document: testDocument,
            failure: failure,
            success: failWithResult
        )
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
        
        documentConversion.convertDocument(answerUnitsConfig, document: testPng,
                                failure: failure, success: failWithResult)
        waitForExpectations()
    }
}
