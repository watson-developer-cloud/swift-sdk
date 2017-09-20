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
import RestKit
import DiscoveryV1

class DiscoveryTests: XCTestCase {
    
    private var discovery: Discovery!
    private let timeout = 20.0
    private let environmentName = "swift-sdk-unit-test-environment"
    private let testDescription = "For testing"
    private var environmentID: String?
    private let newsEnvironmentName = "Watson News Environment"
    private var newsEnvironmentID: String?
    private let newsCollectionName = "watson_news"
    private var newsCollectionID: String?
    private let collectionName = "swift-sdk-unit-test-collection"
    private var collectionID: String?
    private var configurationID: String?
    private var documentID: String?
    
    // MARK: - Test Configuration
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateDiscovery()
        lookupNewsCollectionEnvironment()
        lookupEnvironment()
        lookupConfiguration()
        lookupCollection()
        addDocumentToCollection()
    }
    
    override class func tearDown() {
        let failure = { (error: Error) in
            XCTFail("Failed with error: \(error)")
        }
        
        let discovery = Discovery(username: Credentials.DiscoveryUsername, password: Credentials.DiscoveryPassword, version: "2016-12-01")
        discovery.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        discovery.defaultHeaders["X-Watson-Test"] = "true"
        var trainedEnvironmentID: String?
        
        let description1 = "Get trained environment ID."
        let expectation1 = XCTestExpectation(description: description1)
        discovery.getEnvironments(withName: "swift-sdk-unit-test-environment", failure: failure) { environment in
            trainedEnvironmentID = environment.first?.environmentID
            expectation1.fulfill()
        }
        let _ = XCTWaiter.wait(for: [expectation1], timeout: 20)
        
        let description2 = "Delete the trained environment."
        let expectation2 = XCTestExpectation(description: description2)
        discovery.deleteEnvironment(withID: trainedEnvironmentID!, failure: failure) { environment in
            expectation2.fulfill()
        }
        let _ = XCTWaiter.wait(for: [expectation2], timeout: 20)
    }
    
    /** Instantiate Discovery instance. */
    func instantiateDiscovery() {
        let username = Credentials.DiscoveryUsername
        let password = Credentials.DiscoveryPassword
        let version = "2016-12-01"
        discovery = Discovery(username: username, password: password, version: version)
        discovery.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        discovery.defaultHeaders["X-Watson-Test"] = "true"
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
            withSize: .one,
            withDescription: testDescription,
            failure: failure) { environment in
                self.environmentID = environment.environmentID
                expectation.fulfill()
                return
        }
        waitForExpectations()
        
        sleep(30)
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
            failure: failure) { configurations in
                for configuration in configurations {
                    if configuration.name == defaultConfigName {
                        self.configurationID = configuration.configurationID
                        expectation.fulfill()
                        return
                    }
                }
                expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Lookup (or create) collection for test suite. */
    func lookupCollection() {
        let description = "Look up collection for the test suite."
        let expectation = self.expectation(description: description)
        
        let failure = { (error: Error) in XCTFail("Could not find collection with specified environmentID") }
        discovery.getCollections(withEnvironmentID: environmentID!, failure: failure) {
            collections in
            for collection in collections {
                if self.collectionName == collection.name {
                    self.collectionID = collection.collectionID
                    expectation.fulfill()
                    return
                }
            }
            expectation.fulfill()
        }
        waitForExpectations()
        if collectionID == nil {
            createCollection()
        }
    }
    
    /** Look up news collection from the given news environment. */
    func lookupNewsCollectionEnvironment() {
        let description = "Look up example news environment."
        let expectation = self.expectation(description: description)
        
        let failure = { (error: Error) in
            XCTFail("Failed to locate news environment")
        }
        
        discovery.getEnvironments(withName: newsEnvironmentName, failure: failure) { environments in
            for environment in environments {
                if environment.name == self.newsEnvironmentName {
                    self.newsEnvironmentID = environment.environmentID
                    expectation.fulfill()
                    return
                }
            }
            expectation.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Look up news collection within found news environment"
        let expectation2 = self.expectation(description: description2)
        
        let failure2 = { (error: Error) in
            XCTFail("Failed to locate news collection")
        }
        
        discovery.getCollections(withEnvironmentID: newsEnvironmentID!, withName: newsCollectionName, failure: failure2) { collections in
            for collection in collections {
                if collection.name == self.newsCollectionName {
                    self.newsCollectionID = collection.collectionID
                    expectation2.fulfill()
                    return
                }
            }
            expectation2.fulfill()
        }
        waitForExpectations()
    }
    
    /** Create a collection for the test suite. */
    func createCollection() {
        
        var environmentReady = false
        var tries = 0
        while(!environmentReady) {
            tries += 1
            let description = "Get environment and check if it's `active`."
            let expectation = self.expectation(description: description)
            self.discovery.getEnvironment(withID: environmentID!, failure: failWithError) { environment in
                if environment.status == "active" {
                    environmentReady = true
                }
                expectation.fulfill()
            }
            waitForExpectations()
            
            if tries > 5 {
                XCTFail("Environment is not ready, could not add new collection. Try again later.")
                return
            }
            
            sleep(5)
        }
        
        let description = "Create collection for the test suite."
        let expectation = self.expectation(description: description)
        
        let failure = { (error: Error) in XCTFail("Could not create collection.") }
        discovery.createCollection(
            withEnvironmentID: environmentID!,
            withName: collectionName,
            withDescription: testDescription,
            withConfigurationID: configurationID!,
            failure: failure) {
                collection in
                self.collectionID = collection.collectionID
                expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Add document to collection to test. */
    func addDocumentToCollection() {
        let description = "Add a document to the collection."
        let expectation = self.expectation(description: description)
        
        let failure = { (error: Error) in XCTFail("Could not add document to collection.") }
        
        guard let file = Bundle(for: type(of: self)).url(forResource: "KennedySpeech", withExtension: "html") else {
            XCTFail("Unable to locate KennedySpeech.html")
            return
        }
        discovery.addDocumentToCollection(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID!,
            file: file,
            failure: failure) {
                document in
                XCTAssertNotNil(document.documentID)
                self.documentID = document.documentID
                XCTAssertEqual(document.status, DocumentStatus.processing)
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
    
    /** Fail false positives. */
    func failWithResult() {
        XCTFail("Negative test returned a result.")
    }
    
    /** Wait for expectations. */
    func waitForExpectations() {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
    // MARK: - Environments
    
    /** Retrieve a list of the environments associated with this service instance. */
    func testGetEnvironments() {
        let description = "Retrieve a list of environments."
        let expectation = self.expectation(description: description)
        
        discovery.getEnvironments(failure: failWithError) { environments in
            XCTAssertGreaterThan(environments.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Delete and create a test environment. */
    func testDeleteAndCreateEnvironment() {
        
        let description = "Delete the existing test environment."
        let expectation = self.expectation(description: description)
        
        discovery.deleteEnvironment(withID: self.environmentID!, failure: failWithError) {
            environment in
            
            XCTAssertEqual(environment.environmentID, self.environmentID)
            XCTAssertEqual(environment.status, "deleted")
            
            expectation.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Recreate the deleted environment."
        let expectation2 = self.expectation(description: description2)

        discovery.createEnvironment(
            withName: environmentName,
            withSize: .one,
            withDescription: testDescription,
            failure: failWithError)
        {
            environment in
            
            // verify that an environment ID was returned, and save this value
            XCTAssertNotNil(environment.environmentID)
            self.environmentID = environment.environmentID
            
            // check all the fields are present
            XCTAssertEqual(environment.name, self.environmentName)
            XCTAssertEqual(environment.description, self.testDescription)
            XCTAssertNotNil(environment.created)
            XCTAssertNotNil(environment.updated)
            XCTAssertNotNil(environment.status)
            XCTAssertNotNil(environment.indexCapacity?.diskUsage)
            XCTAssertNotNil(environment.indexCapacity?.memoryUsage)
            
            // check all the fields within diskUsage are present
            let diskUsage = environment.indexCapacity?.diskUsage
            XCTAssertNotNil(diskUsage?.usedBytes)
            XCTAssertNotNil(diskUsage?.totalBytes)
            XCTAssertNotNil(diskUsage?.used)
            XCTAssertNotNil(diskUsage?.total)
            XCTAssertNotNil(diskUsage?.percentUsed)
            
            // check all the fields within memoryUsage are present
            let memoryUsage = environment.indexCapacity?.memoryUsage
            XCTAssertNotNil(memoryUsage?.usedBytes)
            XCTAssertNotNil(memoryUsage?.totalBytes)
            XCTAssertNotNil(memoryUsage?.used)
            XCTAssertNotNil(memoryUsage?.total)
            XCTAssertNotNil(memoryUsage?.percentUsed)
            
            expectation2.fulfill()
        }
        waitForExpectations()
        
        // Allow time for the environment to be ready for the next test.
        sleep(20)
    }
    
    /** Get the trained environment. */
    func testGetTrainedEnvironment() {
        let description = "Retrieve the trained environment."
        let expectation = self.expectation(description: description)
        
        discovery.getEnvironment(withID: self.environmentID!, failure: failWithError) {
            environment in
            
            XCTAssertEqual(environment.name, self.environmentName)
            XCTAssertEqual(environment.description, self.testDescription)
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Update the name and description of the trained environment. */
    func testUpdateEnvironment() {
        let description = "Update the trained environment's description and name."
        let expectation = self.expectation(description: description)
        
        discovery.updateEnvironment(
            withID: self.environmentID!,
            name: "new name",
            description: "new description",
            failure: failWithError)
        {
            environment in
            
            XCTAssertEqual(environment.environmentID, self.environmentID)
            XCTAssertNotEqual(environment.name, self.environmentName)
            XCTAssertEqual(environment.name, "new name")
            XCTAssertNotEqual(environment.description, self.testDescription)
            XCTAssertEqual(environment.description, "new description")
            
            expectation.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Change trained environment's description and name back to normal."
        let expectation2 = self.expectation(description: description2)
        
        discovery.updateEnvironment(
            withID: self.environmentID!,
            name: self.environmentName,
            description: self.testDescription,
            failure: failWithError)
        {
            environment in
            
            XCTAssertEqual(environment.environmentID, self.environmentID)
            XCTAssertEqual(environment.name, self.environmentName)
            XCTAssertEqual(environment.description, self.testDescription)
            
            expectation2.fulfill()
        }
        waitForExpectations()
    }
    
    // MARK: Configurations
    
    /** Retrieve a list of the configurations in the given environment. */
    func testGetConfigurations() {
        let description = "Retrieve a list of configurations."
        let expectation = self.expectation(description: description)
        
        guard let environmentID = environmentID else {
            XCTFail("Failed to find test environment")
            return
        }
        
        discovery.getConfigurations(withEnvironmentID: environmentID, failure: failWithError) {
            configurations in
            
            for configuration in configurations {
                if configuration.name == "Default Configuration" {
                    XCTAssertEqual(configuration.description, "The configuration used by default when creating a new collection without specifying a configuration_id.")
                    expectation.fulfill()
                }
            }
        }
        waitForExpectations()
    }

    /** Retrieve a configuration by name where the name contains special chars. */
    func testGetConfigurationWithFunkyName() {
        let description = "Retrieve a configuration with a funky name."
        let expectation = self.expectation(description: description)

        guard let environmentID = environmentID else {
            XCTFail("Failed to find test environment")
            return
        }

        let configurationName = UUID().uuidString + " with \"funky\" ?x=y&foo=bar ,[x](y) ~!@#$%^&*()-+ {} | ;:<>\\/ chars"

        let configuration = ConfigurationDetails(
            name: configurationName,
            description: "configuration with funky name")

        discovery.createConfiguration(
            withEnvironmentID: environmentID,
            configuration: configuration,
            failure: failWithError) { _ in

                self.discovery.getConfigurations(withEnvironmentID: environmentID, withName: configurationName, failure: self.failWithError) {
                    configurations in

                    XCTAssertEqual(configurations.count, 1)
                    XCTAssertEqual(configurations[0].name, configurationName)
                    expectation.fulfill()
                }
            }

        waitForExpectations()
    }

    /** Create and delete a configuration. */
    func testCreateAndDeleteConfiguration() {
        let description = "Create a new configuration."
        let expectation = self.expectation(description: description)
        
        guard let environmentID = environmentID else {
            XCTFail("Failed to find test environment")
            return
        }
        
        let normalization1 = Normalization(
            operation: .move,
            sourceField: "extracted_metadata.title",
            destinationField: "metadata.title"
        )
        
        let normalization2 = Normalization(
            operation: .remove,
            sourceField: "extracted_metadata"
        )
        
        let conversions = Conversion(
            html: ["exclude_tags_keep_content": ["font", "span"]],
            jsonNormalizations: [normalization1, normalization2]
        )
        
        let enrichment = Enrichment(
            destinationField: "alchemy_enriched_text",
            sourceField: "text",
            enrichment: "alchemy_language",
            options: ["extract": "keyword"])
        
        let configuration = ConfigurationDetails(
            name: "swift-sdk-unit-test-configuration",
            description: "test configuration",
            conversions: conversions,
            enrichments: [enrichment],
            normalizations: [normalization1, normalization2])
        
        var newConfigurationID: String?
        
        discovery.createConfiguration(
            withEnvironmentID: environmentID,
            configuration: configuration,
            failure: failWithError) { configuration in
            
            // check description exists
            XCTAssertEqual(configuration.description, "test configuration")
                
            // check conversion object exists, fields exist within it
            XCTAssertNotNil(configuration.conversions)
            if let configConversion = configuration.conversions {
                XCTAssertNil(configConversion.word)
                XCTAssertNil(configConversion.pdf)
                XCTAssertNotNil(configConversion.html)
                XCTAssertNotNil(configConversion.jsonNormalizations)
            }
                
            // check enrichment object exists, fields exist within it
            XCTAssertNotNil(configuration.enrichments)
            if let configEnrichment = configuration.enrichments?[0] {
                XCTAssertNotNil(configEnrichment)
                XCTAssertEqual(configEnrichment.destinationField, enrichment.destinationField)
                XCTAssertEqual(configEnrichment.sourceField, enrichment.sourceField)
                XCTAssertEqual(configEnrichment.enrichment, enrichment.enrichment)
                XCTAssertNotNil(configEnrichment.options)
            }
            
            // check normalization object exists
            XCTAssertNotNil(configuration.normalizations)
            if let configNormArray = configuration.normalizations {
                for configNorm in configNormArray {
                    XCTAssertNotNil(configNorm.operation)
                    XCTAssertNotNil(configNorm.sourceField)
                }
            }
                
            XCTAssertNotNil(configuration.configurationID)
            newConfigurationID = configuration.configurationID
            expectation.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Delete the new configuration."
        let expectation2 = self.expectation(description: description2)
        
        guard let newConfigID = newConfigurationID else {
            XCTFail("Failed to instantiate configurationID when creating configuration.")
            return
        }
        
        discovery.deleteConfiguration(
            withEnvironmentID: environmentID,
            withConfigurationID: newConfigID,
            failure: failWithError) { configuration in
            
            XCTAssertEqual(configuration.configurationID, newConfigID)
            XCTAssertEqual(configuration.status, "deleted")
            XCTAssertNil(configuration.noticeMessages)
            expectation2.fulfill()
        }
        waitForExpectations()
    }
    
    /** Get the default configuration. */
    func testGetDefaultConfigurationDetails() {
        let description = "Retrieve details of the default configuration."
        let expectation = self.expectation(description: description)
        
        guard let environmentID = environmentID else {
            XCTFail("Failed to find test environment")
            return
        }
        
        guard let configurationID = configurationID else {
            XCTFail("Failed to find the default configuration.")
            return
        }
        
        discovery.getConfiguration(
            withEnvironmentID: environmentID,
            withConfigurationID: configurationID,
            failure: failWithError) { configuration in
                
            XCTAssertEqual(configuration.configurationID, configurationID)
            XCTAssertEqual(configuration.name, "Default Configuration")
            XCTAssertEqual(configuration.description, "The configuration used by default when creating a new collection without specifying a configuration_id.")
            XCTAssertNotNil(configuration.conversions)
            XCTAssertNotNil(configuration.enrichments)
            XCTAssertNotNil(configuration.normalizations)
                
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Test updating a configuration. */
    func testCreateUpdateAndDeleteConfiguration() {
        let description = "Create a new configuration."
        let expectation = self.expectation(description: description)
        
        guard let environmentID = environmentID else {
            XCTFail("Failed to find test environment")
            return
        }
        
        let enrichment = Enrichment(
            destinationField: "alchemy_enriched_text",
            sourceField: "text",
            enrichment: "alchemy_language",
            options: ["extract": "keyword"])
        
        let configuration = ConfigurationDetails(
            name: "swift-sdk-unit-test-configuration",
            description: "test configuration",
            enrichments: [enrichment])
        
        var newConfigurationID: String?
        
        discovery.createConfiguration(
            withEnvironmentID: environmentID,
            configuration: configuration,
            failure: failWithError) { configuration in
                
                XCTAssertNotNil(configuration.configurationID)
                newConfigurationID = configuration.configurationID
                expectation.fulfill()
        }
        waitForExpectations()

        guard let newConfigID = newConfigurationID else {
            XCTFail("Failed to instantiate configurationID when creating configuration.")
            return
        }
        
        let description2 = "Update the configuration."
        let expectation2 = self.expectation(description: description2)
        
        let normalization = Normalization(
            operation: .move,
            sourceField: "extracted_metadata.title",
            destinationField: "metadata.title"
        )
        
        let configuration2 = ConfigurationDetails(
            name: "swift-sdk-unit-test-new-configuration",
            description: "replacement test configuration",
            normalizations: [normalization])
        
        discovery.updateConfiguration(
            withEnvironmentID: environmentID,
            withConfigurationID: newConfigID,
            configuration: configuration2,
            failure: failWithError) { configuration in
            
            expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Retrieve details of the updated configuration."
        let expectation3 = self.expectation(description: description3)
        
        discovery.getConfiguration(
            withEnvironmentID: environmentID,
            withConfigurationID: newConfigID,
            failure: failWithError) { configuration in
                
            // check name changed
            XCTAssertEqual(configuration.name, "swift-sdk-unit-test-new-configuration")
            
            // check description exists
            XCTAssertEqual(configuration.description, "replacement test configuration")
            
            // check conversion object doesn't exist
            XCTAssertNil(configuration.conversions)
            
            // check enrichment object doesn't exist
            XCTAssertNil(configuration.enrichments)
            
            // check normalization object exists
            XCTAssertNotNil(configuration.normalizations)
            if let configNormArray = configuration.normalizations {
                for configNorm in configNormArray {
                    XCTAssertNotNil(configNorm.operation)
                    XCTAssertNotNil(configNorm.sourceField)
                    XCTAssertNotNil(configNorm.destinationField)
                }
            }
            
            expectation3.fulfill()
        }
        waitForExpectations()
        
        let description4 = "Delete the new configuration."
        let expectation4 = self.expectation(description: description4)
        
        discovery.deleteConfiguration(
            withEnvironmentID: environmentID,
            withConfigurationID: newConfigID,
            failure: failWithError) { configuration in
                
                XCTAssertEqual(configuration.configurationID, newConfigID)
                XCTAssertEqual(configuration.status, "deleted")
                XCTAssertNil(configuration.noticeMessages)
                expectation4.fulfill()
        }
        waitForExpectations()
    }
    
    // MARK: - Test Configuration on Document
    
    /** Test default configuration on document. */
    func testConfigurationOnDocument() {
        let description = "Test default configuration on document."
        let expectation = self.expectation(description: description)
        
        guard let file = Bundle(for: type(of: self)).url(forResource: "metadata", withExtension: "json") else {
            XCTFail("Unable to locate metadata.json")
            return
        }
        
        discovery.testConfigurationInEnvironment(
            withEnvironmentID: environmentID!,
            withConfigurationID: configurationID!,
            file: file,
            failure: failWithError) {
                testConfigurationDetails in
                XCTAssertEqual(testConfigurationDetails.status, "completed")
                XCTAssertEqual(testConfigurationDetails.enrichedFieldUnits, nil)
                XCTAssertEqual(testConfigurationDetails.originalMediaType, "application/json")
                if let snapshots = testConfigurationDetails.snapshots {
                    for snapshot in snapshots {
                        XCTAssertNotNil(snapshot.step)
                        XCTAssertNotNil(snapshot.snapshot)
                    }
                }
                XCTAssertNotNil(testConfigurationDetails.notices)
                expectation.fulfill()
        }
        waitForExpectations()
    }
    
    // MARK: - Collections
    
    /** Retrieve a list of the collections associated with the test suite's environment. */
    func testGetCollections() {
        let description = "Retrieve a list of collections."
        let expectation = self.expectation(description: description)
        
        guard let environmentID = environmentID else {
            XCTFail("Failed to find test environment")
            return
        }
        
        discovery.getCollections(withEnvironmentID: environmentID, withName: collectionName) {
            collections in
            XCTAssertNotNil(collections)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Create and delete collection. */
    func testCreateAndDeleteCollection() {
        let description = "Create a new collection."
        let expectation = self.expectation(description: description)
        
        let collectionName = "swift-sdk-unit-test-collection-to-delete"
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
    
    /** Retrieve test collection details. */
    func testListCollectionDetails() {
        let description = "Retrieve test collection."
        let expectation = self.expectation(description: description)
        
        discovery.listCollectionDetails(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID!,
            failure: failWithError) {
                collection in
                
                // Verify all fields are present.
                XCTAssertEqual(self.collectionID!, collection.collectionID)
                XCTAssertEqual(self.collectionName, collection.name)
                XCTAssertEqual(self.testDescription, collection.description)
                XCTAssertNotNil(collection.created)
                XCTAssertNotNil(collection.updated)
                XCTAssertNotNil(collection.status)
                XCTAssertEqual(self.configurationID!, collection.configurationID)
                XCTAssertNotNil(collection.documentCounts?.available)
                XCTAssertNotNil(collection.documentCounts?.processing)
                XCTAssertNotNil(collection.documentCounts?.failed)
                
                expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Update the test collection with a new description. */
    func testUpdateCollection() {
        let description = "Update test collection name and description."
        let expectation = self.expectation(description: description)
        
        let updatedName = "updated-name"
        let updatedDescription = "updated-description"
        
        discovery.updateCollection(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID!,
            name: updatedName,
            description: updatedDescription,
            configurationID: configurationID!) {
                collection in
                XCTAssertEqual(updatedName, collection.name)
                XCTAssertEqual(updatedDescription, collection.description)
                XCTAssertEqual(self.configurationID, collection.configurationID)
                
                expectation.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Revert collection and description names to original values."
        let expectation2 = self.expectation(description: description2)
        
        discovery.updateCollection(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID!,
            name: collectionName,
            description: testDescription,
            configurationID: configurationID!) {
                collection in
                XCTAssertEqual(self.collectionName, collection.name)
                XCTAssertEqual(self.testDescription, collection.description)
                XCTAssertEqual(self.configurationID, collection.configurationID)
                
                expectation2.fulfill()
        }
        waitForExpectations()
    }
    
    /** List the fields in the test suite's collection. */
    func testListCollectionFields() {
        let description = "List the fields in the test suite's collection."
        let expectation = self.expectation(description: description)
        
        discovery.listCollectionFields(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID!,
            failure: failWithError) {
                fields in
                XCTAssertNotNil(fields)
                expectation.fulfill()
        }
        waitForExpectations()
    }
    
    // MARK: - Test Documents
    func testAddDeleteDocumentToCollection() {
        let description = "Add a document to the sample collection."
        let expectation = self.expectation(description: description)
        
        guard let file = Bundle(for: type(of: self)).url(forResource: "discoverySample", withExtension: "json") else {
            XCTFail("Unable to locate discoverySample.json")
            return
        }
        var documentID: String?
        // Add document to test collection and environment
        discovery.addDocumentToCollection(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID!,
            file: file,
            failure: failWithError) {
                document in
                documentID = document.documentID
                XCTAssertNotNil(document.status)
                expectation.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Delete newly created document from collection."
        let expectation2 = self.expectation(description: description2)
        guard let docID = documentID else {
            XCTFail("Failed to grab document ID from adding document to collection.")
            return
        }
        // Delete document from test collection and environment
        discovery.deleteDocumentFromCollection(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID!,
            withDocumentID: docID,
            failure: failWithError) {
                document in
                XCTAssertEqual(documentID, document.documentID)
                XCTAssertEqual(DocumentStatus.deleted, document.status)
                expectation2.fulfill()
        }
        waitForExpectations()
    }
    
    /* List details of a document in the test collection. */
    func testListDocumentDetails() {
        let description = "List details of a document in the test collection."
        let expectation = self.expectation(description: description)
        
        discovery.listDocumentDetails(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID!,
            withDocumentID: documentID!,
            failure: failWithError) { document in
                XCTAssertEqual(self.documentID!, document.documentID)
                XCTAssertEqual(document.status, DocumentStatus.processing)
                XCTAssertNotNil(document.notices)
                XCTAssertNotNil(document.statusDescription)
                expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /* Update document in the test collection. */
    func testUpdateDocument() {
        let description = "Update document name and description in collection."
        let expectation = self.expectation(description: description)
        
        guard let file = Bundle(for: type(of: self)).url(forResource: "discoverySample", withExtension: "json") else {
            XCTFail("Unable to locate discoverySample.json")
            return
        }
        
        guard let metadata = Bundle(for: type(of: self)).url(forResource: "metadata", withExtension: "json") else {
            XCTFail("Unable to locate metadata.json")
            return
        }

        discovery.updateDocumentInCollection(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID!,
            withDocumentID: documentID!,
            file: file,
            metadata: metadata,
            failure: failWithError) { document in
                XCTAssertEqual(self.documentID!, document.documentID)
                XCTAssertEqual(document.status, DocumentStatus.processing)
                expectation.fulfill()
        }
        waitForExpectations()
    }
    
    // MARK: - Test Query
    
    func testQueryInNewsCollection() {
        let description = "Query, filter and aggregate news resources in Watson collection."
        let expectation = self.expectation(description: description)
        
        let query = "entities:(text:\"general motors\",type:company),language:english,taxonomy:(label:\"technology and computing\")"
        let aggregation = "[timeslice(blekko.chrondate,12hours).filter(entities.type:Company).term(entities.text).term(docSentiment.type),filter(entities.type:Company).term(entities.text),filter(entities.type:Person).term(entities.text),term(keywords.text),term(blekko.host).term(docSentiment.type),term(docSentiment.type),min(docSentiment.score),max(docSentiment.score)]"
        let filter = "blekko.chrondate>1481335550"
        let filterDate = 1481335550
        let count = 10
        let returnWatson = "url,enrichedTitle.text,text,docSentiment.type,blekko.chrondate"
        discovery.queryDocumentsInCollection(
            withEnvironmentID: newsEnvironmentID!,
            withCollectionID: newsCollectionID!,
            withFilter: filter,
            withQuery: query,
            withAggregation: aggregation,
            count: count,
            return: returnWatson,
            failure: failWithError) {
                queryResponse in
                XCTAssertNotNil(queryResponse.matchingResults)
                if let count = queryResponse.matchingResults {
                    XCTAssertGreaterThan(count, 0)
                }
                XCTAssertNotNil(queryResponse.results)
                if let results = queryResponse.results {
                    XCTAssertEqual(count, results.count)
                    for result in results {
                        XCTAssertNotNil(result.documentID)
                        XCTAssertNotNil(result.score)
                        if let sentiment = result.documentSentiment {
                            XCTAssertNotNil(sentiment.type)
                        }
                        if let blekko = result.blekko {
                            if let chronDate = blekko.chrondate {
                                XCTAssertGreaterThan(chronDate, filterDate)
                            }
                        }
                        XCTAssertNotNil(result.text)
                        XCTAssertNotNil(result.enrichedTitle)
                        if let enrichedTitle = result.enrichedTitle {
                            XCTAssertNotNil(enrichedTitle.text)
                        }
                        XCTAssertNotNil(result.extractedURL)
                        break
                    }
                }
                /// Test all different types of aggregation queries.
                XCTAssertNotNil(queryResponse.aggregations)
                if let aggregations = queryResponse.aggregations {
                    for aggregation in aggregations {
                        if let type = aggregation.type {
                            XCTAssertNotNil(type)
                            if type == "term" {
                                XCTAssertNotNil(aggregation.field)
                                if let results = aggregation.results {
                                    for result in results {
                                        XCTAssertNotNil(result.key)
                                        XCTAssertNotNil(result.matchingResults)
                                        break
                                    }
                                }
                            }
                            if type == "filter" {
                                XCTAssertNotNil(aggregation.match)
                                XCTAssertNotNil(aggregation.matchingResults)
                                if let results = aggregation.results {
                                    for result in results {
                                        XCTAssertNotNil(result.key)
                                        XCTAssertNotNil(result.matchingResults)
                                        break
                                    }
                                }
                                if let aggregations = aggregation.aggregations {
                                    XCTAssertNotNil(aggregations)
                                }
                            }
                            if type == "max" || type == "min" {
                                XCTAssertNotNil(aggregation.value)
                            }
                            if type == "timeslice" {
                                XCTAssertEqual("12h", aggregation.interval)
                                if let results = aggregation.results {
                                    for result in results {
                                        XCTAssertNotNil(result.matchingResults)
                                        XCTAssertNotNil(result.aggregations)
                                        break
                                    }
                                }
                            }
                        }
                        if let field = aggregation.field {
                            XCTAssertNotNil(field)
                            if field == "blekko.host" {
                                if let results = aggregation.results {
                                    for result in results {
                                        XCTAssertNotNil(result.aggregations)
                                        break
                                    }
                                }
                            }
                        }

                        XCTAssertNotNil(aggregation.type)
                    }
                }
                XCTAssertNotNil(queryResponse.results)
                
                expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /* Test 'Concepts' model within the documents in the test collection. */
    func testConceptsModel() {
        let description = "Test \'Concepts\' model within the documents in the test collection."
        let expectation = self.expectation(description: description)
        
        let query = "United Nations"
        
        /// Specify which portion of the document hierarchy to return.
        let returnHierarchies = "enriched_text.concepts"
        
        discovery.queryDocumentsInCollection(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID!,
            withQuery: query,
            return: returnHierarchies,
            failure: failWithError) { queryResponse in
                XCTAssertNotNil(queryResponse.matchingResults)
                XCTAssertNotNil(queryResponse.results)
                if let results = queryResponse.results {
                    for result in results {
                        XCTAssertNotNil(result.score)
                        XCTAssertNotNil(result.enrichedTitle)
                        if let enrichedTitle = result.enrichedTitle {
                            XCTAssertNotNil(enrichedTitle.concepts)
                            var conceptMatchesQuery = false
                            if let concepts = enrichedTitle.concepts {
                                for concept in concepts {
                                    if concept.text == query {
                                        conceptMatchesQuery = true
                                        XCTAssertNotNil(concept.website, "http://www.un.org/")
                                        XCTAssertNotNil(concept.dbpedia)
                                        XCTAssertNotNil(concept.relevance)
                                        XCTAssertNotNil(concept.freebase)
                                        XCTAssertNotNil(concept.yago)
                                        break
                                    }
                                }
                            }
                            XCTAssertEqual(true, conceptMatchesQuery)
                        }
                    }
                }
                expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /* Test EnrichedTitle.docSentiment model within the documents in the test collection. */
    func testDocumentSentimentModel() {
        let description = "Test EnrichedTitle.docSentiment model within the documents in the test collection."
        let expectation = self.expectation(description: description)
        
        let query = "United Nations"
        
        /// Specify which portion of the document hierarchy to return.
        let returnHierarchies = "enriched_text.docSentiment"
        
        discovery.queryDocumentsInCollection(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID!,
            withQuery: query,
            return: returnHierarchies,
            failure: failWithError) { queryResponse in
                XCTAssertNotNil(queryResponse.results)
                if let results = queryResponse.results {
                    for result in results {
                        XCTAssertNotNil(result.enrichedTitle)
                        if let enrichedTitle = result.enrichedTitle {
                            XCTAssertNotNil(enrichedTitle.documentSentiment)
                            if let documentSentiment = enrichedTitle.documentSentiment {
                                XCTAssertNotNil(documentSentiment.mixed)
                                XCTAssertNotNil(documentSentiment.score)
                                XCTAssertNotNil(documentSentiment.type)
                            }
                        }
                    }
                }
                expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /* Test EnrichedTitle.taxonomy within the document in the test collection.*/
    func testTaxonomyModel() {
        let description = "Test EnrichedTitle.docSentiment model within the documents in the test collection."
        let expectation = self.expectation(description: description)
        
        let query = "United Nations"
        
        /// Specify which portion of the document hierarchy to return.
        let returnHierarchies = "enriched_text.taxonomy"
        
        discovery.queryDocumentsInCollection(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID!,
            withQuery: query,
            return: returnHierarchies,
            failure: failWithError) { queryResponse in
                XCTAssertNotNil(queryResponse.results)
                if let results = queryResponse.results {
                    for result in results {
                        if let enrichedTitle = result.enrichedTitle {
                            XCTAssertNotNil(enrichedTitle.taxonomy)
                            if let taxonomies = enrichedTitle.taxonomy {
                                for taxonomy in taxonomies {
                                    XCTAssertNotNil(taxonomy.score)
                                    XCTAssertNotNil(taxonomy.confident)
                                    XCTAssertNotNil(taxonomy.label)
                                }
                            }
                        }
                    }
                }
                expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /* Test EnrichedTitle.relations, SAO relations within the document in the test collection. */
    func testRelationsModel() {
        let description = "Test EnrichedTitle.docSentiment, subject, action, object models within the documents in the test collection."
        let expectation = self.expectation(description: description)
        
        let query = "United Nations"
        
        /// Specify which portion of the document hierarchy to return.
        let returnHierarchies = "enriched_text.relations"
        
        discovery.queryDocumentsInCollection(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID!,
            withQuery: query,
            return: returnHierarchies,
            failure: failWithError) { queryResponse in
                XCTAssertNotNil(queryResponse.results)
                if let results = queryResponse.results {
                    for result in results {
                        XCTAssertNotNil(result.enrichedTitle)
                        if let enrichedTitle = result.enrichedTitle {
                            XCTAssertNotNil(enrichedTitle.relations)
                            if let relations = enrichedTitle.relations {
                                for relation in relations {
                                    XCTAssertNotNil(relation.sentence)
                                    XCTAssertNotNil(relation.action)
                                    if let action = relation.action {
                                        XCTAssertNotNil(action.lemmatized)
                                        XCTAssertNotNil(action.text)
                                        XCTAssertNotNil(action.verb)
                                    }
                                    XCTAssertNotNil(relation.sentence)
                                    XCTAssertNotNil(relation.subject)
                                    if let subject = relation.subject {
                                        if let keywords = subject.keywords {
                                            for keyword in keywords {
                                                if let knowledgeGraph = keyword.knowledgeGraph {
                                                    XCTAssertNotNil(knowledgeGraph.typeHierarchy)
                                                }
                                                XCTAssertNotNil(keyword.text)
                                                break
                                            }
                                        }
                                        XCTAssertNotNil(subject.text)
                                    }
                                    if let object = relation.object {
                                        if let keywords = object.keywords {
                                            XCTAssertNotNil(keywords[0])
                                        }
                                        XCTAssertNotNil(object.text)
                                        if let sentiment = object.sentiment {
                                            XCTAssertNotNil(sentiment.mixed)
                                            XCTAssertNotNil(sentiment.type)
                                            XCTAssertNotNil(sentiment.score)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Test enriched_text.entities model. */
    func testEntityModel() {
        let description = "Test enriched_text.entities models within the documents in the test collection."
        let expectation = self.expectation(description: description)
        
        let query = "United Nations"
        
        /// Specify which portion of the document hierarchy to return.
        let returnHierarchies = "enriched_text.entities"
        
        discovery.queryDocumentsInCollection(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID!,
            withQuery: query,
            return: returnHierarchies,
            failure: failWithError) { queryResponse in
                XCTAssertNotNil(queryResponse.results)
                if let results = queryResponse.results {
                    for result in results {
                        XCTAssertNotNil(result.enrichedTitle)
                        if let enrichedTitle = result.enrichedTitle {
                            XCTAssertNotNil(enrichedTitle.entities)
                            if let entities = result.entities {
                                for entity in entities {
                                    XCTAssertNotNil(entity.count)
                                    XCTAssertNotNil(entity.disambiguated)
                                    XCTAssertNotNil(entity.relevance)
                                    XCTAssertNotNil(entity.text)
                                    XCTAssertNotNil(entity.type)
                                    XCTAssertNotNil(entity.sentiment)
                                }
                            }
                        }
                    }
                }
                expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Test aggregation query. */
    func testEntityAggregationModel() {
        let description = "Test enriched_text.entities models within the documents in the test collection."
        let expectation = self.expectation(description: description)
        
        let query = "United Nations"
        let aggregation = "max(enriched_text.entities.sentiment.score)"
        
        /// Specify which portion of the document hierarchy to return.
        let returnHierarchies = "enriched_text.entities.sentiment,enriched_text.entities.text"
        
        discovery.queryDocumentsInCollection(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID!,
            withQuery: query,
            withAggregation: aggregation,
            return: returnHierarchies,
            failure: failWithError) { queryResponse in
                if let results = queryResponse.results {
                    for result in results {
                        if let entities = result.entities {
                            for entity in entities {
                                XCTAssertNotNil(entity.sentiment)
                                XCTAssertNotNil(entity.text)
                            }
                        }
                    }
                }
                expectation.fulfill()
        }
        waitForExpectations()
    }
}
