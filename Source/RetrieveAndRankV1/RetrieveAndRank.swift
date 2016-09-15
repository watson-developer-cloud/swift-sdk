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
    private let userAgent = buildUserAgent("watson-apis-ios-sdk/0.8.0 RetrieveAndRankV1")
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
            
            if let msg = try? json.string("msg") {
                let code = try json.int("code")
                let userInfo = [NSLocalizedFailureReasonErrorKey: msg]
                return NSError(domain: domain, code: code, userInfo: userInfo)
            } else {
                let error = try json.string("error")
                let description = try json.string("description")
                let code = try json.int("code")
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
    
    // MARK: - Solr Clusters
    
    /**
     Retrieves the list of Solr clusters available for this Retrieve and Rank instance.
     
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with an array of `SolrCluster` objects.
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
        name: String,
        size: Int? = nil,
        failure: (NSError -> Void)? = nil,
        success: SolrCluster -> Void) {
        
        // construct body
        var json = ["cluster_name": name]
        if let size = size {
            json["cluster_size"] = String(size)
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
            .responseObject(dataToError: dataToError) {
                (response: Response<SolrCluster, NSError>) in
                switch response.result {
                case .Success(let cluster): success(cluster)
                case .Failure(let error): failure?(error)
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
    
    /**
     Gets the status and other information about a specific cluster.
     
     - parameter solrClusterID: The ID of the cluster that you want more information about.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a `SolrCluster` object.
     */
    public func getSolrCluster(
        solrClusterID: String,
        failure: (NSError -> Void)? = nil,
        success: SolrCluster -> Void) {
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)",
            acceptType: "application/json",
            userAgent: userAgent
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject(dataToError: dataToError) {
                (response: Response<SolrCluster, NSError>) in
                switch response.result {
                case .Success(let cluster): success(cluster)
                case .Failure(let error): failure?(error)
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
        solrClusterID: String,
        failure: (NSError -> Void)? = nil,
        success: [String] -> Void) {
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)/config",
            acceptType: "application/json",
            userAgent: userAgent
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseArray(dataToError: dataToError, path: ["solr_configs"]) {
                (response: Response<[String], NSError>) in
                switch response.result {
                case .Success(let config): success(config)
                case .Failure(let error): failure?(error)
                }
            }
    }
    
    /**
     Delete this specific configuration from the specified cluster.
     
     - parameter solrClusterID: The ID of the cluster that you want to delete the configuration of.
     - parameter configName: The name of the configuration you want to delete.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func deleteSolrConfiguration(
        solrClusterID: String,
        configName: String,
        failure: (NSError -> Void)? = nil,
        success: (Void -> Void)? = nil) {
        
        // construct REST request
        let request = RestRequest(
            method: .DELETE,
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)/config/\(configName)",
            userAgent: userAgent
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
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
    
    /**
     Gets a configuration .zip file with the given name from the specified cluster.
     
     - parameter solrClusterID: The ID of the cluster that you want the configuration of.
     - parameter configName: The name of the configuration you want.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the URL of the downloaded configuration file.
     */
    public func getSolrConfiguration(
        solrClusterID: String,
        configName: String,
        failure: (NSError -> Void)? = nil,
        success: NSURL -> Void) {
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)/config/\(configName)",
            userAgent: userAgent
        )
        
        // locate downloads directory
        let fileManager = NSFileManager.defaultManager()
        let directories = fileManager.URLsForDirectory(.DownloadsDirectory, inDomains: .UserDomainMask)
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
            let filePath = downloads.URLByAppendingPathComponent(filename)!.path!
            if fileManager.fileExistsAtPath(filePath) {
                duplicates += 1
                filename = configName + "-\(duplicates)" + ".zip"
            } else {
                isUnique = true
            }
        }
        
        // specify download destination
        let destinationURL = downloads.URLByAppendingPathComponent(filename)!
        let destination: Request.DownloadFileDestination = { temporaryURL, response -> NSURL in
            return destinationURL
        }
        
        // execute REST request
        Alamofire.download(request, destination: destination)
            .authenticate(user: username, password: password)
            .response { _, response, data, error in
                guard error == nil else {
                    failure?(error!)
                    return
                }
                
                guard let response = response else {
                    let failureReason = "Did not receive response."
                    let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }
                
                if let data = data {
                    if let error = self.dataToError(data) {
                        failure?(error)
                        return
                    }
                }
                
                let statusCode = response.statusCode
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
     
     - parameter solrClusterID: The ID of the cluster whose configuration you want to update.
     - parameter configName: The name of the configuration you want to update.
     - parameter zipFile: The zip file configuration set that you would like to upload.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func uploadSolrConfiguration(
        solrClusterID: String,
        configName: String,
        zipFile: NSURL,
        failure: (NSError -> Void)? = nil,
        success: (Void -> Void)? = nil) {
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)/config/\(configName)",
            contentType: "application/zip",
            userAgent: userAgent
        )
        
        // execute REST request
        Alamofire.upload(request, file: zipFile)
            .authenticate(user: self.username, password: self.password)
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
    
    /**
     Creates a new Solr collection.
     
     - parameter solrClusterID: The ID of the cluster to add this collection to.
     - parameter name: The name of the collection.
     - parameter configName: The name of the configuration to use.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func createSolrCollection(
        solrClusterID: String,
        name: String,
        configName: String,
        failure: (NSError -> Void)? = nil,
        success: (Void -> Void)? = nil) {
        
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "action", value: "CREATE"))
        queryParameters.append(NSURLQueryItem(name: "name", value: name))
        queryParameters.append(NSURLQueryItem(name: "collection.configName", value: configName))
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)/solr/admin/collections",
            userAgent: userAgent,
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
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
    
    /**
     Deletes a Solr collection.
     
     - parameter solrClusterID: The ID of the cluster to delete this collection from.
     - parameter name: The name of the collection.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func deleteSolrCollection(
        solrClusterID: String,
        name: String,
        failure: (NSError -> Void)? = nil,
        success: (Void -> Void)? = nil) {
        
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "action", value: "DELETE"))
        queryParameters.append(NSURLQueryItem(name: "name", value: name))
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)/solr/admin/collections",
            userAgent: userAgent,
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
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
    
    /**
     Lists the names of the collections in this Solr cluster.
     
     Note: For the SDK to work properly, you must define the writer type as "json" within the
     configuration solrconfig.xml file.
     
     - parameter solrClusterID: The ID of the cluster whose collections you want.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with an array of collection names.
     */
    public func getSolrCollections(
        solrClusterID: String,
        failure: (NSError -> Void)? = nil,
        success: [String] -> Void) {
        
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "action", value: "LIST"))
        queryParameters.append(NSURLQueryItem(name: "wt", value: "json"))
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)/solr/admin/collections",
            userAgent: userAgent,
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseArray(dataToError: dataToError, path: ["collections"]) {
                (response: Response<[String], NSError>) in
                switch response.result {
                case .Success(let collections): success(collections)
                case .Failure(let error): failure?(error)
                }
            }
    }
    
    /**
     Update a collection by adding content to it. This indexes the documents and allows us to 
     search the newly uploaded data later. For more information about the accepted file types and
     how to structure the content files, refer to this link:
     https://cwiki.apache.org/confluence/display/solr/Indexing+and+Basic+Data+Operations
     
     - parameter solrClusterID: The ID of the cluster this collection points to.
     - parameter collectionName: The name of the collection you would like to update.
     - parameter contentType: The media type of the content that is being uploaded.
     - parameter contentFile: The content to be added to the collection. Accepted file types are 
            listed in the link above.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func updateSolrCollection(
        solrClusterID: String,
        collectionName: String,
        contentType: String,
        contentFile: NSURL,
        failure: (NSError -> Void)? = nil,
        success: (Void -> Void)? = nil) {
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)/solr/\(collectionName)/update",
            contentType: contentType,
            userAgent: userAgent
        )
        
        // execute REST request
        Alamofire.upload(
            request,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: contentFile, name: "body")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.authenticate(user: self.username, password: self.password)
                    upload.responseData { response in
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
                case .Failure:
                    let failureReason = "File could not be encoded as form data."
                    let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }
            }
        )
    }
    
    /**
     Use the given query to search this specific collection within a given cluster. This command
     doesn't rank the values; to search and rank, use the `searchAndRank()` call.
     
     Note: For the SDK to work properly, you must define the writer type as "json" within the
     configuration solrconfig.xml file.
     
     - parameter solrClusterID: The ID of the Solr cluster.
     - parameter collectionName: The name of the collection in the cluster.
     - parameter query: The query. Refer to the following link for more information on how to 
            structure the query string: 
            https://cwiki.apache.org/confluence/display/solr/The+Standard+Query+Parser
     - parameter returnFields: The fields that should be returned. These fields should correspond
            to the fields within the content that has been uploaded to the collection. This
            parameter should be a comma-separated list.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a `SearchResponse` object.
     */
    public func search(
        solrClusterID: String,
        collectionName: String,
        query: String,
        returnFields: String,
        failure: (NSError -> Void)? = nil,
        success: SearchResponse -> Void) {
        
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "q", value: query))
        queryParameters.append(NSURLQueryItem(name: "fl", value: returnFields))
        queryParameters.append(NSURLQueryItem(name: "wt", value: "json"))
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)/solr/\(collectionName)/select",
            userAgent: userAgent,
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject(dataToError: dataToError) {
                (response: Response<SearchResponse, NSError>) in
                switch response.result {
                case .Success(let response): success(response)
                case .Failure(let error): failure?(error)
                }
            }
    }
    
    /**
     Searches the results and then returns them in ranked order.
     
     Note: For the SDK to work properly, you must define the writer type as "json" within the
     configuration solrconfig.xml file.
     
     - parameter solrClusterID: The ID of the Solr cluster.
     - parameter collectionName: The name of the collection in the cluster.
     - parameter rankerID: The ID of the ranker.
     - parameter query: The query. Refer to the following link for more information on how to
            structure the query string:
            https://cwiki.apache.org/confluence/display/solr/The+Standard+Query+Parser
     - parameter returnFields: The fields that should be returned. These fields should correspond
            to the fields within the content that has been uploaded to the collection. This
            parameter should be a comma-separated list.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a `SearchAndRankResponse` object.
     */
    public func searchAndRank(
        solrClusterID: String,
        collectionName: String,
        rankerID: String,
        query: String,
        returnFields: String,
        failure: (NSError -> Void)? = nil,
        success: SearchAndRankResponse -> Void) {
        
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "q", value: query))
        queryParameters.append(NSURLQueryItem(name: "ranker_id", value: rankerID))
        queryParameters.append(NSURLQueryItem(name: "fl", value: returnFields))
        queryParameters.append(NSURLQueryItem(name: "wt", value: "json"))
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/solr_clusters/\(solrClusterID)/solr/\(collectionName)/fcselect",
            userAgent: userAgent,
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject(dataToError: dataToError) {
                (response: Response<SearchAndRankResponse, NSError>) in
                switch response.result {
                case .Success(let response): success(response)
                case .Failure(let error): failure?(error)
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
        failure: (NSError -> Void)? = nil,
        success: [Ranker] -> Void) {
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/rankers",
            acceptType: "application/json",
            userAgent: userAgent
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseArray(dataToError: dataToError, path: ["rankers"]) {
                (response: Response<[Ranker], NSError>) in
                switch response.result {
                case .Success(let rankers): success(rankers)
                case .Failure(let error): failure?(error)
                }
            }
    }
    
    /**
     Creates and trains a new ranker. The status of the ranker will be set to `Training` until
     the ranker is ready. You need to wait until the status is `Available` before using.
     
     - parameter trainingDataFile: The training data content that will be used to train this ranker.
     - parameter name: An optional name for the ranker.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a `Ranker` object.
     */
    public func createRanker(
        trainingDataFile: NSURL,
        name: String? = nil,
        failure: (NSError -> Void)? = nil,
        success: RankerDetails -> Void) {
        
        // construct body
        var json = [String: String]()
        if let name = name {
            json["name"] = name
        } else {
            json["name"] = ""
        }
        guard let trainingMetadata = try? json.toJSON().serialize() else {
            let failureReason = "Ranker metadata could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v1/rankers",
            acceptType: "application/json",
            userAgent: userAgent
        )
        
        // execute REST request
        Alamofire.upload(
            request,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: trainingDataFile, name: "training_data")
                multipartFormData.appendBodyPart(data: trainingMetadata, name: "training_metadata")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.authenticate(user: self.username, password: self.password)
                    upload.responseObject(dataToError: self.dataToError) {
                        (response: Response<RankerDetails, NSError>) in
                        switch response.result {
                        case .Success(let ranker): success(ranker)
                        case .Failure(let error): failure?(error)
                        }
                    }
                case .Failure:
                    let failureReason = "File could not be encoded as form data."
                    let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }
            }
        )
    }
    
    /**
     Identifies the top answer from the list of provided results to rank, and provides the
     number of answers requested, listed in order from descending ranked score.
     
     - parameter rankerID: The ID of the ranker to use.
     - parameter resultsFile: A CSV file containing the search results that you want ranked. The 
            first column header must be labeled `answer_id`. The other column headers should 
            match the names of the features in the `trainingDataFile` used to train the ranker.
     - parameter numberOfResults: The number of answers needed. The default number given is 10.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a `Ranking` object.
     */
    public func rankResults(
        rankerID: String,
        resultsFile: NSURL,
        failure: (NSError -> Void)? = nil,
        success: Ranking -> Void) {
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v1/rankers/\(rankerID)/rank",
            acceptType: "application/json",
            userAgent: userAgent
        )
        
        // execute REST request
        Alamofire.upload(
            request,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: resultsFile, name: "answer_data")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.authenticate(user: self.username, password: self.password)
                    upload.responseObject(dataToError: self.dataToError) {
                        (response: Response<Ranking, NSError>) in
                        switch response.result {
                        case .Success(let ranking): success(ranking)
                        case .Failure(let error): failure?(error)
                        }
                    }
                case .Failure:
                    let failureReason = "File could not be encoded as form data."
                    let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }
            }
        )
    }
    
    /**
     Delete a ranker.
     
     - parameter rankerID: The ranker to delete.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func deleteRanker(
        rankerID: String,
        failure: (NSError -> Void)? = nil,
        success: (Void -> Void)? = nil) {
        
        // construct REST request
        let request = RestRequest(
            method: .DELETE,
            url: serviceURL + "/v1/rankers/\(rankerID)",
            userAgent: userAgent
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
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
    
    /**
     Get status and information about a specific ranker.
     
     - parameter rankerID: The unique identifier for the ranker you want more information about.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a `RankerDetails` object.
     */
    public func getRanker(
        rankerID: String,
        failure: (NSError -> Void)? = nil,
        success: RankerDetails -> Void) {
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/rankers/\(rankerID)",
            acceptType: "application/json",
            userAgent: userAgent
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject(dataToError: dataToError) {
                (response: Response<RankerDetails, NSError>) in
                switch response.result {
                case .Success(let details): success(details)
                case .Failure(let error): failure?(error)
                }
            }
    }
}
