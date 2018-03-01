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

// swiftlint:disable function_body_length force_try force_unwrapping superfluous_disable_command

import XCTest
import PersonalityInsightsV3

class PersonalityInsightsTests: XCTestCase {

    private var personalityInsights: PersonalityInsights!
    private var mobyDickIntro: String?
    private var kennedySpeechTXT: String?
    private var kennedySpeechHTML: String?
    private var version: String = "2016-10-20"

    static var allTests: [(String, (PersonalityInsightsTests) -> () throws -> Void)] {
        return [
            ("testProfile", testProfile),
            ("testContentItem", testContentItem),
            ("testHTMLProfile", testHTMLProfile),
            ("testNeedsAndConsumptionPreferences", testNeedsAndConsumptionPreferences),
            ("testProfileWithShortText", testProfileWithShortText),
        ]
    }

    // MARK: - Test Configuration

    /** Set up for each test by loading text files and instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiatePersonalityInsights()
        loadTestResources()
    }

    /** Instantiate Personality Insights. */
    func instantiatePersonalityInsights() {
        let username = Credentials.PersonalityInsightsV3Username
        let password = Credentials.PersonalityInsightsV3Password
        personalityInsights = PersonalityInsights(username: username, password: password, version: version)
        personalityInsights.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        personalityInsights.defaultHeaders["X-Watson-Test"] = "true"
    }

    /** Load external files to test. Fails if unable to locate file. */
    func load(forResource resource: String, ofType ext: String) -> String? {
        #if os(iOS)
            let bundle = Bundle(for: type(of: self))
            guard let file = bundle.path(forResource: resource, ofType: ext) else {
                XCTFail("Unable to locate \(resource).\(ext) file.")
                return nil
            }
            return try? String(contentsOfFile: file)
        #else
            let file = URL(fileURLWithPath: "Tests/PersonalityInsightsV3Tests/" + resource + "." + ext).path
            return try? String(contentsOfFile: file, encoding: .utf8)
        #endif
    }

    /** Load all testing resources required to run the tests. */
    public func loadTestResources() {
        self.mobyDickIntro = load(forResource: "MobyDickIntro", ofType: "txt")
        self.kennedySpeechTXT = load(forResource: "KennedySpeech", ofType: "txt")
        self.kennedySpeechHTML = load(forResource: "KennedySpeech", ofType: "html")
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
    func waitForExpectations(timeout: TimeInterval = 5.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: - Positive Tests

    /** Analyze the text of Kennedy's speech. */
    func testProfile() {
        let description = "Analyze the text of Kennedy's speech."
        let expectation = self.expectation(description: description)

        guard let kennedySpeech = kennedySpeechTXT else {
            XCTFail("Unable to read KennedySpeech.txt file.")
            return
        }
        personalityInsights.getProfile(fromText: kennedySpeech,
                                         failure: failWithError)
        {
            profile in
            for preference in profile.personality {
                XCTAssertNotNil(preference.name)
                break
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Analyze the HTML text of Kennedy's speech. */
    func testHTMLProfile() {
        let description = "Analyze the HTML text of Kennedy's speech."
        let expectation = self.expectation(description: description)

        guard let kennedySpeech = kennedySpeechHTML else {
            XCTFail("Unable to read KennedySpeech.html file.")
            return
        }
        personalityInsights.getProfile(fromHTML: kennedySpeech,
                                       failure: failWithError)
        {
            profile in
            for preference in profile.personality {
                XCTAssertNotNil(preference.name)
                break
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Analyze content items. */
    func testContentItem() {
        let description = "Analyze content items."
        let expectation = self.expectation(description: description)

        guard let kennedySpeech = kennedySpeechTXT else {
            XCTFail("Unable to read KennedySpeech.txt file.")
            return
        }

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

    /** Analyze needs and consumption preferences. */
    func testNeedsAndConsumptionPreferences() {
        let description = "Analyze needs and consumption preferences."
        let expectation = self.expectation(description: description)

        guard let kennedySpeech = kennedySpeechTXT else {
            XCTFail("Unable to read KennedySpeech.txt file.")
            return
        }

        personalityInsights.getProfile(fromText: kennedySpeech,
                                       rawScores: true,
                                       consumptionPreferences: true,
                                       failure: failWithError)
        {
            profile in
            for need in profile.needs {
                XCTAssertNotNil(need.rawScore)
                break
            }
            guard let preferences = profile.consumptionPreferences else {
                XCTAssertNotNil(profile.consumptionPreferences)
                return
            }
            for consumption in preferences {
                for node in consumption.consumptionPreferences {
                    XCTAssertNotNil(consumption.consumptionPreferenceCategoryId)
                    XCTAssertNotNil(node.score)
                    expectation.fulfill()
                    return

                }
            }
        }
        waitForExpectations()
    }

    // MARK: - Negative Tests

    /** Test getProfile() with text that is too short (less than 100 words). */
    func testProfileWithShortText() {
        let description = "Try to analyze text that is too short (less than 100 words)."
        let expectation = self.expectation(description: description)

        guard let mobyDickIntro = mobyDickIntro else {
            XCTFail("Unable to read MobyDickIntro.txt file.")
            return
        }

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
