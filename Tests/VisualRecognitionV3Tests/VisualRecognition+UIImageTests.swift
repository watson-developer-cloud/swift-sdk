/**
 * Copyright IBM Corporation 2016-2017
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
import VisualRecognitionV3

class VisualRecognitionUIImageTests: XCTestCase {

    private var visualRecognition: VisualRecognition!

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
        let apiKey = Credentials.VisualRecognitionAPIKey
        let version = "2018-03-19"
        visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
        visualRecognition.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        visualRecognition.defaultHeaders["X-Watson-Test"] = "true"
    }

    func failWithError(error: Error) {
        XCTFail("Positive test failed with error: \(error)")
    }

    func waitForExpectations(timeout: TimeInterval = 15.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    func testClassifyUIImage() {
        let expectation = self.expectation(description: "Classify a UIImage using the default classifier.")
        visualRecognition.classify(image: car, failure: failWithError) {
            classifiedImages in
            var containsPersonClass = false
            var classifierScore: Double?
            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertNil(image?.sourceUrl)
            XCTAssertNil(image?.resolvedUrl)
            XCTAssertNil(image?.error)
            XCTAssertEqual(image?.classifiers.count, 1)

            // verify the image's classifier
            let classifier = image?.classifiers.first
            XCTAssertEqual(classifier?.classifierID, "default")
            XCTAssertEqual(classifier?.name, "default")
            guard let classes = classifier?.classes else {
                XCTFail("Did not return any classes")
                return
            }
            XCTAssertGreaterThan(classes.count, 0)
            for cls in classes where cls.className == "car" {
                containsPersonClass = true
                classifierScore = cls.score
                break
            }
            XCTAssertEqual(true, containsPersonClass)
            if let score = classifierScore {
                XCTAssertGreaterThan(score, 0.5)
            }

            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testDetectFacesByUIImage() {
        let expectation = self.expectation(description: "Detect faces in a UIImage.")
        visualRecognition.detectFaces(image: obama, failure: failWithError) {
            faceImages in

            // verify face images object
            XCTAssertEqual(faceImages.imagesProcessed, 1)
            XCTAssertNil(faceImages.warnings)
            XCTAssertEqual(faceImages.images.count, 1)

            // verify the face image object
            let face = faceImages.images.first
            XCTAssertNil(face?.sourceUrl)
            XCTAssertNil(face?.resolvedUrl)
            XCTAssertNotNil(face?.image)
            XCTAssertNil(face?.error)
            XCTAssertEqual(face?.faces.count, 1)

            // verify the age
            let age = face?.faces.first?.age
            XCTAssertGreaterThanOrEqual(age!.min!, 40)
            XCTAssertLessThanOrEqual(age!.max!, 54)
            XCTAssertGreaterThanOrEqual(age!.score!, 0.25)

            // verify the face location
            let location = face?.faces.first?.faceLocation
            XCTAssertEqual(location?.height, 174)
            XCTAssertEqual(location?.left, 219)
            XCTAssertEqual(location?.top, 78)
            XCTAssertEqual(location?.width, 143)

            // verify the gender
            let gender = face?.faces.first?.gender
            XCTAssertEqual(gender!.gender, "MALE")
            XCTAssertGreaterThanOrEqual(gender!.score!, 0.75)

            expectation.fulfill()
        }
        waitForExpectations()
    }
}

#endif
