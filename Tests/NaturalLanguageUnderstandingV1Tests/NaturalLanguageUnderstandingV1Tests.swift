/**
 * Copyright IBM Corporation 2017
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
import NaturalLanguageUnderstandingV1

class NaturalLanguageUnderstandingV1Tests: XCTestCase {
    
    private var naturalLanguageUnderstanding: NaturalLanguageUnderstanding!
    private let timeout: TimeInterval = 5.0
    private let text = "In 2009, Elliot Turner launched AlchemyAPI to process the written word, with all of its quirks and nuances, and got immediate traction."
    
    override func setUp() {
        super.setUp()
        instantiateNaturalLanguageUnderstanding()
    }
    
    static var allTests : [(String, (NaturalLanguageUnderstandingV1Tests) -> () throws -> Void)] {
        return [
        ]
    }
    
    /** Instantiate Natural Language Understanding instance. */
    func instantiateNaturalLanguageUnderstanding() {
        let username = Credentials.NaturalLanguageUnderstandingUsername
        let password = Credentials.NaturalLanguageUnderstandingPassword
        naturalLanguageUnderstanding = NaturalLanguageUnderstanding(username: username, password: password, version: "2016-05-17")
    }
    
    /** Fail false negatives. */
    func failWithError(error: Error) {
        XCTFail("Positive test failed with error: \(error)")
    }
    
    /** Fail false positives. */
    func failWithResult<T>(result: T) {
        XCTFail("Negative test returned a result.")
    }
    
    /** Wait for expectations. */
    func waitForExpectations() {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
    // MARK: - Helper Functions
    
    /** Load a file. */
    func loadFile(name: String, withExtension: String) -> URL? {
        
        #if os(iOS)
            let bundle = Bundle(for: type(of: self))
            guard let url:URL = bundle.url(forResource: name, withExtension: withExtension) else {
                return nil
            }
        #else
            let url = URL(fileURLWithPath: "Tests/NaturalLanguageUnderstandingV1Tests/"+name+"."+withExtension)
        #endif
        
        return url
    }
    
    /// load text to analyze
    
    /// load html to analyze
    
    /// load public webpage to analyze.
    
    // MARK: - Positive tests
    
    /** Analyze given test text with . */
    func testAnalyzeText() {
        let description = "Analyze text with features."
    }
    
    func testAnalyzeTextWithSemanticRoles() {
        let description = "Analyze text and verify semantic roles returned."
        let expectation = self.expectation(description: description)
        
        let features = Features(semanticRoles: SemanticRolesOptions(limit: 7, keywords: true, entities: true, requireEntities: false))
        
        let param = Parameters(features: features, text: text, returnAnalyzedText: true)
        naturalLanguageUnderstanding.analyzeContent(withParameters: param, failure: failWithError) {
            results in
            
            XCTAssertEqual(results.analyzedText, self.text)
            XCTAssertEqual(results.language, "en")
            XCTAssertNotNil(results.semanticRoles)
            for semanticRole in results.semanticRoles! {
                XCTAssertEqual(semanticRole.sentence, self.text)
                if let subject = semanticRole.subject {
                    XCTAssertNotNil(subject.text)
                }
                if let action = semanticRole.action {
                    XCTAssertNotNil(action.text)
                }
                if let object = semanticRole.object {
                    XCTAssertNotNil(object.text)
                }
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testAnalyzeTextWithSentiment() {
        let description = "Analyze text and verify sentiment returned."
        let expectation = self.expectation(description: description)
        
        let features = Features(sentiment: SentimentOptions(document: true, targets: ["Elliot Turner", "traction"]))
        
        let param = Parameters(features: features, text: text, returnAnalyzedText: true)
        naturalLanguageUnderstanding.analyzeContent(withParameters: param, failure: failWithError) {
            results in
            
            XCTAssertEqual(results.analyzedText, self.text)
            XCTAssertEqual(results.language, "en")
            XCTAssertNotNil(results.sentiment)
            XCTAssertNotNil(results.sentiment?.document)
            XCTAssertNotNil(results.sentiment?.document?.score)
            XCTAssertNotNil(results.sentiment?.targets)
            for target in (results.sentiment?.targets)! {
                XCTAssertNotNil(target.text)
                XCTAssertNotNil(target.score)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testAnalyzeTextWithCategories() {
        let description = "Analyze text and verify categories returned."
        let expectation = self.expectation(description: description)
        
        let features = Features(categories: CategoriesOptions())
        
        let param = Parameters(features: features, text: text, returnAnalyzedText: true)
        naturalLanguageUnderstanding.analyzeContent(withParameters: param, failure: failWithError) {
            results in
            
            XCTAssertEqual(results.analyzedText, self.text)
            XCTAssertEqual(results.language, "en")
            XCTAssertNotNil(results.categories)
            for category in results.categories! {
                XCTAssertNotNil(category.label)
                XCTAssertNotNil(category.score)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Negative tests
    
}
