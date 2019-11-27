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

import XCTest
import Foundation
// Do not import @testable to ensure only public interface is exposed
import DiscoveryV2

class DiscoveryTests: XCTestCase {

    private var discovery: Discovery!
    private var projectID: String!
    private var collectionID: String!
    private let timeout: TimeInterval = 30.0

    // MARK: - Test Configuration

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateDiscovery()
    }

    func instantiateDiscovery() {
        // TODO: CP4D authenticator
        let username = WatsonCredentials.DiscoveryV2CPDUsername
        let password = WatsonCredentials.DiscoveryV2CPDPassword
        let url = WatsonCredentials.DiscoveryV2CPDURL

        let authenticator = WatsonCloudPakForDataAuthenticator.init(username: username, password: password, url: url)
        authenticator.disableSSLVerification()

        discovery = Discovery(version: "2019-11-30", authenticator: authenticator)

        discovery.serviceURL = WatsonCredentials.DiscoveryV2ServiceURL

        discovery.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        discovery.defaultHeaders["X-Watson-Test"] = "true"

        discovery.disableSSLVerification()

        projectID = WatsonCredentials.DiscoveryV2TestProjectID
        collectionID = WatsonCredentials.DiscoveryV2TestCollectionID
    }

    func loadDocument(name: String, ext: String) -> Data? {
        #if os(Linux)
        let url = URL(fileURLWithPath: "Tests/DiscoveryV1Tests/Resources/" + name + "." + ext)
        #else
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: name, withExtension: ext) else { return nil }
        #endif
        let data = try? Data(contentsOf: url)
        return data
    }

    // MARK: - Test Definition for Linux

    static var allTests: [(String, (DiscoveryTests) -> () throws -> Void)] {
        let tests: [(String, (DiscoveryTests) -> () throws -> Void)] = []
        return tests
    }

    // MARK: - Tests
    // MARK: Collections

    func testListCollections() {
        let expectation = self.expectation(description: "listCollections")
        discovery.listCollections(projectID: projectID) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let response = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(response.collections)

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }

    // MARK: Queries

    func testQueryProject() {
        let expectation = self.expectation(description: "queryProject")
        discovery.query(projectID: projectID) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let response = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(response.results)

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }

    func testQueryProjectWithNaturalLanguage() {
        let expectation = self.expectation(description: "queryProjectWithNaturalLanguage")
        discovery.query(projectID: projectID, naturalLanguageQuery: "test", spellingSuggestions: true) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let response = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(response.results)

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }

    func testQueryProjectWithTermAggregation() {
        let expectation = self.expectation(description: "queryProjectWithNaturalLanguage")
        discovery.query(projectID: projectID, collectionIDs: [collectionID], filter: nil, query: nil, naturalLanguageQuery: "test", aggregation: "term(text.entities.text,count:10)", count: 10, offset: nil, sort: nil, highlight: true, spellingSuggestions: true, tableResults: nil, suggestedRefinements: nil, passages: nil, headers: nil
        ) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(result)

            guard let aggregation = result.aggregations?.first else {
                XCTFail("no aggregation")
                return
            }

            guard case let .term(term) = aggregation else {
                XCTFail("Unexpected aggregation return type")
                expectation.fulfill()
                return
            }

            XCTAssertNotNil(term)
            XCTAssertNotNil(term.field)

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }

    func testQueryProjectWithFilterAggregation() {
        let expectation = self.expectation(description: "queryProjectWithNaturalLanguage")
        discovery.query(projectID: projectID, collectionIDs: [collectionID], filter: nil, query: nil, naturalLanguageQuery: "kennedy", aggregation: "filter(enriched_text.keywords.text:\"test\")", count: 10, offset: nil, sort: nil, highlight: true, spellingSuggestions: true, tableResults: nil, suggestedRefinements: nil, passages: nil, headers: nil
        ) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(result)

            guard let aggregation = result.aggregations?.first else {
                XCTFail("no aggregation")
                return
            }

            guard case let .filter(filter) = aggregation else {
                XCTFail("Unexpected aggregation return type")
                expectation.fulfill()
                return
            }

            XCTAssertNotNil(filter)
            XCTAssertEqual(filter.type, "filter")

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }

    func testQueryProjectWithNestedAggregation() {
        let expectation = self.expectation(description: "queryProjectWithNaturalLanguage")
        discovery.query(projectID: projectID, collectionIDs: [collectionID], filter: nil, query: nil, naturalLanguageQuery: "test", aggregation: "nested(enriched_text.entities)", count: 10, offset: nil, sort: nil, highlight: true, spellingSuggestions: true, tableResults: nil, suggestedRefinements: nil, passages: nil, headers: nil
        ) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(result)

            guard let aggregation = result.aggregations?.first else {
                XCTFail("no aggregation")
                return
            }

            guard case let .nested(nested) = aggregation else {
                XCTFail("Unexpected aggregation return type")
                expectation.fulfill()
                return
            }

            XCTAssertNotNil(nested)
            XCTAssertEqual(nested.type, "nested")

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }

    func testQueryProjectWithHistogramAggregation() {
        let expectation = self.expectation(description: "queryProjectWithNaturalLanguage")
        discovery.query(projectID: projectID, collectionIDs: [collectionID], filter: nil, query: nil, naturalLanguageQuery: "kennedy", aggregation: "histogram(enriched_text.concepts.relevance,interval:1)", count: 10, offset: nil, sort: nil, highlight: true, spellingSuggestions: true, tableResults: nil, suggestedRefinements: nil, passages: nil, headers: nil
        ) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(result)

            guard let aggregation = result.aggregations?.first else {
                XCTFail("no aggregation")
                return
            }

            guard case let .histogram(histogram) = aggregation else {
                XCTFail("Unexpected aggregation return type")
                expectation.fulfill()
                return
            }

            XCTAssertNotNil(histogram)
            XCTAssertEqual(histogram.type, "histogram")

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }

    func testQueryProjectWithTimesliceAggregation() {
        let expectation = self.expectation(description: "queryProjectWithNaturalLanguage")
        discovery.query(projectID: projectID, collectionIDs: [collectionID], filter: nil, query: nil, naturalLanguageQuery: "kennedy", aggregation: "timeslice(publication_date,12hours)", count: 10, offset: nil, sort: nil, highlight: true, spellingSuggestions: true, tableResults: nil, suggestedRefinements: nil, passages: nil, headers: nil
        ) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(result)

            guard let aggregation = result.aggregations?.first else {
                XCTFail("no aggregation")
                return
            }

            guard case let .term(term) = aggregation else {
                XCTFail("Unexpected aggregation return type")
                expectation.fulfill()
                return
            }

            XCTAssertNotNil(term)
            XCTAssertNotNil(term.field)

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }

    func testQueryProjectWithTopHitsAggregation() {
        let expectation = self.expectation(description: "queryProjectWithNaturalLanguage")
        discovery.query(projectID: projectID, collectionIDs: [collectionID], filter: nil, query: nil, naturalLanguageQuery: "test", aggregation: "top_hits(1)", count: 10, offset: nil, sort: nil, highlight: true, spellingSuggestions: true, tableResults: nil, suggestedRefinements: nil, passages: nil, headers: nil
        ) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(result)

            guard let aggregation = result.aggregations?.first else {
                XCTFail("no aggregation")
                return
            }

            guard case let .topHits(topHits) = aggregation else {
                XCTFail("Unexpected aggregation return type")
                expectation.fulfill()
                return
            }

            XCTAssertNotNil(topHits)
            XCTAssertEqual(topHits.type, "top_hits")

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }

    func testQueryProjectWithUniqueCountAggregation() {
        let expectation = self.expectation(description: "queryProjectWithNaturalLanguage")
        discovery.query(projectID: projectID, collectionIDs: [collectionID], filter: nil, query: nil, naturalLanguageQuery: "kennedy", aggregation: "unique_count(enriched_text.entities.text)", count: 10, offset: nil, sort: nil, highlight: true, spellingSuggestions: true, tableResults: nil, suggestedRefinements: nil, passages: nil, headers: nil
        ) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(result)

            guard let aggregation = result.aggregations?.first else {
                XCTFail("no aggregation")
                return
            }

            guard case let .uniqueCount(uniqueCount) = aggregation else {
                XCTFail("Unexpected aggregation return type")
                expectation.fulfill()
                return
            }

            XCTAssertNotNil(uniqueCount)
            XCTAssertEqual(uniqueCount.type, "unique_count")

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }

    func testQueryProjectWithMaxAggregation() {
        let expectation = self.expectation(description: "queryProjectWithNaturalLanguage")
        discovery.query(projectID: projectID, collectionIDs: [collectionID], filter: nil, query: nil, naturalLanguageQuery: "kennedy", aggregation: "max(enriched_text.entities.count)", count: 10, offset: nil, sort: nil, highlight: true, spellingSuggestions: true, tableResults: nil, suggestedRefinements: nil, passages: nil, headers: nil
        ) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(result)

            guard let aggregation = result.aggregations?.first else {
                XCTFail("no aggregation")
                return
            }

            guard case let .max(max) = aggregation else {
                XCTFail("Unexpected aggregation return type")
                expectation.fulfill()
                return
            }

            XCTAssertNotNil(max)
            XCTAssertEqual(max.type, "max")

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }

    // NOTE: currently breaks due to disco issue
    func testQueryProjectWithMinAggregation() {
        let expectation = self.expectation(description: "queryProjectWithNaturalLanguage")
        discovery.query(projectID: projectID, collectionIDs: [collectionID], filter: nil, query: nil, naturalLanguageQuery: "kennedy", aggregation: "min(enriched_text.entities.count)", count: 10, offset: nil, sort: nil, highlight: true, spellingSuggestions: true, tableResults: nil, suggestedRefinements: nil, passages: nil, headers: nil
        ) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(result)

            guard let aggregation = result.aggregations?.first else {
                XCTFail("no aggregation")
                return
            }

            guard case let .min(min) = aggregation else {
                XCTFail("Unexpected aggregation return type")
                expectation.fulfill()
                return
            }

            XCTAssertNotNil(min)
            XCTAssertEqual(min.type, "min")

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }

    func testQueryProjectWithAverageAggregation() {
        let expectation = self.expectation(description: "queryProjectWithNaturalLanguage")
        discovery.query(projectID: projectID, collectionIDs: [collectionID], filter: nil, query: nil, naturalLanguageQuery: "kennedy", aggregation: "average(enriched_text.entities.count)", count: 10, offset: nil, sort: nil, highlight: true, spellingSuggestions: true, tableResults: nil, suggestedRefinements: nil, passages: nil, headers: nil
        ) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(result)

            guard let aggregation = result.aggregations?.first else {
                XCTFail("no aggregation")
                return
            }

            guard case let .average(average) = aggregation else {
                XCTFail("Unexpected aggregation return type")
                expectation.fulfill()
                return
            }

            XCTAssertNotNil(average)
            XCTAssertEqual(average.type, "average")

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }

    func testQueryProjectWithSumAggregation() {
        let expectation = self.expectation(description: "queryProjectWithNaturalLanguage")
        discovery.query(projectID: projectID, collectionIDs: [collectionID], filter: nil, query: nil, naturalLanguageQuery: "kennedy", aggregation: "sum(enriched_text.entities.count)", count: 10, offset: nil, sort: nil, highlight: true, spellingSuggestions: true, tableResults: nil, suggestedRefinements: nil, passages: nil, headers: nil
        ) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(result)

            guard let aggregation = result.aggregations?.first else {
                XCTFail("no aggregation")
                return
            }

            guard case let .sum(sum) = aggregation else {
                XCTFail("Unexpected aggregation return type")
                expectation.fulfill()
                return
            }

            XCTAssertNotNil(sum)
            XCTAssertEqual(sum.type, "sum")

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }

    func testAutocompleteSuggestions() {
        let expectation = self.expectation(description: "queryProjectWithNaturalLanguage")
        discovery.getAutocompletion(projectID: projectID, prefix: "test", collectionIDs: [collectionID], field: nil, count: 5, headers: nil) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let response = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(response.completions)

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }

    // MARK: - System Noticies

    func testQuerySystemNoticies() {
        let expectation = self.expectation(description: "queryProjectWithNaturalLanguage")
        discovery.queryNotices(projectID: projectID, naturalLanguageQuery: "warning") { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let results = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(results.notices)

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }

    // MARK: - List Fields

    func testListFields() {
        let expectation = self.expectation(description: "listFields")
        discovery.listFields(projectID: projectID) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(result.fields)

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }

    // MARK: - Component Settings

    func testComponentSettings() {
        let expectation = self.expectation(description: "componentSettings")
        discovery.getComponentSettings(projectID: projectID) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(result.autocomplete)
            XCTAssertNotNil(result.resultsPerPage)

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }

    // MARK: - Documents

    func testDocumentsCRUD() {
        var documentID: String!
        let testDocument = loadDocument(name: "KennedySpeech", ext: "html")

        // TODO: get some document to use in the bundle
        let addDocumentExpectation = self.expectation(description: "addDocument")
        discovery.addDocument(projectID: projectID, collectionID: collectionID, file: testDocument, filename: "test_file", fileContentType: "application/html", metadata: nil, xWatsonDiscoveryForce: false, headers: nil) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(result.documentID)
            documentID = result.documentID

            addDocumentExpectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        let updateDocumentExpectation = self.expectation(description: "updateDocument")
        discovery.updateDocument(projectID: projectID, collectionID: collectionID, documentID: documentID, file: testDocument, filename: "updated_file", fileContentType: "text/html", metadata: nil, xWatsonDiscoveryForce: false, headers: nil) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(result.documentID)

            updateDocumentExpectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        let deleteDocumentExpectation = self.expectation(description: "deleteDocument")
        discovery.deleteDocument(projectID: projectID, collectionID: collectionID, documentID: documentID, xWatsonDiscoveryForce: false, headers: nil) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(result.documentID)

            deleteDocumentExpectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }

    // MARK: - Training data

    func testTrainingDataCRUD() {
        var queryID: String!
        let testDocumentID = "9f393d4b221c68a9f26d4f9d6d513e22"

        // TODO: get some document to use in the bundle
        let trainingExample = TrainingExample(documentID: testDocumentID, collectionID: collectionID, relevance: 1)

        let createTrainingQueryExpectation = self.expectation(description: "createTrainingQuery")
        discovery.createTrainingQuery(projectID: projectID, naturalLanguageQuery: "test", examples: [trainingExample], filter: nil, headers: nil) {
            response, error in

            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(result.queryID)
            queryID = result.queryID

            createTrainingQueryExpectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        let updateTrainingQueryExpectation = self.expectation(description: "updateTrainingQuery")
        discovery.updateTrainingQuery(projectID: projectID, queryID: queryID, naturalLanguageQuery: "updated", examples: [trainingExample], filter: nil, headers: nil) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(result.queryID)

            updateTrainingQueryExpectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        let getTrainingQueryExpectation = self.expectation(description: "getTrainingQuery")
        discovery.getTrainingQuery(projectID: projectID, queryID: queryID, headers: nil) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(result.queryID)

            getTrainingQueryExpectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        let listTrainingQueriesExpectation = self.expectation(description: "listTrainingQueries")
        discovery.listTrainingQueries(projectID: projectID, headers: nil) { response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result else {
                XCTFail("No response")
                return
            }

            XCTAssertNotNil(result.queries)

            listTrainingQueriesExpectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        let deleteTrainingQueriesExpectation = self.expectation(description: "deleteTrainingQueries")
        discovery.deleteTrainingQueries(projectID: projectID, headers: nil) { _, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            deleteTrainingQueriesExpectation.fulfill()
        }

        waitForExpectations(timeout: timeout)
    }
}
