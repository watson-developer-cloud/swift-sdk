/**
 * Copyright IBM Corporation 2015
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
@testable import WatsonDeveloperCloud

class PersonalityInsightsTests: XCTestCase {
    
    // MARK: - Parameters and Constants
    
    // the PersonalityInsights service
    var service: PersonalityInsights!
    
    // sample text
    var mobyDickIntro: String!
    var kennedySpeech: String!
    
    // timeout for asynchronous completion handlers
    let timeout: NSTimeInterval = 30.0
    
    // MARK: - Test Configuration
    
    // Load credentials, load sample files, and instantiate PersonalityInsights service
    override func setUp() {
        super.setUp()
        
        // identify credentials file
        let bundle = NSBundle(forClass: self.dynamicType)
        guard let credentialsURL = bundle.pathForResource("Credentials", ofType: "plist") else {
            XCTFail("Unable to locate credentials file.")
            return
        }
        
        // load credentials file
        let dict = NSDictionary(contentsOfFile: credentialsURL)
        guard let credentials = dict as? Dictionary<String, String> else {
            XCTFail("Unable to read credentials file.")
            return
        }
        
        // identify the sample text files
        guard let mobyDickIntroURL = bundle.pathForResource("MobyDickIntro", ofType: "txt") else {
            XCTFail("Unable to locate MobyDickIntro file.")
            return
        }
        guard let kennedySpeechURL = bundle.pathForResource("KennedySpeech", ofType: "txt") else {
            XCTFail("Unable to locate KennedySpeech file.")
            return
        }
        
        // load sample text files
        do {
            mobyDickIntro = try String(contentsOfFile: mobyDickIntroURL)
            kennedySpeech = try String(contentsOfFile: kennedySpeechURL)
        } catch {
            XCTFail("Unable to read sample text files.")
        }
        
        // read PersonalityInsights username
        guard let user = credentials["PersonalityInsightsUsername"] else {
            XCTFail("Unable to read Personality Insights username.")
            return
        }
        
        // read PersonalityInsights password
        guard let password = credentials["PersonalityInsightsPassword"] else {
            XCTFail("Unable to read Personality Insights password.")
            return
        }
        
        // instantiate the service
        if service == nil {
            service = PersonalityInsights(username: user, password: password)
        }
    }
    
    // Wait for an expectation to be fulfilled.
    func waitForExpectation() {
        waitForExpectationsWithTimeout(timeout) { error in
            XCTAssertNil(error, "Timeout.")
        }
    }
    
    // MARK: - Positive Tests
    
    // Analyze the text of Kennedy's speech.
    func testProfile() {
        let description = "Analyze the text of Kennedy's speech."
        let expectation = expectationWithDescription(description)
        
        // analyze speech
        service.getProfile(kennedySpeech) { profile, error in
            
            // verify expected response
            XCTAssertNotNil(profile)
            XCTAssertNil(error)
            
            // ensure profile is as expected
            XCTAssertNotNil(profile, "Profile should not be nil")
            XCTAssertEqual("root", profile!.tree!.name, "Tree root should be named root")
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // Analyze a content item.
    func testContentItem() {
        let description = "Analyze a content item."
        let expectation = expectationWithDescription(description)
        
        // define content item
        let contentItem = PersonalityInsights.ContentItem(
            ID: "245160944223793152",
            userID: "Bob",
            sourceID: "Twitter",
            created: 1427720427,
            updated: 1427720427,
            contentType: MediaType.Plain.rawValue,
            charset: "UTF-8",
            language: "en-us",
            content: kennedySpeech,
            parentID: "",
            reply: false,
            forward: false)
        
        // analyze duplicate content items
        service.getProfile([contentItem, contentItem]) { profile, error in
            
            // verify expected response
            XCTAssertNotNil(profile)
            XCTAssertNil(error)
            
            // ensure profile is as expected
            XCTAssertNotNil(profile, "Profile should not be nil")
            XCTAssertEqual("root", profile!.tree!.name, "Tree root should be named root")
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // MARK: - Negative Tests
    
    // Test getProfile() with text that is too short (less than 100 words).
    func testProfileWithShortText() {
        let description = "Try to analyze text that is too short (less than 100 words)."
        let expectation = expectationWithDescription(description)
        
        service.getProfile(mobyDickIntro) { profile, error in
            // verify expected response
            XCTAssertNil(profile)
            XCTAssertNotNil(error)
            
            // ensure error is as expected
            XCTAssert(error!.code == 400)
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
}