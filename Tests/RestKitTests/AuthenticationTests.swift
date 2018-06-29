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

// swiftlint:disable function_body_length force_try force_unwrapping file_length

import XCTest

class AuthenticationTests: XCTestCase {

    static var allTests = [
        ("testNoAuthentication", testNoAuthentication),
        ("testBasicAuthentication", testBasicAuthentication),
        ("testAPIKeyAuthenticationHeader", testAPIKeyAuthenticationHeader),
        ("testAPIKeyAuthenticationQuery", testAPIKeyAuthenticationQuery),
        ("testIAMAccessToken", testIAMAccessToken),
        ("testIAMToken", testIAMToken),
        ("testIAMAuthentication", testIAMAuthentication),
    ]

    internal static func errorResponseDecoder(data: Data, response: HTTPURLResponse) -> Error {
        let genericMessage = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
        return RestError.failure(response.statusCode, genericMessage)
    }

    var request = RestRequest(
        session: URLSession(configuration: URLSessionConfiguration.default),
        authMethod: NoAuthentication(),
        errorResponseDecoder: errorResponseDecoder,
        method: "GET",
        url: "http://www.example.com",
        headerParameters: ["x-custom-header": "value"],
        queryItems: [URLQueryItem(name: "name", value: "value")],
        messageBody: "hello-world".data(using: .utf8)
    )

    func testNoAuthentication() {
        request.authMethod = NoAuthentication()
        request.authMethod.authenticate(request: request) { request, error in
            guard let request = request, error == nil else { XCTFail(error!.localizedDescription); return }
            XCTAssertEqual(self.request.method, request.method)
            XCTAssertEqual(self.request.url, request.url)
            XCTAssertEqual(self.request.headerParameters, request.headerParameters)
            XCTAssertEqual(self.request.queryItems, request.queryItems)
            XCTAssertEqual(self.request.messageBody, request.messageBody)
        }
    }

    func testBasicAuthentication() {
        let authentication = "Basic dXNlcm5hbWU6cGFzc3dvcmQ="
        request.authMethod = BasicAuthentication(username: "username", password: "password")
        request.authMethod.authenticate(request: request) { request, error in
            guard let request = request, error == nil else { XCTFail(error!.localizedDescription); return }
            XCTAssertEqual(self.request.method, request.method)
            XCTAssertEqual(self.request.url, request.url)
            XCTAssertEqual(request.headerParameters["x-custom-header"], "value")
            XCTAssertEqual(request.headerParameters["Authorization"], authentication)
            XCTAssertEqual(self.request.queryItems, request.queryItems)
            XCTAssertEqual(self.request.messageBody, request.messageBody)
        }
    }

    func testAPIKeyAuthenticationHeader() {
        request.authMethod = APIKeyAuthentication(name: "foo", key: "bar", location: .header)
        request.authMethod.authenticate(request: request) { request, error in
            guard let request = request, error == nil else { XCTFail(error!.localizedDescription); return }
            XCTAssertEqual(self.request.method, request.method)
            XCTAssertEqual(self.request.url, request.url)
            XCTAssertEqual(request.headerParameters["x-custom-header"], "value")
            XCTAssertEqual(request.headerParameters["foo"], "bar")
            XCTAssertEqual(self.request.queryItems, request.queryItems)
            XCTAssertEqual(self.request.messageBody, request.messageBody)
        }
    }

    func testAPIKeyAuthenticationQuery() {
        request.authMethod = APIKeyAuthentication(name: "foo", key: "bar", location: .query)
        request.authMethod.authenticate(request: request) { request, error in
            guard let request = request, error == nil else { XCTFail(error!.localizedDescription); return }
            XCTAssertEqual(self.request.method, request.method)
            XCTAssertEqual(self.request.url, request.url)
            XCTAssertEqual(self.request.headerParameters, request.headerParameters)
            XCTAssertEqual(self.request.queryItems[0], request.queryItems[0])
            XCTAssertEqual(request.queryItems[1].name, "foo")
            XCTAssertEqual(request.queryItems[1].value, "bar")
            XCTAssertEqual(self.request.messageBody, request.messageBody)
        }
    }

    func testIAMAccessToken() {
        request.authMethod = IAMAccessToken(accessToken: "access-token")
        request.authMethod.authenticate(request: request) { request, error in
            guard let request = request, error == nil else { XCTFail(error!.localizedDescription); return }
            XCTAssertEqual(self.request.method, request.method)
            XCTAssertEqual(self.request.url, request.url)
            XCTAssertEqual(request.headerParameters["x-custom-header"], "value")
            XCTAssertEqual(request.headerParameters["Authorization"], "Bearer access-token")
            XCTAssertEqual(self.request.queryItems, request.queryItems)
            XCTAssertEqual(self.request.messageBody, request.messageBody)
        }
    }

    func testIAMToken() {

        // To run this test:
        // 1. Set `IAMToken` access level to `internal`
        // 2. Uncomment the code below

        // The `private` access level of the `IAMToken` makes it difficult to test. However, it should
        // remain `private` because it should not be used by any class outside of `Authentication.swift`.
        // You can test the token, though, by temporarily changing its access level to `internal` and
        // uncommenting the code below.

        /**

        // test JSON decoding
        let json = """
        {
            "access_token": "foo",
            "refresh_token":"bar",
            "token_type": "Bearer",
            "expires_in": 3600,
            "expiration": 1524754769
        }
        """
        let token1 = try! JSONDecoder().decode(IAMToken.self, from: json.data(using: .utf8)!)
        XCTAssertEqual(token1.accessToken, "foo")
        XCTAssertEqual(token1.refreshToken, "bar")
        XCTAssertEqual(token1.tokenType, "Bearer")
        XCTAssertEqual(token1.expiresIn, 3600)
        XCTAssertEqual(token1.expiration, 1524754769)

        // test both access token and refresh token expired
        let token2 = IAMToken(
            accessToken: "access-token",
            refreshToken: "refresh-token",
            tokenType: "token-type",
            expiresIn: 3600,
            expiration: 0
        )
        XCTAssertTrue(token2.isAccessTokenExpired)
        XCTAssertTrue(token2.isRefreshTokenExpired)

        // test access token expired, but not refresh token
        // (set expiration in the future, but before the 20% refresh buffer)
        let token3 = IAMToken(
            accessToken: "access-token",
            refreshToken: "refresh-token",
            tokenType: "token-type",
            expiresIn: 3600,
            expiration: Int(Date().addingTimeInterval(3600 * 0.19).timeIntervalSince1970)
        )
        XCTAssertTrue(token3.isAccessTokenExpired)
        XCTAssertFalse(token3.isRefreshTokenExpired)

        // test neither access token nor refresh token expired
        // (set expiration in the future, but just after the 20% refresh buffer)
        let token4 = IAMToken(
            accessToken: "access-token",
            refreshToken: "refresh-token",
            tokenType: "token-type",
            expiresIn: 3600,
            expiration: Int(Date().addingTimeInterval(3600 * 0.21).timeIntervalSince1970)
        )
        XCTAssertFalse(token4.isAccessTokenExpired)
        XCTAssertFalse(token4.isRefreshTokenExpired)

        */
    }

    func testIAMAuthentication() {

        // To run this test:
        // 1. Set `IAMToken` access level to `internal`
        // 2. Set `IAMAuthentication.token` access level to `internal`
        // 3. Uncomment the code below

        // The `private` access level of the properties and functions in `IAMAuthentication` prohibit us from
        // modifying/calling them directly. As a result, this is hard to test properly (particularly token refresh).
        // One alternative would be to make the access level `internal` instead of `private`. Or we might be able to
        // build a `RestKit` framework and import it using `@testable RestKit` in order to access private members.

        /**

        let authMethod = IAMAuthentication(apiKey: Credentials.IAMAPIKey, url: Credentials.IAMURL)
        var authorizationHeader: String! // save initial authorization header (it should stay the same until refreshed)
        request.authMethod = authMethod

        // request initial iam token
        let expectation1 = self.expectation(description: "request initial iam token")
        request.authMethod.authenticate(request: request) { request, error in
            guard let request = request, error == nil else { XCTFail(error!.localizedDescription); return }
            XCTAssertEqual(self.request.method, request.method)
            XCTAssertEqual(self.request.url, request.url)
            XCTAssertEqual(request.headerParameters["x-custom-header"], "value")
            XCTAssertTrue(request.headerParameters["Authorization"]!.starts(with: "Bearer "))
            XCTAssertEqual(self.request.queryItems, request.queryItems)
            XCTAssertEqual(self.request.messageBody, request.messageBody)
            authorizationHeader = request.headerParameters["Authorization"]!
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 5)

        // use the same iam token
        let expectation2 = self.expectation(description: "use the same iam token")
        request.authMethod.authenticate(request: request) { request, error in
            guard let request = request, error == nil else { XCTFail(error!.localizedDescription); return }
            XCTAssertEqual(request.headerParameters["Authorization"]!, authorizationHeader)
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 5)

        sleep(1) // sleep for 1 second to make sure the unix time stamp increments

        // change the token's expiration date to force a refresh
        let token = IAMToken(
            accessToken: authMethod.token!.accessToken,
            refreshToken: authMethod.token!.refreshToken,
            tokenType: authMethod.token!.tokenType,
            expiresIn: authMethod.token!.expiresIn,
            expiration: Int(Date().timeIntervalSince1970)
        )
        authMethod.token = token

        // refresh the iam token
        let expectation3 = self.expectation(description: "refresh the iam token")
        request.authMethod.authenticate(request: request) { request, error in
            guard let request = request, error == nil else { XCTFail(error!.localizedDescription); return }
            XCTAssertTrue(request.headerParameters["Authorization"]!.starts(with: "Bearer "))
            XCTAssertNotEqual(request.headerParameters["Authorization"]!, authorizationHeader)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: 5)

        */
    }
}
