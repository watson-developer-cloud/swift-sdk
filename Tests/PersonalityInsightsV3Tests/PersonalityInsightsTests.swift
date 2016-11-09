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

    private var personalityInsightsV3: PersonalityInsights!
    private var mobyDickIntro: String!
    private var kennedySpeech: String!
    private let timeout: TimeInterval = 5.0
    private var version: String = "2016-10-20"
    
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
        let username = Credentials.PersonalityInsightsV3Username
        let password = Credentials.PersonalityInsightsV3Password
        personalityInsightsV3 = PersonalityInsights(username: username, password: password)
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
        
        personalityInsightsV3.getProfile(fromText: kennedySpeech,
                                         failure: failWithError,
                                         success: { profile in
                                            //for preference in profile.personality {
                                                XCTAssertNotNil(profile.personality[0].name)
                                                XCTAssertNotNil(profile.personality[0].trait_id)
                                                expectation.fulfill()
                                           // }
//                                            NSLog("\(profile.personality)")
//                                            for node in profile.consumptionPreferences:
                                            //just check if the value for the key is not nil.
//                                                node.
//                                            profile.consumptionPreferences[0].
                                        },
                                         version: version)

        waitForExpectations()
    }
    
    /** Analyze content items. */
    func testContentItem() {
        let description = "Analyze content items."
        let expectation = self.expectation(description: description)

        let contentItem = PersonalityInsightsV3.ContentItem(
            id: "245160944223793152",
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
        personalityInsightsV3.getProfile(fromContentItems: contentItems,
                                         failure: failWithError,
                                         success: { profile in
//                                            XCTAssertEqual("root", profile.tree.name, "Tree root should be named root")
                                            expectation.fulfill()
            },
                                         version: version)
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

        personalityInsightsV3.getProfile(
            fromText: mobyDickIntro,
            failure: failure,
            success: failWithResult,
            version: version
        )
        waitForExpectations()
    }
}
