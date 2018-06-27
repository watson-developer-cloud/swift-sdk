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

// swiftlint:disable function_body_length force_try force_unwrapping file_length

import XCTest
import Foundation
import DiscoveryV1

class DiscoveryTests: XCTestCase {

    private var discovery: Discovery!
    private var environment: Environment!
    private let newsEnvironmentID = "system"
    private let newsCollectionID = "news-en"
    private var documentURL: URL!
    private let timeout: TimeInterval = 20.0

    // MARK: - Test Configuration

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        discovery = instantiateDiscovery()
        environment = lookupOrCreateTestEnvironment()
        documentURL = loadDocument(name: "KennedySpeech", ext: "html")
    }

    func instantiateDiscovery() -> Discovery {
        let username = Credentials.DiscoveryUsername
        let password = Credentials.DiscoveryPassword
        let version = "2017-11-07"
        let discovery = Discovery(username: username, password: password, version: version)
        discovery.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        discovery.defaultHeaders["X-Watson-Test"] = "true"
        return discovery
    }

    func loadDocument(name: String, ext: String) -> URL? {
        #if os(Linux)
            let url = URL(fileURLWithPath: "Tests/DiscoveryV1Tests/" + name + "." + ext)
        #else
            let bundle = Bundle(for: type(of: self))
            guard let url = bundle.url(forResource: name, withExtension: ext) else { return nil }
        #endif
        return url
    }

    // MARK: - Test Definition for Linux

    static var allTests: [(String, (DiscoveryTests) -> () throws -> Void)] {
        return [
            ("testListEnvironments", testListEnvironments),
            ("testListEnvironmentsByName", testListEnvironmentsByName),
            ("testGetEnvironment", testGetEnvironment),
            ("testEnvironmentCRUD", testEnvironmentCRUD),
            ("testListFields", testListFields),
            ("testListConfigurations", testListConfigurations),
            ("testListConfigurationsByName", testListConfigurationsByName),
            ("testConfigurationCRUD", testConfigurationCRUD),
            ("testConfigurationInEnvironment", testConfigurationInEnvironment),
            ("testListCollections", testListCollections),
            ("testListCollectionsByName", testListCollectionsByName),
            ("testCollectionsCRUD", testCollectionsCRUD),
            ("testListCollectionFields", testListCollectionFields),
            ("testExpansionsCRUD", testExpansionsCRUD),
            ("testDocumentsCRUD", testDocumentsCRUD),
            ("testQuery", testQuery),
            ("testQueryWithNaturalLanguage", testQueryWithNaturalLanguage),
            ("testQueryWithPassages", testQueryWithPassages),
            ("testQueryWithSimilar", testQueryWithSimilar),
            ("testQueryWithTermAggregation", testQueryWithTermAggregation),
            ("testQueryWithFilterAggregation", testQueryWithFilterAggregation),
            ("testQueryWithNestedAggregation", testQueryWithNestedAggregation),
            ("testQueryWithHistogramAggregation", testQueryWithHistogramAggregation),
            ("testQueryWithTimesliceAggregation", testQueryWithTimesliceAggregation),
            ("testQueryWithTopHitsAggregation", testQueryWithTopHitsAggregation),
            ("testQueryWithUniqueCountAggregation", testQueryWithUniqueCountAggregation),
            ("testQueryWithMaxAggregation", testQueryWithMaxAggregation),
            ("testQueryWithMinAggregation", testQueryWithMinAggregation),
            ("testQueryWithAverageAggregation", testQueryWithAverageAggregation),
            ("testQueryWithSumAggregation", testQueryWithSumAggregation),
            ("testQueryNotices", testQueryNotices),
            ("testFederatedQuery", testFederatedQuery),
            ("testFederatedQueryNotices", testFederatedQueryNotices),
            ("testListTrainingData", testListTrainingData),
            ("testTrainingDataCRUD", testTrainingDataCRUD),
            ("testDeleteAllTrainingData", testDeleteAllTrainingData),
            ("testListTrainingExamples", testListTrainingExamples),
            ("testTrainingExamplesCRUD", testTrainingExamplesCRUD),
            ("testGetEnvironmentWithInvalidID", testGetEnvironmentWithInvalidID),
            ("testGetConfigurationWithInvalidID", testGetConfigurationWithInvalidID),
            ("testGetCollectionWithInvalidID", testGetCollectionWithInvalidID),
            ("testQueryWithInvalidID", testQueryWithInvalidID),
        ]
    }

    // MARK: - State Management

    func lookupOrCreateTestEnvironment() -> Environment {
        var environment: Environment!
        let expectation = self.expectation(description: "listEnvironments")
        let failure = { (error: Error) in XCTFail("Failed to lookup environment: \(error.localizedDescription)") }
        discovery.listEnvironments(failure: failure) {
            response in
            environment = response.environments?.first { !($0.readOnly ?? true) }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
        return environment ?? createTestEnvironment()

    }

    func createTestEnvironment() -> Environment {
        var environment: Environment!
        let expectation = self.expectation(description: "createEnvironment")
        let name = "swift-sdk-test-" + UUID().uuidString
        let description = "An environment created while testing the Swift SDK. Safe to delete."
        let failure = { (error: Error) in XCTFail("Failed to create an environment: \(error.localizedDescription)") }
        discovery.createEnvironment(name: name, description: description, size: 0, failure: failure) {
            response in
            environment = response
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
        return environment
    }

    func lookupOrCreateTestConfiguration(environmentID: String) -> Configuration {
        var configuration: Configuration!
        let expectation = self.expectation(description: "listConfigurations")
        let failure = { (error: Error) in XCTFail("Failed to lookup Configuration: \(error.localizedDescription)") }
        discovery.listConfigurations(environmentID: environmentID, failure: failure) {
            response in
            configuration = response.configurations?.first { $0.name.starts(with: "swift-sdk-test-") }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
        return configuration ?? createTestConfiguration(environmentID: environmentID)
    }

    func createTestConfiguration(environmentID: String) -> Configuration {
        var configuration: Configuration!
        let expectation = self.expectation(description: "createConfiguration")
        let name = "swift-sdk-test-" + UUID().uuidString
        let description = "A configuration created while testing the Swift SDK. Safe to delete."
        let properties = Configuration(name: name, description: description)
        let failure = { (error: Error) in XCTFail("Failed to create a test configuration: \(error.localizedDescription)") }
        discovery.createConfiguration(environmentID: environmentID, configuration: properties, failure: failure) {
            response in
            configuration = response
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
        return configuration
    }

    func lookupOrCreateTestCollection(environmentID: String, configurationID: String) -> DiscoveryV1.Collection {
        var collection: DiscoveryV1.Collection!
        let expectation = self.expectation(description: "listCollections")
        let failure = { (error: Error) in XCTFail("Failed to lookup Collection: \(error.localizedDescription)") }
        discovery.listCollections(environmentID: environmentID, failure: failure) {
            response in
            collection = response.collections?.first { $0.name?.starts(with: "swift-sdk-test-") ?? false }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
        return collection ?? self.createTestCollection(environmentID: environmentID, configurationID: configurationID)
    }

    func createTestCollection(environmentID: String, configurationID: String) -> DiscoveryV1.Collection {
        var collection: DiscoveryV1.Collection!
        let expectation = self.expectation(description: "createCollection")
        let properties = CreateCollectionRequest(
            name: "swift-sdk-test-" + UUID().uuidString,
            description: "A collection created while testing the Swift SDK. Safe to delete.",
            configurationID: configurationID,
            language: "en"
        )
        discovery.createCollection(environmentID: environmentID, properties: properties, failure: failWithError) {
            response in
            collection = response
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
        return collection
    }

    func addTestDocument(environment: Environment, collection: DiscoveryV1.Collection) -> DocumentAccepted {
        var documentAccepted: DocumentAccepted!
        let expectation = self.expectation(description: "addDocument")
        let environmentID = environment.environmentID!
        let collectionID = collection.collectionID!
        discovery.addDocument(
            environmentID: environmentID,
            collectionID: collectionID,
            file: documentURL,
            fileContentType: "text/html",
            failure: failWithError)
        {
            response in
            documentAccepted = response
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
        return documentAccepted
    }

    // MARK: - Helper Functions

    func failWithError(error: Error) {
        XCTFail("Positive test failed with error: \(error)")
    }

    func failWithResult<T>(result: T) {
        XCTFail("Negative test returned a result.")
    }

    func failWithResult() {
        XCTFail("Negative test returned a result.")
    }

    // MARK: - Environments

    func testListEnvironments() {
        let expectation = self.expectation(description: "listEnvironments")
        discovery.listEnvironments(failure: failWithError) {
            response in
            XCTAssertNotNil(response.environments)
            XCTAssertGreaterThan(response.environments!.count, 0)
            XCTAssert(response.environments!.contains { $0.environmentID! == "system" && $0.readOnly! })
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testListEnvironmentsByName() {
        let expectation = self.expectation(description: "listEnvironments")
        discovery.listEnvironments(name: environment.name, failure: failWithError) {
            response in
            XCTAssertNotNil(response.environments)
            XCTAssertGreaterThan(response.environments!.count, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testGetEnvironment() {
        let expectation = self.expectation(description: "getEnvironment")
        discovery.getEnvironment(environmentID: environment.environmentID!, failure: failWithError) {
            response in
            XCTAssertEqual(self.environment.environmentID, response.environmentID)
            XCTAssertEqual(self.environment.name, response.name)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testEnvironmentCRUD() {
        let expectation1 = self.expectation(description: "createEnvironment")
        let name = "swift-sdk-test-" + UUID().uuidString
        let description = "An environment created while testing the Swift SDK. Safe to delete."
        let message = "Cannot provision more than one environment"
        let failure = { (error: Error) in
            error.localizedDescription.contains(message) ? expectation1.fulfill() : self.failWithError(error: error)
        }
        var environment: Environment!
        discovery.createEnvironment(name: name, description: description, size: 0, failure: failure) {
            response in
            environment = response
            expectation1.fulfill()
        }
        waitForExpectations(timeout: timeout)

        // assume that the read, update, and delete tests will pass even if an environment was not created
        // (for example, if we received an error message "cannot provision more than one environment")
        guard environment != nil else {
            return
        }

        let expectation2 = self.expectation(description: "getEnvironment.")
        discovery.getEnvironment(environmentID: environment.environmentID!, failure: failWithError) {
            response in
            XCTAssertEqual(environment.environmentID, response.environmentID)
            XCTAssertEqual(environment.name, response.name)
            XCTAssertEqual(environment.description, response.description)
            XCTAssertEqual(environment.readOnly, response.readOnly)
            expectation2.fulfill()
        }
        waitForExpectations(timeout: timeout)

        let expectation3 = self.expectation(description: "updateEnvironment.")
        let newName = "swift-sdk-test-" + UUID().uuidString
        discovery.updateEnvironment(environmentID: environment.environmentID!, name: newName, failure: failWithError) {
            response in
            XCTAssertEqual(response.name!, newName)
            expectation3.fulfill()
        }
        waitForExpectations(timeout: timeout)

        let expectation4 = self.expectation(description: "deleteEnvironment.")
        discovery.deleteEnvironment(environmentID: environment.environmentID!, failure: failWithError) {
            response in
            XCTAssertEqual(environment.environmentID!, response.environmentID)
            XCTAssertEqual(response.status, "deleted")
            expectation4.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testListFields() {
        let environmentID = environment.environmentID!
        let configuration = lookupOrCreateTestConfiguration(environmentID: environmentID)
        let collection = lookupOrCreateTestCollection(environmentID: environmentID, configurationID: configuration.configurationID!)
        _ = addTestDocument(environment: environment, collection: collection)
        sleep(10) // wait for document to be ingested
        let expectation = self.expectation(description: "listFields")
        let collectionIDs = [collection.collectionID!]
        discovery.listFields(environmentID: environmentID, collectionIds: collectionIDs, failure: failWithError) {
            response in
            XCTAssertNotNil(response.fields)
            XCTAssertGreaterThan(response.fields!.count, 0)
            XCTAssertNotNil(response.fields!.first!.fieldName)
            XCTAssertNotNil(response.fields!.first!.fieldType)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: - Configurations

    func testListConfigurations() {
        let configuration = lookupOrCreateTestConfiguration(environmentID: environment.environmentID!)
        let expectation = self.expectation(description: "listConfigurations")
        discovery.listConfigurations(environmentID: environment.environmentID!, failure: failWithError) {
            response in
            XCTAssertNotNil(response.configurations)
            XCTAssertGreaterThan(response.configurations!.count, 0)
            XCTAssert(response.configurations!.contains { $0.configurationID! == configuration.configurationID! })
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testListConfigurationsByName() {
        let configuration = lookupOrCreateTestConfiguration(environmentID: environment.environmentID!)
        let expectation = self.expectation(description: "listConfigurations")
        let name = configuration.name
        discovery.listConfigurations(environmentID: environment.environmentID!, name: name, failure: failWithError) {
            response in
            XCTAssertNotNil(response.configurations)
            XCTAssertGreaterThan(response.configurations!.count, 0)
            XCTAssert(response.configurations!.contains { $0.configurationID! == configuration.configurationID! })
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testConfigurationCRUD() {
        let expectation1 = self.expectation(description: "createConfiguration")
        let environmentID = environment.environmentID!
        let name = "swift-sdk-test-" + UUID().uuidString
        let description = "A configuration created while testing the Swift SDK. Safe to delete."
        let properties = Configuration(name: name, description: description)
        var configuration: Configuration!
        discovery.createConfiguration(environmentID: environmentID, configuration: properties, failure: failWithError) {
            response in
            configuration = response
            XCTAssertEqual(configuration.name, name)
            XCTAssertEqual(configuration.description, description)
            expectation1.fulfill()
        }
        waitForExpectations(timeout: timeout)

        let expectation2 = self.expectation(description: "getConfiguration")
        let configurationID = configuration.configurationID!
        discovery.getConfiguration(environmentID: environmentID, configurationID: configurationID, failure: failWithError) {
            response in
            XCTAssertEqual(configuration.configurationID, response.configurationID)
            XCTAssertEqual(configuration.name, response.name)
            XCTAssertEqual(configuration.description, response.description)
            expectation2.fulfill()
        }
        waitForExpectations(timeout: timeout)

        let expectation3 = self.expectation(description: "updateConfiguration")
        let newName = "swift-sdk-test-" + UUID().uuidString
        let newProperties = Configuration(name: newName)
        discovery.updateConfiguration(environmentID: environmentID, configurationID: configurationID, configuration: newProperties, failure: failWithError) {
            response in
            XCTAssertEqual(newName, response.name)
            XCTAssertEqual(configuration.configurationID, response.configurationID)
            expectation3.fulfill()
        }
        waitForExpectations(timeout: timeout)

        let expectation4 = self.expectation(description: "deleteConfiguration")
        discovery.deleteConfiguration(environmentID: environmentID, configurationID: configurationID, failure: failWithError) {
            response in
            XCTAssertEqual(response.configurationID, configuration.configurationID!)
            XCTAssertEqual(response.status, "deleted")
            expectation4.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: - Test Configuration in Environment

    func testConfigurationInEnvironment() {
        let environmentID = environment.environmentID!
        let configuration = lookupOrCreateTestConfiguration(environmentID: environmentID)
        let expectation = self.expectation(description: "testConfigurationInEnvironment")
        discovery.testConfigurationInEnvironment(
            environmentID: environmentID,
            configurationID: configuration.configurationID,
            file: documentURL,
            metadata: "{ \"Creator\": \"John F. Kennedy\" }",
            fileContentType: "text/html",
            failure: failWithError)
        {
            response in
            XCTAssertEqual(response.status, "completed")
            XCTAssertEqual(response.originalMediaType, "text/html")
            XCTAssertNotNil(response.snapshots)
            XCTAssertGreaterThan(response.snapshots!.count, 0)
            XCTAssertEqual(response.snapshots!.first!.step, "html_input")
            XCTAssertNotNil(response.snapshots!.first!.snapshot)
            XCTAssertGreaterThan(response.snapshots!.first!.snapshot!.count, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: - Collections

    func testListCollections() {
        let environmentID = environment.environmentID!
        let configuration = lookupOrCreateTestConfiguration(environmentID: environmentID)
        let collection = lookupOrCreateTestCollection(environmentID: environmentID, configurationID: configuration.configurationID!)
        let expectation = self.expectation(description: "listCollections")
        discovery.listCollections(environmentID: environmentID, failure: failWithError) {
            response in
            XCTAssertNotNil(response.collections)
            XCTAssertGreaterThan(response.collections!.count, 0)
            XCTAssert(response.collections!.contains { $0.collectionID == collection.collectionID })
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testListCollectionsByName() {
        let environmentID = environment.environmentID!
        let configuration = lookupOrCreateTestConfiguration(environmentID: environmentID)
        let collection = lookupOrCreateTestCollection(environmentID: environmentID, configurationID: configuration.configurationID!)
        let expectation = self.expectation(description: "listCollections")
        discovery.listCollections(environmentID: environmentID, name: collection.name!, failure: failWithError) {
            response in
            XCTAssertNotNil(response.collections)
            XCTAssertGreaterThan(response.collections!.count, 0)
            XCTAssert(response.collections!.contains { $0.collectionID == collection.collectionID })
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testCollectionsCRUD() {
        var collection: DiscoveryV1.Collection!
        let environmentID = environment.environmentID!
        let configuration = lookupOrCreateTestConfiguration(environmentID: environmentID)
        let expectation1 = self.expectation(description: "createCollection")
        let properties = CreateCollectionRequest(
            name: "swift-sdk-test-" + UUID().uuidString,
            description: "A collection created while testing the Swift SDK. Safe to delete.",
            configurationID: configuration.configurationID!,
            language: "en"
        )
        discovery.createCollection(environmentID: environmentID, properties: properties, failure: failWithError) {
            response in
            collection = response
            XCTAssertNotNil(collection.name)
            XCTAssertEqual(collection.name!, properties.name)
            XCTAssertEqual(collection.description, properties.description!)
            XCTAssertNotNil(collection.configurationID)
            XCTAssertEqual(collection.configurationID!, properties.configurationID)
            XCTAssertNotNil(collection.language)
            XCTAssertEqual(collection.language!, properties.language!)
            expectation1.fulfill()
        }
        waitForExpectations(timeout: timeout)

        let expectation2 = self.expectation(description: "getCollection")
        let collectionID = collection.collectionID!
        discovery.getCollection(environmentID: environmentID, collectionID: collectionID, failure: failWithError) {
            response in
            XCTAssertEqual(response.name, collection.name)
            XCTAssertEqual(response.description, collection.description)
            XCTAssertEqual(response.configurationID!, collection.configurationID)
            XCTAssertEqual(response.language!, collection.language!)
            expectation2.fulfill()
        }
        waitForExpectations(timeout: timeout)

        let expectation3 = self.expectation(description: "updateCollection")
        let newName = "swift-sdk-test-" + UUID().uuidString
        discovery.updateCollection(environmentID: environmentID, collectionID: collectionID, name: newName, failure: failWithError) {
            response in
            XCTAssertNotNil(response.name)
            XCTAssertEqual(response.name!, newName)
            expectation3.fulfill()
        }
        waitForExpectations(timeout: timeout)

        let expectation4 = self.expectation(description: "deleteCollection")
        discovery.deleteCollection(environmentID: environmentID, collectionID: collectionID, failure: failWithError) {
            response in
            XCTAssertEqual(response.status, "deleted")
            XCTAssertEqual(response.collectionID, collection.collectionID)
            expectation4.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testListCollectionFields() {
        let environmentID = environment.environmentID!
        let configuration = lookupOrCreateTestConfiguration(environmentID: environmentID)
        let collection = lookupOrCreateTestCollection(environmentID: environmentID, configurationID: configuration.configurationID!)
        _ = addTestDocument(environment: environment, collection: collection)
        sleep(10) // wait for document to be ingested
        let collectionID = collection.collectionID!
        let expectation = self.expectation(description: "listFields")
        discovery.listCollectionFields(environmentID: environmentID, collectionID: collectionID, failure: failWithError) {
            response in
            XCTAssertNotNil(response.fields)
            XCTAssertGreaterThan(response.fields!.count, 0)
            XCTAssertNotNil(response.fields!.first!.fieldName)
            XCTAssertNotNil(response.fields!.first!.fieldType)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testExpansionsCRUD() {
        let environmentID = environment.environmentID!
        let configuration = lookupOrCreateTestConfiguration(environmentID: environmentID)
        let collection = lookupOrCreateTestCollection(environmentID: environmentID, configurationID: configuration.configurationID!)
        let collectionID = collection.collectionID!

        let expectation1 = self.expectation(description: "createExpansions")
        let expansion = Expansion(expandedTerms: ["international business machines", "big blue"], inputTerms: ["ibm"])
        discovery.createExpansions(
            environmentID: environmentID,
            collectionID: collectionID,
            expansions: [expansion],
            failure: failWithError)
        {
            response in
            XCTAssertEqual(response.expansions.count, 1)
            XCTAssertEqual(response.expansions.first!.expandedTerms.count, 2)
            XCTAssertEqual(response.expansions.first!.inputTerms!.count, 1)
            expectation1.fulfill()
        }
        waitForExpectations(timeout: timeout)

        let expectation2 = self.expectation(description: "listExpansions")
        discovery.listExpansions(environmentID: environmentID, collectionID: collectionID, failure: failWithError) {
            response in
            XCTAssertEqual(response.expansions.count, 1)
            XCTAssertEqual(response.expansions.first!.expandedTerms.count, 2)
            XCTAssertEqual(response.expansions.first!.inputTerms!.count, 1)
            expectation2.fulfill()
        }
        waitForExpectations(timeout: timeout)

        let expectation3 = self.expectation(description: "deleteExpansions")
        discovery.deleteExpansions(environmentID: environmentID, collectionID: collectionID, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: - Documents

    func testDocumentsCRUD() {
        let environmentID = environment.environmentID!
        let configuration = lookupOrCreateTestConfiguration(environmentID: environmentID)
        let collection = lookupOrCreateTestCollection(environmentID: environmentID, configurationID: configuration.configurationID!)
        let collectionID = collection.collectionID!

        let expectation1 = self.expectation(description: "addDocument")
        let metadata = "{ \"name\": \"Kennedy Speech\" }"
        var documentID: String!
        discovery.addDocument(
            environmentID: environmentID,
            collectionID: collectionID,
            file: documentURL,
            metadata: metadata,
            fileContentType: "text/html",
            failure: failWithError)
        {
            response in
            documentID = response.documentID
            XCTAssertNotNil(response.documentID)
            XCTAssertEqual(response.status, "processing")
            XCTAssertNil(response.notices)
            expectation1.fulfill()
        }
        waitForExpectations(timeout: timeout)

        sleep(10) // wait for document to be ingested

        let expectation2 = self.expectation(description: "getDocument")
        discovery.getDocumentStatus(
            environmentID: environmentID,
            collectionID: collectionID,
            documentID: documentID,
            failure: failWithError)
        {
            response in
            XCTAssertEqual(response.documentID, documentID)
            XCTAssertEqual(response.status, "available")
            XCTAssertGreaterThan(response.statusDescription.count, 0)
            XCTAssertEqual(response.filename, "KennedySpeech.html")
            XCTAssertEqual(response.fileType, "html")
            XCTAssertEqual(response.notices.count, 0)
            expectation2.fulfill()
        }
        waitForExpectations(timeout: timeout)

        let expectation3 = self.expectation(description: "deleteDocument")
        discovery.deleteDocument(
            environmentID: environmentID,
            collectionID: collectionID,
            documentID: documentID,
            failure: failWithError)
        {
            response in
            XCTAssertEqual(response.documentID, documentID)
            XCTAssertEqual(response.status, "deleted")
            expectation3.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: - Queries

    func testQuery() {
        let expectation = self.expectation(description: "query")
        discovery.query(
            environmentID: newsEnvironmentID,
            collectionID: newsCollectionID,
            filter: "enriched_text.concepts.text:\"Technology\"",
            query: "enriched_text.concepts.text:\"Cloud computing\"",
            count: 5,
            returnFields: ["enriched_text"],
            offset: 1,
            sort: ["enriched_text.sentiment.document.score"],
            highlight: true,
            deduplicate: true,
            deduplicateField: "title",
            failure: failWithError)
        {
            queryResponse in
            XCTAssertNotNil(queryResponse.matchingResults)
            XCTAssertGreaterThan(queryResponse.matchingResults!, 0)
            XCTAssertNotNil(queryResponse.results)
            XCTAssertEqual(queryResponse.results!.count, 5)
            for result in queryResponse.results! {
                XCTAssertNotNil(result.id)
                XCTAssertNotNil(result.resultMetadata)
                XCTAssertNotNil(result.resultMetadata!.score)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testQueryWithNaturalLanguage() {
        let expectation = self.expectation(description: "query")
        discovery.query(
            environmentID: newsEnvironmentID,
            collectionID: newsCollectionID,
            naturalLanguageQuery: "Kubernetes",
            count: 5,
            failure: failWithError)
        {
            queryResponse in
            XCTAssertNotNil(queryResponse.matchingResults)
            XCTAssertGreaterThan(queryResponse.matchingResults!, 0)
            XCTAssertNotNil(queryResponse.results)
            XCTAssertEqual(queryResponse.results!.count, 5)
            for result in queryResponse.results! {
                XCTAssertNotNil(result.id)
                XCTAssertNotNil(result.resultMetadata)
                XCTAssertNotNil(result.resultMetadata!.score)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testQueryWithPassages() {
        let expectation = self.expectation(description: "query")
        discovery.query(
            environmentID: newsEnvironmentID,
            collectionID: newsCollectionID,
            query: "enriched_text.concepts.text:\"Cloud computing\"",
            passages: true,
            passagesFields: ["text"],
            passagesCount: 1,
            passagesCharacters: 400,
            failure: failWithError)
        {
            queryResponse in
            XCTAssertNotNil(queryResponse.matchingResults)
            XCTAssertGreaterThan(queryResponse.matchingResults!, 0)
            XCTAssertNotNil(queryResponse.passages)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testQueryWithSimilar() {
        let expectation = self.expectation(description: "query")
        discovery.query(
            environmentID: newsEnvironmentID,
            collectionID: newsCollectionID,
            query: "enriched_text.concepts.text:\"Cloud computing\"",
            similar: true,
            similarDocumentIds: [],
            similarFields: ["text"],
            failure: failWithError)
        {
            queryResponse in
            XCTAssertNotNil(queryResponse.matchingResults)
            XCTAssertGreaterThan(queryResponse.matchingResults!, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testQueryWithTermAggregation() {
        let expectation = self.expectation(description: "query")
        discovery.query(
            environmentID: newsEnvironmentID,
            collectionID: newsCollectionID,
            query: "enriched_text.concepts.text:\"Cloud computing\"",
            aggregation: "term(enriched_text.concepts.text,count:10)",
            count: 1,
            failure: failWithError)
        {
            queryResponse in
            XCTAssertNotNil(queryResponse.aggregations)
            XCTAssertEqual(queryResponse.aggregations!.count, 1)
            guard case let .term(term) = queryResponse.aggregations!.first! else {
                XCTFail("unexpected aggregation type")
                expectation.fulfill()
                return
            }
            XCTAssertEqual(term.type, "term")
            XCTAssertEqual(term.field, "enriched_text.concepts.text")
            XCTAssertEqual(term.count, 10)
            XCTAssertNotNil(term.results)
            XCTAssertEqual(term.results!.count, 10)
            XCTAssertNotNil(term.results!.first!.key)
            XCTAssertEqual(term.results!.first!.key, "Cloud computing")
            XCTAssertNotNil(term.results!.first!.matchingResults)
            XCTAssertGreaterThan(term.results!.first!.matchingResults!, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testQueryWithFilterAggregation() {
        let expectation = self.expectation(description: "query")
        discovery.query(
            environmentID: newsEnvironmentID,
            collectionID: newsCollectionID,
            query: "enriched_text.concepts.text:\"Cloud computing\"",
            aggregation: "filter(enriched_text.concepts.text:\"cloud computing\")",
            count: 1,
            failure: failWithError)
        {
            queryResponse in
            XCTAssertNotNil(queryResponse.aggregations)
            XCTAssertEqual(queryResponse.aggregations!.count, 1)
            guard case let .filter(filter) = queryResponse.aggregations!.first! else {
                XCTFail("unexpected aggregation type")
                expectation.fulfill()
                return
            }
            XCTAssertEqual(filter.type, "filter")
            XCTAssertEqual(filter.match, "enriched_text.concepts.text:\"cloud computing\"")
            XCTAssertNotNil(filter.matchingResults)
            XCTAssertGreaterThan(filter.matchingResults!, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testQueryWithNestedAggregation() {
        let expectation = self.expectation(description: "query")
        discovery.query(
            environmentID: newsEnvironmentID,
            collectionID: newsCollectionID,
            query: "enriched_text.concepts.text:\"Cloud computing\"",
            aggregation: "nested(enriched_text.entities)",
            count: 1,
            failure: failWithError)
        {
            queryResponse in
            XCTAssertNotNil(queryResponse.aggregations)
            XCTAssertEqual(queryResponse.aggregations!.count, 1)
            guard case let .nested(nested) = queryResponse.aggregations!.first! else {
                XCTFail("unexpected aggregation type")
                expectation.fulfill()
                return
            }
            XCTAssertEqual(nested.type, "nested")
            XCTAssertEqual(nested.path, "enriched_text.entities")
            XCTAssertNotNil(nested.matchingResults)
            XCTAssertGreaterThan(nested.matchingResults!, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testQueryWithHistogramAggregation() {
        let expectation = self.expectation(description: "query")
        discovery.query(
            environmentID: newsEnvironmentID,
            collectionID: newsCollectionID,
            query: "enriched_text.concepts.text:\"Cloud computing\"",
            aggregation: "histogram(enriched_text.concepts.relevance,interval:1)",
            count: 1,
            failure: failWithError)
        {
            queryResponse in
            XCTAssertNotNil(queryResponse.aggregations)
            XCTAssertEqual(queryResponse.aggregations!.count, 1)
            guard case let .histogram(histogram) = queryResponse.aggregations!.first! else {
                XCTFail("unexpected aggregation type")
                expectation.fulfill()
                return
            }
            XCTAssertEqual(histogram.type, "histogram")
            XCTAssertEqual(histogram.field, "enriched_text.concepts.relevance")
            XCTAssertEqual(histogram.interval, 1)
            XCTAssertNotNil(histogram.results)
            XCTAssertGreaterThan(histogram.results!.count, 0)
            XCTAssertNotNil(histogram.results!.first!.key)
            XCTAssertEqual(histogram.results!.first!.key!, "0")
            XCTAssertNotNil(histogram.results!.first!.matchingResults)
            XCTAssertGreaterThan(histogram.results!.first!.matchingResults!, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testQueryWithTimesliceAggregation() {
        let expectation = self.expectation(description: "query")
        discovery.query(
            environmentID: newsEnvironmentID,
            collectionID: newsCollectionID,
            query: "enriched_text.concepts.text:\"Cloud computing\"",
            aggregation: "timeslice(publication_date,12hours)",
            count: 1,
            failure: failWithError)
        {
            queryResponse in
            XCTAssertNotNil(queryResponse.aggregations)
            XCTAssertEqual(queryResponse.aggregations!.count, 1)
            guard case let .timeslice(timeslice) = queryResponse.aggregations!.first! else {
                XCTFail("unexpected aggregation type")
                expectation.fulfill()
                return
            }
            XCTAssertEqual(timeslice.type, "timeslice")
            XCTAssertEqual(timeslice.field, "publication_date")
            XCTAssertEqual(timeslice.interval, "12h")
            XCTAssertNotNil(timeslice.results)
            XCTAssertGreaterThan(timeslice.results!.count, 0)
            XCTAssertNotNil(timeslice.results!.first!.key)
            XCTAssertNotNil(timeslice.results!.first!.matchingResults)
            XCTAssertGreaterThan(timeslice.results!.first!.matchingResults!, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testQueryWithTopHitsAggregation() {
        let expectation = self.expectation(description: "query")
        discovery.query(
            environmentID: newsEnvironmentID,
            collectionID: newsCollectionID,
            query: "enriched_text.concepts.text:\"Cloud computing\"",
            aggregation: "top_hits(1)",
            count: 1,
            failure: failWithError)
        {
            queryResponse in
            XCTAssertNotNil(queryResponse.aggregations)
            XCTAssertEqual(queryResponse.aggregations!.count, 1)
            guard case let .topHits(topHits) = queryResponse.aggregations!.first! else {
                XCTFail("unexpected aggregation type")
                expectation.fulfill()
                return
            }
            XCTAssertEqual(topHits.type, "top_hits")
            XCTAssertEqual(topHits.size, 1)
            XCTAssertNotNil(topHits.hits)
            XCTAssertNotNil(topHits.hits!.matchingResults)
            XCTAssertGreaterThan(topHits.hits!.matchingResults!, 0)
            XCTAssertNotNil(topHits.hits!.hits)
            XCTAssertGreaterThan(topHits.hits!.hits!.count, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testQueryWithUniqueCountAggregation() {
        let expectation = self.expectation(description: "query")
        discovery.query(
            environmentID: newsEnvironmentID,
            collectionID: newsCollectionID,
            query: "enriched_text.concepts.text:\"Cloud computing\"",
            aggregation: "unique_count(enriched_text.keywords.text)",
            count: 1,
            failure: failWithError)
        {
            queryResponse in
            XCTAssertNotNil(queryResponse.aggregations)
            XCTAssertEqual(queryResponse.aggregations!.count, 1)
            guard case let .uniqueCount(uniqueCount) = queryResponse.aggregations!.first! else {
                XCTFail("unexpected aggregation type")
                expectation.fulfill()
                return
            }
            XCTAssertEqual(uniqueCount.type, "unique_count")
            XCTAssertEqual(uniqueCount.field, "enriched_text.keywords.text")
            XCTAssertNotNil(uniqueCount.value)
            XCTAssertGreaterThan(uniqueCount.value!, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testQueryWithMaxAggregation() {
        let expectation = self.expectation(description: "query")
        discovery.query(
            environmentID: newsEnvironmentID,
            collectionID: newsCollectionID,
            query: "enriched_text.concepts.text:\"Cloud computing\"",
            aggregation: "max(enriched_text.entities.count)",
            count: 1,
            failure: failWithError)
        {
            queryResponse in
            XCTAssertNotNil(queryResponse.aggregations)
            XCTAssertEqual(queryResponse.aggregations!.count, 1)
            guard case let .max(calculation) = queryResponse.aggregations!.first! else {
                XCTFail("unexpected aggregation type")
                expectation.fulfill()
                return
            }
            XCTAssertEqual(calculation.type, "max")
            XCTAssertEqual(calculation.field, "enriched_text.entities.count")
            XCTAssertNotNil(calculation.value)
            XCTAssertGreaterThan(calculation.value!, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testQueryWithMinAggregation() {
        let expectation = self.expectation(description: "query")
        discovery.query(
            environmentID: newsEnvironmentID,
            collectionID: newsCollectionID,
            query: "enriched_text.concepts.text:\"Cloud computing\"",
            aggregation: "min(enriched_text.entities.count)",
            count: 1,
            failure: failWithError)
        {
            queryResponse in
            XCTAssertNotNil(queryResponse.aggregations)
            XCTAssertEqual(queryResponse.aggregations!.count, 1)
            guard case let .min(calculation) = queryResponse.aggregations!.first! else {
                XCTFail("unexpected aggregation type")
                expectation.fulfill()
                return
            }
            XCTAssertEqual(calculation.type, "min")
            XCTAssertEqual(calculation.field, "enriched_text.entities.count")
            XCTAssertNotNil(calculation.value)
            XCTAssertGreaterThan(calculation.value!, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testQueryWithAverageAggregation() {
        let expectation = self.expectation(description: "query")
        discovery.query(
            environmentID: newsEnvironmentID,
            collectionID: newsCollectionID,
            query: "enriched_text.concepts.text:\"Cloud computing\"",
            aggregation: "average(enriched_text.entities.count)",
            count: 1,
            failure: failWithError)
        {
            queryResponse in
            XCTAssertNotNil(queryResponse.aggregations)
            XCTAssertEqual(queryResponse.aggregations!.count, 1)
            guard case let .average(calculation) = queryResponse.aggregations!.first! else {
                XCTFail("unexpected aggregation type")
                expectation.fulfill()
                return
            }
            XCTAssertEqual(calculation.type, "average")
            XCTAssertEqual(calculation.field, "enriched_text.entities.count")
            XCTAssertNotNil(calculation.value)
            XCTAssertGreaterThan(calculation.value!, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testQueryWithSumAggregation() {
        let expectation = self.expectation(description: "query")
        discovery.query(
            environmentID: newsEnvironmentID,
            collectionID: newsCollectionID,
            query: "enriched_text.concepts.text:\"Cloud computing\"",
            aggregation: "sum(enriched_text.entities.count)",
            count: 1,
            failure: failWithError)
        {
            queryResponse in
            XCTAssertNotNil(queryResponse.aggregations)
            XCTAssertEqual(queryResponse.aggregations!.count, 1)
            guard case let .sum(calculation) = queryResponse.aggregations!.first! else {
                XCTFail("unexpected aggregation type")
                expectation.fulfill()
                return
            }
            XCTAssertEqual(calculation.type, "sum")
            XCTAssertEqual(calculation.field, "enriched_text.entities.count")
            XCTAssertNotNil(calculation.value)
            XCTAssertGreaterThan(calculation.value!, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testQueryNotices() {
        let environmentID = environment.environmentID!
        let configuration = lookupOrCreateTestConfiguration(environmentID: environmentID)
        let collection = lookupOrCreateTestCollection(environmentID: environmentID, configurationID: configuration.configurationID!)
        let collectionID = collection.collectionID!

        let expectation = self.expectation(description: "queryNotices")
        discovery.queryNotices(environmentID: environmentID, collectionID: collectionID, failure: failWithError) {
            response in
            XCTAssertNotNil(response.matchingResults)
            XCTAssertEqual(response.matchingResults!, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testFederatedQuery() {
        let environmentID = environment.environmentID!
        let configuration = lookupOrCreateTestConfiguration(environmentID: environmentID)
        let collection = lookupOrCreateTestCollection(environmentID: environmentID, configurationID: configuration.configurationID!)
        let collectionID = collection.collectionID!

        let expectation = self.expectation(description: "federatedQuery")
        discovery.federatedQuery(environmentID: environmentID, collectionIds: [collectionID], failure: failWithError) {
            response in
            XCTAssertNotNil(response.matchingResults)
            XCTAssertGreaterThanOrEqual(response.matchingResults!, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testFederatedQueryNotices() {
        let environmentID = environment.environmentID!
        let configuration = lookupOrCreateTestConfiguration(environmentID: environmentID)
        let collection = lookupOrCreateTestCollection(environmentID: environmentID, configurationID: configuration.configurationID!)
        let collectionID = collection.collectionID!

        let expectation = self.expectation(description: "federatedQuery")
        discovery.federatedQueryNotices(environmentID: environmentID, collectionIds: [collectionID], failure: failWithError) {
            response in
            XCTAssertNotNil(response.matchingResults)
            XCTAssertEqual(response.matchingResults!, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: - Training Data

    func testListTrainingData() {
        let environmentID = environment.environmentID!
        let configuration = lookupOrCreateTestConfiguration(environmentID: environmentID)
        let collection = lookupOrCreateTestCollection(environmentID: environmentID, configurationID: configuration.configurationID!)
        let collectionID = collection.collectionID!

        let expectation = self.expectation(description: "listTrainingData")
        discovery.listTrainingData(environmentID: environmentID, collectionID: collectionID, failure: failWithError) {
            response in
            XCTAssertNotNil(response.queries)
            XCTAssertEqual(response.queries!.count, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testTrainingDataCRUD() {
        let environmentID = environment.environmentID!
        let configuration = lookupOrCreateTestConfiguration(environmentID: environmentID)
        let collection = createTestCollection(environmentID: environmentID, configurationID: configuration.configurationID!)
        let document = addTestDocument(environment: environment, collection: collection)
        let collectionID = collection.collectionID!
        let documentID = document.documentID!

        let expectation1 = self.expectation(description: "addTrainingData")
        let example = TrainingExample(documentID: documentID, relevance: 4)
        var trainingQuery: TrainingQuery!
        discovery.addTrainingData(
            environmentID: environmentID,
            collectionID: collectionID,
            naturalLanguageQuery: "1962 State of the Union",
            filter: "text:politics",
            examples: [example],
            failure: failWithError)
        {
            response in
            trainingQuery = response
            XCTAssertNotNil(response.queryID)
            XCTAssertEqual(response.naturalLanguageQuery, "1962 State of the Union")
            XCTAssertNotNil(response.filter)
            XCTAssertEqual(response.filter, "text:politics")
            XCTAssertNotNil(response.examples)
            XCTAssertEqual(response.examples!.count, 1)
            expectation1.fulfill()
        }
        waitForExpectations(timeout: timeout)

        let expectation2 = self.expectation(description: "getTrainingData")
        let queryID = trainingQuery.queryID!
        discovery.getTrainingData(environmentID: environmentID, collectionID: collectionID, queryID: queryID, failure: failWithError) {
            response in
            XCTAssertEqual(response.queryID, trainingQuery.queryID)
            XCTAssertEqual(response.naturalLanguageQuery, trainingQuery.naturalLanguageQuery)
            XCTAssertEqual(response.filter, trainingQuery.filter)
            XCTAssertEqual(response.examples!.count, trainingQuery.examples!.count)
            expectation2.fulfill()
        }
        waitForExpectations(timeout: timeout)

        let expectation3 = self.expectation(description: "deleteTrainingData")
        discovery.deleteTrainingData(environmentID: environmentID, collectionID: collectionID, queryID: queryID, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations(timeout: timeout)

        // Test cleanup

        let expectation4 = self.expectation(description: "deleteCollection")
        discovery.deleteCollection(environmentID: environmentID, collectionID: collectionID, failure: failWithError) {_ in
            expectation4.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testDeleteAllTrainingData() {
        let environmentID = environment.environmentID!
        let configuration = lookupOrCreateTestConfiguration(environmentID: environmentID)
        let collection = lookupOrCreateTestCollection(environmentID: environmentID, configurationID: configuration.configurationID!)
        let collectionID = collection.collectionID!
        let expectation = self.expectation(description: "deleteAllTrainingData")
        discovery.deleteAllTrainingData(environmentID: environmentID, collectionID: collectionID, failure: failWithError) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: - Training Examples

    func testListTrainingExamples() {
        let environmentID = environment.environmentID!
        let configuration = lookupOrCreateTestConfiguration(environmentID: environmentID)
        let collection = createTestCollection(environmentID: environmentID, configurationID: configuration.configurationID!)
        let document = addTestDocument(environment: environment, collection: collection)
        let collectionID = collection.collectionID!
        let documentID = document.documentID!

        let expectation1 = self.expectation(description: "addTrainingData")
        let example = TrainingExample(documentID: documentID, relevance: 4)
        var trainingQuery: TrainingQuery!
        discovery.addTrainingData(
            environmentID: environmentID,
            collectionID: collectionID,
            naturalLanguageQuery: "1962 State of the Union",
            filter: "text:politics",
            examples: [example],
            failure: failWithError)
        {
            response in
            trainingQuery = response
            expectation1.fulfill()
        }
        waitForExpectations(timeout: timeout)

        let expectation2 = self.expectation(description: "listTrainingExamples")
        let queryID = trainingQuery.queryID!
        discovery.listTrainingExamples(environmentID: environmentID, collectionID: collectionID, queryID: queryID, failure: failWithError) {
            response in
            XCTAssertNotNil(response.examples)
            XCTAssertEqual(response.examples!.count, 1)
            XCTAssertEqual(response.examples!.first!.documentID, documentID)
            expectation2.fulfill()
        }
        waitForExpectations(timeout: timeout)

        // Test cleanup

        let expectation3 = self.expectation(description: "deleteCollection")
        discovery.deleteCollection(environmentID: environmentID, collectionID: collectionID, failure: failWithError) {_ in
            expectation3.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testTrainingExamplesCRUD() {
        let environmentID = environment.environmentID!
        let configuration = lookupOrCreateTestConfiguration(environmentID: environmentID)
        let collection = createTestCollection(environmentID: environmentID, configurationID: configuration.configurationID!)
        let document = addTestDocument(environment: environment, collection: collection)
        let collectionID = collection.collectionID!
        let documentID = document.documentID!

        let expectation1 = self.expectation(description: "addTrainingData")
        var trainingQuery: TrainingQuery!
        discovery.addTrainingData(
            environmentID: environmentID,
            collectionID: collectionID,
            naturalLanguageQuery: "1962 State of the Union",
            filter: "text:politics",
            failure: failWithError)
        {
            response in
            trainingQuery = response
            expectation1.fulfill()
        }
        waitForExpectations(timeout: timeout)

        let expectation2 = self.expectation(description: "createTrainingExample")
        let queryID = trainingQuery.queryID!
        discovery.createTrainingExample(
            environmentID: environmentID,
            collectionID: collectionID,
            queryID: queryID,
            documentID: documentID,
            relevance: 4,
            failure: failWithError)
        {
            response in
            XCTAssertEqual(response.documentID, documentID)
            XCTAssertEqual(response.relevance, 4)
            expectation2.fulfill()
        }
        waitForExpectations(timeout: timeout)

        let expectation3 = self.expectation(description: "getTrainingExample")
        discovery.getTrainingExample(environmentID: environmentID, collectionID: collectionID, queryID: queryID, exampleID: documentID, failure: failWithError) {
            response in
            XCTAssertEqual(response.documentID, documentID)
            XCTAssertEqual(response.relevance, 4)
            expectation3.fulfill()
        }
        waitForExpectations(timeout: timeout)

        let expectation4 = self.expectation(description: "updateTrainingExample")
        discovery.updateTrainingExample(environmentID: environmentID, collectionID: collectionID, queryID: queryID, exampleID: documentID, relevance: 0, failure: failWithError) {
            response in
            XCTAssertEqual(response.documentID, documentID)
            XCTAssertEqual(response.relevance, 0)
            expectation4.fulfill()
        }
        waitForExpectations(timeout: timeout)

        let expectation5 = self.expectation(description: "deleteTrainingExample")
        discovery.deleteTrainingExample(environmentID: environmentID, collectionID: collectionID, queryID: queryID, exampleID: documentID, failure: failWithError) {
            expectation5.fulfill()
        }
        waitForExpectations(timeout: timeout)

        // Test cleanup

        let expectation6 = self.expectation(description: "deleteCollection")
        discovery.deleteCollection(environmentID: environmentID, collectionID: collectionID, failure: failWithError) {_ in
            expectation6.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: - Negative Tests

    func testGetEnvironmentWithInvalidID() {
        let expectation = self.expectation(description: "getEnvironment")
        let failure = { (error: Error) in
            XCTAssert(error.localizedDescription.lowercased().contains("invalid environment id"))
            expectation.fulfill()
        }
        discovery.getEnvironment(environmentID: "invalid-id", failure: failure, success: failWithResult)
        waitForExpectations(timeout: timeout)
    }

    func testGetConfigurationWithInvalidID() {
        let expectation = self.expectation(description: "getEnvironment")
        let environmentID = environment.environmentID!
        let failure = { (error: Error) in
            XCTAssert(error.localizedDescription.lowercased().contains("invalid configuration id"))
            expectation.fulfill()
        }
        discovery.getConfiguration(environmentID: environmentID, configurationID: "invalid-id", failure: failure, success: failWithResult)
        waitForExpectations(timeout: timeout)
    }

    func testGetCollectionWithInvalidID() {
        let expectation = self.expectation(description: "getEnvironment")
        let environmentID = environment.environmentID!
        let failure = { (error: Error) in
            XCTAssert(error.localizedDescription.lowercased().contains("could not find"))
            expectation.fulfill()
        }
        discovery.getCollection(environmentID: environmentID, collectionID: "invalid-id", failure: failure, success: failWithResult)
        waitForExpectations(timeout: timeout)
    }

    func testQueryWithInvalidID() {
        let expectation = self.expectation(description: "getEnvironment")
        let failure = { (error: Error) in
            XCTAssert(error.localizedDescription.lowercased().contains("invalid environment id"))
            expectation.fulfill()
        }
        discovery.query(
            environmentID: "invalid-id",
            collectionID: "invalid-id",
            query: "enriched_text.concepts.text:\"Cloud computing\"",
            failure: failure,
            success: failWithResult
        )
        waitForExpectations(timeout: timeout)
    }
}
