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
import PersonalityInsightsV3

class PersonalityInsightsTests: XCTestCase {

    private var personalityInsights: PersonalityInsights!
    private var mobyDickIntro: String!
    private var kennedySpeech: String!
    private let timeout: TimeInterval = 5.0
    private var version: String = "2016-10-20"

    static var allTests : [(String, (PersonalityInsightsTests) -> () throws -> Void)] {
        return [
            ("testProfile", testProfile),
            ("testContentItem", testContentItem),
            ("testProfileWithShortText", testProfileWithShortText),
            ("testConsumptionPreferences", testConsumptionPreferences)
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
        let username = Credentials.PersonalityInsightsV3Username
        let password = Credentials.PersonalityInsightsV3Password
        personalityInsights = PersonalityInsights(username: username, password: password, version: version)
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

        personalityInsights.getProfile(fromText: kennedySpeech,
                                         failure: failWithError)
        {
            profile in
            for preference in profile.personality {
                XCTAssertEqual("Openness", preference.name)
                break
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Analyze consumption preferences. */
    func testConsumptionPreferences() {
        let description = "Analyze consumption preferences."
        let expectation = self.expectation(description: description)

        personalityInsights.getProfile(fromText: kennedySpeech,
                                         consumptionPreferences: true,
                                         failure: failWithError)
        {
            profile in
            guard let preferences = profile.consumptionPreferences else {
                XCTFail("No consumption preferences found.")
                return
            }
            for consumption in preferences {
                for node in consumption.consumptionPreferences {
                    XCTAssertEqual("consumption_preferences_shopping", consumption.consumptionPreferenceCategoryId)
                    XCTAssertNotNil(node.score)
                    expectation.fulfill()
                    return
                    
                }
            }
        }
        waitForExpectations()
    }

    /** Analyze content items. */
    func testContentItem() {
        let description = "Analyze content items."
        let expectation = self.expectation(description: description)

        let contentItem = PersonalityInsightsV3.ContentItem(
            content: kennedySpeech,
            id: "245160944223793152",
            created: 1427720427,
            updated: 1427720427,
            contentType: "text/plain",
            language: "en",
            parentID: "",
            reply: false,
            forward: false
        )

        let contentItems = [contentItem, contentItem]
        personalityInsights.getProfile(fromContentItems: contentItems,
                                         failure: failWithError)
        {
            profile in
            if let behaviors = profile.behavior {
                for behavior in behaviors {
                    XCTAssertNotNil(behavior.traitID)
                }
                expectation.fulfill()
            }
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
