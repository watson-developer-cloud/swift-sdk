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
import Foundation
import VisualRecognitionV3

class VisualRecognitionWithIAMTests: XCTestCase {

    private let timeout: TimeInterval = 45.0

    static var allTests: [(String, (VisualRecognitionWithIAMTests) -> () throws -> Void)] {
        return [
            ("testAccessWithAPIKey", testAccessWithAPIKey),
            ("testAccessWithAccessToken", testAccessWithAccessToken),
        ]
    }

    private let ginniURL = "https://watson-developer-cloud.github.io/doc-tutorial-downloads/" +
        "visual-recognition/Ginni_Rometty_at_the_Fortune_MPW_Summit_in_2011.jpg"
    private let obamaURL = "https://www.whitehouse.gov/sites/whitehouse.gov/files/images/" +
        "Administration/People/president_official_portrait_lores.jpg"
    private let trumpURL = "https://watson-developer-cloud.github.io/doc-tutorial-downloads/" +
        "visual-recognition/prez-trump.jpg"

    /** Get access token using IAM API Key. */
    func getTokenInfo(apiKey: String, refreshToken: String? = nil) -> [String: Any]? {
        // swiftlint:disable force_unwrapping
        let url = URL(string: "https://iam.ng.bluemix.net/identity/token")!
        let auth = "bx:bx".data(using: String.Encoding.utf8)!.base64EncodedString()
        // swiftlint:enable force_unwrapping
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json"]
        request.addValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        let formBody: String
        if let refreshToken = refreshToken {
            formBody = "grant_type=refresh_token&refresh_token=\(refreshToken)"
        } else {
            formBody = "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=\(apiKey)&response_type=cloud_iam"
        }
        request.httpBody = formBody.data(using: .utf8)

        let expectation = self.expectation(description: "getAccessToken")

        var tokenInfo: [String: Any]?
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let data = data {
                do {
                    // Convert the data to JSON
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        tokenInfo = json
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            expectation.fulfill()
        }
        task.resume()
        waitForExpectations(timeout: timeout)

        return tokenInfo
    }

    // MARK: - Positive Tests

    /** Access service using IAM API Key credentials  */
    func testAccessWithAPIKey() {
        guard let apiKey = WatsonCredentials.VisualRecognitionAPIKey else {
            XCTFail("Missing credentials for Visual Recognition service")
            return
        }
        let visualRecognition = VisualRecognition(version: versionDate, apiKey: apiKey)
        visualRecognition.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        visualRecognition.defaultHeaders["X-Watson-Test"] = "true"

        let expectation = self.expectation(description: "Access service using IAM API Key WatsonCredentials.")

        visualRecognition.classify(url: ginniURL, acceptLanguage: "en") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifiedImages = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertEqual(image?.sourceURL, self.ginniURL)
            XCTAssertEqual(image?.resolvedURL, self.ginniURL)
            XCTAssertNil(image?.image)
            XCTAssertNil(image?.error)
            XCTAssertEqual(image?.classifiers.count, 1)

            // verify the image's classifier
            let classifier = image?.classifiers.first
            XCTAssertEqual(classifier?.classifierID, "default")
            XCTAssertEqual(classifier?.name, "default")

            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    /** Access service using access token obtained using IAM API Key.  */
    func testAccessWithAccessToken() {
        guard let apiKey = WatsonCredentials.VisualRecognitionAPIKey else {
            XCTFail("Missing credentials for Visual Recognition service")
            return
        }
        // Obtain an access token using the IAM API Key
        var tokenInfo = getTokenInfo(apiKey: apiKey)
        guard let accessToken = tokenInfo?["access_token"] as? String else {
            XCTFail("Failed to obtain access token")
            return
        }

        // Pass the access token as the credentials when instantiating the service

        let visualRecognition = VisualRecognition(version: versionDate, accessToken: accessToken)
        visualRecognition.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        visualRecognition.defaultHeaders["X-Watson-Test"] = "true"

        // Verify access to the service using the access token

        let expectation = self.expectation(description: "Access VR service with access token")
        visualRecognition.classify(url: obamaURL, acceptLanguage: "en") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifiedImages = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertEqual(image?.sourceURL, self.obamaURL)
            XCTAssertEqual(image?.resolvedURL, self.obamaURL)
            XCTAssertNil(image?.image)
            XCTAssertNil(image?.error)
            XCTAssertEqual(image?.classifiers.count, 1)

            // verify the image's classifier
            let classifier = image?.classifiers.first
            XCTAssertEqual(classifier?.classifierID, "default")
            XCTAssertEqual(classifier?.name, "default")

            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)

        // Obtain a new access token using the refresh token returned with the first access token

        tokenInfo = getTokenInfo(apiKey: apiKey, refreshToken: tokenInfo?["refresh_token"] as? String ?? "bogus")
        guard let newToken = tokenInfo?["access_token"] as? String else {
            XCTFail("Failed to obtain access token")
            return
        }

        // Update the access token to be used for requests by the service

        visualRecognition.accessToken(newToken)

        // Verify access to the service using the refreshed access token

        let expectation2 = self.expectation(description: "Access VR service with refreshed access token")
        visualRecognition.classify(url: trumpURL, acceptLanguage: "en") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifiedImages = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertEqual(image?.sourceURL, self.trumpURL)
            XCTAssertEqual(image?.resolvedURL, self.trumpURL)
            XCTAssertNil(image?.image)
            XCTAssertNil(image?.error)
            XCTAssertEqual(image?.classifiers.count, 1)

            // verify the image's classifier
            let classifier = image?.classifiers.first
            XCTAssertEqual(classifier?.classifierID, "default")
            XCTAssertEqual(classifier?.name, "default")

            expectation2.fulfill()
        }
        waitForExpectations(timeout: timeout)

    }
}
