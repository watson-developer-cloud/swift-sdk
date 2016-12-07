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
        withDescription description: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Environment) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct body
        var jsonData = [String: Any]()
        jsonData["name"] = name
        jsonData["description"] = description
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

    // MARK: - Collections
    
    /**
     Create a new collection for storing documents.
     
     - parameter withEnvironmentID: Unique ID of the environment to create a collection in.
     - parameter body: JSON string or file that defines the new collection.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with details of the created collection.
     */
    public func createCollection(
        withEnvironmentID environmentID: String,
        body: URL,
        failure: ((Error) -> Void)? = nil,
        success: @escaping([Collection]) -> Void)
    {
        // construct query parameters
    }
}
