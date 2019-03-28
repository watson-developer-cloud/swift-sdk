/**
 * Copyright IBM Corporation 2019
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
// swiftlint:disable file_length

import Foundation
import RestKit

/**
 The IBM Watson&trade; Discovery Service is a cognitive search and content analytics engine that you can add to
 applications to identify patterns, trends and actionable insights to drive better decision-making. Securely unify
 structured and unstructured data with pre-enriched content, and use a simplified query language to eliminate the need
 for manual filtering of results.
 */
public class Discovery {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/discovery/api"
    internal let serviceName = "Discovery"
    internal let serviceVersion = "v1"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    var session = URLSession(configuration: URLSessionConfiguration.default)
    var authMethod: AuthenticationMethod
    let version: String

    #if os(Linux)
    /**
     Create a `Discovery` object.

     This initializer will retrieve credentials from the environment or a local credentials file.
     The credentials file can be downloaded from your service instance on IBM Cloud as ibm-credentials.env.
     Make sure to add the credentials file to your project so that it can be loaded at runtime.

     If credentials are not available in the environment or a local credentials file, initialization will fail.
     In that case, try another initializer that directly passes in the credentials.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     */
    public init?(version: String) {
        self.version = version
        guard let credentials = Shared.extractCredentials(serviceName: "discovery") else {
            return nil
        }
        guard let authMethod = Shared.getAuthMethod(from: credentials) else {
            return nil
        }
        if let serviceURL = Shared.getServiceURL(from: credentials) {
            self.serviceURL = serviceURL
        }
        self.authMethod = authMethod
        RestRequest.userAgent = Shared.userAgent
    }
    #endif

    /**
     Create a `Discovery` object.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     */
    public init(version: String, username: String, password: String) {
        self.version = version
        self.authMethod = Shared.getAuthMethod(username: username, password: password)
        RestRequest.userAgent = Shared.userAgent
    }

    /**
     Create a `Discovery` object.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     - parameter apiKey: An API key for IAM that can be used to obtain access tokens for the service.
     - parameter iamUrl: The URL for the IAM service.
     */
    public init(version: String, apiKey: String, iamUrl: String? = nil) {
        self.authMethod = Shared.getAuthMethod(apiKey: apiKey, iamURL: iamUrl)
        self.version = version
        RestRequest.userAgent = Shared.userAgent
    }

    /**
     Create a `Discovery` object.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     - parameter accessToken: An access token for the service.
     */
    public init(version: String, accessToken: String) {
        self.version = version
        self.authMethod = IAMAccessToken(accessToken: accessToken)
        RestRequest.userAgent = Shared.userAgent
    }

    public func accessToken(_ newToken: String) {
        if self.authMethod is IAMAccessToken {
            self.authMethod = IAMAccessToken(accessToken: newToken)
        }
    }

    /**
     Use the HTTP response and data received by the Discovery service to extract
     information about the error that occurred.

     - parameter data: Raw data returned by the service that may represent an error.
     - parameter response: the URL response returned by the service.
     */
    func errorResponseDecoder(data: Data, response: HTTPURLResponse) -> WatsonError {

        let statusCode = response.statusCode
        var errorMessage: String?
        var metadata = [String: Any]()

        do {
            let json = try JSON.decoder.decode([String: JSON].self, from: data)
            metadata["response"] = json
            if case let .some(.array(errors)) = json["errors"],
                case let .some(.object(error)) = errors.first,
                case let .some(.string(message)) = error["message"] {
                errorMessage = message
            } else if case let .some(.string(message)) = json["error"] {
                errorMessage = message
            } else if case let .some(.string(message)) = json["message"] {
                errorMessage = message
            } else {
                errorMessage = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
            }
        } catch {
            metadata["response"] = data
            errorMessage = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
        }

        return WatsonError.http(statusCode: statusCode, message: errorMessage, metadata: metadata)
    }

    /**
     Create an environment.

     Creates a new environment for private data. An environment must be created before collections can be created.
     **Note**: You can create only one environment for private data per service instance. An attempt to create another
     environment results in an error.

     - parameter name: Name that identifies the environment.
     - parameter description: Description of the environment.
     - parameter size: Size of the environment. In the Lite plan the default and only accepted value is `LT`, in all
       other plans the default is `S`.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createEnvironment(
        name: String,
        description: String? = nil,
        size: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Environment>?, WatsonError?) -> Void)
    {
        // construct body
        let createEnvironmentRequest = CreateEnvironmentRequest(
            name: name,
            description: description,
            size: size)
        guard let body = try? JSON.encoder.encode(createEnvironmentRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createEnvironment")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v1/environments",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List environments.

     List existing environments for the service instance.

     - parameter name: Show only the environment with the given name.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listEnvironments(
        name: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ListEnvironmentsResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listEnvironments")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let name = name {
            let queryParameter = URLQueryItem(name: "name", value: name)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + "/v1/environments",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Get environment info.

     - parameter environmentID: The ID of the environment.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getEnvironment(
        environmentID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Environment>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getEnvironment")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Update an environment.

     Updates an environment. The environment's **name** and  **description** parameters can be changed. You must specify
     a **name** for the environment.

     - parameter environmentID: The ID of the environment.
     - parameter name: Name that identifies the environment.
     - parameter description: Description of the environment.
     - parameter size: Size that the environment should be increased to. Environment size cannot be modified when
       using a Lite plan. Environment size can only increased and not decreased.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateEnvironment(
        environmentID: String,
        name: String? = nil,
        description: String? = nil,
        size: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Environment>?, WatsonError?) -> Void)
    {
        // construct body
        let updateEnvironmentRequest = UpdateEnvironmentRequest(
            name: name,
            description: description,
            size: size)
        guard let body = try? JSON.encoder.encode(updateEnvironmentRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateEnvironment")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "PUT",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete environment.

     - parameter environmentID: The ID of the environment.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteEnvironment(
        environmentID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DeleteEnvironmentResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteEnvironment")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List fields across collections.

     Gets a list of the unique fields (and their types) stored in the indexes of the specified collections.

     - parameter environmentID: The ID of the environment.
     - parameter collectionIDs: A comma-separated list of collection IDs to be queried against.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listFields(
        environmentID: String,
        collectionIDs: [String],
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ListCollectionFieldsResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listFields")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        queryParameters.append(URLQueryItem(name: "collection_ids", value: collectionIDs.joined(separator: ",")))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/fields"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Add configuration.

     Creates a new configuration.
     If the input configuration contains the **configuration_id**, **created**, or **updated** properties, then they are
     ignored and overridden by the system, and an error is not returned so that the overridden fields do not need to be
     removed when copying a configuration.
     The configuration can contain unrecognized JSON fields. Any such fields are ignored and do not generate an error.
     This makes it easier to use newer configuration files with older versions of the API and the service. It also makes
     it possible for the tooling to add additional metadata and information to the configuration.

     - parameter environmentID: The ID of the environment.
     - parameter name: The name of the configuration.
     - parameter description: The description of the configuration, if available.
     - parameter conversions: Document conversion settings.
     - parameter enrichments: An array of document enrichment settings for the configuration.
     - parameter normalizations: Defines operations that can be used to transform the final output JSON into a
       normalized form. Operations are executed in the order that they appear in the array.
     - parameter source: Object containing source parameters for the configuration.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createConfiguration(
        environmentID: String,
        name: String,
        description: String? = nil,
        conversions: Conversions? = nil,
        enrichments: [Enrichment]? = nil,
        normalizations: [NormalizationOperation]? = nil,
        source: Source? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Configuration>?, WatsonError?) -> Void)
    {
        // construct body
        let createConfigurationRequest = Configuration(
            name: name,
            description: description,
            conversions: conversions,
            enrichments: enrichments,
            normalizations: normalizations,
            source: source)
        guard let body = try? JSON.encoder.encode(createConfigurationRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createConfiguration")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/configurations"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List configurations.

     Lists existing configurations for the service instance.

     - parameter environmentID: The ID of the environment.
     - parameter name: Find configurations with the given name.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listConfigurations(
        environmentID: String,
        name: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ListConfigurationsResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listConfigurations")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let name = name {
            let queryParameter = URLQueryItem(name: "name", value: name)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/environments/\(environmentID)/configurations"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Get configuration details.

     - parameter environmentID: The ID of the environment.
     - parameter configurationID: The ID of the configuration.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getConfiguration(
        environmentID: String,
        configurationID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Configuration>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getConfiguration")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/configurations/\(configurationID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Update a configuration.

     Replaces an existing configuration.
       * Completely replaces the original configuration.
       * The **configuration_id**, **updated**, and **created** fields are accepted in the request, but they are
     ignored, and an error is not generated. It is also acceptable for users to submit an updated configuration with
     none of the three properties.
       * Documents are processed with a snapshot of the configuration as it was at the time the document was submitted
     to be ingested. This means that already submitted documents will not see any updates made to the configuration.

     - parameter environmentID: The ID of the environment.
     - parameter configurationID: The ID of the configuration.
     - parameter name: The name of the configuration.
     - parameter description: The description of the configuration, if available.
     - parameter conversions: Document conversion settings.
     - parameter enrichments: An array of document enrichment settings for the configuration.
     - parameter normalizations: Defines operations that can be used to transform the final output JSON into a
       normalized form. Operations are executed in the order that they appear in the array.
     - parameter source: Object containing source parameters for the configuration.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateConfiguration(
        environmentID: String,
        configurationID: String,
        name: String,
        description: String? = nil,
        conversions: Conversions? = nil,
        enrichments: [Enrichment]? = nil,
        normalizations: [NormalizationOperation]? = nil,
        source: Source? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Configuration>?, WatsonError?) -> Void)
    {
        // construct body
        let updateConfigurationRequest = Configuration(
            name: name,
            description: description,
            conversions: conversions,
            enrichments: enrichments,
            normalizations: normalizations,
            source: source)
        guard let body = try? JSON.encoder.encode(updateConfigurationRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateConfiguration")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/configurations/\(configurationID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "PUT",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete a configuration.

     The deletion is performed unconditionally. A configuration deletion request succeeds even if the configuration is
     referenced by a collection or document ingestion. However, documents that have already been submitted for
     processing continue to use the deleted configuration. Documents are always processed with a snapshot of the
     configuration as it existed at the time the document was submitted.

     - parameter environmentID: The ID of the environment.
     - parameter configurationID: The ID of the configuration.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteConfiguration(
        environmentID: String,
        configurationID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DeleteConfigurationResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteConfiguration")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/configurations/\(configurationID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Test configuration.

     Runs a sample document through the default or your configuration and returns diagnostic information designed to
     help you understand how the document was processed. The document is not added to the index.

     - parameter environmentID: The ID of the environment.
     - parameter configuration: The configuration to use to process the document. If this part is provided, then the
       provided configuration is used to process the document. If the **configuration_id** is also provided (both are
       present at the same time), then request is rejected. The maximum supported configuration size is 1 MB.
       Configuration parts larger than 1 MB are rejected.
       See the `GET /configurations/{configuration_id}` operation for an example configuration.
     - parameter file: The content of the document to ingest. The maximum supported file size when adding a file to a
       collection is 50 megabytes, the maximum supported file size when testing a confiruration is 1 megabyte. Files
       larger than the supported size are rejected.
     - parameter filename: The filename for file.
     - parameter fileContentType: The content type of file.
     - parameter metadata: If you're using the Data Crawler to upload your documents, you can test a document against
       the type of metadata that the Data Crawler might send. The maximum supported metadata file size is 1 MB. Metadata
       parts larger than 1 MB are rejected.
       Example:  ``` {
         \"Creator\": \"Johnny Appleseed\",
         \"Subject\": \"Apples\"
       } ```.
     - parameter step: Specify to only run the input document through the given step instead of running the input
       document through the entire ingestion workflow. Valid values are `convert`, `enrich`, and `normalize`.
     - parameter configurationID: The ID of the configuration to use to process the document. If the **configuration**
       form part is also provided (both are present at the same time), then the request will be rejected.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func testConfigurationInEnvironment(
        environmentID: String,
        configuration: String? = nil,
        file: Data? = nil,
        filename: String? = nil,
        fileContentType: String? = nil,
        metadata: String? = nil,
        step: String? = nil,
        configurationID: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TestDocument>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        if let configuration = configuration {
            if let configurationData = configuration.data(using: .utf8) {
                multipartFormData.append(configurationData, withName: "configuration")
            }
        }
        if let file = file {
            multipartFormData.append(file, withName: "file", mimeType: fileContentType, fileName: filename ?? "filename")
        }
        if let metadata = metadata {
            if let metadataData = metadata.data(using: .utf8) {
                multipartFormData.append(metadataData, withName: "metadata")
            }
        }
        guard let body = try? multipartFormData.toData() else {
            completionHandler(nil, WatsonError.serialization(values: "request multipart form data"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "testConfigurationInEnvironment")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let step = step {
            let queryParameter = URLQueryItem(name: "step", value: step)
            queryParameters.append(queryParameter)
        }
        if let configurationID = configurationID {
            let queryParameter = URLQueryItem(name: "configuration_id", value: configurationID)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/environments/\(environmentID)/preview"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Create a collection.

     - parameter environmentID: The ID of the environment.
     - parameter name: The name of the collection to be created.
     - parameter description: A description of the collection.
     - parameter configurationID: The ID of the configuration in which the collection is to be created.
     - parameter language: The language of the documents stored in the collection, in the form of an ISO 639-1
       language code.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createCollection(
        environmentID: String,
        name: String,
        description: String? = nil,
        configurationID: String? = nil,
        language: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Collection>?, WatsonError?) -> Void)
    {
        // construct body
        let createCollectionRequest = CreateCollectionRequest(
            name: name,
            description: description,
            configurationID: configurationID,
            language: language)
        guard let body = try? JSON.encoder.encode(createCollectionRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createCollection")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List collections.

     Lists existing collections for the service instance.

     - parameter environmentID: The ID of the environment.
     - parameter name: Find collections with the given name.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listCollections(
        environmentID: String,
        name: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ListCollectionsResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listCollections")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let name = name {
            let queryParameter = URLQueryItem(name: "name", value: name)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Get collection details.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getCollection(
        environmentID: String,
        collectionID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Collection>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getCollection")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Update a collection.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter name: The name of the collection.
     - parameter description: A description of the collection.
     - parameter configurationID: The ID of the configuration in which the collection is to be updated.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateCollection(
        environmentID: String,
        collectionID: String,
        name: String,
        description: String? = nil,
        configurationID: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Collection>?, WatsonError?) -> Void)
    {
        // construct body
        let updateCollectionRequest = UpdateCollectionRequest(
            name: name,
            description: description,
            configurationID: configurationID)
        guard let body = try? JSON.encoder.encodeIfPresent(updateCollectionRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateCollection")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "PUT",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete a collection.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteCollection(
        environmentID: String,
        collectionID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DeleteCollectionResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteCollection")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List collection fields.

     Gets a list of the unique fields (and their types) stored in the index.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listCollectionFields(
        environmentID: String,
        collectionID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ListCollectionFieldsResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listCollectionFields")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/fields"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Get the expansion list.

     Returns the current expansion list for the specified collection. If an expansion list is not specified, an object
     with empty expansion arrays is returned.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listExpansions(
        environmentID: String,
        collectionID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Expansions>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listExpansions")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/expansions"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Create or update expansion list.

     Create or replace the Expansion list for this collection. The maximum number of expanded terms per collection is
     `500`.
     The current expansion list is replaced with the uploaded content.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter expansions: An array of query expansion definitions.
        Each object in the **expansions** array represents a term or set of terms that will be expanded into other
       terms. Each expansion object can be configured as bidirectional or unidirectional. Bidirectional means that all
       terms are expanded to all other terms in the object. Unidirectional means that a set list of terms can be
       expanded into a second list of terms.
        To create a bi-directional expansion specify an **expanded_terms** array. When found in a query, all items in
       the **expanded_terms** array are then expanded to the other items in the same array.
        To create a uni-directional expansion, specify both an array of **input_terms** and an array of
       **expanded_terms**. When items in the **input_terms** array are present in a query, they are expanded using the
       items listed in the **expanded_terms** array.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createExpansions(
        environmentID: String,
        collectionID: String,
        expansions: [Expansion],
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Expansions>?, WatsonError?) -> Void)
    {
        // construct body
        let createExpansionsRequest = Expansions(
            expansions: expansions)
        guard let body = try? JSON.encoder.encode(createExpansionsRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createExpansions")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/expansions"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete the expansion list.

     Remove the expansion information for this collection. The expansion list must be deleted to disable query expansion
     for a collection.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteExpansions(
        environmentID: String,
        collectionID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteExpansions")
        headerParameters.merge(sdkHeaders) { (_, new) in new }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/expansions"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     Get tokenization dictionary status.

     Returns the current status of the tokenization dictionary for the specified collection.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getTokenizationDictionaryStatus(
        environmentID: String,
        collectionID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TokenDictStatusResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getTokenizationDictionaryStatus")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/word_lists/tokenization_dictionary"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Create tokenization dictionary.

     Upload a custom tokenization dictionary to use with the specified collection.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter tokenizationRules: An array of tokenization rules. Each rule contains, the original `text` string,
       component `tokens`, any alternate character set `readings`, and which `part_of_speech` the text is from.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createTokenizationDictionary(
        environmentID: String,
        collectionID: String,
        tokenizationRules: [TokenDictRule]? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TokenDictStatusResponse>?, WatsonError?) -> Void)
    {
        // construct body
        let createTokenizationDictionaryRequest = TokenDict(
            tokenizationRules: tokenizationRules)
        guard let body = try? JSON.encoder.encodeIfPresent(createTokenizationDictionaryRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createTokenizationDictionary")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/word_lists/tokenization_dictionary"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete tokenization dictionary.

     Delete the tokenization dictionary from the collection.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteTokenizationDictionary(
        environmentID: String,
        collectionID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteTokenizationDictionary")
        headerParameters.merge(sdkHeaders) { (_, new) in new }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/word_lists/tokenization_dictionary"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     Get stopword list status.

     Returns the current status of the stopword list for the specified collection.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getStopwordListStatus(
        environmentID: String,
        collectionID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TokenDictStatusResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getStopwordListStatus")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/word_lists/stopwords"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Create stopword list.

     Upload a custom stopword list to use with the specified collection.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter stopwordFile: The content of the stopword list to ingest.
     - parameter stopwordFilename: The filename for stopwordFile.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createStopwordList(
        environmentID: String,
        collectionID: String,
        stopwordFile: Data,
        stopwordFilename: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TokenDictStatusResponse>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(stopwordFile, withName: "stopword_file", fileName: stopwordFilename)
        guard let body = try? multipartFormData.toData() else {
            completionHandler(nil, WatsonError.serialization(values: "request multipart form data"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createStopwordList")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/word_lists/stopwords"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete a custom stopword list.

     Delete a custom stopword list from the collection. After a custom stopword list is deleted, the default list is
     used for the collection.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteStopwordList(
        environmentID: String,
        collectionID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteStopwordList")
        headerParameters.merge(sdkHeaders) { (_, new) in new }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/word_lists/stopwords"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     Add a document.

     Add a document to a collection with optional metadata.
       * The **version** query parameter is still required.
       * Returns immediately after the system has accepted the document for processing.
       * The user must provide document content, metadata, or both. If the request is missing both document content and
     metadata, it is rejected.
       * The user can set the **Content-Type** parameter on the **file** part to indicate the media type of the
     document. If the **Content-Type** parameter is missing or is one of the generic media types (for example,
     `application/octet-stream`), then the service attempts to automatically detect the document's media type.
       * The following field names are reserved and will be filtered out if present after normalization: `id`, `score`,
     `highlight`, and any field with the prefix of: `_`, `+`, or `-`
       * Fields with empty name values after normalization are filtered out before indexing.
       * Fields containing the following characters after normalization are filtered out before indexing: `#` and `,`
      **Note:** Documents can be added with a specific **document_id** by using the
     **_/v1/environments/{environment_id}/collections/{collection_id}/documents** method.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter file: The content of the document to ingest. The maximum supported file size when adding a file to a
       collection is 50 megabytes, the maximum supported file size when testing a confiruration is 1 megabyte. Files
       larger than the supported size are rejected.
     - parameter filename: The filename for file.
     - parameter fileContentType: The content type of file.
     - parameter metadata: If you're using the Data Crawler to upload your documents, you can test a document against
       the type of metadata that the Data Crawler might send. The maximum supported metadata file size is 1 MB. Metadata
       parts larger than 1 MB are rejected.
       Example:  ``` {
         \"Creator\": \"Johnny Appleseed\",
         \"Subject\": \"Apples\"
       } ```.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func addDocument(
        environmentID: String,
        collectionID: String,
        file: Data? = nil,
        filename: String? = nil,
        fileContentType: String? = nil,
        metadata: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DocumentAccepted>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        if let file = file {
            multipartFormData.append(file, withName: "file", mimeType: fileContentType, fileName: filename ?? "filename")
        }
        if let metadata = metadata {
            if let metadataData = metadata.data(using: .utf8) {
                multipartFormData.append(metadataData, withName: "metadata")
            }
        }
        guard let body = try? multipartFormData.toData() else {
            completionHandler(nil, WatsonError.serialization(values: "request multipart form data"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "addDocument")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/documents"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Get document details.

     Fetch status details about a submitted document. **Note:** this operation does not return the document itself.
     Instead, it returns only the document's processing status and any notices (warnings or errors) that were generated
     when the document was ingested. Use the query API to retrieve the actual document content.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter documentID: The ID of the document.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getDocumentStatus(
        environmentID: String,
        collectionID: String,
        documentID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DocumentStatus>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getDocumentStatus")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/documents/\(documentID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Update a document.

     Replace an existing document or add a document with a specified **document_id**. Starts ingesting a document with
     optional metadata.
     **Note:** When uploading a new document with this method it automatically replaces any document stored with the
     same **document_id** if it exists.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter documentID: The ID of the document.
     - parameter file: The content of the document to ingest. The maximum supported file size when adding a file to a
       collection is 50 megabytes, the maximum supported file size when testing a confiruration is 1 megabyte. Files
       larger than the supported size are rejected.
     - parameter filename: The filename for file.
     - parameter fileContentType: The content type of file.
     - parameter metadata: If you're using the Data Crawler to upload your documents, you can test a document against
       the type of metadata that the Data Crawler might send. The maximum supported metadata file size is 1 MB. Metadata
       parts larger than 1 MB are rejected.
       Example:  ``` {
         \"Creator\": \"Johnny Appleseed\",
         \"Subject\": \"Apples\"
       } ```.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateDocument(
        environmentID: String,
        collectionID: String,
        documentID: String,
        file: Data? = nil,
        filename: String? = nil,
        fileContentType: String? = nil,
        metadata: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DocumentAccepted>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        if let file = file {
            multipartFormData.append(file, withName: "file", mimeType: fileContentType, fileName: filename ?? "filename")
        }
        if let metadata = metadata {
            if let metadataData = metadata.data(using: .utf8) {
                multipartFormData.append(metadataData, withName: "metadata")
            }
        }
        guard let body = try? multipartFormData.toData() else {
            completionHandler(nil, WatsonError.serialization(values: "request multipart form data"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateDocument")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/documents/\(documentID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete a document.

     If the given document ID is invalid, or if the document is not found, then the a success response is returned (HTTP
     status code `200`) with the status set to 'deleted'.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter documentID: The ID of the document.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteDocument(
        environmentID: String,
        collectionID: String,
        documentID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DeleteDocumentResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteDocument")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/documents/\(documentID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Long collection queries.

     Complex queries might be too long for a standard method query. By using this method, you can construct longer
     queries. However, these queries may take longer to complete than the standard method. For details, see the
     [Discovery service
     documentation](https://cloud.ibm.com/docs/services/discovery?topic=discovery-query-concepts#query-concepts).

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter filter: A cacheable query that excludes documents that don't mention the query content. Filter
       searches are better for metadata-type searches and for assessing the concepts in the data set.
     - parameter query: A query search returns all documents in your data set with full enrichments and full text, but
       with the most relevant documents listed first. Use a query search when you want to find the most relevant search
       results. You cannot use **natural_language_query** and **query** at the same time.
     - parameter naturalLanguageQuery: A natural language query that returns relevant documents by utilizing training
       data and natural language understanding. You cannot use **natural_language_query** and **query** at the same
       time.
     - parameter passages: A passages query that returns the most relevant passages from the results.
     - parameter aggregation: An aggregation search that returns an exact answer by combining query search with
       filters. Useful for applications to build lists, tables, and time series. For a full list of possible
       aggregations, see the Query reference.
     - parameter count: Number of results to return.
     - parameter returnFields: A comma-separated list of the portion of the document hierarchy to return.
     - parameter offset: The number of query results to skip at the beginning. For example, if the total number of
       results that are returned is 10 and the offset is 8, it returns the last two results.
     - parameter sort: A comma-separated list of fields in the document to sort on. You can optionally specify a sort
       direction by prefixing the field with `-` for descending or `+` for ascending. Ascending is the default sort
       direction if no prefix is specified. This parameter cannot be used in the same query as the **bias** parameter.
     - parameter highlight: When true, a highlight field is returned for each result which contains the fields which
       match the query with `<em></em>` tags around the matching query terms.
     - parameter passagesFields: A comma-separated list of fields that passages are drawn from. If this parameter not
       specified, then all top-level fields are included.
     - parameter passagesCount: The maximum number of passages to return. The search returns fewer passages if the
       requested total is not found. The default is `10`. The maximum is `100`.
     - parameter passagesCharacters: The approximate number of characters that any one passage will have.
     - parameter deduplicate: When `true`, and used with a Watson Discovery News collection, duplicate results (based
       on the contents of the **title** field) are removed. Duplicate comparison is limited to the current query only;
       **offset** is not considered. This parameter is currently Beta functionality.
     - parameter deduplicateField: When specified, duplicate results based on the field specified are removed from the
       returned results. Duplicate comparison is limited to the current query only, **offset** is not considered. This
       parameter is currently Beta functionality.
     - parameter collectionIDs: A comma-separated list of collection IDs to be queried against. Required when querying
       multiple collections, invalid when performing a single collection query.
     - parameter similar: When `true`, results are returned based on their similarity to the document IDs specified in
       the **similar.document_ids** parameter.
     - parameter similarDocumentIDs: A comma-separated list of document IDs to find similar documents.
       **Tip:** Include the **natural_language_query** parameter to expand the scope of the document similarity search
       with the natural language query. Other query parameters, such as **filter** and **query**, are subsequently
       applied and reduce the scope.
     - parameter similarFields: A comma-separated list of field names that are used as a basis for comparison to
       identify similar documents. If not specified, the entire document is used for comparison.
     - parameter bias: Field which the returned results will be biased against. The specified field must be either a
       **date** or **number** format. When a **date** type field is specified returned results are biased towards field
       values closer to the current date. When a **number** type field is specified, returned results are biased towards
       higher field values. This parameter cannot be used in the same query as the **sort** parameter.
     - parameter loggingOptOut: If `true`, queries are not stored in the Discovery **Logs** endpoint.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func query(
        environmentID: String,
        collectionID: String,
        filter: String? = nil,
        query: String? = nil,
        naturalLanguageQuery: String? = nil,
        passages: Bool? = nil,
        aggregation: String? = nil,
        count: Int? = nil,
        returnFields: String? = nil,
        offset: Int? = nil,
        sort: String? = nil,
        highlight: Bool? = nil,
        passagesFields: String? = nil,
        passagesCount: Int? = nil,
        passagesCharacters: Int? = nil,
        deduplicate: Bool? = nil,
        deduplicateField: String? = nil,
        collectionIDs: String? = nil,
        similar: Bool? = nil,
        similarDocumentIDs: String? = nil,
        similarFields: String? = nil,
        bias: String? = nil,
        loggingOptOut: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<QueryResponse>?, WatsonError?) -> Void)
    {
        // construct body
        let queryRequest = QueryLarge(
            filter: filter,
            query: query,
            naturalLanguageQuery: naturalLanguageQuery,
            passages: passages,
            aggregation: aggregation,
            count: count,
            returnFields: returnFields,
            offset: offset,
            sort: sort,
            highlight: highlight,
            passagesFields: passagesFields,
            passagesCount: passagesCount,
            passagesCharacters: passagesCharacters,
            deduplicate: deduplicate,
            deduplicateField: deduplicateField,
            collectionIDs: collectionIDs,
            similar: similar,
            similarDocumentIDs: similarDocumentIDs,
            similarFields: similarFields,
            bias: bias)
        guard let body = try? JSON.encoder.encodeIfPresent(queryRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "query")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let loggingOptOut = loggingOptOut {
            headerParameters["X-Watson-Logging-Opt-Out"] = "\(loggingOptOut)"
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/query"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Query system notices.

     Queries for notices (errors or warnings) that might have been generated by the system. Notices are generated when
     ingesting documents and performing relevance training. See the [Discovery service
     documentation](https://cloud.ibm.com/docs/services/discovery?topic=discovery-query-concepts#query-concepts) for
     more details on the query language.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter filter: A cacheable query that excludes documents that don't mention the query content. Filter
       searches are better for metadata-type searches and for assessing the concepts in the data set.
     - parameter query: A query search returns all documents in your data set with full enrichments and full text, but
       with the most relevant documents listed first. Use a query search when you want to find the most relevant search
       results. You cannot use **natural_language_query** and **query** at the same time.
     - parameter naturalLanguageQuery: A natural language query that returns relevant documents by utilizing training
       data and natural language understanding. You cannot use **natural_language_query** and **query** at the same
       time.
     - parameter passages: A passages query that returns the most relevant passages from the results.
     - parameter aggregation: An aggregation search that returns an exact answer by combining query search with
       filters. Useful for applications to build lists, tables, and time series. For a full list of possible
       aggregations, see the Query reference.
     - parameter count: Number of results to return. The maximum for the **count** and **offset** values together in
       any one query is **10000**.
     - parameter returnFields: A comma-separated list of the portion of the document hierarchy to return.
     - parameter offset: The number of query results to skip at the beginning. For example, if the total number of
       results that are returned is 10 and the offset is 8, it returns the last two results. The maximum for the
       **count** and **offset** values together in any one query is **10000**.
     - parameter sort: A comma-separated list of fields in the document to sort on. You can optionally specify a sort
       direction by prefixing the field with `-` for descending or `+` for ascending. Ascending is the default sort
       direction if no prefix is specified.
     - parameter highlight: When true, a highlight field is returned for each result which contains the fields which
       match the query with `<em></em>` tags around the matching query terms.
     - parameter passagesFields: A comma-separated list of fields that passages are drawn from. If this parameter not
       specified, then all top-level fields are included.
     - parameter passagesCount: The maximum number of passages to return. The search returns fewer passages if the
       requested total is not found.
     - parameter passagesCharacters: The approximate number of characters that any one passage will have.
     - parameter deduplicateField: When specified, duplicate results based on the field specified are removed from the
       returned results. Duplicate comparison is limited to the current query only, **offset** is not considered. This
       parameter is currently Beta functionality.
     - parameter similar: When `true`, results are returned based on their similarity to the document IDs specified in
       the **similar.document_ids** parameter.
     - parameter similarDocumentIDs: A comma-separated list of document IDs to find similar documents.
       **Tip:** Include the **natural_language_query** parameter to expand the scope of the document similarity search
       with the natural language query. Other query parameters, such as **filter** and **query**, are subsequently
       applied and reduce the scope.
     - parameter similarFields: A comma-separated list of field names that are used as a basis for comparison to
       identify similar documents. If not specified, the entire document is used for comparison.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func queryNotices(
        environmentID: String,
        collectionID: String,
        filter: String? = nil,
        query: String? = nil,
        naturalLanguageQuery: String? = nil,
        passages: Bool? = nil,
        aggregation: String? = nil,
        count: Int? = nil,
        returnFields: [String]? = nil,
        offset: Int? = nil,
        sort: [String]? = nil,
        highlight: Bool? = nil,
        passagesFields: [String]? = nil,
        passagesCount: Int? = nil,
        passagesCharacters: Int? = nil,
        deduplicateField: String? = nil,
        similar: Bool? = nil,
        similarDocumentIDs: [String]? = nil,
        similarFields: [String]? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<QueryNoticesResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "queryNotices")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let filter = filter {
            let queryParameter = URLQueryItem(name: "filter", value: filter)
            queryParameters.append(queryParameter)
        }
        if let query = query {
            let queryParameter = URLQueryItem(name: "query", value: query)
            queryParameters.append(queryParameter)
        }
        if let naturalLanguageQuery = naturalLanguageQuery {
            let queryParameter = URLQueryItem(name: "natural_language_query", value: naturalLanguageQuery)
            queryParameters.append(queryParameter)
        }
        if let passages = passages {
            let queryParameter = URLQueryItem(name: "passages", value: "\(passages)")
            queryParameters.append(queryParameter)
        }
        if let aggregation = aggregation {
            let queryParameter = URLQueryItem(name: "aggregation", value: aggregation)
            queryParameters.append(queryParameter)
        }
        if let count = count {
            let queryParameter = URLQueryItem(name: "count", value: "\(count)")
            queryParameters.append(queryParameter)
        }
        if let returnFields = returnFields {
            let queryParameter = URLQueryItem(name: "return", value: returnFields.joined(separator: ","))
            queryParameters.append(queryParameter)
        }
        if let offset = offset {
            let queryParameter = URLQueryItem(name: "offset", value: "\(offset)")
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort.joined(separator: ","))
            queryParameters.append(queryParameter)
        }
        if let highlight = highlight {
            let queryParameter = URLQueryItem(name: "highlight", value: "\(highlight)")
            queryParameters.append(queryParameter)
        }
        if let passagesFields = passagesFields {
            let queryParameter = URLQueryItem(name: "passages.fields", value: passagesFields.joined(separator: ","))
            queryParameters.append(queryParameter)
        }
        if let passagesCount = passagesCount {
            let queryParameter = URLQueryItem(name: "passages.count", value: "\(passagesCount)")
            queryParameters.append(queryParameter)
        }
        if let passagesCharacters = passagesCharacters {
            let queryParameter = URLQueryItem(name: "passages.characters", value: "\(passagesCharacters)")
            queryParameters.append(queryParameter)
        }
        if let deduplicateField = deduplicateField {
            let queryParameter = URLQueryItem(name: "deduplicate.field", value: deduplicateField)
            queryParameters.append(queryParameter)
        }
        if let similar = similar {
            let queryParameter = URLQueryItem(name: "similar", value: "\(similar)")
            queryParameters.append(queryParameter)
        }
        if let similarDocumentIDs = similarDocumentIDs {
            let queryParameter = URLQueryItem(name: "similar.document_ids", value: similarDocumentIDs.joined(separator: ","))
            queryParameters.append(queryParameter)
        }
        if let similarFields = similarFields {
            let queryParameter = URLQueryItem(name: "similar.fields", value: similarFields.joined(separator: ","))
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/notices"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Long environment queries.

     Complex queries might be too long for a standard method query. By using this method, you can construct longer
     queries. However, these queries may take longer to complete than the standard method. For details, see the
     [Discovery service
     documentation](https://cloud.ibm.com/docs/services/discovery?topic=discovery-query-concepts#query-concepts).

     - parameter environmentID: The ID of the environment.
     - parameter filter: A cacheable query that excludes documents that don't mention the query content. Filter
       searches are better for metadata-type searches and for assessing the concepts in the data set.
     - parameter query: A query search returns all documents in your data set with full enrichments and full text, but
       with the most relevant documents listed first. Use a query search when you want to find the most relevant search
       results. You cannot use **natural_language_query** and **query** at the same time.
     - parameter naturalLanguageQuery: A natural language query that returns relevant documents by utilizing training
       data and natural language understanding. You cannot use **natural_language_query** and **query** at the same
       time.
     - parameter passages: A passages query that returns the most relevant passages from the results.
     - parameter aggregation: An aggregation search that returns an exact answer by combining query search with
       filters. Useful for applications to build lists, tables, and time series. For a full list of possible
       aggregations, see the Query reference.
     - parameter count: Number of results to return.
     - parameter returnFields: A comma-separated list of the portion of the document hierarchy to return.
     - parameter offset: The number of query results to skip at the beginning. For example, if the total number of
       results that are returned is 10 and the offset is 8, it returns the last two results.
     - parameter sort: A comma-separated list of fields in the document to sort on. You can optionally specify a sort
       direction by prefixing the field with `-` for descending or `+` for ascending. Ascending is the default sort
       direction if no prefix is specified. This parameter cannot be used in the same query as the **bias** parameter.
     - parameter highlight: When true, a highlight field is returned for each result which contains the fields which
       match the query with `<em></em>` tags around the matching query terms.
     - parameter passagesFields: A comma-separated list of fields that passages are drawn from. If this parameter not
       specified, then all top-level fields are included.
     - parameter passagesCount: The maximum number of passages to return. The search returns fewer passages if the
       requested total is not found. The default is `10`. The maximum is `100`.
     - parameter passagesCharacters: The approximate number of characters that any one passage will have.
     - parameter deduplicate: When `true`, and used with a Watson Discovery News collection, duplicate results (based
       on the contents of the **title** field) are removed. Duplicate comparison is limited to the current query only;
       **offset** is not considered. This parameter is currently Beta functionality.
     - parameter deduplicateField: When specified, duplicate results based on the field specified are removed from the
       returned results. Duplicate comparison is limited to the current query only, **offset** is not considered. This
       parameter is currently Beta functionality.
     - parameter collectionIDs: A comma-separated list of collection IDs to be queried against. Required when querying
       multiple collections, invalid when performing a single collection query.
     - parameter similar: When `true`, results are returned based on their similarity to the document IDs specified in
       the **similar.document_ids** parameter.
     - parameter similarDocumentIDs: A comma-separated list of document IDs to find similar documents.
       **Tip:** Include the **natural_language_query** parameter to expand the scope of the document similarity search
       with the natural language query. Other query parameters, such as **filter** and **query**, are subsequently
       applied and reduce the scope.
     - parameter similarFields: A comma-separated list of field names that are used as a basis for comparison to
       identify similar documents. If not specified, the entire document is used for comparison.
     - parameter bias: Field which the returned results will be biased against. The specified field must be either a
       **date** or **number** format. When a **date** type field is specified returned results are biased towards field
       values closer to the current date. When a **number** type field is specified, returned results are biased towards
       higher field values. This parameter cannot be used in the same query as the **sort** parameter.
     - parameter loggingOptOut: If `true`, queries are not stored in the Discovery **Logs** endpoint.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func federatedQuery(
        environmentID: String,
        filter: String? = nil,
        query: String? = nil,
        naturalLanguageQuery: String? = nil,
        passages: Bool? = nil,
        aggregation: String? = nil,
        count: Int? = nil,
        returnFields: String? = nil,
        offset: Int? = nil,
        sort: String? = nil,
        highlight: Bool? = nil,
        passagesFields: String? = nil,
        passagesCount: Int? = nil,
        passagesCharacters: Int? = nil,
        deduplicate: Bool? = nil,
        deduplicateField: String? = nil,
        collectionIDs: String? = nil,
        similar: Bool? = nil,
        similarDocumentIDs: String? = nil,
        similarFields: String? = nil,
        bias: String? = nil,
        loggingOptOut: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<QueryResponse>?, WatsonError?) -> Void)
    {
        // construct body
        let federatedQueryRequest = QueryLarge(
            filter: filter,
            query: query,
            naturalLanguageQuery: naturalLanguageQuery,
            passages: passages,
            aggregation: aggregation,
            count: count,
            returnFields: returnFields,
            offset: offset,
            sort: sort,
            highlight: highlight,
            passagesFields: passagesFields,
            passagesCount: passagesCount,
            passagesCharacters: passagesCharacters,
            deduplicate: deduplicate,
            deduplicateField: deduplicateField,
            collectionIDs: collectionIDs,
            similar: similar,
            similarDocumentIDs: similarDocumentIDs,
            similarFields: similarFields,
            bias: bias)
        guard let body = try? JSON.encoder.encodeIfPresent(federatedQueryRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "federatedQuery")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let loggingOptOut = loggingOptOut {
            headerParameters["X-Watson-Logging-Opt-Out"] = "\(loggingOptOut)"
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/query"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Query multiple collection system notices.

     Queries for notices (errors or warnings) that might have been generated by the system. Notices are generated when
     ingesting documents and performing relevance training. See the [Discovery service
     documentation](https://cloud.ibm.com/docs/services/discovery?topic=discovery-query-concepts#query-concepts) for
     more details on the query language.

     - parameter environmentID: The ID of the environment.
     - parameter collectionIDs: A comma-separated list of collection IDs to be queried against.
     - parameter filter: A cacheable query that excludes documents that don't mention the query content. Filter
       searches are better for metadata-type searches and for assessing the concepts in the data set.
     - parameter query: A query search returns all documents in your data set with full enrichments and full text, but
       with the most relevant documents listed first. Use a query search when you want to find the most relevant search
       results. You cannot use **natural_language_query** and **query** at the same time.
     - parameter naturalLanguageQuery: A natural language query that returns relevant documents by utilizing training
       data and natural language understanding. You cannot use **natural_language_query** and **query** at the same
       time.
     - parameter aggregation: An aggregation search that returns an exact answer by combining query search with
       filters. Useful for applications to build lists, tables, and time series. For a full list of possible
       aggregations, see the Query reference.
     - parameter count: Number of results to return. The maximum for the **count** and **offset** values together in
       any one query is **10000**.
     - parameter returnFields: A comma-separated list of the portion of the document hierarchy to return.
     - parameter offset: The number of query results to skip at the beginning. For example, if the total number of
       results that are returned is 10 and the offset is 8, it returns the last two results. The maximum for the
       **count** and **offset** values together in any one query is **10000**.
     - parameter sort: A comma-separated list of fields in the document to sort on. You can optionally specify a sort
       direction by prefixing the field with `-` for descending or `+` for ascending. Ascending is the default sort
       direction if no prefix is specified.
     - parameter highlight: When true, a highlight field is returned for each result which contains the fields which
       match the query with `<em></em>` tags around the matching query terms.
     - parameter deduplicateField: When specified, duplicate results based on the field specified are removed from the
       returned results. Duplicate comparison is limited to the current query only, **offset** is not considered. This
       parameter is currently Beta functionality.
     - parameter similar: When `true`, results are returned based on their similarity to the document IDs specified in
       the **similar.document_ids** parameter.
     - parameter similarDocumentIDs: A comma-separated list of document IDs to find similar documents.
       **Tip:** Include the **natural_language_query** parameter to expand the scope of the document similarity search
       with the natural language query. Other query parameters, such as **filter** and **query**, are subsequently
       applied and reduce the scope.
     - parameter similarFields: A comma-separated list of field names that are used as a basis for comparison to
       identify similar documents. If not specified, the entire document is used for comparison.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func federatedQueryNotices(
        environmentID: String,
        collectionIDs: [String],
        filter: String? = nil,
        query: String? = nil,
        naturalLanguageQuery: String? = nil,
        aggregation: String? = nil,
        count: Int? = nil,
        returnFields: [String]? = nil,
        offset: Int? = nil,
        sort: [String]? = nil,
        highlight: Bool? = nil,
        deduplicateField: String? = nil,
        similar: Bool? = nil,
        similarDocumentIDs: [String]? = nil,
        similarFields: [String]? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<QueryNoticesResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "federatedQueryNotices")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        queryParameters.append(URLQueryItem(name: "collection_ids", value: collectionIDs.joined(separator: ",")))
        if let filter = filter {
            let queryParameter = URLQueryItem(name: "filter", value: filter)
            queryParameters.append(queryParameter)
        }
        if let query = query {
            let queryParameter = URLQueryItem(name: "query", value: query)
            queryParameters.append(queryParameter)
        }
        if let naturalLanguageQuery = naturalLanguageQuery {
            let queryParameter = URLQueryItem(name: "natural_language_query", value: naturalLanguageQuery)
            queryParameters.append(queryParameter)
        }
        if let aggregation = aggregation {
            let queryParameter = URLQueryItem(name: "aggregation", value: aggregation)
            queryParameters.append(queryParameter)
        }
        if let count = count {
            let queryParameter = URLQueryItem(name: "count", value: "\(count)")
            queryParameters.append(queryParameter)
        }
        if let returnFields = returnFields {
            let queryParameter = URLQueryItem(name: "return", value: returnFields.joined(separator: ","))
            queryParameters.append(queryParameter)
        }
        if let offset = offset {
            let queryParameter = URLQueryItem(name: "offset", value: "\(offset)")
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort.joined(separator: ","))
            queryParameters.append(queryParameter)
        }
        if let highlight = highlight {
            let queryParameter = URLQueryItem(name: "highlight", value: "\(highlight)")
            queryParameters.append(queryParameter)
        }
        if let deduplicateField = deduplicateField {
            let queryParameter = URLQueryItem(name: "deduplicate.field", value: deduplicateField)
            queryParameters.append(queryParameter)
        }
        if let similar = similar {
            let queryParameter = URLQueryItem(name: "similar", value: "\(similar)")
            queryParameters.append(queryParameter)
        }
        if let similarDocumentIDs = similarDocumentIDs {
            let queryParameter = URLQueryItem(name: "similar.document_ids", value: similarDocumentIDs.joined(separator: ","))
            queryParameters.append(queryParameter)
        }
        if let similarFields = similarFields {
            let queryParameter = URLQueryItem(name: "similar.fields", value: similarFields.joined(separator: ","))
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/environments/\(environmentID)/notices"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Knowledge Graph entity query.

     See the [Knowledge Graph documentation](https://cloud.ibm.com/docs/services/discovery?topic=discovery-kg#kg) for
     more details.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter feature: The entity query feature to perform. Supported features are `disambiguate` and
       `similar_entities`.
     - parameter entity: A text string that appears within the entity text field.
     - parameter context: Entity text to provide context for the queried entity and rank based on that association.
       For example, if you wanted to query the city of London in England your query would look for `London` with the
       context of `England`.
     - parameter count: The number of results to return. The default is `10`. The maximum is `1000`.
     - parameter evidenceCount: The number of evidence items to return for each result. The default is `0`. The
       maximum number of evidence items per query is 10,000.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func queryEntities(
        environmentID: String,
        collectionID: String,
        feature: String? = nil,
        entity: QueryEntitiesEntity? = nil,
        context: QueryEntitiesContext? = nil,
        count: Int? = nil,
        evidenceCount: Int? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<QueryEntitiesResponse>?, WatsonError?) -> Void)
    {
        // construct body
        let queryEntitiesRequest = QueryEntities(
            feature: feature,
            entity: entity,
            context: context,
            count: count,
            evidenceCount: evidenceCount)
        guard let body = try? JSON.encoder.encode(queryEntitiesRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "queryEntities")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/query_entities"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Knowledge Graph relationship query.

     See the [Knowledge Graph documentation](https://cloud.ibm.com/docs/services/discovery?topic=discovery-kg#kg) for
     more details.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter entities: An array of entities to find relationships for.
     - parameter context: Entity text to provide context for the queried entity and rank based on that association.
       For example, if you wanted to query the city of London in England your query would look for `London` with the
       context of `England`.
     - parameter sort: The sorting method for the relationships, can be `score` or `frequency`. `frequency` is the
       number of unique times each entity is identified. The default is `score`. This parameter cannot be used in the
       same query as the **bias** parameter.
     - parameter filter:
     - parameter count: The number of results to return. The default is `10`. The maximum is `1000`.
     - parameter evidenceCount: The number of evidence items to return for each result. The default is `0`. The
       maximum number of evidence items per query is 10,000.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func queryRelations(
        environmentID: String,
        collectionID: String,
        entities: [QueryRelationsEntity]? = nil,
        context: QueryEntitiesContext? = nil,
        sort: String? = nil,
        filter: QueryRelationsFilter? = nil,
        count: Int? = nil,
        evidenceCount: Int? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<QueryRelationsResponse>?, WatsonError?) -> Void)
    {
        // construct body
        let queryRelationsRequest = QueryRelations(
            entities: entities,
            context: context,
            sort: sort,
            filter: filter,
            count: count,
            evidenceCount: evidenceCount)
        guard let body = try? JSON.encoder.encode(queryRelationsRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "queryRelations")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/query_relations"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List training data.

     Lists the training data for the specified collection.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listTrainingData(
        environmentID: String,
        collectionID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TrainingDataSet>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listTrainingData")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/training_data"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Add query to training data.

     Adds a query to the training data for this collection. The query can contain a filter and natural language query.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter naturalLanguageQuery: The natural text query for the new training query.
     - parameter filter: The filter used on the collection before the **natural_language_query** is applied.
     - parameter examples: Array of training examples.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func addTrainingData(
        environmentID: String,
        collectionID: String,
        naturalLanguageQuery: String? = nil,
        filter: String? = nil,
        examples: [TrainingExample]? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TrainingQuery>?, WatsonError?) -> Void)
    {
        // construct body
        let addTrainingDataRequest = NewTrainingQuery(
            naturalLanguageQuery: naturalLanguageQuery,
            filter: filter,
            examples: examples)
        guard let body = try? JSON.encoder.encode(addTrainingDataRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "addTrainingData")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/training_data"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete all training data.

     Deletes all training data from a collection.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteAllTrainingData(
        environmentID: String,
        collectionID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteAllTrainingData")
        headerParameters.merge(sdkHeaders) { (_, new) in new }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/training_data"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     Get details about a query.

     Gets details for a specific training data query, including the query string and all examples.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter queryID: The ID of the query used for training.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getTrainingData(
        environmentID: String,
        collectionID: String,
        queryID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TrainingQuery>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getTrainingData")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/training_data/\(queryID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete a training data query.

     Removes the training data query and all associated examples from the training data set.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter queryID: The ID of the query used for training.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteTrainingData(
        environmentID: String,
        collectionID: String,
        queryID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteTrainingData")
        headerParameters.merge(sdkHeaders) { (_, new) in new }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/training_data/\(queryID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     List examples for a training data query.

     List all examples for this training data query.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter queryID: The ID of the query used for training.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listTrainingExamples(
        environmentID: String,
        collectionID: String,
        queryID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TrainingExampleList>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listTrainingExamples")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/training_data/\(queryID)/examples"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Add example to training data query.

     Adds a example to this training data query.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter queryID: The ID of the query used for training.
     - parameter documentID: The document ID associated with this training example.
     - parameter crossReference: The cross reference associated with this training example.
     - parameter relevance: The relevance of the training example.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createTrainingExample(
        environmentID: String,
        collectionID: String,
        queryID: String,
        documentID: String? = nil,
        crossReference: String? = nil,
        relevance: Int? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TrainingExample>?, WatsonError?) -> Void)
    {
        // construct body
        let createTrainingExampleRequest = TrainingExample(
            documentID: documentID,
            crossReference: crossReference,
            relevance: relevance)
        guard let body = try? JSON.encoder.encode(createTrainingExampleRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createTrainingExample")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/training_data/\(queryID)/examples"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete example for training data query.

     Deletes the example document with the given ID from the training data query.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter queryID: The ID of the query used for training.
     - parameter exampleID: The ID of the document as it is indexed.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteTrainingExample(
        environmentID: String,
        collectionID: String,
        queryID: String,
        exampleID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteTrainingExample")
        headerParameters.merge(sdkHeaders) { (_, new) in new }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/training_data/\(queryID)/examples/\(exampleID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     Change label or cross reference for example.

     Changes the label or cross reference query for this training data example.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter queryID: The ID of the query used for training.
     - parameter exampleID: The ID of the document as it is indexed.
     - parameter crossReference: The example to add.
     - parameter relevance: The relevance value for this example.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateTrainingExample(
        environmentID: String,
        collectionID: String,
        queryID: String,
        exampleID: String,
        crossReference: String? = nil,
        relevance: Int? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TrainingExample>?, WatsonError?) -> Void)
    {
        // construct body
        let updateTrainingExampleRequest = TrainingExamplePatch(
            crossReference: crossReference,
            relevance: relevance)
        guard let body = try? JSON.encoder.encode(updateTrainingExampleRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateTrainingExample")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/training_data/\(queryID)/examples/\(exampleID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "PUT",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Get details for training data example.

     Gets the details for this training example.

     - parameter environmentID: The ID of the environment.
     - parameter collectionID: The ID of the collection.
     - parameter queryID: The ID of the query used for training.
     - parameter exampleID: The ID of the document as it is indexed.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getTrainingExample(
        environmentID: String,
        collectionID: String,
        queryID: String,
        exampleID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TrainingExample>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getTrainingExample")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/collections/\(collectionID)/training_data/\(queryID)/examples/\(exampleID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete labeled data.

     Deletes all data associated with a specified customer ID. The method has no effect if no data is associated with
     the customer ID.
     You associate a customer ID with data by passing the **X-Watson-Metadata** header with a request that passes data.
     For more information about personal data and customer IDs, see [Information
     security](https://cloud.ibm.com/docs/services/discovery?topic=discovery-information-security#information-security).

     - parameter customerID: The customer ID for which all data is to be deleted.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteUserData(
        customerID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteUserData")
        headerParameters.merge(sdkHeaders) { (_, new) in new }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        queryParameters.append(URLQueryItem(name: "customer_id", value: customerID))

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceURL + "/v1/user_data",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     Create event.

     The **Events** API can be used to create log entries that are associated with specific queries. For example, you
     can record which documents in the results set were \"clicked\" by a user and when that click occured.

     - parameter type: The event type to be created.
     - parameter data: Query event data object.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createEvent(
        type: String,
        data: EventData,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<CreateEventResponse>?, WatsonError?) -> Void)
    {
        // construct body
        let createEventRequest = CreateEventObject(
            type: type,
            data: data)
        guard let body = try? JSON.encoder.encode(createEventRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createEvent")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v1/events",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Search the query and event log.

     Searches the query and event log to find query sessions that match the specified criteria. Searching the **logs**
     endpoint uses the standard Discovery query syntax for the parameters that are supported.

     - parameter filter: A cacheable query that excludes documents that don't mention the query content. Filter
       searches are better for metadata-type searches and for assessing the concepts in the data set.
     - parameter query: A query search returns all documents in your data set with full enrichments and full text, but
       with the most relevant documents listed first. Use a query search when you want to find the most relevant search
       results. You cannot use **natural_language_query** and **query** at the same time.
     - parameter count: Number of results to return. The maximum for the **count** and **offset** values together in
       any one query is **10000**.
     - parameter offset: The number of query results to skip at the beginning. For example, if the total number of
       results that are returned is 10 and the offset is 8, it returns the last two results. The maximum for the
       **count** and **offset** values together in any one query is **10000**.
     - parameter sort: A comma-separated list of fields in the document to sort on. You can optionally specify a sort
       direction by prefixing the field with `-` for descending or `+` for ascending. Ascending is the default sort
       direction if no prefix is specified.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func queryLog(
        filter: String? = nil,
        query: String? = nil,
        count: Int? = nil,
        offset: Int? = nil,
        sort: [String]? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<LogQueryResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "queryLog")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let filter = filter {
            let queryParameter = URLQueryItem(name: "filter", value: filter)
            queryParameters.append(queryParameter)
        }
        if let query = query {
            let queryParameter = URLQueryItem(name: "query", value: query)
            queryParameters.append(queryParameter)
        }
        if let count = count {
            let queryParameter = URLQueryItem(name: "count", value: "\(count)")
            queryParameters.append(queryParameter)
        }
        if let offset = offset {
            let queryParameter = URLQueryItem(name: "offset", value: "\(offset)")
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort.joined(separator: ","))
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + "/v1/logs",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Number of queries over time.

     Total number of queries using the **natural_language_query** parameter over a specific time window.

     - parameter startTime: Metric is computed from data recorded after this timestamp; must be in
       `YYYY-MM-DDThh:mm:ssZ` format.
     - parameter endTime: Metric is computed from data recorded before this timestamp; must be in
       `YYYY-MM-DDThh:mm:ssZ` format.
     - parameter resultType: The type of result to consider when calculating the metric.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getMetricsQuery(
        startTime: Date? = nil,
        endTime: Date? = nil,
        resultType: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<MetricResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getMetricsQuery")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let startTime = startTime {
            let queryParameter = URLQueryItem(name: "start_time", value: "\(startTime)")
            queryParameters.append(queryParameter)
        }
        if let endTime = endTime {
            let queryParameter = URLQueryItem(name: "end_time", value: "\(endTime)")
            queryParameters.append(queryParameter)
        }
        if let resultType = resultType {
            let queryParameter = URLQueryItem(name: "result_type", value: resultType)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + "/v1/metrics/number_of_queries",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Number of queries with an event over time.

     Total number of queries using the **natural_language_query** parameter that have a corresponding \"click\" event
     over a specified time window. This metric requires having integrated event tracking in your application using the
     **Events** API.

     - parameter startTime: Metric is computed from data recorded after this timestamp; must be in
       `YYYY-MM-DDThh:mm:ssZ` format.
     - parameter endTime: Metric is computed from data recorded before this timestamp; must be in
       `YYYY-MM-DDThh:mm:ssZ` format.
     - parameter resultType: The type of result to consider when calculating the metric.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getMetricsQueryEvent(
        startTime: Date? = nil,
        endTime: Date? = nil,
        resultType: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<MetricResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getMetricsQueryEvent")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let startTime = startTime {
            let queryParameter = URLQueryItem(name: "start_time", value: "\(startTime)")
            queryParameters.append(queryParameter)
        }
        if let endTime = endTime {
            let queryParameter = URLQueryItem(name: "end_time", value: "\(endTime)")
            queryParameters.append(queryParameter)
        }
        if let resultType = resultType {
            let queryParameter = URLQueryItem(name: "result_type", value: resultType)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + "/v1/metrics/number_of_queries_with_event",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Number of queries with no search results over time.

     Total number of queries using the **natural_language_query** parameter that have no results returned over a
     specified time window.

     - parameter startTime: Metric is computed from data recorded after this timestamp; must be in
       `YYYY-MM-DDThh:mm:ssZ` format.
     - parameter endTime: Metric is computed from data recorded before this timestamp; must be in
       `YYYY-MM-DDThh:mm:ssZ` format.
     - parameter resultType: The type of result to consider when calculating the metric.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getMetricsQueryNoResults(
        startTime: Date? = nil,
        endTime: Date? = nil,
        resultType: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<MetricResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getMetricsQueryNoResults")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let startTime = startTime {
            let queryParameter = URLQueryItem(name: "start_time", value: "\(startTime)")
            queryParameters.append(queryParameter)
        }
        if let endTime = endTime {
            let queryParameter = URLQueryItem(name: "end_time", value: "\(endTime)")
            queryParameters.append(queryParameter)
        }
        if let resultType = resultType {
            let queryParameter = URLQueryItem(name: "result_type", value: resultType)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + "/v1/metrics/number_of_queries_with_no_search_results",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Percentage of queries with an associated event.

     The percentage of queries using the **natural_language_query** parameter that have a corresponding \"click\" event
     over a specified time window.  This metric requires having integrated event tracking in your application using the
     **Events** API.

     - parameter startTime: Metric is computed from data recorded after this timestamp; must be in
       `YYYY-MM-DDThh:mm:ssZ` format.
     - parameter endTime: Metric is computed from data recorded before this timestamp; must be in
       `YYYY-MM-DDThh:mm:ssZ` format.
     - parameter resultType: The type of result to consider when calculating the metric.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getMetricsEventRate(
        startTime: Date? = nil,
        endTime: Date? = nil,
        resultType: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<MetricResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getMetricsEventRate")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let startTime = startTime {
            let queryParameter = URLQueryItem(name: "start_time", value: "\(startTime)")
            queryParameters.append(queryParameter)
        }
        if let endTime = endTime {
            let queryParameter = URLQueryItem(name: "end_time", value: "\(endTime)")
            queryParameters.append(queryParameter)
        }
        if let resultType = resultType {
            let queryParameter = URLQueryItem(name: "result_type", value: resultType)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + "/v1/metrics/event_rate",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Most frequent query tokens with an event.

     The most frequent query tokens parsed from the **natural_language_query** parameter and their corresponding
     \"click\" event rate within the recording period (queries and events are stored for 30 days). A query token is an
     individual word or unigram within the query string.

     - parameter count: Number of results to return. The maximum for the **count** and **offset** values together in
       any one query is **10000**.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getMetricsQueryTokenEvent(
        count: Int? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<MetricTokenResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getMetricsQueryTokenEvent")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let count = count {
            let queryParameter = URLQueryItem(name: "count", value: "\(count)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + "/v1/metrics/top_query_tokens_with_event_rate",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List credentials.

     List all the source credentials that have been created for this service instance.
      **Note:**  All credentials are sent over an encrypted connection and encrypted at rest.

     - parameter environmentID: The ID of the environment.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listCredentials(
        environmentID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<CredentialsList>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listCredentials")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/credentials"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Create credentials.

     Creates a set of credentials to connect to a remote source. Created credentials are used in a configuration to
     associate a collection with the remote source.
     **Note:** All credentials are sent over an encrypted connection and encrypted at rest.

     - parameter environmentID: The ID of the environment.
     - parameter sourceType: The source that this credentials object connects to.
       -  `box` indicates the credentials are used to connect an instance of Enterprise Box.
       -  `salesforce` indicates the credentials are used to connect to Salesforce.
       -  `sharepoint` indicates the credentials are used to connect to Microsoft SharePoint Online.
       -  `web_crawl` indicates the credentials are used to perform a web crawl.
       =  `cloud_object_storage` indicates the credentials are used to connect to an IBM Cloud Object Store.
     - parameter credentialDetails: Object containing details of the stored credentials.
       Obtain credentials for your source from the administrator of the source.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createCredentials(
        environmentID: String,
        sourceType: String? = nil,
        credentialDetails: CredentialDetails? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Credentials>?, WatsonError?) -> Void)
    {
        // construct body
        let createCredentialsRequest = Credentials(
            sourceType: sourceType,
            credentialDetails: credentialDetails)
        guard let body = try? JSON.encoder.encode(createCredentialsRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createCredentials")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/credentials"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     View Credentials.

     Returns details about the specified credentials.
      **Note:** Secure credential information such as a password or SSH key is never returned and must be obtained from
     the source system.

     - parameter environmentID: The ID of the environment.
     - parameter credentialID: The unique identifier for a set of source credentials.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getCredentials(
        environmentID: String,
        credentialID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Credentials>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getCredentials")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/credentials/\(credentialID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Update credentials.

     Updates an existing set of source credentials.
     **Note:** All credentials are sent over an encrypted connection and encrypted at rest.

     - parameter environmentID: The ID of the environment.
     - parameter credentialID: The unique identifier for a set of source credentials.
     - parameter sourceType: The source that this credentials object connects to.
       -  `box` indicates the credentials are used to connect an instance of Enterprise Box.
       -  `salesforce` indicates the credentials are used to connect to Salesforce.
       -  `sharepoint` indicates the credentials are used to connect to Microsoft SharePoint Online.
       -  `web_crawl` indicates the credentials are used to perform a web crawl.
       =  `cloud_object_storage` indicates the credentials are used to connect to an IBM Cloud Object Store.
     - parameter credentialDetails: Object containing details of the stored credentials.
       Obtain credentials for your source from the administrator of the source.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateCredentials(
        environmentID: String,
        credentialID: String,
        sourceType: String? = nil,
        credentialDetails: CredentialDetails? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Credentials>?, WatsonError?) -> Void)
    {
        // construct body
        let updateCredentialsRequest = Credentials(
            sourceType: sourceType,
            credentialDetails: credentialDetails)
        guard let body = try? JSON.encoder.encode(updateCredentialsRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateCredentials")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/credentials/\(credentialID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "PUT",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete credentials.

     Deletes a set of stored credentials from your Discovery instance.

     - parameter environmentID: The ID of the environment.
     - parameter credentialID: The unique identifier for a set of source credentials.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteCredentials(
        environmentID: String,
        credentialID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DeleteCredentials>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteCredentials")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/credentials/\(credentialID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List Gateways.

     List the currently configured gateways.

     - parameter environmentID: The ID of the environment.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listGateways(
        environmentID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<GatewayList>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listGateways")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/gateways"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Create Gateway.

     Create a gateway configuration to use with a remotely installed gateway.

     - parameter environmentID: The ID of the environment.
     - parameter name: User-defined name.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createGateway(
        environmentID: String,
        name: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Gateway>?, WatsonError?) -> Void)
    {
        // construct body
        let createGatewayRequest = GatewayName(
            name: name)
        guard let body = try? JSON.encoder.encodeIfPresent(createGatewayRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createGateway")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/gateways"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List Gateway Details.

     List information about the specified gateway.

     - parameter environmentID: The ID of the environment.
     - parameter gatewayID: The requested gateway ID.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getGateway(
        environmentID: String,
        gatewayID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Gateway>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getGateway")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/gateways/\(gatewayID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete Gateway.

     Delete the specified gateway configuration.

     - parameter environmentID: The ID of the environment.
     - parameter gatewayID: The requested gateway ID.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteGateway(
        environmentID: String,
        gatewayID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<GatewayDelete>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteGateway")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/environments/\(environmentID)/gateways/\(gatewayID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

}
