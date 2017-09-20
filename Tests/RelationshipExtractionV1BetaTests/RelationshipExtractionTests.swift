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
import RelationshipExtractionV1Beta

class RelationshipExtractionTests: XCTestCase {
    
    private var relationshipExtraction: RelationshipExtraction!
    private let timeout: TimeInterval = 5.0
    
    static var allTests : [(String, (RelationshipExtractionTests) -> () throws -> Void)] {
        return [
            ("testGetRelationships", testGetRelationships),
            ("testGetRelationshipsEmptyText", testGetRelationshipsEmptyText),
            ("testGetRelationshipsWithInvalidLanguage", testGetRelationshipsWithInvalidLanguage)
        ]
    }
    
    private let text = "The president’s trip was designed to reward Milwaukee for its success " +
        "in signing up people for coverage. It won a competition called the Healthy " +
        "Communities Challenge that involved 20 cities."
    
    // MARK: - Test Configuration
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateRelationshipExtraction()
    }
    
    /** Instantiate Relationship Extraction instance. */
    func instantiateRelationshipExtraction() {
        let username = Credentials.RelationshipExtractionUsername
        let password = Credentials.RelationshipExtractionPassword
        relationshipExtraction = RelationshipExtraction(username: username, password: password)
        relationshipExtraction.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        relationshipExtraction.defaultHeaders["X-Watson-Test"] = "true"
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
    
    // Disabled test, failed with: `Code: 415. Unsupported Media Type.`
    /** Analyze a piece of text for the relationships between all entities. */
    func testGetRelationships() {
        let description = "Test the getRelationships method."
        let expectation = self.expectation(description: description)
        
        relationshipExtraction.getRelationships(
            fromText: text,
            withLanguage: "ie-en-news",
            failure: failWithError) { document in
                
            XCTAssertNotNil(document.id)
            XCTAssertNotNil(document.text)
            XCTAssertEqual(document.text, self.text)
            
            XCTAssertEqual(document.entities.count, 7)
            for entity in document.entities {
                XCTAssertNotNil(entity.entityClass)
                XCTAssertNotNil(entity.entityID)
                XCTAssertNotNil(entity.level)
                XCTAssertNotNil(entity.mentions)
                XCTAssertNotNil(entity.mentions.first?.mentionID)
                XCTAssertNotNil(entity.mentions.first?.text)
                XCTAssertNotNil(entity.subtype)
                XCTAssertNotNil(entity.type)
                XCTAssertNotNil(entity.generic)
                XCTAssertNotNil(entity.score)
            }
                
            XCTAssertEqual(document.mentions.count, 7)
            for mention in document.mentions {
                XCTAssertNotNil(mention.mentionID)
                XCTAssertNotNil(mention.type)
                XCTAssertNotNil(mention.begin)
                XCTAssertNotNil(mention.end)
                XCTAssertNotNil(mention.headBegin)
                XCTAssertNotNil(mention.headEnd)
                XCTAssertNotNil(mention.entityID)
                XCTAssertNotNil(mention.entityRole)
                XCTAssertNotNil(mention.entityType)
                XCTAssertNotNil(mention.mentionClass)
                XCTAssertNotNil(mention.text)
                XCTAssertNotNil(mention.metonymy)
                XCTAssertNotNil(mention.score)
                XCTAssertNotNil(mention.corefScore)
            }
                
            XCTAssertNotNil(document.relations.version)
            XCTAssertEqual(document.relations.relations.count, 1)
            if let relation = document.relations.relations.first {
                XCTAssertNotNil(relation.relationID)
                XCTAssertNotNil(relation.type)
                XCTAssertNotNil(relation.subtype)
                
                XCTAssertNotNil(relation.relationEntityArgument)
                for relEntArg in relation.relationEntityArgument {
                    XCTAssertNotNil(relEntArg.entityID)
                    XCTAssertNotNil(relEntArg.argumentNumber)
                }
                
                XCTAssertNotNil(relation.relatedMentions)
                for relMen in relation.relatedMentions {
                    XCTAssertNotNil(relMen.relatedMentionID)
                    XCTAssertNotNil(relMen.score)
                    XCTAssertNotNil(relMen.relatedMentionClass)
                    XCTAssertNotNil(relMen.modality)
                    XCTAssertNotNil(relMen.tense)
                    
                    XCTAssertNotNil(relMen.relatedMentionArgument)
                    for relMenArg in relMen.relatedMentionArgument {
                        XCTAssertNotNil(relMenArg.mentionID)
                        XCTAssertNotNil(relMenArg.argumentNumber)
                        XCTAssertNotNil(relMenArg.text)
                    }
                }
            }
                
            XCTAssertEqual(document.sentences.count, 2)
            for sentence in document.sentences {
                XCTAssertNotNil(sentence.sentenceID)
                XCTAssertNotNil(sentence.begin)
                XCTAssertNotNil(sentence.end)
                XCTAssertNotNil(sentence.text)
                XCTAssertNotNil(sentence.parse)
                XCTAssertNotNil(sentence.dependencyParse)
                XCTAssertNotNil(sentence.usdDependencyParse)
                
                XCTAssertNotNil(sentence.tokens)
                for token in sentence.tokens {
                    XCTAssertNotNil(token.tokenID)
                    XCTAssertNotNil(token.begin)
                    XCTAssertNotNil(token.end)
                    XCTAssertNotNil(token.text)
                }
            }
                
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    // MARK: - Negative Tests
    
    /** Test getting relationships when passing an empty string as the text. */
    func testGetRelationshipsEmptyText() {
        let description = "Test getRelationships() when passing an empty string as the text."
        let expectation = self.expectation(description: description)
        
        let failure = { (error: Error) in
            expectation.fulfill()
        }
        
        relationshipExtraction.getRelationships(
            fromText: "",
            withLanguage: "ie-en-news",
            failure: failure,
            success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Test getting relationships when passing an invalid language. */
    func testGetRelationshipsWithInvalidLanguage() {
        let description = "Test getRelationships() when passing an empty string as the text."
        let expectation = self.expectation(description: description)
        
        let failure = { (error: Error) in
            expectation.fulfill()
        }
        
        relationshipExtraction.getRelationships(
            fromText: text,
            withLanguage: "INVALIDLANGUAGE",
            failure: failure,
            success: failWithResult)
        
        waitForExpectations()
    }
}
