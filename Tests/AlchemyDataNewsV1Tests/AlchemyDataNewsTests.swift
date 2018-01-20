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
import AlchemyDataNewsV1

class AlchemyDataNewsTests: XCTestCase {

    private var alchemyDataNews: AlchemyDataNews!

    static var allTests: [(String, (AlchemyDataNewsTests) -> () throws -> Void)] {
        return [
            ("testGetNews", testGetNews),
            ("testGetNewsWithQuery", testGetNewsWithQuery),
            ("testGetNewsWithInvalidQuery", testGetNewsWithInvalidQuery),
            ("testGetNewsWithInvalidReturnQuery", testGetNewsWithInvalidReturnQuery),
            ("testGetNewsInvalidTimeframe", testGetNewsInvalidTimeframe)
        ]
    }

    override func setUp() {
        super.setUp()
        alchemyDataNews = AlchemyDataNews(apiKey: Credentials.AlchemyAPIKey)
        alchemyDataNews.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        alchemyDataNews.defaultHeaders["X-Watson-Test"] = "true"
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

    // Positive Unit Tests

    func testGetNews() {
        let description = "Get the volume of articles within a timeframe"
        let expectation = self.expectation(description: description)

        alchemyDataNews.getNews(from: "now-1d", to: "now", failure: failWithError) { news in
            XCTAssertNotNil(news, "Response should not be nil")
            XCTAssertNotNil(news.result!.count, "Count should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testGetNewsWithQuery() {
        let description = "Get articles with IBM in the title and assorted values"
        let expectation = self.expectation(description: description)

        var queryDict = [String: String]()
        queryDict["q.enriched.url.title"] = "O[IBM^Apple]"
        queryDict["return"] = "enriched.url.title,enriched.url.entities.entity.text,enriched.url.entities.entity.type"

        alchemyDataNews.getNews(from: "now-1d", to: "now", query: queryDict, failure: failWithError) { news in
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
        let description = "Use an invalid return key"
        let expectation = self.expectation(description: description)

        var queryDict = [String: String]()
        queryDict["q.enriched.url.apple"] = "O[IBM^Apple]"
        queryDict["return"] = "enriched.url.title"

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        alchemyDataNews.getNews(from: "now-1d", to: "now", query: queryDict, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    func testGetNewsWithInvalidReturnQuery() {
        let description = "Use an invalid return key"
        let expectation = self.expectation(description: description)

        var queryDict = [String: String]()
        queryDict["q.enriched.url.title"] = "O[IBM^Apple]"
        queryDict["return"] = "enriched.url.hotdog"

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        alchemyDataNews.getNews(from: "now-1d", to: "now", query: queryDict, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    func testGetNewsInvalidTimeframe() {
        let description = "Get the volume of articles within a timeframe"
        let expectation = self.expectation(description: description)

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        alchemyDataNews.getNews(from: "now", to: "now-1d", failure: failure, success: failWithResult)
        waitForExpectations()
    }

}
