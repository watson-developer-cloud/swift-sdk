/**
 * Copyright IBM Corporation 2016
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
import RelationshipExtractionV1

class RelationshipExtractionTests: XCTestCase {
    
    private var relationshipExtraction: RelationshipExtraction!
    private let timeout: NSTimeInterval = 30.0
    
    // MARK: - Test Configuration
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateRelationshipExtraction()
    }
    
    /** Instantiate Text to Speech instance. */
    func instantiateRelationshipExtraction() {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard
            let file = bundle.pathForResource("Credentials", ofType: "plist"),
            let credentials = NSDictionary(contentsOfFile: file) as? [String: String],
            let username = credentials["RelationshipExtractionUsername"],
            let password = credentials["RelationshipExtractionPassword"]
            else {
                XCTFail("Unable to read credentials.")
                return
        }
        relationshipExtraction = RelationshipExtraction(username: username, password: password)
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
    
    func testGetRelationships() {
        let description = "Test the getRelationships method."
        let expectation = expectationWithDescription(description)
        
        relationshipExtraction.getRelationships(
            "ie-en-news",
            text: "The president’s trip was designed to reward Milwaukee for its success in signing " +
                "up people for coverage. It won a competition called the Healthy Communities " +
                "Challenge that involved 20 cities.",
            failure: failWithError) { document in
            
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    // MARK: - Negative Tests
}
