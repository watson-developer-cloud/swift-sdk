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
import Foundation
import DocumentConversionV1

class DocumentConversionTests: XCTestCase {
    
    private var documentConversion: DocumentConversion!
    private let timeout: TimeInterval = 5.0
    
    private var testDocument: URL!
    private var testPng: URL!
    
    private var textConfig: URL!
    private var htmlConfig: URL!
    private var answerUnitsConfig: URL!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateDocumentConversion()
        loadResources()
    }
    
    static var allTests : [(String, (DocumentConversionTests) -> () throws -> Void)] {
        return [
            ("testConvertToText", testConvertToText),
            ("testConvertToHtml", testConvertToHtml),
            ("testConvertToTextCreateConfig", testConvertToTextCreateConfig),
            ("testConvertToAnswerUnits", testConvertToAnswerUnits),
            ("testInvalidVersion", testInvalidVersion),
            ("testInvalidFileType", testInvalidFileType)
        ]
    }
    
    func instantiateDocumentConversion() {
        let username = Credentials.DocumentConversionUsername
        let password = Credentials.DocumentConversionPassword
        let version = "2015-12-15"
        documentConversion = DocumentConversion(username: username, password: password, version: version)
        documentConversion.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        documentConversion.defaultHeaders["X-Watson-Test"] = "true"
    }

    func loadResources() {
        #if os(iOS)
            let bundle = Bundle(for: type(of: self))
            guard
                let htmlUrl = bundle.url(forResource: "arsArticle", withExtension: "html"),
                let pngUrl = bundle.url(forResource: "car", withExtension: "png"),
                let config1 = bundle.url(forResource: "testConfigText", withExtension: ".json"),
                let config2 = bundle.url(forResource: "testConfigHtml", withExtension: ".json"),
                let config3 = bundle.url(forResource: "testConfigAU", withExtension: ".json")
                else
            {
                XCTFail("One or more resources could not be loaded.")
                return
            }
        #else
            let htmlUrl =   URL(fileURLWithPath: "Tests/DocumentConversionV1Tests/arsArticle.html")
            let pngUrl =    URL(fileURLWithPath: "Tests/DocumentConversionV1Tests/car.png")
            let config1 =   URL(fileURLWithPath: "Tests/DocumentConversionV1Tests/testConfigText.json")
            let config2 =   URL(fileURLWithPath: "Tests/DocumentConversionV1Tests/testConfigHtml.json")
            let config3 =   URL(fileURLWithPath: "Tests/DocumentConversionV1Tests/testConfigAU.json")
        #endif
        
        
        testDocument = htmlUrl
        testPng = pngUrl
        textConfig = config1
        htmlConfig = config2
        answerUnitsConfig = config3
    }
    
    /** Fail false negatives. */
    func failWithError(error: Error) {
        XCTFail("Positive test failed with error: \(error)")
    }
    
    /** Fail false positives. */
    func failWithResult<T>(result: T) {
        XCTFail("Negative test returned a result.")
    }
    
    /** Fail false positives. */
    func failWithResult() {
        XCTFail("Negative test returned a result.")
    }
    
    /** Wait for expectations. */
    func waitForExpectations() {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
    // MARK: - Positive Tests
    
    func testConvertToText() {
        let description = "Convert a document to only its text pieces"
        let expectation = self.expectation(description: description)
        
        documentConversion.convertDocument(testDocument, withConfigurationFile: textConfig,
                                           failure: failWithError) { text in
                                            XCTAssertNotNil(text, "Response should not be nil")
                                            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testConvertToHtml() {
        let description = "Convert a document to html"
        let expectation = self.expectation(description: description)
        
        documentConversion.convertDocument(testDocument, withConfigurationFile: htmlConfig,
                                           failure: failWithError) { text in
                                            XCTAssertNotNil(text, "Response should not be nil")
                                            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testConvertToTextCreateConfig() {
        let description = "Convert a document to only its text pieces"
        let expectation = self.expectation(description: description)
        
        do{
            try documentConversion.convertDocument(
                testDocument,
                withConfigurationFile: documentConversion.writeConfig(type: ReturnType.text),
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
        let expectation = self.expectation(description: description)
        
        documentConversion.convertDocument(testDocument, withConfigurationFile: answerUnitsConfig,
                                           failure: failWithError) { text in
                                            do {
                                                let responseObject = try self.documentConversion.deserializeAnswerUnits(string: text)
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
        let expectation = self.expectation(description: description)
        
        let failure = { (error: Error) in
            expectation.fulfill()
        }
        
        let username = Credentials.DocumentConversionUsername
        let password = Credentials.DocumentConversionPassword
        let version = "invalid-version"
        documentConversion = DocumentConversion(username: username, password: password, version: version)
        
        documentConversion.convertDocument(
            testDocument,
            withConfigurationFile: answerUnitsConfig,
            failure: failure,
            success: failWithResult
        )
        waitForExpectations()
    }
    
    func testInvalidFileType() {
        let description = "Use an invalid file type"
        let expectation = self.expectation(description: description)
        
        let failure = { (error: Error) in
            expectation.fulfill()
        }
        
        documentConversion.convertDocument(testPng, withConfigurationFile: answerUnitsConfig,
                                           failure: failure, success: failWithResult)
        waitForExpectations()
    }
}
