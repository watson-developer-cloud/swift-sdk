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
import AlchemyDataNewsV1

class AlchemyDataNewsTests: XCTestCase {
    
    private var service: AlchemyDataNews!

    private let timeout: NSTimeInterval = 5.0
    
    override func setUp() {
        super.setUp()
        if let url = NSBundle(forClass: self.dynamicType).pathForResource("Credentials", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: url) as? Dictionary<String, String> {
                let apikey = dict["AlchemyAPIKey"]!
                if service == nil {
                    service = AlchemyDataNews(apiKey: apikey)
                }
            } else {
                XCTFail("Unable to extract dictionary from plist")
            }
        } else {
            XCTFail("Plist file not found")
        }
    }
    
    /** Fail false negatives. */
    func failWithError(error: NSError) {
        XCTFail("Positive test failed with error: \(error)")
    }
    
    /** Fail false positives. */
    func failWithResult<T>(result: T) {
        XCTFail("Negative test returned a result.")
    }
    
    /** Wait for expectations. */
    func waitForExpectations() {
        waitForExpectationsWithTimeout(timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
    // Positive Unit Tests
    
    func testGetNews() {
        let description = "Get the volume of articles within a timeframe"
        let expectation = expectationWithDescription(description)
        
        service.getNews("now-1d", end: "now", failure: failWithError) { news in
            XCTAssertNotNil(news, "Response should not be nil")
            XCTAssertNotNil(news.result!.count, "Count should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetNewsWithQuery() {
        let description = "Get articles with IBM in the title and assorted values"
        let expectation = expectationWithDescription(description)
        
        var queryDict = [String: String]()
        queryDict["q.enriched.url.title"] = "O[IBM^Apple]"
        queryDict["return"] = "enriched.url.title,enriched.url.entities.entity.text,enriched.url.entities.entity.type"
        
        service.getNews("now-1d", end: "now", query: queryDict, failure: failWithError) { news in
            XCTAssertNotNil(news, "Response should not be nil")
            XCTAssertNil(news.result?.count, "Count should not return")
            XCTAssertNotNil(news.result?.docs?[0].id, "Document ID should not be nil")
            XCTAssertNotNil(news.result?.docs?[0].source?.enriched?.url?.title, "Title should not be nil")
            XCTAssertNotNil(news.result?.docs?[0].source?.enriched?.url?.entities![0].text, "Entity text should not be nil")
            XCTAssertNotNil(news.result?.docs?[0].source?.enriched?.url?.entities![0].type, "Entity type should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    // Negative Unit Tests
    
    func testGetNewsWithInvalidQuery() {
        let description = "Use an invalid retrun key"
        let expectation = expectationWithDescription(description)
        
        var queryDict = [String: String]()
        queryDict["q.enriched.url.apple"] = "O[IBM^Apple]"
        queryDict["return"] = "enriched.url.title"
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            XCTAssertEqual(error.localizedDescription, "Invalid field = 'enriched.url.apple'")
            expectation.fulfill()
        }
        
        service.getNews("now-1d", end: "now", query: queryDict, failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
    func testGetNewsWithInvalidReturnQuery() {
        let description = "Use an invalid retrun key"
        let expectation = expectationWithDescription(description)
        
        var queryDict = [String: String]()
        queryDict["q.enriched.url.title"] = "O[IBM^Apple]"
        queryDict["return"] = "enriched.url.hotdog"
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            XCTAssertEqual(error.localizedDescription, "Invalid field = 'enriched.url.hotdog'")
            expectation.fulfill()
        }
        
        service.getNews("now-1d", end: "now", query: queryDict, failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
    func testGetNewsInvalidTimeframe() {
        let description = "Get the volume of articles within a timeframe"
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            XCTAssertEqual(error.localizedDescription, "Invalid timestamp range")
            expectation.fulfill()
        }
        
        service.getNews("now", end: "now-1d", failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
}
