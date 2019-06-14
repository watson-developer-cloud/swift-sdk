/**
 * (C) Copyright IBM Corp. 2018, 2019.
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
import RestKit
@testable import DiscoveryV1

class DiscoveryUnitTests: XCTestCase {

    private var discovery: Discovery!
    private let timeout = 1.0

    override func setUp() {
        discovery = Discovery(version: versionDate, accessToken: accessToken)
        #if !os(Linux)
        let configuration = URLSessionConfiguration.ephemeral
        #else
        let configuration = URLSessionConfiguration.default
        #endif
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: configuration)
        discovery.session = mockSession
    }

    // MARK: - Inject Credentials

    #if os(Linux)
    func testInjectCredentialsFromFile() {
        setenv("IBM_CREDENTIALS_FILE", "Source/SupportingFiles/ibm-credentials.env", 1)
        let discovery = Discovery(version: versionDate)
        XCTAssertNotNil(discovery)
        XCTAssert(discovery?.authMethod is BasicAuthentication)
    }
    #endif
}

#if os(Linux)
extension DiscoveryUnitTests {

    static var allTests: [(String, (DiscoveryUnitTests) -> () throws -> ())] {
        let tests: [(String, (DiscoveryUnitTests) -> () throws -> Void)] = [
            // Inject Credentials
            ("testInjectCredentialsFromFile", testInjectCredentialsFromFile),
        ]
        return tests
    }
}
#endif
