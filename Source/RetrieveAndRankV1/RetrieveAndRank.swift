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
import RestKit

/**
 The IBM Watson Retrieve and Rank service combines two information retrieval components into a 
 single service. The service uses Apache Solr in conjunction with a machine learning algorithm to
 provide users with more relevant search results by automatically re-ranking them.
 */
public class RetrieveAndRank {
    
    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/retrieve-and-rank/api"
    
    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()
    
    private let credentials: Credentials
    private let domain = "com.ibm.watson.developer-cloud.RetrieveAndRankV1"
    
    /**
     Create a `RetrieveAndRank` object.
     
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     */
    public init(username: String, password: String) {
        self.credentials = Credentials.basicAuthentication(username: username, password: password)
    }
    
    /**
     If the response or data represents an error returned by the Retrieve and Rank service,
     then return NSError with information about the error that occured. Otherwise, return nil.
     
     - parameter response: the URL response returned from the service.
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func responseToError(response: HTTPURLResponse?, data: Data?) -> NSError? {
        
        // First check http status code in response
        if let response = response {
            if response.statusCode >= 200 && response.statusCode < 300 {
                return nil
            }
        }
        
        // ensure data is not nil
        guard let data = data else {
            if let code = response?.statusCode {
                return NSError(domain: domain, code: code, userInfo: nil)
            }
            return nil  // RestKit will generate error for this case
        }
        
        do {
            let json = try JSON(data: data)
            let code = response?.statusCode ?? 400
            let userInfo: [String: String]
            if let message = try? json.getString(at: "msg") {
                userInfo = [NSLocalizedFailureReasonErrorKey: message]
            } else {
                let message = try json.getString(at: "error")
                let description = try json.getString(at: "description")
                userInfo = [
                    NSLocalizedFailureReasonErrorKey: message,
                    NSLocalizedRecoverySuggestionErrorKey: description
                ]
            }
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }
    
    // MARK: - Solr Clusters
    
    /**
     Retrieves the list of Solr clusters available for this Retrieve and Rank instance.
     
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with an array of `SolrCluster` objects.
     */
    public func getSolrClusters(
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([SolrCluster]) -> Void) {
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/solr_clusters",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )
        
        // execute REST request
        request.responseArray(responseToError: responseToError, path: ["clusters"]) {
            (response: RestResponse<[SolrCluster]>) in
                switch response.result {
                case .success(let clusters): success(clusters)
                case .failure(let error): failure?(error)
                }
            }
    }
    
    /**
     Creates a new Solr cluster. The Solr cluster will have an initial status of "Not Available"
     and can't be used until the status becomes "Ready".
     
     - parameter name: The name for the new Solr cluster.
     - parameter size: The size of the Solr cluster to create. This can range from 1 to 7. You can 
            create one small free cluster for testing by keeping this value empty.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a `SolrCluster` object.
     */
    public func createSolrCluster(
        withName name: String,
        size: Int? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SolrCluster) -> Void) {
        
        // construct body
        var json = ["cluster_name": name]
        if let size = size {
            json["cluster_size"] = String(size)
        }
        
        guard let body = try? JSON(dictionary: json).serialize() else {
            let failureReason = "Classification text could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/solr_clusters",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            messageBody: body
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<SolrCluster>) in
                switch response.result {
                case .success(let cluster): success(cluster)
                case .failure(let error): failure?(error)
                }
            }
    }
    
    /**
     Stops and deletes a Solr cluster.
     
     - parameter solrClusterID: The ID of the Solr cluster to delete.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func deleteSolrCluster(
        withID solrClusterID: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil) {
        
        // construct REST request
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)",
            credentials: credentials,
            headerParameters: defaultHeaders
        )
        
        // execute REST request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    /**
     Gets the status and other information about a specific cluster.
     
     - parameter solrClusterID: The ID of the cluster that you want more information about.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a `SolrCluster` object.
     */
    public func getSolrCluster(
        withID solrClusterID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SolrCluster) -> Void) {
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<SolrCluster>) in
                switch response.result {
                case .success(let cluster): success(cluster)
                case .failure(let error): failure?(error)
                }
            }
    }
    
    /**
     Gets all configurations for the specific cluster.
     
     - parameter solrClusterID: The ID of the cluster that you want the configurations of.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a string array listing the names of all the 
            configurations associated with this Solr cluster.
     */
    public func getSolrConfigurations(
        fromSolrClusterID solrClusterID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([String]) -> Void) {
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)/config",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )
        
        // execute REST request
        request.responseArray(responseToError: responseToError, path: ["solr_configs"]) {
            (response: RestResponse<[String]>) in
                switch response.result {
                case .success(let config): success(config)
                case .failure(let error): failure?(error)
                }
            }
    }
    
    /**
     Delete this specific configuration from the specified cluster.
     
     - parameter configName: The name of the configuration you want to delete.
     - parameter solrClusterID: The ID of the cluster that you want to delete the configuration of.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func deleteSolrConfiguration(
        withName configName: String,
        fromSolrClusterID solrClusterID: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil) {
        
        // construct REST request
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)/config/\(configName)",
            credentials: credentials,
            headerParameters: defaultHeaders
        )
        
        // execute REST request
        request.responseData { response in
                switch response.result {
                case .success(let data):
                    switch self.responseToError(response: response.response, data: data) {
                    case .some(let error): failure?(error)
                    case .none: success?()
                    }
                case .failure(let error):
                    failure?(error)
                }
            }
    }
    
    /**
     Gets a configuration .zip file with the given name from the specified cluster.
     
     - parameter configName: The name of the configuration you want.
     - parameter solrClusterID: The ID of the cluster that you want the configuration of.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the URL of the downloaded configuration file.
     */
    public func getSolrConfiguration(
        withName configName: String,
        fromSolrClusterID solrClusterID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (URL) -> Void) {
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)/config/\(configName)",
            credentials: credentials,
            headerParameters: defaultHeaders
        )
        
        // locate downloads directory
        let fileManager = FileManager.default
        let directories = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask)
        guard let downloads = directories.first else {
            let failureReason = "Cannot locate documents directory."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct unique filename
        var filename = configName + ".zip"
        var isUnique = false
        var duplicates = 0
        while !isUnique {
            let filePath = downloads.appendingPathComponent(filename).path
            if fileManager.fileExists(atPath: filePath) {
                duplicates += 1
                filename = configName + "-\(duplicates)" + ".zip"
            } else {
                isUnique = true
            }
        }
        
        // specify download destination
        let destinationURL = downloads.appendingPathComponent(filename)
        
        // execute REST request
        request.download(to: destinationURL) { response, error in
            guard error == nil else {
                failure?(error!)
                return
            }
            
            guard let statusCode = response?.statusCode else {
                let failureReason = "Did not receive response."
                let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                failure?(error)
                return
            }
            
            if statusCode != 200 {
                let failureReason = "Status code was not acceptable: \(statusCode)."
                let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                let error = NSError(domain: self.domain, code: statusCode, userInfo: userInfo)
                failure?(error)
                return
            }
            
            success(destinationURL)
        }
    }
    
    /**
     Uploads a configuration .zip file set with the given name to the specified cluster.
     
     Note: in order for your service instance to work with this SDK, you must make sure to define 
     the writer type in your solrconfig.xml file to be "json".
     
     - parameter configName: The name of the configuration you want to update.
     - parameter solrClusterID: The ID of the cluster whose configuration you want to update.
     - parameter zipFile: The zip file configuration set that you would like to upload.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func uploadSolrConfiguration(
        withName configName: String,
        toSolrClusterID solrClusterID: String,
        zipFile: URL,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil) {
        
        // construct body
        guard let body = try? Data(contentsOf: zipFile) else {
            failure?(RestError.encodingError)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)/config/\(configName)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            contentType: "application/zip",
            messageBody: body
        )
        
        // execute REST request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    /**
     Creates a new Solr collection.
     
     - parameter name: The name of the collection.
     - parameter solrClusterID: The ID of the cluster to add this collection to.
     - parameter configName: The name of the configuration to use.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func createSolrCollection(
        withName name: String,
        forSolrClusterID solrClusterID: String,
        withConfigurationName configName: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil) {
        
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "action", value: "CREATE"))
        queryParameters.append(URLQueryItem(name: "name", value: name))
        queryParameters.append(URLQueryItem(name: "collection.configName", value: configName))
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)/solr/admin/collections",
            credentials: credentials,
            headerParameters: defaultHeaders,
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseData { response in
                switch response.result {
                case .success(let data):
                    switch self.responseToError(response: response.response, data: data) {
                    case .some(let error): failure?(error)
                    case .none: success?()
                    }
                case .failure(let error):
                    failure?(error)
                }
            }
    }
    
    /**
     Deletes a Solr collection.
     
     - parameter name: The name of the collection.
     - parameter solrClusterID: The ID of the cluster to delete this collection from.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func deleteSolrCollection(
        withName name: String,
        fromSolrClusterID solrClusterID: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil) {
        
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "action", value: "DELETE"))
        queryParameters.append(URLQueryItem(name: "name", value: name))
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)/solr/admin/collections",
            credentials: credentials,
            headerParameters: defaultHeaders,
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseData { response in
                switch response.result {
                case .success(let data):
                    switch self.responseToError(response: response.response, data: data) {
                    case .some(let error): failure?(error)
                    case .none: success?()
                    }
                case .failure(let error):
                    failure?(error)
                }
            }
    }
    
    /**
     Lists the names of the collections in this Solr cluster.
     
     Note: For the SDK to work properly, you must define the writer type as "json" within the
     configuration solrconfig.xml file.
     
     - parameter solrClusterID: The ID of the cluster whose collections you want.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with an array of collection names.
     */
    public func getSolrCollections(
        forSolrClusterID solrClusterID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([String]) -> Void) {
        
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "action", value: "LIST"))
        queryParameters.append(URLQueryItem(name: "wt", value: "json"))
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)/solr/admin/collections",
            credentials: credentials,
            headerParameters: defaultHeaders,
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseArray(responseToError: responseToError, path: ["collections"]) {
            (response: RestResponse<[String]>) in
                switch response.result {
                case .success(let collections): success(collections)
                case .failure(let error): failure?(error)
                }
            }
    }
    
    /**
     Update a collection by adding content to it. This indexes the documents and allows us to 
     search the newly uploaded data later. For more information about the accepted file types and
     how to structure the content files, refer to this link:
     https://cwiki.apache.org/confluence/display/solr/Indexing+and+Basic+Data+Operations
     
     - parameter collectionName: The name of the collection you would like to update.
     - parameter solrClusterID: The ID of the cluster this collection points to.
     - parameter contentFile: The content to be added to the collection. Accepted file types are 
            listed in the link above.
     - parameter contentType: The media type of the content that is being uploaded.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func updateSolrCollection(
        withName collectionName: String,
        inSolrClusterID solrClusterID: String,
        contentFile: URL,
        contentType: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil) {
        
        // construct REST body
        guard let body = try? Data(contentsOf: contentFile) else {
            failure?(RestError.encodingError)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)/solr/\(collectionName)/update",
            credentials: credentials,
            headerParameters: defaultHeaders,
            contentType: contentType,
            messageBody: body
        )
        
        // execute REST request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }

    /**
     Use the given query to search this specific collection within a given cluster. This command
     doesn't rank the values; to search and rank, use the `searchAndRank()` call.
     
     Note: For the SDK to work properly, you must define the writer type as "json" within the
     configuration solrconfig.xml file.
     
     - parameter collectionName: The name of the collection in the cluster.
     - parameter solrClusterID: The ID of the Solr cluster.
     - parameter query: The query. Refer to the following link for more information on how to
            structure the query string: 
            https://cwiki.apache.org/confluence/display/solr/The+Standard+Query+Parser
     - parameter returnFields: The fields that should be returned. These fields should correspond
            to the fields within the content that has been uploaded to the collection. This
            parameter should be a comma-separated list.
     - parameter numberOfDocuments: The number of documents to return. The default number is set in
            the solrconfig.xml configuration file.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a `SearchResponse` object.
     */
    public func search(
        withCollectionName collectionName: String,
        fromSolrClusterID solrClusterID: String,
        query: String,
        returnFields: String,
        numberOfDocuments: Int? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SearchResponse) -> Void) {
        
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "q", value: query))
        queryParameters.append(URLQueryItem(name: "fl", value: returnFields))
        queryParameters.append(URLQueryItem(name: "wt", value: "json"))
        if let numberOfDocuments = numberOfDocuments {
            queryParameters.append(URLQueryItem(name: "rows", value: String(numberOfDocuments)))
        }
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)/solr/\(collectionName)/select",
            credentials: credentials,
            headerParameters: defaultHeaders,
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<SearchResponse>) in
                switch response.result {
                case .success(let response): success(response)
                case .failure(let error): failure?(error)
                }
            }
    }
    
    /**
     Searches the results and then returns them in ranked order.
     
     Note: For the SDK to work properly, you must define the writer type as "json" within the
     configuration solrconfig.xml file.
     
     - parameter collectionName: The name of the collection in the cluster.
     - parameter solrClusterID: The ID of the Solr cluster.
     - parameter rankerID: The ID of the ranker.
     - parameter query: The query. Refer to the following link for more information on how to
            structure the query string:
            https://cwiki.apache.org/confluence/display/solr/The+Standard+Query+Parser
     - parameter returnFields: The fields that should be returned. These fields should correspond
            to the fields within the content that has been uploaded to the collection. This
            parameter should be a comma-separated list.
     - parameter numberOfDocuments: The number of documents to return. The default number is set in 
            the solrconfig.xml configuration file.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a `SearchAndRankResponse` object.
     */
    public func searchAndRank(
        withCollectionName collectionName: String,
        fromSolrClusterID solrClusterID: String,
        rankerID: String,
        query: String,
        returnFields: String,
        numberOfDocuments: Int? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SearchAndRankResponse) -> Void) {
        
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "q", value: query))
        queryParameters.append(URLQueryItem(name: "ranker_id", value: rankerID))
        queryParameters.append(URLQueryItem(name: "fl", value: returnFields))
        queryParameters.append(URLQueryItem(name: "wt", value: "json"))
        if let numberOfDocuments = numberOfDocuments {
            queryParameters.append(URLQueryItem(name: "rows", value: String(numberOfDocuments)))
        }
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)/solr/\(collectionName)/fcselect",
            credentials: credentials,
            headerParameters: defaultHeaders,
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<SearchAndRankResponse>) in
                switch response.result {
                case .success(let response): success(response)
                case .failure(let error): failure?(error)
                }
            }
    }
    
    // MARK: - Rankers
    
    /**
     Retrieves the list of rankers available for this Retrieve and Rank instance.
     
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with an array of `Ranker` objects.
     */
    public func getRankers(
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([Ranker]) -> Void)
    {
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/rankers",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )
        
        // execute REST request
        request.responseArray(responseToError: responseToError, path: ["rankers"]) {
            (response: RestResponse<[Ranker]>) in
                switch response.result {
                case .success(let rankers): success(rankers)
                case .failure(let error): failure?(error)
                }
            }
    }
    
    /**
     Creates and trains a new ranker. The status of the ranker will be set to `Training` until
     the ranker is ready. You need to wait until the status is `Available` before using.
     
     - parameter name: An optional name for the ranker.
     - parameter trainingDataFile: The training data content that will be used to train this ranker.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a `Ranker` object.
     */
    public func createRanker(
        withName name: String? = nil,
        fromFile trainingDataFile: URL,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (RankerDetails) -> Void)
    {
        // construct training metadata
        var json = [String: String]()
        if let name = name {
            json["name"] = name
        }
        guard let trainingMetadata = try? JSON(dictionary: json).serialize() else {
            let failureReason = "Ranker metadata could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct REST body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(trainingDataFile, withName: "training_data")
        multipartFormData.append(trainingMetadata, withName: "training_metadata")
        guard let body = try? multipartFormData.toData() else {
            failure?(RestError.encodingError)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/rankers",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: multipartFormData.contentType,
            messageBody: body
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<RankerDetails>) in
            switch response.result {
            case .success(let ranker): success(ranker)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Identifies the top answer from the list of provided results to rank, and provides the
     number of answers requested, listed in order from descending ranked score.
     
     - parameter resultsFile: A CSV file containing the search results that you want ranked. The 
            first column header must be labeled `answer_id`. The other column headers should 
            match the names of the features in the `trainingDataFile` used to train the ranker.
     - parameter rankerID: The ID of the ranker to use.
     - parameter numberOfDocuments: The number of answers needed. The default number is 10.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a `Ranking` object.
     */
    public func rankResults(
        fromFile resultsFile: URL,
        withRankerID rankerID: String,
        numberOfDocuments: Int? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Ranking) -> Void) {
        
        // construct REST body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(resultsFile, withName: "answer_data")
        if let numberOfDocuments = numberOfDocuments {
            let number = String(numberOfDocuments)
            multipartFormData.append(number.data(using: .utf8)!, withName: "answers")
        }
        guard let body = try? multipartFormData.toData() else {
            failure?(RestError.encodingError)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/rankers/\(rankerID)/rank",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: multipartFormData.contentType,
            messageBody: body
        )
        
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Ranking>) in
            switch response.result {
            case .success(let ranking): success(ranking)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete a ranker.
     
     - parameter rankerID: The ranker to delete.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func deleteRanker(
        withID rankerID: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil) {
        
        // construct REST request
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + "/v1/rankers/\(rankerID)",
            credentials: credentials,
            headerParameters: defaultHeaders
        )
        
        // execute REST request
        request.responseData { response in
                switch response.result {
                case .success(let data):
                    switch self.responseToError(response: response.response, data: data) {
                    case .some(let error): failure?(error)
                    case .none: success?()
                    }
                case .failure(let error):
                    failure?(error)
                }
            }
    }
    
    /**
     Get status and information about a specific ranker.
     
     - parameter rankerID: The unique identifier for the ranker you want more information about.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a `RankerDetails` object.
     */
    public func getRanker(
        withID rankerID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (RankerDetails) -> Void) {
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/rankers/\(rankerID)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<RankerDetails>) in
                switch response.result {
                case .success(let details): success(details)
                case .failure(let error): failure?(error)
                }
            }
    }
}
