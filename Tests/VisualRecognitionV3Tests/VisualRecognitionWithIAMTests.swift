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
import Foundation
import VisualRecognitionV3

class VisualRecognitionWithIAMTests: XCTestCase {

    private let timeout: TimeInterval = 45.0

    static var allTests: [(String, (VisualRecognitionWithIAMTests) -> () throws -> Void)] {
        return [
            ("testAccessWithAPIKey", testAccessWithAPIKey),
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
        let url = URL(string: "https://iam.cloud.ibm.com/identity/token")!
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
        let authenticator = WatsonIAMAuthenticator.init(apiKey: WatsonCredentials.VisualRecognitionV3APIKey)
        let visualRecognition = VisualRecognition(version: versionDate, authenticator: authenticator)
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
}
