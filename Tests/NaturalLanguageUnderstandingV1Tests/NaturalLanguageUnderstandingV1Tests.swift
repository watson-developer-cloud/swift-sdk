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
    
    /** Analyze given test input text for concepts. */
    func testAnalyzeTextForConcepts() {
        let description = "Analyze text with features."
        let expectation = self.expectation(description: description)
        
        let text = "In remote corners of the world, citizens are demanding respect for the dignity of all people no matter their gender, or race, or religion, or disability, or sexual orientation, and those who deny others dignity are subject to public reproach. An explosion of social media has given ordinary people more ways to express themselves, and has raised people's expectations for those of us in power. Indeed, our international order has been so successful that we take it as a given that great powers no longer fight world wars; that the end of the Cold War lifted the shadow of nuclear Armageddon; that the battlefields of Europe have been replaced by peaceful union; that China and India remain on a path of remarkable growth."
        let concepts = ConceptsOptions(limit: 5)
        let features = Features(concepts: concepts)
        let parameters = Parameters(features: features, text: text)
        
        naturalLanguageUnderstanding.analyzeContent(withParameters: parameters, failure: failWithError) {
            results in
            guard let concepts = results.concepts else {
                XCTAssertNil(results.concepts)
                return
            }
            for concept in concepts {
                XCTAssertNotNil(concept.name)
                XCTAssertNotNil(concept.dbpediaResource)
                XCTAssertNotNil(concept.relevance)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Analyze input text for emotions. */
    func testAnalyzeTextForEmotions() {
        let description = "Analyze text for emotions."
        let expectation = self.expectation(description: description)
        
        let text = "But I believe this thinking is wrong. I believe the road of true democracy remains the better path. I believe that in the 21st century, economies can only grow to a certain point until they need to open up -- because entrepreneurs need to access information in order to invent; young people need a global education in order to thrive; independent media needs to check the abuses of power."
        let emotion = EmotionOptions(targets: ["democracy", "entrepreneurs", "media", "economies"])
        let features = Features(emotion: emotion)
        let parameters = Parameters(features: features, text: text)
        naturalLanguageUnderstanding.analyzeContent(withParameters: parameters, failure: failWithError) {
            results in
            print(results)
            guard let emotion = results.emotion else {
                XCTAssertNil(results.emotion)
                return
            }

            XCTAssertNotNil(emotion.document)
            guard let targets = emotion.targets else {
                XCTAssertNil(emotion.targets)
                return
            }
            for target in targets {
                XCTAssertNotNil(target.text)
                guard let emotion = target.emotion else {
                    XCTAssertNil(target.emotion)
                    return
                }
                XCTAssertNotNil(emotion.anger)
                XCTAssertNotNil(emotion.disgust)
                XCTAssertNotNil(emotion.fear)
                XCTAssertNotNil(emotion.joy)
                XCTAssertNotNil(emotion.sadness)
                break
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Analyze input text for emotions. */
    func testAnalyzeTextForEmotionsWithoutTargets() {
        let description = "Analyze text for emotions without targets."
        let expectation = self.expectation(description: description)
        
        let text = "But I believe this thinking is wrong. I believe the road of true democracy remains the better path. I believe that in the 21st century, economies can only grow to a certain point until they need to open up -- because entrepreneurs need to access information in order to invent; young people need a global education in order to thrive; independent media needs to check the abuses of power."
        let features = Features(emotion: EmotionOptions())
        let parameters = Parameters(features: features, text: text)
        naturalLanguageUnderstanding.analyzeContent(withParameters: parameters, failure: failWithError) {
            results in
            print(results)
            guard let emotionResults = results.emotion else {
                XCTAssertNil(results.emotion)
                return
            }
            XCTAssertNotNil(emotionResults.document)
            guard let documentEmotion = emotionResults.document?.emotion else {
                XCTAssertNil(emotionResults.document?.emotion)
                return
            }
            XCTAssertNotNil(documentEmotion.anger)
            XCTAssertNotNil(documentEmotion.disgust)
            XCTAssertNotNil(documentEmotion.fear)
            XCTAssertNotNil(documentEmotion.joy)
            XCTAssertNotNil(documentEmotion.sadness)
            
            XCTAssertNil(emotionResults.targets)

            expectation.fulfill()
        }
        waitForExpectations()
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
