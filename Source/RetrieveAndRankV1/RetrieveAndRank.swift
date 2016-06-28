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

import Foundation
import Alamofire
import Freddy
import RestKit

/**
 The IBM Watson Retrieve and Rank service combines two information retrieval components into a 
 single service. The service uses Apache Solr in conjunction with a machine learning algorithm to
 provide users with more relevant search results by automatically re-ranking them.
 */
public class RetrieveAndRank {
    private let username: String
    private let password: String
    private let serviceURL: String
    private let userAgent = buildUserAgent("watson-apis-ios-sdk/0.3.1 RetrieveAndRankV1")
    private let domain = "com.ibm.watson.developer-cloud.RetrieveAndRankV1"
    
    /**
     Create a `RetrieveAndRank` object.
     
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter serviceURL: The base URL to use when contacting the service.
     */
    public init(
        username: String,
        password: String,
        serviceURL: String = "https://gateway.watsonplatform.net/retrieve-and-rank/api")
    {
        self.username = username
        self.password = password
        self.serviceURL = serviceURL
    }
    
    /**
     If the given data represents an error returned by the Retrieve and Rank service, then
     return an NSError with information about the error that occured. Otherwise, return nil.
     
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func dataToError(data: NSData) -> NSError? {
        do {
            let json = try JSON(data: data)
            let code = try json.int("code")
            
            if let msg = try? json.string("msg") {
                let userInfo = [NSLocalizedFailureReasonErrorKey: msg]
                return NSError(domain: domain, code: code, userInfo: userInfo)
            } else {
                let error = try json.string("error")
                let description = try json.string("description")
                let userInfo = [
                    NSLocalizedFailureReasonErrorKey: error,
                    NSLocalizedRecoverySuggestionErrorKey: description
                ]
                return NSError(domain: domain, code: code, userInfo: userInfo)
            }
            
        } catch {
            return nil
        }
    }
    
    // MARK: - Solr clusters
    
    /**
     Retrieves the list of Solr clusters available for this Retrieve and Rank instance.
     
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with an array of SolrCluster objects.
     */
    public func getSolrClusters(
        failure: (NSError -> Void)? = nil,
        success: [SolrCluster] -> Void) {
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/solr_clusters",
            acceptType: "application/json",
            userAgent: userAgent
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseArray(dataToError: dataToError, path: ["clusters"]) {
                (response: Response<[SolrCluster], NSError>) in
                switch response.result {
                case .Success(let clusters): success(clusters)
                case .Failure(let error): failure?(error)
                }
            }
    }
    
    /** Creates a new Solr cluster. The Solr cluster will have an initial status of "Not Available" 
     and can't be used until the status becomes "Ready".
     
     - parameter name: The name for the new Solr cluster.
     - parameter size: The size of the Solr cluster to create. This can range from 1 to 7. You can 
            create one small free cluster for testing by keeping this value empty.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a SolrCluster object.
     */
    public func createSolrCluster(
        name: String,
        size: String? = nil,
        failure: (NSError -> Void)? = nil,
        success: SolrCluster -> Void) {
        
        // construct body
        var json = ["cluster_name": name]
        if let size = size {
            json["cluster_size"] = size
        }
        
        guard let body = try? json.toJSON().serialize() else {
            let failureReason = "Classification text could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v1/solr_clusters",
            acceptType: "application/json",
            contentType: "application/json",
            userAgent: userAgent,
            messageBody: body
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseString {response in print(response)}
            .responseObject(dataToError: dataToError) {
                (response: Response<SolrCluster, NSError>) in
                switch response.result {
                case .Success(let cluster): success(cluster)
                case .Failure(let error): failure?(error)
                }
            }
    }
    
    /** Stops and deletes a Solr cluster.
     
     - parameter solrClusterID: The ID of the Solr cluster to delete.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func deleteSolrCluster(
        solrClusterID: String,
        failure: (NSError -> Void)? = nil,
        success: (Void -> Void)? = nil) {
        
        // construct REST request
        let request = RestRequest(
            method: .DELETE,
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)",
            userAgent: userAgent
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseString {response in print(response)}
            .responseData { response in
                switch response.result {
                case .Success(let data):
                    switch self.dataToError(data) {
                    case .Some(let error): failure?(error)
                    case .None: success?()
                    }
                case .Failure(let error):
                    failure?(error)
                }
            }
    }
}
