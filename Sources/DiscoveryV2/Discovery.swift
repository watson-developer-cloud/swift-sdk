/**
 * (C) Copyright IBM Corp. 2022.
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

/**
 * IBM OpenAPI SDK Code Generator Version: 3.46.0-a4e29da0-20220224-210428
 **/

// swiftlint:disable file_length

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import IBMSwiftSDKCore

public typealias WatsonError = RestError
public typealias WatsonResponse = RestResponse
/**
 IBM Watson&trade; Discovery is a cognitive search and content analytics engine that you can add to applications to
 identify patterns, trends and actionable insights to drive better decision-making. Securely unify structured and
 unstructured data with pre-enriched content, and use a simplified query language to eliminate the need for manual
 filtering of results.
 */
public class Discovery {

    /// The base URL to use when contacting the service.
    public var serviceURL: String? = "https://api.us-south.discovery.watson.cloud.ibm.com"

    /// Release date of the version of the API you want to use. Specify dates in YYYY-MM-DD format. The current version
    /// is `2020-08-30`.
    public var version: String

    /// Service identifiers
    public static let defaultServiceName = "discovery"
    // Service info for SDK headers
    internal let serviceName = defaultServiceName
    internal let serviceVersion = "v2"
    internal let serviceSdkName = "discovery"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    var session = URLSession(configuration: URLSessionConfiguration.default)
    public let authenticator: Authenticator

    #if os(Linux)
    /**
     Create a `Discovery` object.

     If an authenticator is not supplied, the initializer will retrieve credentials from the environment or
     a local credentials file and construct an appropriate authenticator using these credentials.
     The credentials file can be downloaded from your service instance on IBM Cloud as ibm-credentials.env.
     Make sure to add the credentials file to your project so that it can be loaded at runtime.

     If an authenticator is not supplied and credentials are not available in the environment or a local
     credentials file, initialization will fail by throwing an exception.
     In that case, try another initializer that directly passes in the credentials.

     - parameter version: Release date of the version of the API you want to use. Specify dates in YYYY-MM-DD format.
       The current version is `2020-08-30`.
     - parameter authenticator: The Authenticator object used to authenticate requests to the service
     - serviceName: String = defaultServiceName
     */
    public init(version: String, authenticator: Authenticator? = nil, serviceName: String = defaultServiceName) throws {
        self.version = version
        self.authenticator = try authenticator ?? ConfigBasedAuthenticatorFactory.getAuthenticator(credentialPrefix: serviceName)
        if let serviceURL = CredentialUtils.getServiceURL(credentialPrefix: serviceName) {
            self.serviceURL = serviceURL
        }
        RestRequest.userAgent = Shared.userAgent
    }
    #else
    /**
     Create a `Discovery` object.

     - parameter version: Release date of the version of the API you want to use. Specify dates in YYYY-MM-DD format.
       The current version is `2020-08-30`.
     - parameter authenticator: The Authenticator object used to authenticate requests to the service
     */
    public init(version: String, authenticator: Authenticator) {
        self.version = version
        self.authenticator = authenticator
        RestRequest.userAgent = Shared.userAgent
    }
    #endif

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
     Use the HTTP response and data received by the Discovery v2 service to extract
     information about the error that occurred.

     - parameter data: Raw data returned by the service that may represent an error.
     - parameter response: the URL response returned by the service.
     */
    func errorResponseDecoder(data: Data, response: HTTPURLResponse) -> RestError {

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

        return RestError.http(statusCode: statusCode, message: errorMessage, metadata: metadata)
    }

    /**
     List collections.

     Lists existing collections for the specified project.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listCollections")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/collections"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     Create a collection.

     Create a new collection in the specified project.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter name: The name of the collection.
     - parameter description: A description of the collection.
     - parameter language: The language of the collection.
     - parameter enrichments: An array of enrichments that are applied to this collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createCollection(
        projectID: String,
        name: String,
        description: String? = nil,
        language: String? = nil,
        enrichments: [CollectionEnrichment]? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<CollectionDetails>?, WatsonError?) -> Void)
    {
        // construct body
        let createCollectionRequest = CreateCollectionRequest(
            name: name,
            description: description,
            language: language,
            enrichments: enrichments)
        guard let body = try? JSON.encoder.encode(createCollectionRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createCollection")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/collections"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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

    // Private struct for the createCollection request body
    private struct CreateCollectionRequest: Encodable {
        // swiftlint:disable identifier_name
        let name: String
        let description: String?
        let language: String?
        let enrichments: [CollectionEnrichment]?
        // swiftlint:enable identifier_name
    }

    /**
     Get collection.

     Get details about the specified collection.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter collectionID: The ID of the collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getCollection(
        projectID: String,
        collectionID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<CollectionDetails>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getCollection")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/collections/\(collectionID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     Update a collection.

     Updates the specified collection's name, description, and enrichments.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter collectionID: The ID of the collection.
     - parameter name: The name of the collection.
     - parameter description: A description of the collection.
     - parameter enrichments: An array of enrichments that are applied to this collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateCollection(
        projectID: String,
        collectionID: String,
        name: String? = nil,
        description: String? = nil,
        enrichments: [CollectionEnrichment]? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<CollectionDetails>?, WatsonError?) -> Void)
    {
        // construct body
        let updateCollectionRequest = UpdateCollectionRequest(
            name: name,
            description: description,
            enrichments: enrichments)
        guard let body = try? JSON.encoder.encode(updateCollectionRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateCollection")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/collections/\(collectionID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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

    // Private struct for the updateCollection request body
    private struct UpdateCollectionRequest: Encodable {
        // swiftlint:disable identifier_name
        let name: String?
        let description: String?
        let enrichments: [CollectionEnrichment]?
        // swiftlint:enable identifier_name
    }

    /**
     Delete a collection.

     Deletes the specified collection from the project. All documents stored in the specified collection and not shared
     is also deleted.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter collectionID: The ID of the collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteCollection(
        projectID: String,
        collectionID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteCollection")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/collections/\(collectionID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     Query a project.

     Search your data by submitting queries that are written in natural language or formatted in the Discovery Query
     Language. For more information, see the [Discovery
     documentation](https://cloud.ibm.com/docs/discovery-data?topic=discovery-data-query-concepts). The default query
     parameters differ by project type. For more information about the project default settings, see the [Discovery
     documentation](https://cloud.ibm.com/docs/discovery-data?topic=discovery-data-query-defaults). See [the Projects
     API documentation](#create-project) for details about how to set custom default query settings.
     The length of the UTF-8 encoding of the POST body cannot exceed 10,000 bytes, which is roughly equivalent to 10,000
     characters in English.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter collectionIDs: A comma-separated list of collection IDs to be queried against.
     - parameter filter: Searches for documents that match the Discovery Query Language criteria that is specified as
       input. Filter calls are cached and are faster than query calls because the results are not ordered by relevance.
       When used with the `aggregation`, `query`, or `natural_language_query` parameters, the `filter` parameter runs
       first. This parameter is useful for limiting results to those that contain specific metadata values.
     - parameter query: A query search that is written in the Discovery Query Language and returns all matching
       documents in your data set with full enrichments and full text, and with the most relevant documents listed
       first. Use a query search when you want to find the most relevant search results.
     - parameter naturalLanguageQuery: A natural language query that returns relevant documents by using training data
       and natural language understanding.
     - parameter aggregation: An aggregation search that returns an exact answer by combining query search with
       filters. Useful for applications to build lists, tables, and time series. For more information about the
       supported types of aggregations, see the [Discovery
       documentation](https://cloud.ibm.com/docs/discovery-data?topic=discovery-data-query-aggregations).
     - parameter count: Number of results to return.
     - parameter `return`: A list of the fields in the document hierarchy to return. If this parameter is an empty
       list, then all fields are returned.
     - parameter offset: The number of query results to skip at the beginning. For example, if the total number of
       results that are returned is 10 and the offset is 8, it returns the last two results.
     - parameter sort: A comma-separated list of fields in the document to sort on. You can optionally specify a sort
       direction by prefixing the field with `-` for descending or `+` for ascending. Ascending is the default sort
       direction if no prefix is specified.
     - parameter highlight: When `true`, a highlight field is returned for each result that contains fields that match
       the query. The matching query terms are emphasized with surrounding `<em></em>` tags. This parameter is ignored
       if `passages.enabled` and `passages.per_document` are `true`, in which case passages are returned for each
       document instead of highlights.
     - parameter spellingSuggestions: When `true` and the **natural_language_query** parameter is used, the
       **natural_language_query** parameter is spell checked. The most likely correction is returned in the
       **suggested_query** field of the response (if one exists).
     - parameter tableResults: Configuration for table retrieval.
     - parameter suggestedRefinements: Configuration for suggested refinements. Available with Premium plans only.
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
        let queryRequest = QueryRequest(
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
        let body: Data?
        do {
            body = try JSON.encoder.encodeIfPresent(queryRequest)
        } catch {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "query")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/query"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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

    // Private struct for the query request body
    private struct QueryRequest: Encodable {
        // swiftlint:disable identifier_name
        let collectionIDs: [String]?
        let filter: String?
        let query: String?
        let naturalLanguageQuery: String?
        let aggregation: String?
        let count: Int?
        let `return`: [String]?
        let offset: Int?
        let sort: String?
        let highlight: Bool?
        let spellingSuggestions: Bool?
        let tableResults: QueryLargeTableResults?
        let suggestedRefinements: QueryLargeSuggestedRefinements?
        let passages: QueryLargePassages?
        private enum CodingKeys: String, CodingKey {
            case collectionIDs = "collection_ids"
            case filter = "filter"
            case query = "query"
            case naturalLanguageQuery = "natural_language_query"
            case aggregation = "aggregation"
            case count = "count"
            case `return` = "return"
            case offset = "offset"
            case sort = "sort"
            case highlight = "highlight"
            case spellingSuggestions = "spelling_suggestions"
            case tableResults = "table_results"
            case suggestedRefinements = "suggested_refinements"
            case passages = "passages"
        }
        init? (collectionIDs: [String]? = nil, filter: String? = nil, query: String? = nil, naturalLanguageQuery: String? = nil, aggregation: String? = nil, count: Int? = nil, `return`: [String]? = nil, offset: Int? = nil, sort: String? = nil, highlight: Bool? = nil, spellingSuggestions: Bool? = nil, tableResults: QueryLargeTableResults? = nil, suggestedRefinements: QueryLargeSuggestedRefinements? = nil, passages: QueryLargePassages? = nil) {
            if collectionIDs == nil && filter == nil && query == nil && naturalLanguageQuery == nil && aggregation == nil && count == nil && `return` == nil && offset == nil && sort == nil && highlight == nil && spellingSuggestions == nil && tableResults == nil && suggestedRefinements == nil && passages == nil {
                return nil
            }
            self.collectionIDs = collectionIDs
            self.filter = filter
            self.query = query
            self.naturalLanguageQuery = naturalLanguageQuery
            self.aggregation = aggregation
            self.count = count
            self.`return` = `return`
            self.offset = offset
            self.sort = sort
            self.highlight = highlight
            self.spellingSuggestions = spellingSuggestions
            self.tableResults = tableResults
            self.suggestedRefinements = suggestedRefinements
            self.passages = passages
        }
        // swiftlint:enable identifier_name
    }

    /**
     Get Autocomplete Suggestions.

     Returns completion query suggestions for the specified prefix.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter `prefix`: The prefix to use for autocompletion. For example, the prefix `Ho` could autocomplete to
       `hot`, `housing`, or `how`.
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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getAutocompletion")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

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
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     Query collection notices.

     Finds collection-level notices (errors and warnings) that are generated when documents are ingested.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter collectionID: The ID of the collection.
     - parameter filter: Searches for documents that match the Discovery Query Language criteria that is specified as
       input. Filter calls are cached and are faster than query calls because the results are not ordered by relevance.
       When used with the `aggregation`, `query`, or `natural_language_query` parameters, the `filter` parameter runs
       first. This parameter is useful for limiting results to those that contain specific metadata values.
     - parameter query: A query search that is written in the Discovery Query Language and returns all matching
       documents in your data set with full enrichments and full text, and with the most relevant documents listed
       first.
     - parameter naturalLanguageQuery: A natural language query that returns relevant documents by using training data
       and natural language understanding.
     - parameter count: Number of results to return. The maximum for the **count** and **offset** values together in
       any one query is **10,000**.
     - parameter offset: The number of query results to skip at the beginning. For example, if the total number of
       results that are returned is 10 and the offset is 8, it returns the last two results. The maximum for the
       **count** and **offset** values together in any one query is **10000**.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func queryCollectionNotices(
        projectID: String,
        collectionID: String,
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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "queryCollectionNotices")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

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
        let path = "/v2/projects/\(projectID)/collections/\(collectionID)/notices"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     Query project notices.

     Finds project-level notices (errors and warnings). Currently, project-level notices are generated by relevancy
     training.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter filter: Searches for documents that match the Discovery Query Language criteria that is specified as
       input. Filter calls are cached and are faster than query calls because the results are not ordered by relevance.
       When used with the `aggregation`, `query`, or `natural_language_query` parameters, the `filter` parameter runs
       first. This parameter is useful for limiting results to those that contain specific metadata values.
     - parameter query: A query search that is written in the Discovery Query Language and returns all matching
       documents in your data set with full enrichments and full text, and with the most relevant documents listed
       first.
     - parameter naturalLanguageQuery: A natural language query that returns relevant documents by using training data
       and natural language understanding.
     - parameter count: Number of results to return. The maximum for the **count** and **offset** values together in
       any one query is **10,000**.
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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "queryNotices")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

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
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listFields")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

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
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     List component settings.

     Returns default configuration settings for components.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getComponentSettings")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/component_settings"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
       * You can set the **Content-Type** parameter on the **file** part to indicate the media type of the document. If
     the **Content-Type** parameter is missing or is one of the generic media types (for example,
     `application/octet-stream`), then the service attempts to automatically detect the document's media type.
       * The following field names are reserved and are filtered out if present after normalization: `id`, `score`,
     `highlight`, and any field with the characters `_`, `+`, or `-` as a prefix.
       * Fields with empty name values after normalization are filtered out before indexing.
       * Fields that contain the characters `#` or `,` after normalization are filtered out before indexing.
       If the document is uploaded to a collection that shares its data with another collection, the
     **X-Watson-Discovery-Force** header must be set to `true`.
     **Note:** In curl requests only, you can assign an ID to a document that you add by appending the ID to the
     endpoint (`/v2/projects/{project_id}/collections/{collection_id}/documents/{document_id}`). If a document already
     exists with the specified ID, it is replaced.
     **Note:** This operation works with a file upload collection. It cannot be used to modify a collection that crawls
     an external data source.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter collectionID: The ID of the collection.
     - parameter file: The content of the document to ingest. For maximum supported file size limits, see [the
       documentation](https://cloud.ibm.com/docs/discovery-data?topic=discovery-data-collections#collections-doc-limits).
     - parameter filename: The filename for file.
     - parameter fileContentType: The content type of file.
     - parameter metadata: The maximum supported metadata file size is 1 MB. Metadata parts larger than 1 MB are
       rejected.
       Example:  ``` {
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
            completionHandler(nil, RestError.serialization(values: "request multipart form data"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "addDocument")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType
        if let xWatsonDiscoveryForce = xWatsonDiscoveryForce {
            headerParameters["X-Watson-Discovery-Force"] = "\(xWatsonDiscoveryForce)"
        }
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/collections/\(collectionID)/documents"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     If the document is uploaded to a collection that shares its data with another collection, the
     **X-Watson-Discovery-Force** header must be set to `true`.
     **Note:** When uploading a new document with this method it automatically replaces any document stored with the
     same **document_id** if it exists.
     **Note:** This operation works with a file upload collection. It cannot be used to modify a collection that crawls
     an external data source.
     **Note:** If an uploaded document is segmented, all segments are overwritten, even if the updated version of the
     document has fewer segments.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter collectionID: The ID of the collection.
     - parameter documentID: The ID of the document.
     - parameter file: The content of the document to ingest. For maximum supported file size limits, see [the
       documentation](https://cloud.ibm.com/docs/discovery-data?topic=discovery-data-collections#collections-doc-limits).
     - parameter filename: The filename for file.
     - parameter fileContentType: The content type of file.
     - parameter metadata: The maximum supported metadata file size is 1 MB. Metadata parts larger than 1 MB are
       rejected.
       Example:  ``` {
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
            completionHandler(nil, RestError.serialization(values: "request multipart form data"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateDocument")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType
        if let xWatsonDiscoveryForce = xWatsonDiscoveryForce {
            headerParameters["X-Watson-Discovery-Force"] = "\(xWatsonDiscoveryForce)"
        }
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/collections/\(collectionID)/documents/\(documentID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     **Note:** Segments of an uploaded document cannot be deleted individually. Delete all segments by deleting using
     the `parent_document_id` of a segment result.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteDocument")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let xWatsonDiscoveryForce = xWatsonDiscoveryForce {
            headerParameters["X-Watson-Discovery-Force"] = "\(xWatsonDiscoveryForce)"
        }
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/collections/\(collectionID)/documents/\(documentID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listTrainingQueries")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/training_data/queries"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteTrainingQueries")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/training_data/queries"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
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
        let createTrainingQueryRequest = CreateTrainingQueryRequest(
            natural_language_query: naturalLanguageQuery,
            examples: examples,
            filter: filter)
        guard let body = try? JSON.encoder.encode(createTrainingQueryRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createTrainingQuery")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/training_data/queries"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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

    // Private struct for the createTrainingQuery request body
    private struct CreateTrainingQueryRequest: Encodable {
        // swiftlint:disable identifier_name
        let natural_language_query: String
        let examples: [TrainingExample]
        let filter: String?
        // swiftlint:enable identifier_name
    }

    /**
     Get a training data query.

     Get details for a specific training data query, including the query string and all examples.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getTrainingQuery")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/training_data/queries/\(queryID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
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
        let updateTrainingQueryRequest = UpdateTrainingQueryRequest(
            natural_language_query: naturalLanguageQuery,
            examples: examples,
            filter: filter)
        guard let body = try? JSON.encoder.encode(updateTrainingQueryRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateTrainingQuery")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/training_data/queries/\(queryID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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

    // Private struct for the updateTrainingQuery request body
    private struct UpdateTrainingQueryRequest: Encodable {
        // swiftlint:disable identifier_name
        let natural_language_query: String
        let examples: [TrainingExample]
        let filter: String?
        // swiftlint:enable identifier_name
    }

    /**
     Delete a training data query.

     Removes details from a training data query, including the query string and all examples.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter queryID: The ID of the query used for training.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteTrainingQuery(
        projectID: String,
        queryID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteTrainingQuery")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/training_data/queries/\(queryID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     List projects.

     Lists existing projects for this instance.

     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listProjects(
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ListProjectsResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listProjects")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + "/v2/projects",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Create a project.

     Create a new project for this instance.

     - parameter name: The human readable name of this project.
     - parameter type: The type of project.
       The `content_intelligence` type is a *Document Retrieval for Contracts* project and the `other` type is a
       *Custom* project.
       The `content_mining` and `content_intelligence` types are available with Premium plan managed deployments and
       installed deployments only.
     - parameter defaultQueryParameters: Default query parameters for this project.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createProject(
        name: String,
        type: String,
        defaultQueryParameters: DefaultQueryParams? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ProjectDetails>?, WatsonError?) -> Void)
    {
        // construct body
        let createProjectRequest = CreateProjectRequest(
            name: name,
            type: type,
            default_query_parameters: defaultQueryParameters)
        guard let body = try? JSON.encoder.encode(createProjectRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createProject")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + "/v2/projects",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the createProject request body
    private struct CreateProjectRequest: Encodable {
        // swiftlint:disable identifier_name
        let name: String
        let type: String
        let default_query_parameters: DefaultQueryParams?
        // swiftlint:enable identifier_name
    }

    /**
     Get project.

     Get details on the specified project.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getProject(
        projectID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ProjectDetails>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getProject")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     Update a project.

     Update the specified project's name.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter name: The new name to give this project.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateProject(
        projectID: String,
        name: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ProjectDetails>?, WatsonError?) -> Void)
    {
        // construct body
        let updateProjectRequest = UpdateProjectRequest(
            name: name)
        let body: Data?
        do {
            body = try JSON.encoder.encodeIfPresent(updateProjectRequest)
        } catch {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateProject")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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

    // Private struct for the updateProject request body
    private struct UpdateProjectRequest: Encodable {
        // swiftlint:disable identifier_name
        let name: String?
        init? (name: String? = nil) {
            if name == nil {
                return nil
            }
            self.name = name
        }
        // swiftlint:enable identifier_name
    }

    /**
     Delete a project.

     Deletes the specified project.
     **Important:** Deleting a project deletes everything that is part of the specified project, including all
     collections.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteProject(
        projectID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteProject")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     List enrichments.

     Lists the enrichments available to this project. The *Part of Speech* and *Sentiment of Phrases* enrichments might
     be listed, but are reserved for internal use only.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listEnrichments(
        projectID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Enrichments>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listEnrichments")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/enrichments"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     Create an enrichment.

     Create an enrichment for use with the specified project.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter enrichment: Information about a specific enrichment.
     - parameter file: The enrichment file to upload. Expected file types per enrichment are as follows:
       * CSV for `dictionary`
       * PEAR for `uima_annotator` and `rule_based` (Explorer)
       * ZIP for `watson_knowledge_studio_model` and `rule_based` (Studio Advanced Rule Editor).
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createEnrichment(
        projectID: String,
        enrichment: CreateEnrichment,
        file: Data? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Enrichment>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        guard let enrichmentJSON = try? JSON.encoder.encode(enrichment) else {
            completionHandler(nil, RestError.serialization(values: "enrichment"))
            return
        }
        multipartFormData.append(enrichmentJSON, withName: "enrichment", mimeType: "application/json")

        if let file = file {
            multipartFormData.append(file, withName: "file", mimeType: "application/octet-stream", fileName: "filename")
        }
        guard let body = try? multipartFormData.toData() else {
            completionHandler(nil, RestError.serialization(values: "request multipart form data"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createEnrichment")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/enrichments"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     Get enrichment.

     Get details about a specific enrichment.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter enrichmentID: The ID of the enrichment.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getEnrichment(
        projectID: String,
        enrichmentID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Enrichment>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getEnrichment")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/enrichments/\(enrichmentID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     Update an enrichment.

     Updates an existing enrichment's name and description.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter enrichmentID: The ID of the enrichment.
     - parameter name: A new name for the enrichment.
     - parameter description: A new description for the enrichment.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateEnrichment(
        projectID: String,
        enrichmentID: String,
        name: String,
        description: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Enrichment>?, WatsonError?) -> Void)
    {
        // construct body
        let updateEnrichmentRequest = UpdateEnrichmentRequest(
            name: name,
            description: description)
        guard let body = try? JSON.encoder.encode(updateEnrichmentRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateEnrichment")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/enrichments/\(enrichmentID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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

    // Private struct for the updateEnrichment request body
    private struct UpdateEnrichmentRequest: Encodable {
        // swiftlint:disable identifier_name
        let name: String
        let description: String?
        // swiftlint:enable identifier_name
    }

    /**
     Delete an enrichment.

     Deletes an existing enrichment from the specified project.
     **Note:** Only enrichments that have been manually created can be deleted.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter enrichmentID: The ID of the enrichment.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteEnrichment(
        projectID: String,
        enrichmentID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteEnrichment")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/enrichments/\(enrichmentID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     List document classifiers.

     Get a list of the document classifiers in a project.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listDocumentClassifiers(
        projectID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DocumentClassifiers>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listDocumentClassifiers")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/document_classifiers"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     Create a document classifier.

     Create a document classifier. You can create a document classifier for any project type from the API. From the
     product user interface, you can create and work with a document classifier from a Content Mining project only.
     After you create a document classifier, use the Enrichments API to deploy it. (The enrichment type is
     `classifier`).

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter trainingData: The training data CSV file to upload. The CSV file must have headers. The file must
       include a field that contains the text you want to classify and a field that contains the classification labels
       that you want to use to classify your data. If you want to specify multiple values in a single field, use a
       semicolon as the value separator.
     - parameter classifier: An object that manages the settings and data that is required to train a document
       classification model.
     - parameter testData: The CSV with test data to upload. The column values in the test file must be the same as
       the column values in the training data file. If no test data is provided, the training data is split into two
       separate groups of training and test data.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createDocumentClassifier(
        projectID: String,
        trainingData: Data,
        classifier: CreateDocumentClassifier,
        testData: Data? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DocumentClassifier>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(trainingData, withName: "training_data", mimeType: "text/csv", fileName: "filename")
        guard let classifierJSON = try? JSON.encoder.encode(classifier) else {
            completionHandler(nil, RestError.serialization(values: "classifier"))
            return
        }
        multipartFormData.append(classifierJSON, withName: "classifier", mimeType: "application/json")

        if let testData = testData {
            multipartFormData.append(testData, withName: "test_data", mimeType: "text/csv", fileName: "filename")
        }
        guard let body = try? multipartFormData.toData() else {
            completionHandler(nil, RestError.serialization(values: "request multipart form data"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createDocumentClassifier")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/document_classifiers"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     Get a document classifier.

     Get details about a specific document classifier.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter classifierID: The ID of the classifier.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getDocumentClassifier(
        projectID: String,
        classifierID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DocumentClassifier>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getDocumentClassifier")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/document_classifiers/\(classifierID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     Update a document classifier.

     Update the document classifier name or description, update the training data, or add or update the test data.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter classifierID: The ID of the classifier.
     - parameter classifier: An object that contains a new name or description for a classifier, updated training
       data, or new or updated test data.
     - parameter trainingData: The training data CSV file to upload. The CSV file must have headers. The file must
       include a field that contains the text you want to classify and a field that contains the classification labels
       that you want to use to classify your data. If you want to specify multiple values in a single column, use a
       semicolon as the value separator.
     - parameter testData: The CSV with test data to upload. The column values in the test file must be the same as
       the column values in the training data file. If no test data is provided, the training data is split into two
       separate groups of training and test data.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateDocumentClassifier(
        projectID: String,
        classifierID: String,
        classifier: UpdateDocumentClassifier,
        trainingData: Data? = nil,
        testData: Data? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DocumentClassifier>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        guard let classifierJSON = try? JSON.encoder.encode(classifier) else {
            completionHandler(nil, RestError.serialization(values: "classifier"))
            return
        }
        multipartFormData.append(classifierJSON, withName: "classifier", mimeType: "application/json")

        if let trainingData = trainingData {
            multipartFormData.append(trainingData, withName: "training_data", mimeType: "text/csv", fileName: "filename")
        }
        if let testData = testData {
            multipartFormData.append(testData, withName: "test_data", mimeType: "text/csv", fileName: "filename")
        }
        guard let body = try? multipartFormData.toData() else {
            completionHandler(nil, RestError.serialization(values: "request multipart form data"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateDocumentClassifier")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/document_classifiers/\(classifierID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     Delete a document classifier.

     Deletes an existing document classifier from the specified project.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter classifierID: The ID of the classifier.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteDocumentClassifier(
        projectID: String,
        classifierID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteDocumentClassifier")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/document_classifiers/\(classifierID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     List document classifier models.

     Get a list of the trained document classifier models in a project.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter classifierID: The ID of the classifier.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listDocumentClassifierModels(
        projectID: String,
        classifierID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DocumentClassifierModels>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listDocumentClassifierModels")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/document_classifiers/\(classifierID)/models"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     Create a document classifier model.

     Create a document classifier model.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter classifierID: The ID of the classifier.
     - parameter name: The name of the document classifier model.
     - parameter description: A description of the document classifier model.
     - parameter learningRate: A tuning parameter in an optimization algorithm that determines the step size at each
       iteration of the training process. It influences how much of any newly acquired information overrides the
       existing information, and therefore is said to represent the speed at which a machine learning model learns. The
       default value is `0.1`.
     - parameter l1RegularizationStrengths: Avoids overfitting by shrinking the coefficient of less important features
       to zero, which removes some features altogether. You can specify many values for hyper-parameter optimization.
       The default value is `0.000001`.
     - parameter l2RegularizationStrengths: A method you can apply to avoid overfitting your model on the training
       data. You can specify many values for hyper-parameter optimization. The default value is `0.000001`.
     - parameter trainingMaxSteps: Maximum number of training steps to complete. This setting is useful if you need
       the training process to finish in a specific time frame to fit into an automated process. The default value is
       ten million.
     - parameter improvementRatio: Stops the training run early if the improvement ratio is not met by the time the
       process reaches a certain point. The default value is `0.00001`.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createDocumentClassifierModel(
        projectID: String,
        classifierID: String,
        name: String,
        description: String? = nil,
        learningRate: Double? = nil,
        l1RegularizationStrengths: [Double]? = nil,
        l2RegularizationStrengths: [Double]? = nil,
        trainingMaxSteps: Int? = nil,
        improvementRatio: Double? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DocumentClassifierModel>?, WatsonError?) -> Void)
    {
        // construct body
        let createDocumentClassifierModelRequest = CreateDocumentClassifierModelRequest(
            name: name,
            description: description,
            learning_rate: learningRate,
            l1_regularization_strengths: l1RegularizationStrengths,
            l2_regularization_strengths: l2RegularizationStrengths,
            training_max_steps: trainingMaxSteps,
            improvement_ratio: improvementRatio)
        guard let body = try? JSON.encoder.encode(createDocumentClassifierModelRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createDocumentClassifierModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/document_classifiers/\(classifierID)/models"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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

    // Private struct for the createDocumentClassifierModel request body
    private struct CreateDocumentClassifierModelRequest: Encodable {
        // swiftlint:disable identifier_name
        let name: String
        let description: String?
        let learning_rate: Double?
        let l1_regularization_strengths: [Double]?
        let l2_regularization_strengths: [Double]?
        let training_max_steps: Int?
        let improvement_ratio: Double?
        // swiftlint:enable identifier_name
    }

    /**
     Get a document classifier model.

     Get details about a specific document classifier model.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter classifierID: The ID of the classifier.
     - parameter modelID: The ID of the classifier model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getDocumentClassifierModel(
        projectID: String,
        classifierID: String,
        modelID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DocumentClassifierModel>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getDocumentClassifierModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/document_classifiers/\(classifierID)/models/\(modelID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     Update a document classifier model.

     Update the document classifier model name or description.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter classifierID: The ID of the classifier.
     - parameter modelID: The ID of the classifier model.
     - parameter name: A new name for the enrichment.
     - parameter description: A new description for the enrichment.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateDocumentClassifierModel(
        projectID: String,
        classifierID: String,
        modelID: String,
        name: String? = nil,
        description: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DocumentClassifierModel>?, WatsonError?) -> Void)
    {
        // construct body
        let updateDocumentClassifierModelRequest = UpdateDocumentClassifierModelRequest(
            name: name,
            description: description)
        guard let body = try? JSON.encoder.encode(updateDocumentClassifierModelRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateDocumentClassifierModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/document_classifiers/\(classifierID)/models/\(modelID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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

    // Private struct for the updateDocumentClassifierModel request body
    private struct UpdateDocumentClassifierModelRequest: Encodable {
        // swiftlint:disable identifier_name
        let name: String?
        let description: String?
        // swiftlint:enable identifier_name
    }

    /**
     Delete a document classifier model.

     Deletes an existing document classifier model from the specified project.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter classifierID: The ID of the classifier.
     - parameter modelID: The ID of the classifier model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteDocumentClassifierModel(
        projectID: String,
        classifierID: String,
        modelID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteDocumentClassifierModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/document_classifiers/\(classifierID)/models/\(modelID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     Analyze a Document.

     Process a document and return it for realtime use. Supports JSON files only.
     The document is processed according to the collection's configuration settings but is not stored in the collection.
     **Note:** This method is supported on installed instances of Discovery only.

     - parameter projectID: The ID of the project. This information can be found from the *Integrate and Deploy* page
       in Discovery.
     - parameter collectionID: The ID of the collection.
     - parameter file: The content of the document to ingest. For maximum supported file size limits, see [the
       documentation](https://cloud.ibm.com/docs/discovery-data?topic=discovery-data-collections#collections-doc-limits).
     - parameter filename: The filename for file.
     - parameter fileContentType: The content type of file.
     - parameter metadata: The maximum supported metadata file size is 1 MB. Metadata parts larger than 1 MB are
       rejected.
       Example:  ``` {
         "Creator": "Johnny Appleseed",
         "Subject": "Apples"
       } ```.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func analyzeDocument(
        projectID: String,
        collectionID: String,
        file: Data? = nil,
        filename: String? = nil,
        fileContentType: String? = nil,
        metadata: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<AnalyzedDocument>?, WatsonError?) -> Void)
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
            completionHandler(nil, RestError.serialization(values: "request multipart form data"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "analyzeDocument")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/projects/\(projectID)/collections/\(collectionID)/analyze"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
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
     Delete labeled data.

     Deletes all data associated with a specified customer ID. The method has no effect if no data is associated with
     the customer ID.
     You associate a customer ID with data by passing the **X-Watson-Metadata** header with a request that passes data.
     For more information about personal data and customer IDs, see [Information
     security](https://cloud.ibm.com/docs/discovery-data?topic=discovery-data-information-security#information-security).
     **Note:** This method is only supported on IBM Cloud instances of Discovery.

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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteUserData")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        queryParameters.append(URLQueryItem(name: "customer_id", value: customerID))

        // construct REST request

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceEndpoint + "/v2/user_data",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

}
