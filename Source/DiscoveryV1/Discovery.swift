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
 The IBM Watson Discovery service uses data analysis combined with cognitive intuition to take your
 unstructured data and enrich it so you can query it for the information you need.
 */
public class Discovery {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/discovery-experimental/api"
    
    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()
    
    private let credentials: Credentials
    private let domain = "com.ibm.watson.developer-cloud.DiscoveryV1"
    private let version: String
    
    /**
     Create a `Discovery` object.
     
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter version: The release date of the version of the API to use. Specify the date
            in "YYYY-MM-DD" format.
     */
    public init(username: String, password: String, version: String) {
        self.credentials = Credentials.basicAuthentication(username: username, password: password)
        self.version = version
    }
    
    /**
     If the given data represents an error returned by the Discovery service, then return
     an NSError with information about the error that occured. Otherwise, return nil.
     
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func dataToError(data: Data) -> NSError? {
        do {
            let json = try JSON(data: data)
            let error = try json.getString(at: "error")
            let code = try json.getInt(at: "code")
            let userInfo = [NSLocalizedFailureReasonErrorKey: error]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }
    
    // MARK: - Environments
    
    /**
     Get all existing environments for this Discovery instance.
     
     - parameter name: Show only the environment with the given name.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a list of all environments associated with this service instance.
     */
    public func getEnvironments (
        withName name: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([Environment]) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let name = name {
            queryParameters.append(URLQueryItem(name: "name", value: name))
        }
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/environments",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseArray(dataToError: dataToError, path: ["environments"]) {
            (response: RestResponse<[Environment]>) in
            switch response.result {
            case .success(let environments): success(environments)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Create an environment for this service instance.
     
     For the experimental release, the size of the environment is fixed at 2GB
     available disk space, and 1GB RAM.
     
     - parameter name: The name of the new environment.
     - parameter description: The description of the new environment.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with details of the newly created environment.
     */
    public func createEnvironment(
        withName name: String,
        withDescription description: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Environment) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct body
        var jsonData = [String: Any]()
        jsonData["name"] = name
        if let description = description {
            jsonData["description"] = description
        }
        guard let body = try? JSON(dictionary: jsonData).serialize() else {
            failure?(RestError.encodingError)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/environments",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )
        
        // execute REST request
        request.responseObject(dataToError: dataToError) {
            (response: RestResponse<Environment>) in
            switch response.result {
            case .success(let environment): success(environment)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Delete the environment with the given environment ID.
     
     - parameter environmentID: The name of the new environment.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with details of the newly deleted environment.
     */
    public func deleteEnvironment(
        withID environmentID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DeletedEnvironment) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + "/v1/environments/\(environmentID)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseObject(dataToError: dataToError) {
            (response: RestResponse<DeletedEnvironment>) in
            switch response.result {
            case .success(let environment): success(environment)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Retrieve information about an environment.
     
     - parameter environmentID: The ID of the environment to retrieve information about.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the requested environment.
     */
    public func getEnvironment(
        withID environmentID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Environment) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/environments/\(environmentID)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseObject(dataToError: dataToError) {
            (response: RestResponse<Environment>) in
            switch response.result {
            case .success(let environment): success(environment)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Update an environment.
     
     - parameter environmentID: The ID of the environment to retrieve information about.
     - parameter name: The updated name of the environment.
     - parameter description: The updated description of the environment.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the requested environment.
     */
    public func updateEnvironment(
        withID environmentID: String,
        name: String,
        description: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Environment) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct body
        var jsonData = [String: Any]()
        jsonData["name"] = name
        if let description = description {
            jsonData["description"] = description
        }
        guard let body = try? JSON(dictionary: jsonData).serialize() else {
            failure?(RestError.encodingError)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "PUT",
            url: serviceURL + "/v1/environments/\(environmentID)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )
        
        // execute REST request
        request.responseObject(dataToError: dataToError) {
            (response: RestResponse<Environment>) in
            switch response.result {
            case .success(let environment): success(environment)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    // MARK: - Configurations

    /**
     List existing configurations for the service instance. 
    
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with details of the configurations.
    */
    public func getConfigurations(
        withEnvironmentID environmentID: String,
        withName name: String?,
        failure: ((Error) -> Void)? = nil,
        success: @escaping([Configuration]) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/environments/\(environmentID)/configurations",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseArray(dataToError: dataToError, path: ["configurations"]) {
            (response: RestResponse<[Configuration]>) in
            switch response.result {
            case .success(let configurations): success(configurations)
            case .failure(let error): failure?(error)
            }
        }
    }

    // MARK: - Collections
    
    /**
     Get all existing collections.

     - parameter withEnvironmentID: The ID of the environment the collections are stored in.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with details of the collections.
    */
    public func getCollections(
        withEnvironmentID environmentID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping([Collection]) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/environments/\(environmentID)/collections",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseArray(dataToError: dataToError, path: ["collections"]) {
            (response: RestResponse<[Collection]>) in
            switch response.result {
            case .success(let collections): success(collections)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Create a new collection for storing documents.
     
     - parameter withEnvironmentID: The unique ID of the environment to create a collection in.
     - parameter withName: The name of the new collection.
     - parameter withDescription: The description of the configuration.
     - parameter withConfigurationID: The unique ID of the configuration the collection will be
        created with. If nil, the default value will be specified. Call the getConfigurationID method
        to find the default value.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with details of the created collection.
     */
    public func createCollection(
        withEnvironmentID environmentID: String,
        withName name: String,
        withDescription description: String?,
        withConfigurationID configurationID: String?,
        failure: ((Error) -> Void)? = nil,
        success: @escaping(Collection) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct json from parameters
        var bodyData = [String: Any]()
        bodyData["name"] = name
        if let description = description {
            bodyData["description"] = description
        }
        if let configurationID = configurationID {
            bodyData["configuration_id"] = configurationID
        }
        guard let json = try? JSON(dictionary: bodyData).serialize() else {
            failure?(RestError.encodingError)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/environments/\(environmentID)/collections",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: json
        )
        
        // execute REST request
        request.responseObject(dataToError: dataToError) {
            (response: RestResponse<Collection>) in
            switch response.result {
            case .success(let collection): success(collection)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /** 
     Delete a collection in the environment the collection is located in.
     
     - parameter withEnvironmentID: The ID of the environment the collection is in.
     - parameter withCollectionID: The ID of the collection to delete.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with details of the newly deleted environment.
     */
    public func deleteCollection(
        withEnvironmentID environmentID: String,
        withCollectionID collectionID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DeletedCollection) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + "/v1/environments/\(environmentID)/collections/\(collectionID)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseObject(dataToError: dataToError) {
            (response: RestResponse<DeletedCollection>) in
            switch response.result {
            case .success(let collection): success(collection)
            case .failure(let error): failure?(error)
            }
        }
    }
 
    /** 
     Retrieve the information of a specified collection.
     
     - paramater withEnvironmentID: The ID of the environment the collection is in.
     - paramater withCollectionID: The ID of the collection to retrieve details of.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with details of the collection retrieved.
     */
    public func retrieveCollectionDetails(
        withEnvironmentID environmentID: String,
        withCollectionID collectionID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping(Collection) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/environments/\(environmentID)/collections/\(collectionID)",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseObject(dataToError: dataToError) {
            (response: RestResponse<Collection>) in
            switch response.result {
            case .success(let collection): success(collection)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /** 
     Replaces an existing collection.
     
     - paramater withEnvironmentID: The ID of the environment the collection is in.
     - paramater withCollectionID: The ID of the collection to update by replacing the collection with
        the updated information.
     - parameter name: The updated name of the collection.
     - parameter description: The updated description of the collection. If ommitted, the default
        description will replace the current description.
     - parameter configurationID: The configuration ID of the collection in which the collection is to
        be updated. If omitted, the default configuration ID will replace the current ID.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with details of the collection retrieved.
    */
    public func updateCollection(
        withEnvironmentID environmentID: String,
        withCollectionID collectionID: String,
        name: String,
        description: String?,
        configurationID: String?,
        failure: ((Error) -> Void)? = nil,
        success: @escaping(Collection) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct json from parameters
        var bodyData = [String: Any]()
        bodyData["name"] = name
        if let description = description {
            bodyData["description"] = description
        }
        if let configurationID = configurationID {
            bodyData["configuration_id"] = configurationID
        }
        guard let json = try? JSON(dictionary: bodyData).serialize() else {
            failure?(RestError.encodingError)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "PUT",
            url: serviceURL + "/v1/environments/\(environmentID)/collections/\(collectionID)",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: json
        )
        
        // execute REST request
        request.responseObject(dataToError: dataToError) {
            (response: RestResponse<Collection>) in
            switch response.result {
            case .success(let collection): success(collection)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /** 
     Retrieve all unique fields and each field's type stored in a collection's index.
 
     - parameter withEnvironmentID: The unique identifier of the environment the collection is in.
     - paramater withCollectionID: The unique identifier of the collection to display the fields of.
     - paramater failure: A function executed if an error occurs.
     - paramater success: A function executed with details of the fields.
    */
    public func listCollectionFields(
        withEnvironmentID environmentID: String,
        withCollectionID collectionID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping([Field]) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/environments/\(environmentID)/collections/\(collectionID)/fields",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseArray(dataToError: dataToError, path: ["fields"]) {
            (response: RestResponse<[Field]>) in
            switch response.result {
            case .success(let fields): success(fields)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    // MARK - Documents
    
    /** 
     Add document to collection. If both the configuration ID and configuration file are
        provided, the request will be rejected. Either metadata or file must be specified.
        
     - parameter withEnvironmentID: The unique identifier of the environment the collection is in.
     - parameter withCollectionID: The unique identifier of the collection to add a document to.
     - parameter withConfigurationID: The unique identifier of the configuration to process the
        document.
     - parameter file: The content of the document to ingest. Maximum file size is 50 MB. If this
        paramater is not specififed, the metadata parameter must be specififed instead.
     - parameter metadata: The JSON specifiying metadata related to the document. If not specified,
        the file parameter must be specified.
     - parameter configuration: The name of the configuration used to process the document. If this
        parameter is specified at the same time as the configuration ID is specified, the request
        will be rejected.
     - paramater failure: A function executed if an error occurs.
     - paramater success: A function executed with details of the document.
     */
    
    public func addDocumentToCollection(
        withEnvironmentID environmentID: String,
        withCollectionID collectionID: String,
        withConfigurationID configurationID: String?,
        file: URL?,
        metadata: URL?,
        configuration: URL?,
        failure: ((Error) -> Void)? = nil,
        success: @escaping(Document) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let configurationID = configurationID {
            queryParameters.append(URLQueryItem(name: "configuration_id", value: configurationID))
        }
        
        // construct body
        let multipartFormData = MultipartFormData()
        if let file = file {
            multipartFormData.append(file, withName: "file")
        }
        if let metadata = metadata {
            multipartFormData.append(metadata, withName: "metadata")
        }
        if let configuration = configuration {
            multipartFormData.append(configuration, withName: "configuration")
        }
        guard let body = try? multipartFormData.toData() else {
            failure?(RestError.encodingError)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/environments/\(environmentID)/collections/\(collectionID)/documents",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: multipartFormData.contentType,
            queryItems: queryParameters,
            messageBody: body
        )
        
        // execute REST request
        request.responseObject(dataToError: dataToError) {
            (response: RestResponse<Document>) in
            switch response.result {
            case .success(let document): success(document)
            case .failure(let error): failure?(error)
            }
        }    }
}
