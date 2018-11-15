/**
 * Copyright IBM Corporation 2018
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

class SharedTests: XCTestCase {

    func testGetAuthMethodFromBasicAuth() {
        let authMethod1 = Shared.getAuthMethod(username: "user", password: "password")
        XCTAssert(authMethod1 is BasicAuthentication)

        let authMethod2 = Shared.getAuthMethod(username: "apikey", password: "icp-s53f18as793f")
        XCTAssert(authMethod2 is BasicAuthentication)

        let authMethod3 = Shared.getAuthMethod(username: "apikey", password: "password")
        XCTAssert(authMethod3 is IAMAuthentication)
    }

    func testGetAuthMethodFromIAMAuth() {
        let authMethod1 = Shared.getAuthMethod(apiKey: "1234", iamURL: nil)
        XCTAssert(authMethod1 is IAMAuthentication)

        let authMethod2 = Shared.getAuthMethod(apiKey: "icp-as34567as45a76sdf", iamURL: nil)
        XCTAssert(authMethod2 is BasicAuthentication)
    }

    func testConfigureRestRequest() {
        Shared.configureRestRequest()
        let userAgent = RestRequest.userAgent!
        XCTAssert(userAgent.contains(Shared.sdkVersion))

        #if os(iOS)
        XCTAssert(userAgent.contains("iOS"))
        #endif
    }
}
