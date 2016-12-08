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
    private let environmentName: String = "swift-sdk-unit-test-environment"
    private let environmentDescription: String = "For testing"
    private var environmentID: String?
    private var configurationID: String?
    
    // MARK: - Test Configuration
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateDiscovery()
        lookupEnvironment()
        lookupConfiguration()
    }
    
    /** Instantiate Retrieve and Rank instance. */
    func instantiateDiscovery() {
        let username = Credentials.DiscoveryUsername
        let password = Credentials.DiscoveryPassword
        let version = "2016-11-07"
        discovery = Discovery(username: username, password: password, version: version)
    }
    
    /** Look up (or create) environment. */
    func lookupEnvironment() {
        let description = "Look up (or create) the environment."
        let expectation = self.expectation(description: description)
        
        let failure = { (error: Error) in
            XCTFail("Failed to locate environment")
        }
        
        discovery.getEnvironments(withName: environmentName, failure: failure) { environments in
            for environment in environments {
                if environment.name == self.environmentName {
                    self.environmentID = environment.environmentID
                    expectation.fulfill()
                    return
                }
            }
            expectation.fulfill()
        }
        waitForExpectations()
        if (environmentID == nil) {
            createEnvironment()
        }
    }
    
    /** Create an environment for test suite. */
    func createEnvironment() {
        let description = "Create an environment for the test suite."
        let expectation = self.expectation(description: description)
        
        let failure = { (error: Error) in XCTFail("Could not create environment") }
        discovery.createEnvironment(
            withName: environmentName,
            withDescription: environmentDescription,
            failure: failure) { environment in
                self.environmentID = environment.environmentID
                expectation.fulfill()
        }
        waitForExpectations()
        
    }
    
    /** Lookup default configuration for environment created. */
    func lookupConfiguration() {
        let description = "Look up default configuration for the test suite's environment."
        let expectation = self.expectation(description: description)
        
        let defaultConfigName = "Default Configuration"
        let failure = { (error: Error) in XCTFail("Could not find configuration") }
        guard let environmentID = environmentID else {
            XCTFail("Failed to create environment for test suite.")
            return
        }
        discovery.getConfigurations(
            withEnvironmentID: environmentID,
            withName: nil,
            failure: failure) { configurations in
                for configuration in configurations {
                    if configuration.name == defaultConfigName {
                        self.configurationID = configuration.configurationID
                    }
                }
                expectation.fulfill()
        }
        waitForExpectations()
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
    
    /** Create and delete collection. */
    func testCreateAndDeleteCollection() {
        let description = "Create a new collection."
        let expectation = self.expectation(description: description)
        
        let collectionName = "swift-sdk-unit-test-collection"
        let collectionDescription = "collection for test suite"
        var collectionID: String?
        
        guard let environmentID = environmentID else {
            XCTFail("Failed to find test environment")
            return
        }
        
        guard let configurationID = configurationID else {
            XCTFail("Failed to find default configuration ID")
            return
        }
        
        discovery.createCollection(
            withEnvironmentID: environmentID,
            withName: collectionName,
            withDescription: collectionDescription,
            withConfigurationID: configurationID,
            failure: failWithError)
        {
            collection in
            
            // Verify collection was made
            collectionID = collection.collectionID
            XCTAssertEqual(collectionName, collection.name)
            XCTAssertEqual(collectionDescription, collection.description)
            XCTAssertNotNil(collection.created)
            XCTAssertNotNil(collection.updated)
            XCTAssertNotNil(collection.status)
            XCTAssertEqual(configurationID, collection.configurationID)
            
            expectation.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Delete the new collection."
        let expectation2 = self.expectation(description: description2)
        
        guard let collectionToDelete = collectionID else {
            XCTFail("Failed to instantiate collectionID when creating collection.")
            return
        }
        
        discovery.deleteCollection(withEnvironmentID: environmentID, withCollectionID: collectionToDelete, failure: failWithError) {
            collection in
            
            XCTAssertEqual(collection.collectionID, collectionToDelete)
            XCTAssertEqual(collection.status, CollectionStatus.deleted)
            
            expectation2.fulfill()
        }
        waitForExpectations()
    }
}
