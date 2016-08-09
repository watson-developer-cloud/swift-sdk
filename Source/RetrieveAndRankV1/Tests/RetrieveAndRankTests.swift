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
import RetrieveAndRankV1

class RetrieveAndRankTests: XCTestCase {
    
    private var retrieveAndRank: RetrieveAndRank!
    private let timeout: NSTimeInterval = 30.0
    private let trainedClusterID = "sc36a81e8a_bc3e_4c51_9998_7fc5148d11cb"
    private let trainedClusterName = "trained-swift-sdk-solr-cluster"
    private let trainedConfigurationName = "trained-swift-sdk-config"
    private let trainedCollectionName = "trained-swift-sdk-collection"
    private let trainedRankerID = "1ba90dx16-rank-674"
    private let trainedRankerName = "trained-swift-sdk-ranker"
    
    // MARK: - Test Configuration
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateRetrieveAndRank()
        confirmTrainedClusterExists(trainedClusterID)
        confirmTrainedRankerExists(trainedRankerID)
    }
    
    /** Instantiate Retrieve and Rank instance. */
    func instantiateRetrieveAndRank() {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard
            let file = bundle.pathForResource("Credentials", ofType: "plist"),
            let credentials = NSDictionary(contentsOfFile: file) as? [String: String],
            let username = credentials["RetrieveAndRankUsername"],
            let password = credentials["RetrieveAndRankPassword"]
            else {
                XCTFail("Unable to read credentials.")
                return
        }
        retrieveAndRank = RetrieveAndRank(username: username, password: password)
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
    
    // MARK: - Helper Functions
    
    /** Create a new Solr cluster. */
    private func createSolrCluster(clusterName: String, size: Int? = nil) -> SolrCluster? {
        let description = "Create a new Solr Cluster."
        let expectation = expectationWithDescription(description)
        
        var solrCluster: SolrCluster?
        retrieveAndRank.createSolrCluster(clusterName, size: size, failure: failWithError) {
            cluster in
            
            solrCluster = cluster
            expectation.fulfill()
        }
        waitForExpectations()
        return solrCluster
    }
    
    /** Delete a Solr cluster. */
    private func deleteSolrCluster(clusterID: String) {
        let description = "Delete the Solr Cluster with the given ID."
        let expectation = expectationWithDescription(description)
        
        retrieveAndRank.deleteSolrCluster(clusterID, failure: failWithError) {
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Get the Solr cluster with the specified ID. */
    private func getSolrCluster(clusterID: String) -> SolrCluster? {
        let description = "Get the Solr cluster with the given ID."
        let expectation = expectationWithDescription(description)
        
        var solrCluster: SolrCluster?
        retrieveAndRank.getSolrCluster(clusterID, failure: failWithError) { cluster in
            solrCluster = cluster
            expectation.fulfill()
        }
        waitForExpectations()
        return solrCluster
    }
    
    /** Create a new Ranker. */
    private func createRanker(trainingDataFile: NSURL, rankerName: String? = nil) -> RankerDetails? {
        let description = "Create a new ranker."
        let expectation = expectationWithDescription(description)
        
        var rankerDetails: RankerDetails?
        retrieveAndRank.createRanker(trainingDataFile, name: rankerName, failure: failWithError) {
            ranker in
            
            rankerDetails = ranker
            expectation.fulfill()
        }
        waitForExpectations()
        return rankerDetails
    }
    
    /** Attempt to get the trained cluster; if it doesn't exist, create one. */
    func confirmTrainedClusterExists(clusterID: String) {
        let description = "Ensure the given trained cluster is available."
        let expectation = expectationWithDescription(description)
        
        func createTrainedCluster() {
            let failToCreate =  { (error: NSError) in
                XCTFail("Failed to create the trained cluster.")
            }
            retrieveAndRank.createSolrCluster(trainedClusterName, failure: failToCreate) {
                cluster in
                
                XCTAssertNotNil(cluster)
                XCTAssertNotEqual("", cluster.solrClusterID, "Expected to get an id.")
                let message = "A trained cluster was not found. It has been created and " +
                    "is currently being trained. You will need to set the " +
                    "trainedClusterID property using the cluster id " +
                    "printed below. Then wait a few minutes for training to " +
                    "complete before running the tests again.\n"
                print(message)
                print("** trainedClusterID: \(cluster.solrClusterID)\n")
                XCTFail("Trained cluster not found. Set trainedClusterID and try again.")
            }
        }
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400, "Cannot locate the trained cluster.")
            createTrainedCluster()
        }

        retrieveAndRank.getSolrCluster(clusterID, failure: failure) {
            cluster in
            
            if cluster.solrClusterName != self.trainedClusterName {
                let message = "The wrong cluster was provided as a trained " +
                    "cluster. The trained cluster will be recreated."
                print(message)
                createTrainedCluster()
                return
            }
            if cluster.solrClusterStatus != SolrClusterStatus.Ready {
                XCTFail(" Please wait. The given cluster is still being trained.")
                return
            }
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    /** Attempt to get the trained ranker; if it doesn't exist, create one. */
    func confirmTrainedRankerExists(rankerID: String) {
        let description = "Ensure the given trained ranker is available."
        let expectation = expectationWithDescription(description)
        
        func createTrainedRanker() {
            let failToCreate =  { (error: NSError) in
                XCTFail("Failed to create the trained ranker.")
            }

            guard let trainingDataFile = loadFile("ranker_train_data", withExtension: "csv") else {
                XCTFail("Failed to load files needed to create the ranker.")
                return
            }
            
            retrieveAndRank.createRanker(
                trainingDataFile,
                name: trainedRankerName,
                failure: failToCreate) { ranker in

                XCTAssertNotNil(ranker)
                XCTAssertNotEqual("", ranker.rankerID, "Expected to get an id.")
                let message = "A trained ranker was not found. It has been created and " +
                    "is currently being trained. You will need to set the " +
                    "trainedRankerID property using the ranker id " +
                    "printed below. Then wait a few minutes for training to " +
                    "complete before running the tests again.\n"
                print(message)
                print("** trainedRankerID: \(ranker.rankerID)\n")
                XCTFail("Trained ranker not found. Set trainedRankerID and try again.")
            }
        }
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404, "Cannot locate the trained ranker.")
            createTrainedRanker()
        }
        
        retrieveAndRank.getRanker(rankerID, failure: failure) {
            ranker in

            if ranker.name != self.trainedRankerName {
                let message = "The wrong ranker was provided as a trained " +
                    "ranker. The trained ranker will be recreated."
                print(message)
                createTrainedRanker()
                return
            }
            if ranker.status != RankerStatus.Available {
                XCTFail("Please wait. The given ranker is still being trained.")
                return
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    /** Load files needed for the following unit tests. */
    private func loadFile(name: String, withExtension: String) -> NSURL? {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard let url = bundle.URLForResource(name, withExtension: withExtension) else {
            return nil
        }
        return url
    }
    
    // MARK: - Positive Tests
    
    /** List all of the Solr clusters associated with this service instance. */
    func testGetSolrClusters() {
        let description = "Get all of the Solr clusters associated with this instance."
        let expectation = expectationWithDescription(description)
        
        retrieveAndRank.getSolrClusters(failWithError) { clusters in
            
            XCTAssertEqual(clusters.count, 1)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Create and then delete a new Solr cluster. */
    func testCreateAndDeleteSolrCluster() {
        guard let solrCluster = createSolrCluster("temp-swift-sdk-solr-cluster", size: 1) else {
            XCTFail("Failed to create the Solr cluster.")
            return
        }
        XCTAssertNotNil(solrCluster.solrClusterName)
        XCTAssertNotNil(solrCluster.solrClusterID)
        XCTAssertNotNil(solrCluster.solrClusterSize)
        XCTAssertNotNil(solrCluster.solrClusterStatus)
        XCTAssertEqual(solrCluster.solrClusterName, "temp-swift-sdk-solr-cluster")
        XCTAssertEqual(solrCluster.solrClusterSize, 1)
        XCTAssertEqual(solrCluster.solrClusterStatus, SolrClusterStatus.NotAvailable)
        
        deleteSolrCluster(solrCluster.solrClusterID)
    }
    
    /** Get detailed information about a specific Solr cluster. */
    func testGetSolrCluster() {
        guard let solrCluster = createSolrCluster("temp-swift-sdk-solr-cluster", size: 1) else {
            XCTFail("Failed to create the Solr cluster.")
            return
        }
        
        guard let solrClusterDetails = getSolrCluster(solrCluster.solrClusterID) else {
            XCTFail("Failed to get the newly created Solr cluster.")
            return
        }
        XCTAssertNotNil(solrClusterDetails.solrClusterID)
        XCTAssertNotNil(solrClusterDetails.solrClusterName)
        XCTAssertNotNil(solrClusterDetails.solrClusterSize)
        XCTAssertNotNil(solrClusterDetails.solrClusterStatus)
        XCTAssertEqual(solrClusterDetails.solrClusterName, "temp-swift-sdk-solr-cluster")
        XCTAssertEqual(solrClusterDetails.solrClusterSize, 1)
        
        deleteSolrCluster(solrCluster.solrClusterID)
    }
    
    /** List all Solr configurations associated with the trained Solr cluster. */
    func testListAllSolrConfigurations() {
        let description = "Get all configurations associated with the trained cluster."
        let expectation = expectationWithDescription(description)
        
        retrieveAndRank.getSolrConfigurations(trainedClusterID, failure: failWithError) {
            configurations in
            
            XCTAssertEqual(configurations.count, 1)
            XCTAssertEqual(configurations.first, self.trainedConfigurationName)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Create and delete a new Solr configuration. */
    func testCreateAndDeleteSolrConfiguration() {
        let description = "Upload configuration zip file."
        let expectation = expectationWithDescription(description)
        
        guard let configFile = loadFile("cranfield_solr_config", withExtension: "zip") else {
            XCTFail("Failed to load config file needed to create the configuration.")
            return
        }
        retrieveAndRank.uploadSolrConfiguration(
            trainedClusterID,
            configName: "temp-swift-sdk-config",
            zipFile: configFile,
            failure: failWithError) { response in
            
            expectation.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Delete newly created configuration."
        let expectation2 = expectationWithDescription(description2)
        
        retrieveAndRank.deleteSolrConfiguration(
            trainedClusterID,
            configName: "temp-swift-sdk-config",
            failure: failWithError) {
                
            expectation2.fulfill()
        }
        waitForExpectations()
    }
    
    /** Get a specific configuration. */
    func testGetSolrConfiguration() {
        let description = "Get the trained configuration in the trained Solr cluster."
        let expectation = expectationWithDescription(description)
        
        retrieveAndRank.getSolrConfiguration(
            trainedClusterID,
            configName: trainedConfigurationName,
            failure: failWithError) { url in
            
            XCTAssertNotNil(url)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** List all Solr collections associated with the trained cluster. */
    func testGetSolrCollections() {
        let description = "Get all Solr collections associated with the trained cluster."
        let expectation = expectationWithDescription(description)
        
        retrieveAndRank.getSolrCollections(
            trainedClusterID,
            failure: failWithError) { collections in
            
            XCTAssertEqual(collections.count, 1)
            XCTAssertEqual(collections.first, self.trainedCollectionName)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Create and delete a Solr collections. */
    func testCreateAndDeleteSolrCollection() {
        let description = "Create a Solr collection."
        let expectation = expectationWithDescription(description)
        
        retrieveAndRank.createSolrCollection(
            trainedClusterID,
            name: "temp-swift-sdk-collection",
            configName: trainedConfigurationName,
            failure: failWithError) {
            
            expectation.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Delete the newly created Solr collection."
        let expectation2 = expectationWithDescription(description2)
        retrieveAndRank.deleteSolrCollection(
            trainedClusterID,
            name: "temp-swift-sdk-collection",
            failure: failWithError) {
            
            expectation2.fulfill()
        }
        waitForExpectations()
    }
    
    /** Add documents to the Solr collection. */
    func testUpdateSolrCollection() {
        let description = "Create a Solr collection."
        let expectation = expectationWithDescription(description)
        
        retrieveAndRank.createSolrCollection(
            trainedClusterID,
            name: "temp-swift-sdk-collection",
            configName: trainedConfigurationName,
            failure: failWithError) {
            
            expectation.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Update a Solr collection."
        let expectation2 = expectationWithDescription(description2)
        
        guard let collectionFile = loadFile("cranfield_data", withExtension: "json") else {
            XCTFail("Failed to load json file needed to upload to the collection.")
            return
        }
        retrieveAndRank.updateSolrCollection(
            trainedClusterID,
            collectionName: "temp-swift-sdk-collection",
            contentType: "application/json",
            contentFile: collectionFile,
            failure: failWithError) {
            
            expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Delete the newly created Solr collection."
        let expectation3 = expectationWithDescription(description3)
        retrieveAndRank.deleteSolrCollection(
            trainedClusterID,
            name: "temp-swift-sdk-collection",
            failure: failWithError) {
            
            expectation3.fulfill()
        }
        waitForExpectations()
    }
    
    /** Test the search portion only of the retrieve and rank service. */
    func testSearch() {
        let description = "Test the search portion of retrieve and rank."
        let expectation = expectationWithDescription(description)
        
        retrieveAndRank.search(
            trainedClusterID,
            collectionName: trainedCollectionName,
            query: "aerodynamics",
            returnFields: "id, title, author",
            failure: failWithError) { response in
            
            XCTAssertNotNil(response.header)
            XCTAssertNotNil(response.header.status)
            XCTAssertNotNil(response.header.qTime)
            XCTAssertNotNil(response.header.params)
            XCTAssertNotNil(response.header.params.query)
            XCTAssertNotNil(response.header.params.returnFields)
            XCTAssertNotNil(response.header.params.writerType)
                
            XCTAssertNotNil(response.body)
            XCTAssertNotNil(response.body.start)
            XCTAssertNotNil(response.body.numFound)
            XCTAssertNotNil(response.body.documents)
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Test search and rank. */
    func testSearchAndRank() {
        let description = "Test search and rank."
        let expectation = expectationWithDescription(description)
        
        retrieveAndRank.searchAndRank(
            trainedClusterID,
            collectionName: trainedCollectionName,
            rankerID: trainedRankerID,
            query: "aerodynamics",
            returnFields: "id, title, author",
            failure: failWithError) { response in
            
            XCTAssertNotNil(response.header)
            XCTAssertNotNil(response.header.status)
            XCTAssertNotNil(response.header.qTime)
            
            XCTAssertNotNil(response.body)
            XCTAssertNotNil(response.body.start)
            XCTAssertNotNil(response.body.numFound)
            XCTAssertNotNil(response.body.maxScore)
            XCTAssertNotNil(response.body.documents)
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** List all rankers associated with this Retrieve and Rank service instance. */
    func testGetRankers() {
        let description = "Get all rankers associated with this service instance."
        let expectation = expectationWithDescription(description)
        
        retrieveAndRank.getRankers(failWithError) {
            rankers in
            
            XCTAssertEqual(rankers.count, 1)
            XCTAssertNotNil(rankers.first)
            XCTAssertNotNil(rankers.first?.rankerID)
            XCTAssertNotNil(rankers.first?.name)
            XCTAssertNotNil(rankers.first?.url)
            XCTAssertNotNil(rankers.first?.created)
            XCTAssertEqual(rankers.first?.rankerID, self.trainedRankerID)
            XCTAssertEqual(rankers.first?.name, self.trainedRankerName)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Get detailed information about a specific ranker. */
    func testGetRankerWithSpecificID() {
        let description = "Get the ranker specified by this ID."
        let expectation = expectationWithDescription(description)
        
        retrieveAndRank.getRanker(trainedRankerID, failure: failWithError) {
            ranker in
        
            XCTAssertNotNil(ranker)
            XCTAssertNotNil(ranker.rankerID)
            XCTAssertNotNil(ranker.name)
            XCTAssertNotNil(ranker.url)
            XCTAssertNotNil(ranker.created)
            XCTAssertNotNil(ranker.status)
            XCTAssertNotNil(ranker.statusDescription)
            XCTAssertEqual(ranker.rankerID, self.trainedRankerID)
            XCTAssertEqual(ranker.name, self.trainedRankerName)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Create and delete a new ranker. */
    func testCreateAndDeleteRanker() {
        guard let rankerFile = loadFile("ranker_train_data", withExtension: "csv") else {
            XCTFail("Failed to load training data needed to create the ranker.")
            return
        }
        guard let ranker = createRanker(rankerFile, rankerName: "temp-swift-sdk-ranker") else {
            XCTFail("Failed to create the ranker.")
            return
        }
        XCTAssertNotNil(ranker.rankerID)
        XCTAssertNotNil(ranker.name)
        XCTAssertNotNil(ranker.created)
        XCTAssertNotNil(ranker.url)
        XCTAssertNotNil(ranker.status)
        XCTAssertNotNil(ranker.statusDescription)
        
        let description = "Delete the newly created ranker."
        let expectation = expectationWithDescription(description)
        retrieveAndRank.deleteRanker(ranker.rankerID, failure: failWithError) {
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Pass in a csv file with answers, and use the trained ranker to rerank those results. */
    func testRanker() {
        guard let answerFile = loadFile("ranker_test_data", withExtension: "csv") else {
            XCTFail("Failed to load test data needed to test the ranker.")
            return
        }
        
        let description = "Use the trained ranker to rerank the given answer results."
        let expectation = expectationWithDescription(description)
        retrieveAndRank.rankResults(trainedRankerID, resultsFile: answerFile, failure: failWithError) {
            results in
            
            XCTAssertEqual(results.topAnswer, "aid_11")
            XCTAssertNotNil(results.answers)
            for answer in results.answers {
                XCTAssertNotNil(answer.answerID)
                XCTAssertNotNil(answer.confidence)
                XCTAssertNotNil(answer.score)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    // MARK: - Negative Tests
    
    /** Create a Solr cluster with an invalid size. */
    func testCreateSolrClusterWithInvalidSize() {
        let description = "Delete a Solr cluster when passing an invalid Solr cluster ID."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        retrieveAndRank.createSolrCluster(
            "swift-sdk-solr-cluster",
            size: 100,
            failure: failure,
            success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Attempt to delete a Solr cluster by passing an invalid Solr cluster ID. */
    func testDeleteSolrClusterWithBadID() {
        let description = "Delete a Solr cluster when passing an invalid Solr cluster ID."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        retrieveAndRank.deleteSolrCluster(
            "abcde-12345-fghij-67890",
            failure: failure,
            success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Get information about a Solr cluster when passing an invalid ID. */
    func testGetSolrClusterWithInvalidID() {
        let description = "Get cluster with invalid ID."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        retrieveAndRank.getSolrCluster("some_invalid_ID", failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
    /** Get all configurations when passing an invalid Solr cluster ID. */
    func testGetConfigurationsWithInvalidSolrClusterID() {
        let description = "Get all configurations when passing an invalid Solr cluster ID."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        retrieveAndRank.getSolrConfigurations(
            "some_invalid_ID",
            failure: failure,
            success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Get all configurations when passing an inaccessible Solr cluster ID. */
    func testGetConfigurationsWithInaccessibleSolrClusterID() {
        let description = "Get all configurations when passing an inaccessible Solr cluster ID."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, -6004)
            expectation.fulfill()
        }
        
        retrieveAndRank.getSolrConfigurations(
            "scfdb9563a_c46a_4e7d_8218_ae07a69c69e0",
            failure: failure,
            success: failWithResult)
    
        waitForExpectations()
    }
    
    /** Create a Solr configuration when passing an invalid Solr cluster ID. */
    func testCreateSolrConfigurationWithBadSolrClusterID() {
        let description = "Create a Solr configuration when passing an invalid Solr cluster ID."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        guard let configFile = loadFile("cranfield_solr_config", withExtension: "zip") else {
            XCTFail("Failed to load config file needed to upload to the cluster.")
            return
        }
        retrieveAndRank.uploadSolrConfiguration(
            "some_invalid_ID",
            configName: "temp-swift-sdk-config",
            zipFile: configFile,
            failure: failure,
            success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Create a Solr configuration with the same name as an existing configuration. */
    func testCreateSolrConfigurationWithDuplicateName() {
        let description = "Create a Solr configuration with an already existing name."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 409)
            expectation.fulfill()
        }
        
        guard let configFile = loadFile("cranfield_solr_config", withExtension: "zip") else {
            XCTFail("Failed to load config file needed to upload to the cluster.")
            return
        }
        retrieveAndRank.uploadSolrConfiguration(
            trainedClusterID,
            configName: trainedConfigurationName,
            zipFile: configFile,
            failure: failure,
            success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Delete a Solr configuration when passing an invalid Solr cluster ID. */
    func testDeleteSolrConfigurationWithInvalidClusterID() {
        let description = "Delete a Solr configuration when passing an invalid Solr cluster ID."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        retrieveAndRank.deleteSolrConfiguration(
            "invalid_cluster_ID",
            configName: "someConfiguration",
            failure: failure,
            success: failWithResult)
        
        waitForExpectations()
    }

    
    /** Get the collections of a nonexistent Solr cluster. */
    func testGetCollectionsOfNonExistentCluster() {
        let description = "Get all Solr collections of a nonexistent Solr cluster."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        retrieveAndRank.getSolrCollections(
            "invalid_cluster_ID",
            failure: failure,
            success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Create a collection within a nonexistent Solr cluster. */
    func testCreateCollectionInNonExistentCluster() {
        let description = "Create a Solr collection within a nonexistent Solr cluster."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        retrieveAndRank.createSolrCollection(
            "invalid_cluster_id",
            name: "failed-collection",
            configName: "config-name",
            failure: failure,
            success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Delete a collection within a nonexistent Solr cluster. */
    func testDeleteCollectionInNonExistentCluster() {
        let description = "Delete a Solr collection within a nonexistent Solr cluster."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        retrieveAndRank.deleteSolrCollection(
            "invalid_cluster_id",
            name: "failed-collection",
            failure: failure,
            success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Attempt to update a collection within a nonexistent Solr cluster. */
    func testUpdateCollectionWithinNonExistentCluster() {
        let description = "Update a Solr collection within a nonexistent Solr cluster."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        guard let collectionFile = loadFile("cranfield_data", withExtension: "json") else {
            XCTFail("Failed to load json file needed to upload to the collection.")
            return
        }
        retrieveAndRank.updateSolrCollection(
            "invalid_cluster_id",
            collectionName: "failed-collection",
            contentType: "application/json",
            contentFile: collectionFile,
            failure: failure,
            success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Search using an invalid Solr cluster ID. */
    func testSearchWithInvalidClusterID() {
        let description = "Search using an invalid cluster ID."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        retrieveAndRank.search(
            "invalid_cluster_id",
            collectionName: trainedCollectionName,
            query: "aerodynamics",
            returnFields: "id, author",
            failure: failure,
            success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Search and rank using an invalid Solr cluster ID. */
    func testSearchAndRankWithInvalidClusterID() {
        let description = "Search and rank using an invalid cluster ID."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        retrieveAndRank.searchAndRank(
            "invalid_cluster_id",
            collectionName: trainedCollectionName,
            rankerID: trainedRankerID,
            query: "aerodynamics",
            returnFields: "id, author",
            failure: failure,
            success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Get detailed information about a ranker that does not exist. */
    func testGetDetailsOfNonExistentRanker() {
        let description = "Get detailed information about a ranker that does not exist."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }
        
        retrieveAndRank.getRanker("invalid_ranker_id", failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
    /** Delete a ranker that doesn't exist. */
    func testDeleteNonExistentRanker() {
        let description = "Delete a ranker that does not exist."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }
        
        retrieveAndRank.getRanker("invalid_ranker_id", failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
    /** Re-rank the results of the file when passing an invalid ranker ID. */
    func testRankWithInvalidRankerID() {
        let description = "Try re-ranking a list of answers with an invalid ranker ID."
        let expectation = expectationWithDescription(description)
        
        guard let answerFile = loadFile("ranker_test_data", withExtension: "csv") else {
            XCTFail("Failed to load test data needed to test the ranker.")
            return
        }
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }
        
        retrieveAndRank.rankResults("invalid_ranker_id", resultsFile: answerFile, failure: failure, success: failWithResult)
        waitForExpectations()
    }
}
