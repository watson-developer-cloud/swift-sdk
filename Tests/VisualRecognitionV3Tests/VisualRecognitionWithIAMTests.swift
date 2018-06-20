//
//  VisualRecognitionWithIAMTests.swift
//  AssistantV1Tests
//
//  Created by Mike Kistler on 5/24/18.
//  Copyright © 2018 Glenn R. Fisher. All rights reserved.
//

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

    /** Fail false negatives. */
    func failWithError(error: Error) {
        XCTFail("Positive test failed with error: \(error)")
    }

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
        let apiKey = IAMCredentials.VisualRecognitionAPIKey
        let version = "2018-03-19"
        let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)
        visualRecognition.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        visualRecognition.defaultHeaders["X-Watson-Test"] = "true"

        let expectation = self.expectation(description: "Access service using IAM API Key credentials.")

        visualRecognition.classify(url: ginniURL, failure: failWithError) {
            classifiedImages in

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertEqual(image?.sourceUrl, self.ginniURL)
            XCTAssertEqual(image?.resolvedUrl, self.ginniURL)
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
        let apiKey = IAMCredentials.VisualRecognitionAPIKey

        // Obtain an access token using the IAM API Key

        var tokenInfo = getTokenInfo(apiKey: apiKey)
        guard let accessToken = tokenInfo?["access_token"] as? String else {
            XCTFail("Failed to obtain access token")
            return
        }

        // Pass the access token as the credentials when instantiating the service

        let version = "2018-03-19"
        let visualRecognition = VisualRecognition(version: version, accessToken: accessToken)
        visualRecognition.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        visualRecognition.defaultHeaders["X-Watson-Test"] = "true"

        // Verify access to the service using the access token

        let expectation = self.expectation(description: "Access VR service with access token")
        visualRecognition.classify(url: obamaURL, failure: failWithError) {
            classifiedImages in

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertEqual(image?.sourceUrl, self.obamaURL)
            XCTAssertEqual(image?.resolvedUrl, self.obamaURL)
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
        visualRecognition.classify(url: trumpURL, failure: failWithError) {
            classifiedImages in

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertEqual(image?.sourceUrl, self.trumpURL)
            XCTAssertEqual(image?.resolvedUrl, self.trumpURL)
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
