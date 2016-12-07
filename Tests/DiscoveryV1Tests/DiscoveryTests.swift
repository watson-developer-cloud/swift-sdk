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
import Foundation
import DiscoveryV1

class DiscoveryTests: XCTestCase {
    
    private var discovery: Discovery!
    private let timeout: TimeInterval = 15.0
    
    // MARK: - Test Configuration
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateDiscovery()
    }
    
    /** Instantiate Retrieve and Rank instance. */
    func instantiateDiscovery() {
        let username = Credentials.DiscoveryUsername
        let password = Credentials.DiscoveryPassword
        let version = "2016-11-07"
        discovery = Discovery(username: username, password: password, version: version)
    }
    
    /** Fail false negatives. */
    func failWithError(error: Error) {
        XCTFail("Positive test failed with error: \(error)")
    }
    
    /** Fail false positives. */
    func failWithResult<T>(result: T) {
        XCTFail("Negative test returned a result.")
    }
    
    /** Wait for expectations. */
    func waitForExpectations() {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
    // MARK: - Positive Tests
    
    
    /** Retrieve a list of the environments associated with this service instance. */
    func testGetEnvironments() {
        let description = "Retrieve a list of environments."
        let expectation = self.expectation(description: description)
        
        discovery.getEnvironments(failure: failWithError) { environments in
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Create and delete an environment. */
    func testCreateAndDeleteEnvironment() {
        let description = "Create a new environment."
        let expectation = self.expectation(description: description)
        
        let environmentName = "swift-sdk-unit-test-environment"
        let environmentDescription = "A temporary environment created for a Swift SDK test."
        
        var environmentID: String?
        discovery.createEnvironment(
            withName: environmentName,
            withDescription: environmentDescription,
            failure: failWithError)
        {
            environment in
            
            // verify that an environment ID was returned, and save this value
            XCTAssertNotNil(environment.environmentID)
            environmentID = environment.environmentID
            
            // check all the fields are present
            XCTAssertEqual(environment.name, environmentName)
            XCTAssertEqual(environment.description, environmentDescription)
            XCTAssertNotNil(environment.created)
            XCTAssertNotNil(environment.updated)
            XCTAssertNotNil(environment.status)
            XCTAssertNotNil(environment.indexCapacity.diskUsage)
            XCTAssertNotNil(environment.indexCapacity.memoryUsage)
            
            // check all the fields within diskUsage are present
            let diskUsage = environment.indexCapacity.diskUsage
            XCTAssertNotNil(diskUsage.usedBytes)
            XCTAssertNotNil(diskUsage.totalBytes)
            XCTAssertNotNil(diskUsage.used)
            XCTAssertNotNil(diskUsage.total)
            XCTAssertNotNil(diskUsage.percentUsed)
            
            // check all the fields within memoryUsage are present
            let memoryUsage = environment.indexCapacity.memoryUsage
            XCTAssertNotNil(memoryUsage.usedBytes)
            XCTAssertNotNil(memoryUsage.totalBytes)
            XCTAssertNotNil(memoryUsage.used)
            XCTAssertNotNil(memoryUsage.total)
            XCTAssertNotNil(memoryUsage.percentUsed)
            
            expectation.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Delete the new environment."
        let expectation2 = self.expectation(description: description2)
        
        discovery.deleteEnvironment(withID: environmentID!, failure: failWithError) {
            environment in
            
            XCTAssertEqual(environment.environmentID, environmentID)
            XCTAssertEqual(environment.status, "deleted")
            
            expectation2.fulfill()
        }
        waitForExpectations()
    }
}
