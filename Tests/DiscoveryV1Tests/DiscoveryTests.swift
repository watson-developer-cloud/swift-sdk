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

// swiftlint:disable function_body_length force_try force_unwrapping superfluous_disable_command

import XCTest
import Foundation
import DiscoveryV1

class DiscoveryTests: XCTestCase {

    private var discovery: Discovery!
    private var newsEnvironmentID: String = "system"
    private var newsCollectionID: String = "news-en"
    private let defaultConfigurationName = "Default Configuration"
    private let collectionName = "swift-sdk-unit-test-collection"

    private var environmentID: String?

    // MARK: - Test Configuration

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateDiscovery()
        self.environmentID = lookupEnvironment()
    }

    static var allTests: [(String, (DiscoveryTests) -> () throws -> Void)] {
        return [
            ("testGetEnvironments", testGetEnvironments),
            ("testCreateUpdateAndDeleteEnvironment", testCreateUpdateAndDeleteEnvironment),
            ("testGetConfigurations", testGetConfigurations),
            ("testCreateGetDeleteConfigurationWithFunkyName", testCreateGetDeleteConfigurationWithFunkyName),
            ("testCreateAndDeleteConfiguration", testCreateAndDeleteConfiguration),
            ("testGetDefaultConfigurationDetails", testGetDefaultConfigurationDetails),
            ("testCreateUpdateAndDeleteConfiguration", testCreateUpdateAndDeleteConfiguration),
            ("testConfigurationOnDocument", testConfigurationOnDocument),
            ("testGetCollections", testGetCollections),
            ("testCreateUpdateAndDeleteCollection", testCreateUpdateAndDeleteCollection),
            ("testListCollectionDetails", testListCollectionDetails),
            ("testListCollectionFields", testListCollectionFields),
            ("testAddGetUpdateDeleteDocument", testAddGetUpdateDeleteDocument),
            ("testQueryInNewsCollection", testQueryInNewsCollection),
            ("testConceptsModel", testConceptsModel),
            ("testDocumentSentimentModel", testDocumentSentimentModel),
            ("testTaxonomyModel", testTaxonomyModel),
            ("testRelationsModel", testRelationsModel),
            ("testEntityModel", testEntityModel),
            ("testEntityAggregationModel", testEntityAggregationModel),
        ]
    }

    /** Instantiate Discovery instance. */
    func instantiateDiscovery() {
        let username = Credentials.DiscoveryUsername
        let password = Credentials.DiscoveryPassword
        let version = "2017-08-01"
        discovery = Discovery(username: username, password: password, version: version)
        discovery.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        discovery.defaultHeaders["X-Watson-Test"] = "true"
    }

    /** Look up (or create) environment. */
    func lookupEnvironment() -> String? {
        let failure = { (error: Error) in
            XCTFail("Failed to locate environment")
        }

        var environmentID: String?
        let expectation = self.expectation(description: "Look up (or create) the environment.")
        discovery.getEnvironments(failure: failure) { environments in
            for environment in environments where !(environment.readOnly ?? true) {
                environmentID = environment.environmentID
                expectation.fulfill()
                return
            }
            expectation.fulfill()
        }
        waitForExpectations()
        if environmentID == nil {
            environmentID = createEnvironment()
        }
        return environmentID
    }

    /** Create an environment for test suite. */
    func createEnvironment() -> String? {

        var environmentID: String?
        let failure = { (error: Error) in XCTFail("Could not create environment") }

        let expectation = self.expectation(description: "Create an environment for the test suite.")
        discovery.createEnvironment(
            withName: "test_environment",
            withSize: .one,
            withDescription: "Environment for SDK testing -- do not delete",
            failure: failure) { environment in
                environmentID = environment.environmentID
                expectation.fulfill()
        }
        waitForExpectations()

        return environmentID
    }

    /** Lookup a configuration with the given name. */
    func lookupConfiguration(environmentID: String, configurationName: String) -> String? {
        var configurationID: String?

        let failure = { (error: Error) in XCTFail("Could not get configurations: \(error)") }

        let expectation = self.expectation(description: "Lookup a configuration for the specified environment.")
        discovery.getConfigurations(
            withEnvironmentID: environmentID,
            failure: failure) { configurations in
                for configuration in configurations where configuration.name == configurationName {
                    configurationID = configuration.configurationID
                    expectation.fulfill()
                    return
                }
                expectation.fulfill()
        }
        waitForExpectations()
        return configurationID
    }

    /** Lookup a collection with the given name. */
    func lookupCollection(environmentID: String, collectionName: String) -> String? {
        var collectionID: String?

        let failure = { (error: Error) in XCTFail("Could not get collections: \(error)") }

        let expectation = self.expectation(description: "Look up collection.")
        discovery.getCollections(withEnvironmentID: environmentID, failure: failure) {
            collections in
            for collection in collections where self.collectionName == collection.name {
                collectionID = collection.collectionID
                expectation.fulfill()
                return
            }
            expectation.fulfill()
        }
        waitForExpectations()
        if collectionID == nil {
            collectionID = self.createCollection(environmentID: environmentID, collectionName: collectionName)
        }
        return collectionID
    }

    /** Create a collection for the test suite. */
    func createCollection(environmentID: String, collectionName: String) -> String? {
        var collectionID: String?

        var tries = 0
        while tries < 10 {
            tries += 1

            var tryAgain = false
            let expectation = self.expectation(description: "Create a collection.")
            let createFailed = { (error: Error) in
                tryAgain = error.localizedDescription.contains("try again")
                expectation.fulfill()
            }
            discovery.createCollection(
                withEnvironmentID: environmentID,
                withName: collectionName,
                withDescription: "Collection for Swift SDK tests -- do not delete",
                failure: createFailed) {
                    collection in
                    collectionID = collection.collectionID
                    expectation.fulfill()
            }
            waitForExpectations()

            if collectionID != nil {
                return collectionID
            }
            if !tryAgain {
                break
            }
            sleep(15)
        }
        XCTFail("Could not create collection")
        return nil
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
    func waitForExpectations(timeout: TimeInterval = 20.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: - Environments

    /** Retrieve a list of the environments associated with this service instance. */
    func testGetEnvironments() {

        let expectation = self.expectation(description: "Retrieve a list of environments.")
        discovery.getEnvironments(failure: failWithError) { environments in
            XCTAssertGreaterThan(environments.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Create, Update, and Delete a test environment. */
    func testCreateUpdateAndDeleteEnvironment() {

        let environmentName = "swift-sdk-test-environment"
        let environmentDescription = "Test environment for Swift SDK"
        var environmentID: String?

        let expectation = self.expectation(description: "Create an environment.")

        let createFailure = { (error: Error) in
            if error.localizedDescription.contains("Cannot provision more than one environment") {
                expectation.fulfill()
                return
            }
            self.failWithError(error: error)
        }

        discovery.createEnvironment(
            withName: environmentName,
            withSize: .one,
            withDescription: environmentDescription,
            failure: createFailure)
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
//            XCTAssertNotNil(environment.indexCapacity?.diskUsage)
//            XCTAssertNotNil(environment.indexCapacity?.memoryUsage)
//
//            // check all the fields within diskUsage are present
//            let diskUsage = environment.indexCapacity?.diskUsage
//            XCTAssertNotNil(diskUsage?.usedBytes)
//            XCTAssertNotNil(diskUsage?.totalBytes)
//            XCTAssertNotNil(diskUsage?.used)
//            XCTAssertNotNil(diskUsage?.total)
//            XCTAssertNotNil(diskUsage?.percentUsed)
//
//            // check all the fields within memoryUsage are present
//            let memoryUsage = environment.indexCapacity?.memoryUsage
//            XCTAssertNotNil(memoryUsage?.usedBytes)
//            XCTAssertNotNil(memoryUsage?.totalBytes)
//            XCTAssertNotNil(memoryUsage?.used)
//            XCTAssertNotNil(memoryUsage?.total)
//            XCTAssertNotNil(memoryUsage?.percentUsed)

            expectation.fulfill()
        }
        waitForExpectations()

        // Skip the rest of the test if the createEnviroment failed. The createFailure closure
        // will determine if the test has failed based on the error code
        if let environmentID = environmentID {

            // Allow time for the environment to be ready for the next test.
            sleep(20)

            let expectation2 = self.expectation(description: "Update the trained environment's description and name.")

            discovery.updateEnvironment(
                withID: environmentID,
                name: "new name",
                description: "new description",
                failure: failWithError)
            {
                environment in

                XCTAssertEqual(environment.environmentID, environmentID)
                XCTAssertEqual(environment.name, "new name")
                XCTAssertEqual(environment.description, "new description")

                expectation2.fulfill()
            }
            waitForExpectations()

            let expectation3 = self.expectation(description: "Delete the test environment.")

            discovery.deleteEnvironment(withID: environmentID, failure: failWithError) {
                environment in

                XCTAssertEqual(environment.environmentID, environmentID)
                XCTAssertEqual(environment.status, "deleted")

                expectation3.fulfill()
            }
            waitForExpectations()
        }
    }

    // MARK: - Configurations

    /** Retrieve a list of the configurations in the given environment. */
    func testGetConfigurations() {

        let expectation = self.expectation(description: "Retrieve a list of configurations.")
        discovery.getConfigurations(withEnvironmentID: environmentID!, failure: failWithError) {
            configurations in

            for configuration in configurations where configuration.name == "Default Configuration" {
                XCTAssertEqual(configuration.description, "The configuration used by default when creating a new collection without specifying a configuration_id.")
                expectation.fulfill()
            }
        }
        waitForExpectations()
    }

    /** Retrieve a configuration by name where the name contains special chars. */
    func testCreateGetDeleteConfigurationWithFunkyName() {

        let configurationName = UUID().uuidString + " with \"funky\" ?x=y&foo=bar ,[x](y) ~!@#$%^&*()-+ {} | ;:<>\\/ chars"

        let configuration = ConfigurationDetails(
            name: configurationName,
            description: "configuration with funky name")

        var newConfigurationID: String?

        let expectation = self.expectation(description: "Retrieve a configuration with a funky name.")
        discovery.createConfiguration(
            withEnvironmentID: environmentID!,
            configuration: configuration,
            failure: failWithError) { _ in

                self.discovery.getConfigurations(withEnvironmentID: self.environmentID!, withName: configurationName, failure: self.failWithError) {
                    configurations in

                    XCTAssertEqual(configurations.count, 1)
                    XCTAssertEqual(configurations[0].name, configurationName)
                    XCTAssertNotNil(configurations[0].configurationID)
                    newConfigurationID = configurations[0].configurationID

                    expectation.fulfill()
                }
            }

        waitForExpectations()

        guard let newConfigID = newConfigurationID else {
            XCTFail("Failed to instantiate configurationID when creating configuration.")
            return
        }

        let expectation2 = self.expectation(description: "Delete the new configuration.")
        discovery.deleteConfiguration(
            withEnvironmentID: environmentID!,
            withConfigurationID: newConfigID,
            failure: failWithError) { configuration in

                XCTAssertEqual(configuration.configurationID, newConfigID)
                XCTAssertEqual(configuration.status, "deleted")
                XCTAssertNil(configuration.noticeMessages)
                expectation2.fulfill()
        }
        waitForExpectations()
    }

    /** Create and delete a configuration. */
    func testCreateAndDeleteConfiguration() {

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

        let expectation = self.expectation(description: "Create a new configuration.")
        discovery.createConfiguration(
            withEnvironmentID: environmentID!,
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

        guard let newConfigID = newConfigurationID else {
            XCTFail("Failed to instantiate configurationID when creating configuration.")
            return
        }

        let expectation2 = self.expectation(description: "Delete the new configuration.")
        discovery.deleteConfiguration(
            withEnvironmentID: environmentID!,
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

        guard let configurationID = lookupConfiguration(environmentID: environmentID!, configurationName: defaultConfigurationName) else {
            XCTFail("Failed to find the default configuration.")
            return
        }

        let expectation = self.expectation(description: "Retrieve details of the default configuration.")
        discovery.getConfiguration(
            withEnvironmentID: environmentID!,
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

        let expectation = self.expectation(description: "Create a new configuration.")
        discovery.createConfiguration(
            withEnvironmentID: environmentID!,
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

        let normalization = Normalization(
            operation: .move,
            sourceField: "extracted_metadata.title",
            destinationField: "metadata.title"
        )

        let configuration2 = ConfigurationDetails(
            name: "swift-sdk-unit-test-new-configuration",
            description: "replacement test configuration",
            normalizations: [normalization])

        let expectation2 = self.expectation(description: "Update the configuration.")
        discovery.updateConfiguration(
            withEnvironmentID: environmentID!,
            withConfigurationID: newConfigID,
            configuration: configuration2,
            failure: failWithError) { _ in
                expectation2.fulfill()
            }
        waitForExpectations()

        let expectation3 = self.expectation(description: "Retrieve details of the updated configuration.")
        discovery.getConfiguration(
            withEnvironmentID: environmentID!,
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

        let expectation4 = self.expectation(description: "Delete the new configuration.")
        discovery.deleteConfiguration(
            withEnvironmentID: environmentID!,
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

        guard let configurationID = lookupConfiguration(environmentID: environmentID!, configurationName: defaultConfigurationName) else {
            XCTFail("Failed to find the default configuration.")
            return
        }
        #if os(iOS)
            guard let file = Bundle(for: type(of: self)).url(forResource: "metadata", withExtension: "json") else {
                XCTFail("Unable to locate metadata.json")
                return
            }
        #else
             let file = URL(fileURLWithPath: "Tests/DiscoveryV1Tests/metadata.json")
        #endif

        let expectation = self.expectation(description: "Test default configuration on document.")
        discovery.testConfigurationInEnvironment(
            withEnvironmentID: environmentID!,
            withConfigurationID: configurationID,
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

        let expectation = self.expectation(description: "Retrieve a list of collections.")
        discovery.getCollections(withEnvironmentID: environmentID!, withName: collectionName) {
            collections in
            XCTAssertNotNil(collections)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Create, update and delete collection. */
    func testCreateUpdateAndDeleteCollection() {

        guard let configurationID = lookupConfiguration(environmentID: environmentID!, configurationName: defaultConfigurationName) else {
            XCTFail("Failed to find the default configuration.")
            return
        }

        let collectionName = "swift-sdk-unit-test-collection-to-delete"
        let collectionDescription = "collection for test suite"
        var collectionID: String?

        let expectation = self.expectation(description: "Create a new collection.")
        discovery.createCollection(
            withEnvironmentID: environmentID!,
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

        let updatedName = "updated-name"
        let updatedDescription = "updated-description"

        let expectation2 = self.expectation(description: "Update test collection name and description.")
        discovery.updateCollection(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID!,
            name: updatedName,
            description: updatedDescription,
            configurationID: configurationID) {
                collection in
                XCTAssertEqual(updatedName, collection.name)
                XCTAssertEqual(updatedDescription, collection.description)
                XCTAssertEqual(configurationID, collection.configurationID)

                expectation2.fulfill()
        }
        waitForExpectations()

        guard let collectionToDelete = collectionID else {
            XCTFail("Failed to instantiate collectionID when creating collection.")
            return
        }

        let expectation3 = self.expectation(description: "Delete the new collection.")
        discovery.deleteCollection(withEnvironmentID: environmentID!, withCollectionID: collectionToDelete, failure: failWithError) {
            collection in

            XCTAssertEqual(collection.collectionID, collectionToDelete)
            XCTAssertEqual(collection.status, CollectionStatus.deleted)

            expectation3.fulfill()
        }
        waitForExpectations()
    }

    /** Retrieve test collection details. */
    func testListCollectionDetails() {

        guard let configurationID = lookupConfiguration(environmentID: environmentID!, configurationName: defaultConfigurationName) else {
            XCTFail("Failed to find the default configuration.")
            return
        }

        guard let collectionID = lookupCollection(environmentID: environmentID!, collectionName: collectionName) else {
            XCTFail("Failed to find the test collection.")
            return
        }

        let expectation = self.expectation(description: "Retrieve test collection.")
        discovery.listCollectionDetails(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID,
            failure: failWithError) {
                collection in

                // Verify all fields are present.
                XCTAssertEqual(collectionID, collection.collectionID)
                XCTAssertEqual(self.collectionName, collection.name)
                XCTAssertNotNil(collection.description)
                XCTAssertNotNil(collection.created)
                XCTAssertNotNil(collection.updated)
                XCTAssertNotNil(collection.status)
                XCTAssertEqual(configurationID, collection.configurationID)
                XCTAssertNotNil(collection.documentCounts?.available)
                XCTAssertNotNil(collection.documentCounts?.processing)
                XCTAssertNotNil(collection.documentCounts?.failed)

                expectation.fulfill()
        }
        waitForExpectations()
    }

    /** List the fields in the test suite's collection. */
    func testListCollectionFields() {

        guard let collectionID = lookupCollection(environmentID: environmentID!, collectionName: collectionName) else {
            XCTFail("Failed to find the test collection.")
            return
        }

        let expectation = self.expectation(description: "List the fields in the test suite's collection.")
        discovery.listCollectionFields(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID,
            failure: failWithError) {
                fields in
                XCTAssertNotNil(fields)
                expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Test Documents
    func testAddGetUpdateDeleteDocument() {

        guard let collectionID = lookupCollection(environmentID: environmentID!, collectionName: collectionName) else {
            XCTFail("Failed to find the test collection.")
            return
        }
        #if os(iOS)
            guard let file = Bundle(for: type(of: self)).url(forResource: "discoverySample", withExtension: "json") else {
                XCTFail("Unable to locate discoverySample.json")
                return
            }
        #else
            let file = URL(fileURLWithPath: "Tests/DiscoveryV1Tests/discoverySample.json")
        #endif

        var documentID: String?
        // Add document to test collection and environment
        let expectation = self.expectation(description: "Add a document to the sample collection.")
        discovery.addDocumentToCollection(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID,
            file: file,
            failure: failWithError) {
                document in
                documentID = document.documentID
                XCTAssertNotNil(document.status)
                expectation.fulfill()
        }
        waitForExpectations()

        guard let docID = documentID else {
            XCTFail("Failed to grab document ID from adding document to collection.")
            return
        }

        // List details of a document in the test collection.

        let expectation2 = self.expectation(description: "List details of a document in the test collection.")
        discovery.listDocumentDetails(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID,
            withDocumentID: documentID!,
            failure: failWithError) { document in
                XCTAssertEqual(documentID!, document.documentID)
                XCTAssertEqual(document.status, DocumentStatus.processing)
                XCTAssertNotNil(document.notices)
                XCTAssertNotNil(document.statusDescription)
                expectation2.fulfill()
        }
        waitForExpectations()

        // Update document in the test collection.
        #if os(iOS)
            guard let metadata = Bundle(for: type(of: self)).url(forResource: "metadata", withExtension: "json") else {
                XCTFail("Unable to locate metadata.json")
                return
            }
        #else
            let metadata = URL(fileURLWithPath: "Tests/DiscoveryV1Tests/metadata.json")
        #endif

        let expectation3 = self.expectation(description: "Update document name and description in collection.")
        discovery.updateDocumentInCollection(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID,
            withDocumentID: documentID!,
            file: file,
            metadata: metadata,
            failure: failWithError) { document in
                XCTAssertEqual(documentID!, document.documentID)
                XCTAssertEqual(document.status, DocumentStatus.processing)
                expectation3.fulfill()
        }
        waitForExpectations()

        // Delete document from test collection and environment

        let expectation4 = self.expectation(description: "Delete newly created document from collection.")
        discovery.deleteDocumentFromCollection(
            withEnvironmentID: environmentID!,
            withCollectionID: collectionID,
            withDocumentID: docID,
            failure: failWithError) {
                document in
                XCTAssertEqual(documentID, document.documentID)
                XCTAssertEqual(DocumentStatus.deleted, document.status)
                expectation4.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Test Query

    // https://console.bluemix.net/docs/services/discovery/migrate-bwdn.html#migrating-from-watson-discovery-news-original

    // swiftlint:disable:next cyclomatic_complexity
    func testQueryInNewsCollection() {

        let query = "enriched_text.concepts.text:\"Cloud computing\""
        let aggregation = "[timeslice(publication_date,12hours).filter(entities.type:Company).term(entities.text).term(docSentiment.type),filter(entities.type:Company).term(entities.text),filter(entities.type:Person).term(entities.text),term(keywords.text),term(enriched_text.sentiment.document.score),min(enriched_text.sentiment.document.score),max(enriched_text.sentiment.document.score)]"
        let count = 10

        let expectation = self.expectation(description: "Query, filter and aggregate news resources in Watson collection.")
        discovery.queryDocumentsInCollection(
            withEnvironmentID: newsEnvironmentID,
            withCollectionID: newsCollectionID,
            withQuery: query,
            withAggregation: aggregation,
            count: count,
            //return: returnWatson,
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
                        XCTAssertNotNil(result.text)
                        XCTAssertNotNil(result.enrichedTitle)
                        XCTAssertNotNil(result.extractedURL)
                        break
                    }
                }
                /// Test all different types of aggregation queries.
                XCTAssertNotNil(queryResponse.aggregations)
                if let aggregations = queryResponse.aggregations {
                    for aggregation in aggregations {
                        XCTAssertNotNil(aggregation.type)
                        if let type = aggregation.type {
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
                    }
                }
                XCTAssertNotNil(queryResponse.results)

                expectation.fulfill()
        }
        waitForExpectations()
    }

    /* Test 'Concepts' model within the documents in the test collection. */
    func testConceptsModel() {

        let query = "United Nations"

        /// Specify which portion of the document hierarchy to return.
        let returnHierarchies = "enriched_text.concepts"

        let expectation = self.expectation(description: "Test \'Concepts\' model within the documents in the test collection.")
        discovery.queryDocumentsInCollection(
            withEnvironmentID: newsEnvironmentID,
            withCollectionID: newsCollectionID,
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
                                for concept in concepts where concept.text == query {
                                    conceptMatchesQuery = true
                                    //XCTAssertNotNil(concept.website, "http://www.un.org/")
                                    //XCTAssertNotNil(concept.dbpedia)
                                    XCTAssertNotNil(concept.relevance)
                                    //XCTAssertNotNil(concept.freebase)
                                    //XCTAssertNotNil(concept.yago)
                                    XCTAssertNotNil(concept.json["dbpedia_resource"])
                                    break
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

        let query = "United Nations"

        /// Specify which portion of the document hierarchy to return.
        let returnHierarchies = "enriched_text.sentiment.document"

        let expectation = self.expectation(description: "Test EnrichedTitle.docSentiment model within the documents in the test collection.")
        discovery.queryDocumentsInCollection(
            withEnvironmentID: newsEnvironmentID,
            withCollectionID: newsCollectionID,
            withQuery: query,
            return: returnHierarchies,
            failure: failWithError) { queryResponse in
                XCTAssertNotNil(queryResponse.results)
                if let results = queryResponse.results {
                    for result in results {
                        XCTAssertNotNil(result.enrichedTitle)
                        if let enrichedTitle = result.enrichedTitle {
                            let sentiment = enrichedTitle.json["sentiment"] as? [String: Any]
                            XCTAssertNotNil(sentiment)
                            let document = sentiment!["document"] as? [String: Any]
                            XCTAssertNotNil(document)
                            XCTAssertNotNil(document!["score"])
                        }
                    }
                }
                expectation.fulfill()
        }
        waitForExpectations()
    }

    /* Test EnrichedTitle.taxonomy within the document in the test collection.*/
    func testTaxonomyModel() {

        let query = "United Nations"

        /// Specify which portion of the document hierarchy to return.
        let returnHierarchies = "enriched_text.taxonomy"

        let expectation = self.expectation(description: "Test EnrichedTitle.docSentiment model within the documents in the test collection.")
        discovery.queryDocumentsInCollection(
            withEnvironmentID: newsEnvironmentID,
            withCollectionID: newsCollectionID,
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
    // swiftlint:disable:next cyclomatic_complexity
    func testRelationsModel() {

        let query = "enriched_title.concepts.text:\"artificial intelligence\""
        let filter = "enriched_title.semantic_roles.subject.entities.type:\"Company\",enriched_title.semantic_roles.action.normalized:\"acquire\""

        /// Specify which portion of the document hierarchy to return.
        let returnHierarchies = "enriched_text.semantic_roles"

        let expectation = self.expectation(description: "Test EnrichedTitle.docSentiment, subject, action, object models within the documents in the test collection.")
        discovery.queryDocumentsInCollection(
            withEnvironmentID: newsEnvironmentID,
            withCollectionID: newsCollectionID,
            withFilter: filter,
            withQuery: query,
            return: returnHierarchies,
            failure: failWithError) { queryResponse in
                XCTAssertNotNil(queryResponse.results)
                if let results = queryResponse.results {
                    for result in results {
                        XCTAssertNotNil(result.enrichedTitle)
                        if let enrichedTitle = result.enrichedTitle {
                            XCTAssertNotNil(enrichedTitle.json["semantic_roles"])
                            if let semantic_roles = enrichedTitle.json["semantic_roles"] as? [[String: Any]] {
                                for semantic_role in semantic_roles {
                                    XCTAssertNotNil(semantic_role["sentence"])
                                    XCTAssertNotNil(semantic_role["action"])
                                    XCTAssertNotNil(semantic_role["subject"])
                                    //XCTAssertNotNil(semantic_role["object"])
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

        let query = "United Nations"

        /// Specify which portion of the document hierarchy to return.
        let returnHierarchies = "enriched_text.entities"

        let expectation = self.expectation(description: "Test enriched_text.entities models within the documents in the test collection.")
        discovery.queryDocumentsInCollection(
            withEnvironmentID: newsEnvironmentID,
            withCollectionID: newsCollectionID,
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

        let query = "United Nations"
        let aggregation = "max(enriched_text.entities.sentiment.score)"

        /// Specify which portion of the document hierarchy to return.
        let returnHierarchies = "enriched_text.entities.sentiment,enriched_text.entities.text"

        let expectation = self.expectation(description: "Test enriched_text.entities models within the documents in the test collection.")
        discovery.queryDocumentsInCollection(
            withEnvironmentID: newsEnvironmentID,
            withCollectionID: newsCollectionID,
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
