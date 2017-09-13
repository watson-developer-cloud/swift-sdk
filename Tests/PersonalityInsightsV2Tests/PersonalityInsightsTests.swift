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
import PersonalityInsightsV2

class PersonalityInsightsTests: XCTestCase {

    private var personalityInsights: PersonalityInsights!
    private var mobyDickIntro: String!
    private var kennedySpeech: String!
    private let timeout: TimeInterval = 5.0
    
    static var allTests : [(String, (PersonalityInsightsTests) -> () throws -> Void)] {
        return [
            ("testProfile", testProfile),
            ("testContentItem", testContentItem),
            ("testProfileWithShortText", testProfileWithShortText)
        ]
    }

    // MARK: - Test Configuration

    /** Set up for each test by loading text files and instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiatePersonalityInsights()
        loadMobyDickIntro()
        loadKennedySpeech()
    }

    /** Instantiate Personality Insights. */
    func instantiatePersonalityInsights() {
        let username = Credentials.PersonalityInsightsUsername
        let password = Credentials.PersonalityInsightsPassword
        personalityInsights = PersonalityInsights(username: username, password: password)
        personalityInsights.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        personalityInsights.defaultHeaders["X-Watson-Test"] = "true"
    }

    /** Load "MobyDickIntro.txt". */
    func loadMobyDickIntro() {
        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.path(forResource: "MobyDickIntro", ofType: "txt") else {
            XCTFail("Unable to locate MobyDickIntro.txt file.")
            return
        }

        mobyDickIntro = try? String(contentsOfFile: file)
        guard mobyDickIntro != nil else {
            XCTFail("Unable to read MobyDickIntro.txt file.")
            return
        }
    }

    /** Load "KennedySpeech.txt." */
    func loadKennedySpeech() {
        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.path(forResource: "KennedySpeech", ofType: "txt") else {
            XCTFail("Unable to locate KennedySpeech.txt file.")
            return
        }

        kennedySpeech = try? String(contentsOfFile: file)
        guard kennedySpeech != nil else {
            XCTFail("Unable to read KennedySpeech.txt file.")
            return
        }
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
    
    /** Analyze the text of Kennedy's speech. */
    func testProfile() {
        let description = "Analyze the text of Kennedy's speech."
        let expectation = self.expectation(description: description)

        personalityInsights.getProfile(fromText: kennedySpeech, failure: failWithError) { profile in
            XCTAssertEqual("root", profile.tree.name, "Tree root should be named root")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Analyze content items. */
    func testContentItem() {
        let description = "Analyze content items."
        let expectation = self.expectation(description: description)

        let contentItem = PersonalityInsightsV2.ContentItem(
            id: "245160944223793152",
            userID: "Bob",
            sourceID: "Twitter",
            created: 1427720427,
            updated: 1427720427,
            contentType: "text/plain",
            language: "en",
            content: kennedySpeech,
            parentID: "",
            reply: false,
            forward: false
        )

        let contentItems = [contentItem, contentItem]
        personalityInsights.getProfile(fromContentItems: contentItems, failure: failWithError) {
            profile in
            XCTAssertEqual("root", profile.tree.name, "Tree root should be named root")
            expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Negative Tests
    
    /** Test getProfile() with text that is too short (less than 100 words). */
    func testProfileWithShortText() {
        let description = "Try to analyze text that is too short (less than 100 words)."
        let expectation = self.expectation(description: description)

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        personalityInsights.getProfile(
            fromText: mobyDickIntro,
            failure: failure,
            success: failWithResult
        )
        waitForExpectations()
    }
}
