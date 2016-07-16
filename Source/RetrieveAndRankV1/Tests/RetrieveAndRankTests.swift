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
    
    // MARK: - Test Configuration
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateRetrieveAndRank()
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
    private func createSolrCluster(clusterName: String, size: String? = nil) -> SolrCluster? {
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
    
    /** Load files used to update Solr clusters. */
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
        guard let solrCluster = createSolrCluster("temp-swift-sdk-solr-cluster") else {
            XCTFail("Failed to create the Solr cluster.")
            return
        }
        XCTAssertEqual(solrCluster.solrClusterName, "temp-swift-sdk-solr-cluster")
        XCTAssertNotNil(solrCluster.solrClusterID)
        XCTAssertNotNil(solrCluster.solrClusterSize)
        XCTAssertNotNil(solrCluster.solrClusterStatus)
        
        deleteSolrCluster(solrCluster.solrClusterID)
    }
    
    func testGetSolrCluster() {
        guard let solrCluster = createSolrCluster("temp-swift-sdk-solr-cluster", size: "1") else {
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
        XCTAssertEqual(solrClusterDetails.solrClusterSize, "1")
        
        deleteSolrCluster(solrCluster.solrClusterID)
    }
    
    /** List all Solr configurations associated with the trained Solr cluster. */
    func testListAllSolrConfigurations() {
        let description = "Get all configurations associated with the trained cluster."
        let expectation = expectationWithDescription(description)
        
        retrieveAndRank.getSolrConfigurations(trainedClusterID, failure: failWithError) {
            clusters in
            
            XCTAssertEqual(clusters.count, 1)
            XCTAssertEqual(clusters[0], "trained-swift-sdk-config")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Create and delete a new Solr configuration. */
    func testCreateAndDeleteSolrConfiguration() {
        let description = "Upload configuration zip file."
        let expectation = expectationWithDescription(description)
        
        guard let configFile = loadFile("cranfield_solr_config", withExtension: "zip") else {
            XCTFail("Failed to load config file needed to upload to the cluster.")
            return
        }
        retrieveAndRank.createSolrConfiguration(trainedClusterID, configName: "temp-swift-sdk-config", zipFile: configFile, failure: failWithError) {
            response in
            
            expectation.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Delete newly created configuration."
        let expectation2 = expectationWithDescription(description2)
        
        retrieveAndRank.deleteSolrConfiguration(trainedClusterID, configName: "temp-swift-sdk-config", failure: failWithError) {
            expectation2.fulfill()
        }
        waitForExpectations()
    }
    
    /** Get a specific configuration. */
    func testGetSolrConfiguration() {
        let description = "Get the trained configuration in the trained Solr cluster."
        let expectation = expectationWithDescription(description)
        
        retrieveAndRank.getSolrConfiguration(trainedClusterID, configName: "trained-swift-sdk-config", failure: failWithError) {
            url in
            
            XCTAssertNotNil(url)
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
            size: "100",
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
    
//    func testDeleteSolrClusterWithInaccessibleID() {
//        let description = "delete invalid"
//        let expectation = expectationWithDescription(description)
//
//        let failure = { (error: NSError) in
//            XCTAssertEqual(error.code, 403)
//            expectation.fulfill()
//        }
//
//        retrieveAndRank.deleteSolrCluster(
//            "sc19cac12e_3587_4510_820d_87945c51a3f9",
//            failure: failure,
//            success: failWithResult)
//
//        waitForExpectations()
//    }
    
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
        
        retrieveAndRank.getSolrConfigurations("some_invalid_ID", failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
//    /** Get all configurations when passing an inaccessible Solr cluster ID. */
//    func testGetConfigurationsWithInaccessibleSolrClusterID() {
//        let description = "Get all configurations when passing an inaccessible Solr cluster ID."
//        let expectation = expectationWithDescription(description)
//        
//        let failure = { (error: NSError) in
//            XCTAssertEqual(error.code, 403)
//            expectation.fulfill()
//        }
//        
//        retrieveAndRank.getSolrConfigurations("scfdb9563a_c46a_4e7d_8218_ae07a69c69e0", failure: failure, success: failWithResult)
//        waitForExpectations()
//    }
    
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
        retrieveAndRank.createSolrConfiguration("some_invalid_ID", configName: "temp-swift-sdk-config", zipFile: configFile, failure: failure, success: failWithResult)
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
        retrieveAndRank.createSolrConfiguration(trainedClusterID, configName: "trained-swift-sdk-config", zipFile: configFile, failure: failure, success: failWithResult)
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
        retrieveAndRank.deleteSolrConfiguration("invalid_cluster_ID", configName: "someConfiguration", failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
//    /** Get a Solr configuration that does not exist. */
//    func testGetNonExistingSolrConfiguration() {
//        let description = "Get a Solr configuration that does not exist."
//        let expectation = expectationWithDescription(description)
//        
//        let failure = { (error: NSError) in
//            XCTAssertEqual(error.code, 404)
//            expectation.fulfill()
//        }
//        retrieveAndRank.getSolrConfiguration(trainedClusterID, configName: "example-configuration", failure: failure, success: failWithResult)
//        waitForExpectations()
//    }
}
