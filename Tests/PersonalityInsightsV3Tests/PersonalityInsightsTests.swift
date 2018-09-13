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

// swiftlint:disable function_body_length force_try force_unwrapping file_length

import XCTest
import PersonalityInsightsV3

class PersonalityInsightsTests: XCTestCase {

    private var personalityInsights: PersonalityInsights!
    private var text: String!
    private var html: String!
    private var short: String!

    static var allTests: [(String, (PersonalityInsightsTests) -> () throws -> Void)] {
        return [
            ("testProfileText", testProfileText),
            ("testProfileHTML", testProfileHTML),
            ("testProfileContent", testProfileContent),
            ("testProfileAsCsvText", testProfileAsCsvText),
            ("testProfileAsCsvContent", testProfileAsCsvContent),
            ("testProfileAsCsvText", testProfileAsCsvText),
            ("testNeedsAndConsumptionPreferences", testNeedsAndConsumptionPreferences),
            ("testProfileWithShortText", testProfileWithShortText),
        ]
    }

    // MARK: - Test Configuration

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiatePersonalityInsights()
        loadTestResources()
    }

    func instantiatePersonalityInsights() {
        let version = "2018-09-14"
        if let apiKey = WatsonCredentials.PersonalityInsightsV3APIKey {
            personalityInsights = PersonalityInsights(version: version, apiKey: apiKey)
        } else {
            let username = WatsonCredentials.PersonalityInsightsV3Username
            let password = WatsonCredentials.PersonalityInsightsV3Password
            personalityInsights = PersonalityInsights(username: username, password: password, version: version)
        }
        if let url = WatsonCredentials.PersonalityInsightsV3URL {
            personalityInsights.serviceURL = url
        }
        personalityInsights.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        personalityInsights.defaultHeaders["X-Watson-Test"] = "true"
    }

    func load(forResource resource: String, ofType ext: String) -> String? {
        #if os(Linux)
            let file = URL(fileURLWithPath: "Tests/PersonalityInsightsV3Tests/" + resource + "." + ext).path
            return try? String(contentsOfFile: file, encoding: .utf8)
        #else
            let bundle = Bundle(for: type(of: self))
            guard let file = bundle.path(forResource: resource, ofType: ext) else {
                XCTFail("Unable to locate \(resource).\(ext) file.")
                return nil
            }
            return try? String(contentsOfFile: file)
        #endif
    }

    public func loadTestResources() {
        self.text = load(forResource: "KennedySpeech", ofType: "txt")
        self.html = load(forResource: "KennedySpeech", ofType: "html")
        self.short = load(forResource: "MobyDickIntro", ofType: "txt")
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

    func testProfileText() {
        let expectation = self.expectation(description: "profile(text:)")
        personalityInsights.profile(text: text, failure: failWithError) { profile in
            for preference in profile.personality {
                XCTAssertNotNil(preference.name)
                break
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testProfileHTML() {
        let expectation = self.expectation(description: "profile(html:)")
        personalityInsights.profile(html: html, failure: failWithError) { profile in
            for preference in profile.personality {
                XCTAssertNotNil(preference.name)
                break
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testProfileContent() {
        let expectation = self.expectation(description: "profile(content:)")
        let contentItem = ContentItem(
            content: text,
            id: "245160944223793152",
            created: 1427720427,
            updated: 1427720427,
            contenttype: "text/plain",
            language: "en",
            parentid: "",
            reply: false,
            forward: false
        )
        let content = Content(contentItems: [contentItem])
        personalityInsights.profile(content: content, failure: failWithError) { profile in
            if let behaviors = profile.behavior {
                for behavior in behaviors {
                    XCTAssertNotNil(behavior.traitID)
                }
                expectation.fulfill()
            }
        }
        waitForExpectations()
    }

    func testProfileAsCsvText() {
        let expectation = self.expectation(description: "profile(text:)")
        personalityInsights.profileAsCsv(text: text, failure: failWithError) { csv in
            XCTAssertGreaterThan(csv.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testProfileAsCsvHTML() {
        let expectation = self.expectation(description: "profile(html:)")
        personalityInsights.profileAsCsv(html: html, failure: failWithError) { csv in
            XCTAssertGreaterThan(csv.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testProfileAsCsvContent() {
        let expectation = self.expectation(description: "profile(content:)")
        let contentItem = ContentItem(
            content: text,
            id: "245160944223793152",
            created: 1427720427,
            updated: 1427720427,
            contenttype: "text/plain",
            language: "en",
            parentid: "",
            reply: false,
            forward: false
        )
        let content = Content(contentItems: [contentItem])
        personalityInsights.profileAsCsv(content: content, failure: failWithError) { csv in
            XCTAssertGreaterThan(csv.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testNeedsAndConsumptionPreferences() {
        let expectation = self.expectation(description: "profile(text:)")
        personalityInsights.profile(text: text, rawScores: true, consumptionPreferences: true, failure: failWithError) {
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
                    XCTAssertNotNil(consumption.consumptionPreferenceCategoryID)
                    XCTAssertNotNil(node.score)
                    expectation.fulfill()
                    return

                }
            }
        }
        waitForExpectations()
    }

    // MARK: - Negative Tests

    func testProfileWithShortText() {
        let expectation = self.expectation(description: "profile(text:)")
        let failure = { (error: Error) in expectation.fulfill() }
        personalityInsights.profile(text: short, failure: failure, success: failWithResult)
        waitForExpectations()
    }
}
