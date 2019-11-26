/**
 * (C) Copyright IBM Corp. 2016, 2019.
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

#if os(iOS) || os(tvOS) || os(watchOS)

import XCTest
import Foundation
import UIKit
import VisualRecognitionV4

class VisualRecognitionUIImageTests: XCTestCase {

    private var visualRecognition: VisualRecognition!
    private let classifierID = WatsonCredentials.VisualRecognitionClassifierID
    private let giraffeCollectionID = WatsonCredentials.VisualRecognitionV4GiraffeCollectionID

    private var car: UIImage {
        let bundle = Bundle(for: type(of: self))
        let file = bundle.url(forResource: "car", withExtension: "png")!
        return UIImage(contentsOfFile: file.path)!
    }

    private var obama: UIImage {
        let bundle = Bundle(for: type(of: self))
        let file = bundle.url(forResource: "obama", withExtension: "jpg")!
        return UIImage(contentsOfFile: file.path)!
    }

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateVisualRecognition()
    }

    func instantiateVisualRecognition() {
        let authenticator = WatsonIAMAuthenticator.init(apiKey: WatsonCredentials.VisualRecognitionV4APIKey)
        visualRecognition = VisualRecognition(version: versionDate, authenticator: authenticator)
        if let url = WatsonCredentials.VisualRecognitionURL {
            visualRecognition.serviceURL = url
        }
        visualRecognition.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        visualRecognition.defaultHeaders["X-Watson-Test"] = "true"
    }

    func waitForExpectations(timeout: TimeInterval = 15.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    func testAnalyzeUIImage() {
        let expectation = self.expectation(description: "Analyze a UIImage.")

        visualRecognition.analyze(
            images: [car],
            collectionIDs: [giraffeCollectionID],
            features: ["objects"]) {
                response, error in

                // make sure we didn't get an error
                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }

                // make sure there are collections in the result
                guard let result = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }

                XCTAssertNotNil(result.images.first)

                expectation.fulfill()
        }

        waitForExpectations()
    }
}

#endif
