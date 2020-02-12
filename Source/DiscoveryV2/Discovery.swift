/**
 * (C) Copyright IBM Corp. 2019, 2020.
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
import IBMSwiftSDKCore

/**
 IBM Watson&trade; Discovery for IBM Cloud Pak for Data is a cognitive search and content analytics engine that you can
 add to applications to identify patterns, trends and actionable insights to drive better decision-making. Securely
 unify structured and unstructured data with pre-enriched content, and use a simplified query language to eliminate the
 need for manual filtering of results.
 */
public class Discovery {

    /// The base URL to use when contacting the service.
    public var serviceURL: String? = nil

    /// Service identifiers
    internal let serviceName = "Discovery"
    internal let serviceVersion = "v2"
    internal let serviceSdkName = "discovery"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    var session = URLSession(configuration: URLSessionConfiguration.default)
    public let authenticator: Authenticator
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
    public init(version: String) throws {
        self.version = version
        
        let authenticator = try ConfigBasedAuthenticatorFactory.getAuthenticator(credentialPrefix: serviceSdkName)
        self.authenticator = authenticator

        if let serviceURL = CredentialUtils.getServiceURL(credentialPrefix: serviceSdkName) {
            self.serviceURL = serviceURL
        }

        RestRequest.userAgent = Shared.userAgent
    }
    #endif

    /**
     Create a `Discovery` object.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     - parameter authenticator: The Authenticator object used to authenticate requests to the service
     */
    public init(version: String, authenticator: Authenticator) {
        self.version = version
        self.authenticator = authenticator
        RestRequest.userAgent = Shared.userAgent
    }

    #if !os(Linux)
    /**
     Allow network requests to a server without verification of the server certificate.
     **IMPORTANT**: This should ONLY be used if truly intended, as it is unsafe otherwise.
     */
    public func disableSSLVerification() {
        session = InsecureConnection.session()
    }
    #endif

    /**
     Use the HTTP response and data received by the IBM Watson Discovery for IBM Cloud Pak for Data service to extract
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
     List collections.

     Lists existing collections for the specified project.

     - parameter projectID: The ID of the project. This information can be found from the deploy page of the Discovery
       administrative tooling.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listCollections(
        projectID: String,
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

        // construct REST request
        let path = "/v2/projects/\(projectID)/collections"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Query a project.

     By using this method, you can construct queries. For details, see the [Discovery
     documentation](https://cloud.ibm.com/docs/services/discovery-data?topic=discovery-data-query-concepts).

     - parameter projectID: The ID of the project. This information can be found from the deploy page of the Discovery
       administrative tooling.
     - parameter collectionIDs: A comma-separated list of collection IDs to be queried against.
     - parameter filter: A cacheable query that excludes documents that don't mention the query content. Filter
       searches are better for metadata-type searches and for assessing the concepts in the data set.
     - parameter query: A query search returns all documents in your data set with full enrichments and full text, but
       with the most relevant documents listed first. Use a query search when you want to find the most relevant search
       results.
     - parameter naturalLanguageQuery: A natural language query that returns relevant documents by utilizing training
       data and natural language understanding.
     - parameter aggregation: An aggregation search that returns an exact answer by combining query search with
       filters. Useful for applications to build lists, tables, and time series. For a full list of possible
       aggregations, see the Query reference.
     - parameter count: Number of results to return.
     - parameter `return`: A list of the fields in the document hierarchy to return. If this parameter not specified,
       then all top-level fields are returned.
     - parameter offset: The number of query results to skip at the beginning. For example, if the total number of
       results that are returned is 10 and the offset is 8, it returns the last two results.
     - parameter sort: A comma-separated list of fields in the document to sort on. You can optionally specify a sort
       direction by prefixing the field with `-` for descending or `+` for ascending. Ascending is the default sort
       direction if no prefix is specified. This parameter cannot be used in the same query as the **bias** parameter.
     - parameter highlight: When `true`, a highlight field is returned for each result which contains the fields which
       match the query with `<em></em>` tags around the matching query terms.
     - parameter spellingSuggestions: When `true` and the **natural_language_query** parameter is used, the
       **natural_language_query** parameter is spell checked. The most likely correction is returned in the
       **suggested_query** field of the response (if one exists).
     - parameter tableResults: Configuration for table retrieval.
     - parameter suggestedRefinements: Configuration for suggested refinements.
     - parameter passages: Configuration for passage retrieval.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func query(
        projectID: String,
        collectionIDs: [String]? = nil,
        filter: String? = nil,
        query: String? = nil,
        naturalLanguageQuery: String? = nil,
        aggregation: String? = nil,
        count: Int? = nil,
        `return`: [String]? = nil,
        offset: Int? = nil,
        sort: String? = nil,
        highlight: Bool? = nil,
        spellingSuggestions: Bool? = nil,
        tableResults: QueryLargeTableResults? = nil,
        suggestedRefinements: QueryLargeSuggestedRefinements? = nil,
        passages: QueryLargePassages? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<QueryResponse>?, WatsonError?) -> Void)
    {
        // construct body
        let queryRequest = QueryLarge(
            collectionIDs: collectionIDs,
            filter: filter,
            query: query,
            naturalLanguageQuery: naturalLanguageQuery,
            aggregation: aggregation,
            count: count,
            `return`: `return`,
            offset: offset,
            sort: sort,
            highlight: highlight,
            spellingSuggestions: spellingSuggestions,
            tableResults: tableResults,
            suggestedRefinements: suggestedRefinements,
            passages: passages)
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

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/query"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Get Autocomplete Suggestions.

     Returns completion query suggestions for the specified prefix.

     - parameter projectID: The ID of the project. This information can be found from the deploy page of the Discovery
       administrative tooling.
     - parameter `prefix`: The prefix to use for autocompletion. For example, the prefix `Ho` could autocomplete to
       `Hot`, `Housing`, or `How do I upgrade`. Possible completions are.
     - parameter collectionIDs: Comma separated list of the collection IDs. If this parameter is not specified, all
       collections in the project are used.
     - parameter field: The field in the result documents that autocompletion suggestions are identified from.
     - parameter count: The number of autocompletion suggestions to return.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getAutocompletion(
        projectID: String,
        `prefix`: String,
        collectionIDs: [String]? = nil,
        field: String? = nil,
        count: Int? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Completions>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getAutocompletion")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        queryParameters.append(URLQueryItem(name: "prefix", value: `prefix`))
        if let collectionIDs = collectionIDs {
            let queryParameter = URLQueryItem(name: "collection_ids", value: collectionIDs.joined(separator: ","))
            queryParameters.append(queryParameter)
        }
        if let field = field {
            let queryParameter = URLQueryItem(name: "field", value: field)
            queryParameters.append(queryParameter)
        }
        if let count = count {
            let queryParameter = URLQueryItem(name: "count", value: "\(count)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v2/projects/\(projectID)/autocompletion"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Query system notices.

     Queries for notices (errors or warnings) that might have been generated by the system. Notices are generated when
     ingesting documents and performing relevance training.

     - parameter projectID: The ID of the project. This information can be found from the deploy page of the Discovery
       administrative tooling.
     - parameter filter: A cacheable query that excludes documents that don't mention the query content. Filter
       searches are better for metadata-type searches and for assessing the concepts in the data set.
     - parameter query: A query search returns all documents in your data set with full enrichments and full text, but
       with the most relevant documents listed first.
     - parameter naturalLanguageQuery: A natural language query that returns relevant documents by utilizing training
       data and natural language understanding.
     - parameter count: Number of results to return. The maximum for the **count** and **offset** values together in
       any one query is **10000**.
     - parameter offset: The number of query results to skip at the beginning. For example, if the total number of
       results that are returned is 10 and the offset is 8, it returns the last two results. The maximum for the
       **count** and **offset** values together in any one query is **10000**.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func queryNotices(
        projectID: String,
        filter: String? = nil,
        query: String? = nil,
        naturalLanguageQuery: String? = nil,
        count: Int? = nil,
        offset: Int? = nil,
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
        if let count = count {
            let queryParameter = URLQueryItem(name: "count", value: "\(count)")
            queryParameters.append(queryParameter)
        }
        if let offset = offset {
            let queryParameter = URLQueryItem(name: "offset", value: "\(offset)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v2/projects/\(projectID)/notices"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List fields.

     Gets a list of the unique fields (and their types) stored in the the specified collections.

     - parameter projectID: The ID of the project. This information can be found from the deploy page of the Discovery
       administrative tooling.
     - parameter collectionIDs: Comma separated list of the collection IDs. If this parameter is not specified, all
       collections in the project are used.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listFields(
        projectID: String,
        collectionIDs: [String]? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ListFieldsResponse>?, WatsonError?) -> Void)
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
        if let collectionIDs = collectionIDs {
            let queryParameter = URLQueryItem(name: "collection_ids", value: collectionIDs.joined(separator: ","))
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v2/projects/\(projectID)/fields"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Configuration settings for components.

     Returns default configuration settings for components.

     - parameter projectID: The ID of the project. This information can be found from the deploy page of the Discovery
       administrative tooling.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getComponentSettings(
        projectID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ComponentSettingsResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getComponentSettings")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/component_settings"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Add a document.

     Add a document to a collection with optional metadata.
      Returns immediately after the system has accepted the document for processing.
       * The user must provide document content, metadata, or both. If the request is missing both document content and
     metadata, it is rejected.
       * The user can set the **Content-Type** parameter on the **file** part to indicate the media type of the
     document. If the **Content-Type** parameter is missing or is one of the generic media types (for example,
     `application/octet-stream`), then the service attempts to automatically detect the document's media type.
       * The following field names are reserved and will be filtered out if present after normalization: `id`, `score`,
     `highlight`, and any field with the prefix of: `_`, `+`, or `-`
       * Fields with empty name values after normalization are filtered out before indexing.
       * Fields containing the following characters after normalization are filtered out before indexing: `#` and `,`
       If the document is uploaded to a collection that has it's data shared with another collection, the
     **X-Watson-Discovery-Force** header must be set to `true`.
      **Note:** Documents can be added with a specific **document_id** by using the
     **_/v2/projects/{project_id}/collections/{collection_id}/documents** method.
     **Note:** This operation only works on collections created to accept direct file uploads. It cannot be used to
     modify a collection that connects to an external source such as Microsoft SharePoint.

     - parameter projectID: The ID of the project. This information can be found from the deploy page of the Discovery
       administrative tooling.
     - parameter collectionID: The ID of the collection.
     - parameter file: The content of the document to ingest. The maximum supported file size when adding a file to a
       collection is 50 megabytes, the maximum supported file size when testing a configuration is 1 megabyte. Files
       larger than the supported size are rejected.
     - parameter filename: The filename for file.
     - parameter fileContentType: The content type of file.
     - parameter metadata: The maximum supported metadata file size is 1 MB. Metadata parts larger than 1 MB are
       rejected. Example:  ``` {
         "Creator": "Johnny Appleseed",
         "Subject": "Apples"
       } ```.
     - parameter xWatsonDiscoveryForce: When `true`, the uploaded document is added to the collection even if the data
       for that collection is shared with other collections.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func addDocument(
        projectID: String,
        collectionID: String,
        file: Data? = nil,
        filename: String? = nil,
        fileContentType: String? = nil,
        metadata: String? = nil,
        xWatsonDiscoveryForce: Bool? = nil,
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
        if let xWatsonDiscoveryForce = xWatsonDiscoveryForce {
            headerParameters["X-Watson-Discovery-Force"] = "\(xWatsonDiscoveryForce)"
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/collections/\(collectionID)/documents"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Update a document.

     Replace an existing document or add a document with a specified **document_id**. Starts ingesting a document with
     optional metadata.
     If the document is uploaded to a collection that has it's data shared with another collection, the
     **X-Watson-Discovery-Force** header must be set to `true`.
     **Note:** When uploading a new document with this method it automatically replaces any document stored with the
     same **document_id** if it exists.
     **Note:** This operation only works on collections created to accept direct file uploads. It cannot be used to
     modify a collection that connects to an external source such as Microsoft SharePoint.

     - parameter projectID: The ID of the project. This information can be found from the deploy page of the Discovery
       administrative tooling.
     - parameter collectionID: The ID of the collection.
     - parameter documentID: The ID of the document.
     - parameter file: The content of the document to ingest. The maximum supported file size when adding a file to a
       collection is 50 megabytes, the maximum supported file size when testing a configuration is 1 megabyte. Files
       larger than the supported size are rejected.
     - parameter filename: The filename for file.
     - parameter fileContentType: The content type of file.
     - parameter metadata: The maximum supported metadata file size is 1 MB. Metadata parts larger than 1 MB are
       rejected. Example:  ``` {
         "Creator": "Johnny Appleseed",
         "Subject": "Apples"
       } ```.
     - parameter xWatsonDiscoveryForce: When `true`, the uploaded document is added to the collection even if the data
       for that collection is shared with other collections.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateDocument(
        projectID: String,
        collectionID: String,
        documentID: String,
        file: Data? = nil,
        filename: String? = nil,
        fileContentType: String? = nil,
        metadata: String? = nil,
        xWatsonDiscoveryForce: Bool? = nil,
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
        if let xWatsonDiscoveryForce = xWatsonDiscoveryForce {
            headerParameters["X-Watson-Discovery-Force"] = "\(xWatsonDiscoveryForce)"
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/collections/\(collectionID)/documents/\(documentID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
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
     **Note:** This operation only works on collections created to accept direct file uploads. It cannot be used to
     modify a collection that connects to an external source such as Microsoft SharePoint.

     - parameter projectID: The ID of the project. This information can be found from the deploy page of the Discovery
       administrative tooling.
     - parameter collectionID: The ID of the collection.
     - parameter documentID: The ID of the document.
     - parameter xWatsonDiscoveryForce: When `true`, the uploaded document is added to the collection even if the data
       for that collection is shared with other collections.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteDocument(
        projectID: String,
        collectionID: String,
        documentID: String,
        xWatsonDiscoveryForce: Bool? = nil,
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
        if let xWatsonDiscoveryForce = xWatsonDiscoveryForce {
            headerParameters["X-Watson-Discovery-Force"] = "\(xWatsonDiscoveryForce)"
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/collections/\(collectionID)/documents/\(documentID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List training queries.

     List the training queries for the specified project.

     - parameter projectID: The ID of the project. This information can be found from the deploy page of the Discovery
       administrative tooling.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listTrainingQueries(
        projectID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TrainingQuerySet>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listTrainingQueries")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/training_data/queries"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete training queries.

     Removes all training queries for the specified project.

     - parameter projectID: The ID of the project. This information can be found from the deploy page of the Discovery
       administrative tooling.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteTrainingQueries(
        projectID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteTrainingQueries")
        headerParameters.merge(sdkHeaders) { (_, new) in new }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/training_data/queries"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     Create training query.

     Add a query to the training data for this project. The query can contain a filter and natural language query.

     - parameter projectID: The ID of the project. This information can be found from the deploy page of the Discovery
       administrative tooling.
     - parameter naturalLanguageQuery: The natural text query for the training query.
     - parameter examples: Array of training examples.
     - parameter filter: The filter used on the collection before the **natural_language_query** is applied.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createTrainingQuery(
        projectID: String,
        naturalLanguageQuery: String,
        examples: [TrainingExample],
        filter: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TrainingQuery>?, WatsonError?) -> Void)
    {
        // construct body
        let createTrainingQueryRequest = TrainingQuery(
            naturalLanguageQuery: naturalLanguageQuery,
            examples: examples,
            filter: filter)
        guard let body = try? JSON.encoder.encode(createTrainingQueryRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createTrainingQuery")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/training_data/queries"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Get a training data query.

     Get details for a specific training data query, including the query string and all examples.

     - parameter projectID: The ID of the project. This information can be found from the deploy page of the Discovery
       administrative tooling.
     - parameter queryID: The ID of the query used for training.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getTrainingQuery(
        projectID: String,
        queryID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TrainingQuery>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getTrainingQuery")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/training_data/queries/\(queryID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Update a training query.

     Updates an existing training query and it's examples.

     - parameter projectID: The ID of the project. This information can be found from the deploy page of the Discovery
       administrative tooling.
     - parameter queryID: The ID of the query used for training.
     - parameter naturalLanguageQuery: The natural text query for the training query.
     - parameter examples: Array of training examples.
     - parameter filter: The filter used on the collection before the **natural_language_query** is applied.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateTrainingQuery(
        projectID: String,
        queryID: String,
        naturalLanguageQuery: String,
        examples: [TrainingExample],
        filter: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TrainingQuery>?, WatsonError?) -> Void)
    {
        // construct body
        let updateTrainingQueryRequest = TrainingQuery(
            naturalLanguageQuery: naturalLanguageQuery,
            examples: examples,
            filter: filter)
        guard let body = try? JSON.encoder.encode(updateTrainingQueryRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateTrainingQuery")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/training_data/queries/\(queryID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

}
