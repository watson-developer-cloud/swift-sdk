/**
 * Copyright IBM Corporation 2015
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
import WatsonDeveloperCloud

class VisualRecognitionTests: XCTestCase {
    
    private var visualRecognition: VisualRecognition!
    private let timeout: NSTimeInterval = 30
    
    // MARK: - Test Configuration
    
    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateVisualRecognition()
    }
    
    /** Instantiate Visual Recognition. */
    func instantiateVisualRecognition() {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard
            let file = bundle.pathForResource("Credentials", ofType: "plist"),
            let credentials = NSDictionary(contentsOfFile: file) as? [String: String],
            let apiKey = credentials["AlchemyAPIKey"]
        else {
            XCTFail("Unable to read credentials.")
            return
        }
        visualRecognition = VisualRecognition(apiKey: apiKey, version: "2015-05-10")
    }
    
    /** Fail false negatives. */
    func failWithError(error: NSError) {
        XCTFail("Positive test failed with error: \(error)")
    }
    
    /** Fail false positives. */
    func failWithResult<T>(result: T) {
        XCTFail("Negative test returned a result.")
    }
    
    /** Wait for expectations. */
    func waitForExpectations() {
        waitForExpectationsWithTimeout(timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
    // MARK: - Positive Tests
    
    /** Retrieve a list of user-trained classifiers. */
    func testGetClassifiers() {
        let description = "Retrieve a list of user-trained classifiers."
        let expectation = expectationWithDescription(description)
        
        visualRecognition.getClassifiers(failWithError) { classifiers in
            XCTAssertEqual(classifiers.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }
}