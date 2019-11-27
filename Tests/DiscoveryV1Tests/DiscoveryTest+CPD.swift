/**
 * (C) Copyright IBM Corp. 2019.
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
import Foundation
// Do not import @testable to ensure only public interface is exposed
import DiscoveryV1

class DiscoveryCPDTests: XCTestCase {

    private var discovery: Discovery!
    private var environment: Environment!
    private let newsEnvironmentID = "system"
    private let newsCollectionID = "news-en"
    private var document: Data!
    private let timeout: TimeInterval = 30.0
    private let unexpectedAggregationTypeMessage = "Unexpected aggregation type"

    // MARK: - Test Configuration

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateDiscovery()
    }

    func instantiateDiscovery() {
        let authenticator = WatsonBearerTokenAuthenticator.init(bearerToken: WatsonCredentials.DiscoveryCPDToken)
        discovery = Discovery(version: versionDate, authenticator: authenticator)

        discovery.serviceURL = WatsonCredentials.DiscoveryCPDURL
        discovery.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        discovery.defaultHeaders["X-Watson-Test"] = "true"

        discovery.disableSSLVerification()
    }

    func loadDocument(name: String, ext: String) -> Data? {
        #if os(Linux)
            let url = URL(fileURLWithPath: "Tests/DiscoveryV1Tests/Resources/" + name + "." + ext)
        #else
            let bundle = Bundle(for: type(of: self))
            guard let url = bundle.url(forResource: name, withExtension: ext) else { return nil }
        #endif
        let data = try? Data(contentsOf: url)
        return data
    }

    // MARK: - Autocomplete tests

    func testAutoComplete() {
        let expectation = self.expectation(description: "Auto complete a statement.")

        discovery.getAutocompletion(environmentID: "default", collectionID: "a6eb02e5-6288-1727-0000-016d91863f52", prefix: "ho") { response, error in
            // check for no error
            if let error = error {
                XCTFail("test failed due to \(error.localizedDescription)")
                return
            }

            guard let result = response?.result else {
                XCTFail("no result")
                return
            }

            XCTAssertEqual(result.completions?.count, 2)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 15)
    }

}
