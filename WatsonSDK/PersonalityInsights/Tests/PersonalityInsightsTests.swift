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
@testable import WatsonSDK

class PersonalityInsightsTests: XCTestCase {
    
    /// Language translation service
    private let service = PersonalityInsights()
    private var inputText:String?
    /// Timeout for an asynchronous call to return before failing the unit test
    private let timeout: NSTimeInterval = 30.0
    
    override func setUp() {
        super.setUp()
        if let url = NSBundle(forClass: self.dynamicType).pathForResource("Credentials", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: url) as? Dictionary<String, String> {
                service.setUsernameAndPassword(dict["PersonalityInsightsUsername"]!, password: dict["PersonalityInsightsPassword"]!)
                //Read long input text from plist file
                inputText=dict["Input Text"]
            } else {
                XCTFail("Unable to extract dictionary from plist")
            }
        } else {
            XCTFail("Plist file not found")
        }
    }
    
    /**
     Test getProfile() using a text input
     */
    func testProfileWithText() {
        let notEnoughWords = expectationWithDescription("NotEnoughWords")
        let valid = expectationWithDescription("Valid")
        
        let text = "Call me Ishmael. Some years ago-never mind how long precisely-having little or no money in my purse, and nothing particular to interest me on shore, I thought I would sail about a little and see the watery part of the world. It is a way I have of driving off the spleen and regulating the circulation. Whenever I find myself growing grim about the mouth; whenever it is a damp, drizzly November in my soul; whenever I find myself involuntarily pausing before coffin warehouses, and bringing up the rear of every funeral I meet; and especially whenever my hypos get such an upper hand of me, that it requires a strong moral principle to prevent me from deliberately stepping into the street, and methodically knocking people's hats off-then, I account it high time to get to sea as soon as I can."
        
        service.getProfile(text, callback:{(profile:Profile?, error) in
            XCTAssertEqual(profile!.ID, nil, "Expect classifierid to be nil")
            XCTAssertEqual(error!.code, 400, "Expect 400 error code")
            notEnoughWords.fulfill()
        })

        service.getProfile(inputText!, callback:{(profile, error) in
            XCTAssertNotNil(profile,"Profile should not be nil")
            XCTAssertEqual("root",profile!.tree!.name,"Tree root should be named root")
            valid.fulfill()
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }

    /**
     Test getProfile() using content item objects
     */
    func testProfileWithContentItems() {
        let valid = expectationWithDescription("Valid")
        
        let id = "245160944223793152"
        let userid = "bob"
        let sourceid = "twitter"
        let created = 1427720427
        let updated = 1427720427
        let contenttype = "text/plain"
        let charset = "UTF-8"
        let language = "en-us"
        let content = inputText!
        let parentid = ""
        let reply = false
        let forward = false
        
        let contentItem = ContentItem(ID:id, userID:userid, sourceID:sourceid, created:created, updated:updated, contentType:contenttype, charset:charset, language:language, content:content, parentID:parentid, reply:reply, forward:forward)
        
        //Test an array of two elements (same values)
        let contentItems = [contentItem, contentItem]
        
        service.getProfile(contentItems, includeRaw: true, language: "en", acceptLanguage: "en", callback:{(profile, error) in
            XCTAssertNotNil(profile,"Profile should not be nil")
            XCTAssertEqual("root",profile!.tree!.name,"Tree root should be named root")
            valid.fulfill()
        })
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    }
}