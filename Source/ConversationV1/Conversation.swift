/**
 * Copyright IBM Corporation 2018
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

/**
 The IBM Watson Conversation service combines machine learning, natural language understanding, and integrated dialog
 tools to create conversation flows between your apps and your users.
 */
@available(*, deprecated, message: "The IBM Watson Conversation service has been renamed to Assistant. Please use the `Assistant` class instead of `Conversation`. The `Conversation` class will be removed in a future release.")
public class Conversation {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/conversation/api"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    private let credentials: Credentials
    private let domain = "com.ibm.watson.developer-cloud.ConversationV1"
    private let version: String

    /**
     Create a `Conversation` object.

     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter version: The release date of the version of the API to use. Specify the date
     in "YYYY-MM-DD" format.
     */
    public init(username: String, password: String, version: String) {
        self.credentials = .basicAuthentication(username: username, password: password)
        self.version = version
    }

    /**
     If the response or data represents an error returned by the Conversation service,
     then return NSError with information about the error that occured. Otherwise, return nil.

     - parameter response: the URL response returned from the service.
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func responseToError(response: HTTPURLResponse?, data: Data?) -> NSError? {

        // First check http status code in response
        if let response = response {
            if (200..<300).contains(response.statusCode) {
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
            let json = try JSONWrapper(data: data)
            let code = response?.statusCode ?? 400
            let message = try json.getString(at: "error")
            let userInfo = [NSLocalizedDescriptionKey: message]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }

    /**
     Get a response to a user's input.    There is no rate limit for this operation.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter request: The message to be sent. This includes the user's input, along with optional intents, entities, and context from the last response.
     - parameter nodesVisitedDetails: Whether to include additional diagnostic information about the dialog nodes that were visited during processing of the message.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func message(
        workspaceID: String,
        request: MessageRequest? = nil,
        nodesVisitedDetails: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (MessageResponse) -> Void)
    {
        // construct body
        guard let body = try? JSONEncoder().encodeIfPresent(request) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let nodesVisitedDetails = nodesVisitedDetails {
            let queryParameter = URLQueryItem(name: "nodes_visited_details", value: "\(nodesVisitedDetails)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/message"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<MessageResponse>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     List workspaces.

     List the workspaces associated with a Conversation service instance.    This operation is limited to 500 requests
     per 30 minutes. For more information, see **Rate limiting**.

     - parameter pageLimit: The number of records to return in each page of results.
     - parameter includeCount: Whether to include information about the number of records returned.
     - parameter sort: The attribute by which returned results will be sorted. To reverse the sort order, prefix the value with a minus sign (`-`). Supported values are `name`, `updated`, and `workspace_id`.
     - parameter cursor: A token identifying the last object from the previous page of results.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listWorkspaces(
        pageLimit: Int? = nil,
        includeCount: Bool? = nil,
        sort: String? = nil,
        cursor: String? = nil,
        includeAudit: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (WorkspaceCollection) -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let includeCount = includeCount {
            let queryParameter = URLQueryItem(name: "include_count", value: "\(includeCount)")
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/workspaces",
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<WorkspaceCollection>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Create workspace.

     Create a workspace based on component objects. You must provide workspace components defining the content of the
     new workspace.    This operation is limited to 30 requests per 30 minutes. For more information, see **Rate
     limiting**.

     - parameter properties: The content of the new workspace.    The maximum size for this data is 50MB. If you need to import a larger workspace, consider importing the workspace without intents and entities and then adding them separately.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func createWorkspace(
        properties: CreateWorkspace? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Workspace) -> Void)
    {
        // construct body
        guard let body = try? JSONEncoder().encodeIfPresent(properties) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/workspaces",
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Workspace>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Get information about a workspace.

     Get information about a workspace, optionally including all workspace content.    With **export**=`false`, this
     operation is limited to 6000 requests per 5 minutes. With **export**=`true`, the limit is 20 requests per 30
     minutes. For more information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter export: Whether to include all element content in the returned data. If **export**=`false`, the returned data includes only information about the element itself. If **export**=`true`, all content, including subelements, is included.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getWorkspace(
        workspaceID: String,
        export: Bool? = nil,
        includeAudit: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (WorkspaceExport) -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let export = export {
            let queryParameter = URLQueryItem(name: "export", value: "\(export)")
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<WorkspaceExport>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Update workspace.

     Update an existing workspace with new or modified data. You must provide component objects defining the content of
     the updated workspace.    This operation is limited to 30 request per 30 minutes. For more information, see **Rate
     limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter properties: Valid data defining the new and updated workspace content.    The maximum size for this data is 50MB. If you need to import a larger amount of workspace data, consider importing components such as intents and entities using separate operations.
     - parameter append: Whether the new data is to be appended to the existing data in the workspace. If **append**=`false`, elements included in the new data completely replace the corresponding existing elements, including all subelements. For example, if the new data includes **entities** and **append**=`false`, all existing entities in the workspace are discarded and replaced with the new entities.    If **append**=`true`, existing elements are preserved, and the new elements are added. If any elements in the new data collide with existing elements, the update request fails.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func updateWorkspace(
        workspaceID: String,
        properties: UpdateWorkspace? = nil,
        append: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Workspace) -> Void)
    {
        // construct body
        guard let body = try? JSONEncoder().encodeIfPresent(properties) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let append = append {
            let queryParameter = URLQueryItem(name: "append", value: "\(append)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Workspace>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete workspace.

     Delete a workspace from the service instance.    This operation is limited to 30 requests per 30 minutes. For more
     information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func deleteWorkspace(
        workspaceID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseVoid(responseToError: responseToError) {
            (response: RestResponse) in
            switch response.result {
            case .success: success()
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     List intents.

     List the intents for a workspace.    With **export**=`false`, this operation is limited to 2000 requests per 30
     minutes. With **export**=`true`, the limit is 400 requests per 30 minutes. For more information, see **Rate
     limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter export: Whether to include all element content in the returned data. If **export**=`false`, the returned data includes only information about the element itself. If **export**=`true`, all content, including subelements, is included.
     - parameter pageLimit: The number of records to return in each page of results.
     - parameter includeCount: Whether to include information about the number of records returned.
     - parameter sort: The attribute by which returned results will be sorted. To reverse the sort order, prefix the value with a minus sign (`-`). Supported values are `name`, `updated`, and `workspace_id`.
     - parameter cursor: A token identifying the last object from the previous page of results.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listIntents(
        workspaceID: String,
        export: Bool? = nil,
        pageLimit: Int? = nil,
        includeCount: Bool? = nil,
        sort: String? = nil,
        cursor: String? = nil,
        includeAudit: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (IntentCollection) -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let export = export {
            let queryParameter = URLQueryItem(name: "export", value: "\(export)")
            queryParameters.append(queryParameter)
        }
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let includeCount = includeCount {
            let queryParameter = URLQueryItem(name: "include_count", value: "\(includeCount)")
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/intents"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<IntentCollection>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Create intent.

     Create a new intent.    This operation is limited to 2000 requests per 30 minutes. For more information, see **Rate
     limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter intent: The name of the intent. This string must conform to the following restrictions:  - It can contain only Unicode alphanumeric, underscore, hyphen, and dot characters.  - It cannot begin with the reserved prefix `sys-`.  - It must be no longer than 128 characters.
     - parameter description: The description of the intent. This string cannot contain carriage return, newline, or tab characters, and it must be no longer than 128 characters.
     - parameter examples: An array of user input examples for the intent.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func createIntent(
        workspaceID: String,
        intent: String,
        description: String? = nil,
        examples: [CreateExample]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Intent) -> Void)
    {
        // construct body
        let createIntentRequest = CreateIntent(intent: intent, description: description, examples: examples)
        guard let body = try? JSONEncoder().encode(createIntentRequest) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/intents"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Intent>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Get intent.

     Get information about an intent, optionally including all intent content.    With **export**=`false`, this
     operation is limited to 6000 requests per 5 minutes. With **export**=`true`, the limit is 400 requests per 30
     minutes. For more information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter intent: The intent name.
     - parameter export: Whether to include all element content in the returned data. If **export**=`false`, the returned data includes only information about the element itself. If **export**=`true`, all content, including subelements, is included.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getIntent(
        workspaceID: String,
        intent: String,
        export: Bool? = nil,
        includeAudit: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (IntentExport) -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let export = export {
            let queryParameter = URLQueryItem(name: "export", value: "\(export)")
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/intents/\(intent)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<IntentExport>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Update intent.

     Update an existing intent with new or modified data. You must provide component objects defining the content of the
     updated intent.    This operation is limited to 2000 requests per 30 minutes. For more information, see **Rate
     limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter intent: The intent name.
     - parameter newIntent: The name of the intent. This string must conform to the following restrictions:  - It can contain only Unicode alphanumeric, underscore, hyphen, and dot characters.  - It cannot begin with the reserved prefix `sys-`.  - It must be no longer than 128 characters.
     - parameter newDescription: The description of the intent.
     - parameter newExamples: An array of user input examples for the intent.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func updateIntent(
        workspaceID: String,
        intent: String,
        newIntent: String? = nil,
        newDescription: String? = nil,
        newExamples: [CreateExample]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Intent) -> Void)
    {
        // construct body
        let updateIntentRequest = UpdateIntent(intent: newIntent, description: newDescription, examples: newExamples)
        guard let body = try? JSONEncoder().encode(updateIntentRequest) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/intents/\(intent)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Intent>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete intent.

     Delete an intent from a workspace.    This operation is limited to 2000 requests per 30 minutes. For more
     information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter intent: The intent name.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func deleteIntent(
        workspaceID: String,
        intent: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/intents/\(intent)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseVoid(responseToError: responseToError) {
            (response: RestResponse) in
            switch response.result {
            case .success: success()
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     List user input examples.

     List the user input examples for an intent.    This operation is limited to 2500 requests per 30 minutes. For more
     information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter intent: The intent name.
     - parameter pageLimit: The number of records to return in each page of results.
     - parameter includeCount: Whether to include information about the number of records returned.
     - parameter sort: The attribute by which returned results will be sorted. To reverse the sort order, prefix the value with a minus sign (`-`). Supported values are `name`, `updated`, and `workspace_id`.
     - parameter cursor: A token identifying the last object from the previous page of results.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listExamples(
        workspaceID: String,
        intent: String,
        pageLimit: Int? = nil,
        includeCount: Bool? = nil,
        sort: String? = nil,
        cursor: String? = nil,
        includeAudit: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ExampleCollection) -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let includeCount = includeCount {
            let queryParameter = URLQueryItem(name: "include_count", value: "\(includeCount)")
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/intents/\(intent)/examples"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<ExampleCollection>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Create user input example.

     Add a new user input example to an intent.    This operation is limited to 1000 requests per 30 minutes. For more
     information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter intent: The intent name.
     - parameter text: The text of a user input example. This string must conform to the following restrictions:  - It cannot contain carriage return, newline, or tab characters.  - It cannot consist of only whitespace characters.  - It must be no longer than 1024 characters.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func createExample(
        workspaceID: String,
        intent: String,
        text: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Example) -> Void)
    {
        // construct body
        let createExampleRequest = CreateExample(text: text)
        guard let body = try? JSONEncoder().encode(createExampleRequest) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/intents/\(intent)/examples"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Example>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Get user input example.

     Get information about a user input example.    This operation is limited to 6000 requests per 5 minutes. For more
     information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter intent: The intent name.
     - parameter text: The text of the user input example.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getExample(
        workspaceID: String,
        intent: String,
        text: String,
        includeAudit: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Example) -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/intents/\(intent)/examples/\(text)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Example>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Update user input example.

     Update the text of a user input example.    This operation is limited to 1000 requests per 30 minutes. For more
     information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter intent: The intent name.
     - parameter text: The text of the user input example.
     - parameter newText: The text of the user input example. This string must conform to the following restrictions:  - It cannot contain carriage return, newline, or tab characters.  - It cannot consist of only whitespace characters.  - It must be no longer than 1024 characters.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func updateExample(
        workspaceID: String,
        intent: String,
        text: String,
        newText: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Example) -> Void)
    {
        // construct body
        let updateExampleRequest = UpdateExample(text: newText)
        guard let body = try? JSONEncoder().encode(updateExampleRequest) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/intents/\(intent)/examples/\(text)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Example>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete user input example.

     Delete a user input example from an intent.    This operation is limited to 1000 requests per 30 minutes. For more
     information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter intent: The intent name.
     - parameter text: The text of the user input example.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func deleteExample(
        workspaceID: String,
        intent: String,
        text: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/intents/\(intent)/examples/\(text)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseVoid(responseToError: responseToError) {
            (response: RestResponse) in
            switch response.result {
            case .success: success()
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     List counterexamples.

     List the counterexamples for a workspace. Counterexamples are examples that have been marked as irrelevant input.
     This operation is limited to 2500 requests per 30 minutes. For more information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter pageLimit: The number of records to return in each page of results.
     - parameter includeCount: Whether to include information about the number of records returned.
     - parameter sort: The attribute by which returned results will be sorted. To reverse the sort order, prefix the value with a minus sign (`-`). Supported values are `name`, `updated`, and `workspace_id`.
     - parameter cursor: A token identifying the last object from the previous page of results.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listCounterexamples(
        workspaceID: String,
        pageLimit: Int? = nil,
        includeCount: Bool? = nil,
        sort: String? = nil,
        cursor: String? = nil,
        includeAudit: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (CounterexampleCollection) -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let includeCount = includeCount {
            let queryParameter = URLQueryItem(name: "include_count", value: "\(includeCount)")
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/counterexamples"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<CounterexampleCollection>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Create counterexample.

     Add a new counterexample to a workspace. Counterexamples are examples that have been marked as irrelevant input.
     This operation is limited to 1000 requests per 30 minutes. For more information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter text: The text of a user input marked as irrelevant input. This string must conform to the following restrictions:  - It cannot contain carriage return, newline, or tab characters  - It cannot consist of only whitespace characters  - It must be no longer than 1024 characters.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func createCounterexample(
        workspaceID: String,
        text: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Counterexample) -> Void)
    {
        // construct body
        let createCounterexampleRequest = CreateCounterexample(text: text)
        guard let body = try? JSONEncoder().encode(createCounterexampleRequest) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/counterexamples"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Counterexample>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Get counterexample.

     Get information about a counterexample. Counterexamples are examples that have been marked as irrelevant input.
     This operation is limited to 6000 requests per 5 minutes. For more information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter text: The text of a user input counterexample (for example, `What are you wearing?`).
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getCounterexample(
        workspaceID: String,
        text: String,
        includeAudit: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Counterexample) -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/counterexamples/\(text)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Counterexample>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Update counterexample.

     Update the text of a counterexample. Counterexamples are examples that have been marked as irrelevant input.
     This operation is limited to 1000 requests per 30 minutes. For more information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter text: The text of a user input counterexample (for example, `What are you wearing?`).
     - parameter newText: The text of a user input counterexample.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func updateCounterexample(
        workspaceID: String,
        text: String,
        newText: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Counterexample) -> Void)
    {
        // construct body
        let updateCounterexampleRequest = UpdateCounterexample(text: newText)
        guard let body = try? JSONEncoder().encode(updateCounterexampleRequest) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/counterexamples/\(text)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Counterexample>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete counterexample.

     Delete a counterexample from a workspace. Counterexamples are examples that have been marked as irrelevant input.
     This operation is limited to 1000 requests per 30 minutes. For more information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter text: The text of a user input counterexample (for example, `What are you wearing?`).
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func deleteCounterexample(
        workspaceID: String,
        text: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/counterexamples/\(text)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseVoid(responseToError: responseToError) {
            (response: RestResponse) in
            switch response.result {
            case .success: success()
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     List entities.

     List the entities for a workspace.    With **export**=`false`, this operation is limited to 1000 requests per 30
     minutes. With **export**=`true`, the limit is 200 requests per 30 minutes. For more information, see **Rate
     limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter export: Whether to include all element content in the returned data. If **export**=`false`, the returned data includes only information about the element itself. If **export**=`true`, all content, including subelements, is included.
     - parameter pageLimit: The number of records to return in each page of results.
     - parameter includeCount: Whether to include information about the number of records returned.
     - parameter sort: The attribute by which returned results will be sorted. To reverse the sort order, prefix the value with a minus sign (`-`). Supported values are `name`, `updated`, and `workspace_id`.
     - parameter cursor: A token identifying the last object from the previous page of results.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listEntities(
        workspaceID: String,
        export: Bool? = nil,
        pageLimit: Int? = nil,
        includeCount: Bool? = nil,
        sort: String? = nil,
        cursor: String? = nil,
        includeAudit: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (EntityCollection) -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let export = export {
            let queryParameter = URLQueryItem(name: "export", value: "\(export)")
            queryParameters.append(queryParameter)
        }
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let includeCount = includeCount {
            let queryParameter = URLQueryItem(name: "include_count", value: "\(includeCount)")
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<EntityCollection>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Create entity.

     Create a new entity.    This operation is limited to 1000 requests per 30 minutes. For more information, see **Rate
     limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter properties: The content of the new entity.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func createEntity(
        workspaceID: String,
        properties: CreateEntity,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Entity) -> Void)
    {
        // construct body
        guard let body = try? JSONEncoder().encode(properties) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Entity>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Get entity.

     Get information about an entity, optionally including all entity content.    With **export**=`false`, this
     operation is limited to 6000 requests per 5 minutes. With **export**=`true`, the limit is 200 requests per 30
     minutes. For more information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter export: Whether to include all element content in the returned data. If **export**=`false`, the returned data includes only information about the element itself. If **export**=`true`, all content, including subelements, is included.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getEntity(
        workspaceID: String,
        entity: String,
        export: Bool? = nil,
        includeAudit: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (EntityExport) -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let export = export {
            let queryParameter = URLQueryItem(name: "export", value: "\(export)")
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<EntityExport>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Update entity.

     Update an existing entity with new or modified data. You must provide component objects defining the content of the
     updated entity.    This operation is limited to 1000 requests per 30 minutes. For more information, see **Rate
     limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter properties: The updated content of the entity. Any elements included in the new data will completely replace the equivalent existing elements, including all subelements. (Previously existing subelements are not retained unless they are also included in the new data.) For example, if you update the values for an entity, the previously existing values are discarded and replaced with the new values specified in the update.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func updateEntity(
        workspaceID: String,
        entity: String,
        properties: UpdateEntity,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Entity) -> Void)
    {
        // construct body
        guard let body = try? JSONEncoder().encode(properties) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Entity>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete entity.

     Delete an entity from a workspace.    This operation is limited to 1000 requests per 30 minutes. For more
     information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func deleteEntity(
        workspaceID: String,
        entity: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseVoid(responseToError: responseToError) {
            (response: RestResponse) in
            switch response.result {
            case .success: success()
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     List entity values.

     List the values for an entity.    This operation is limited to 2500 requests per 30 minutes. For more information,
     see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter export: Whether to include all element content in the returned data. If **export**=`false`, the returned data includes only information about the element itself. If **export**=`true`, all content, including subelements, is included.
     - parameter pageLimit: The number of records to return in each page of results.
     - parameter includeCount: Whether to include information about the number of records returned.
     - parameter sort: The attribute by which returned results will be sorted. To reverse the sort order, prefix the value with a minus sign (`-`). Supported values are `name`, `updated`, and `workspace_id`.
     - parameter cursor: A token identifying the last object from the previous page of results.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listValues(
        workspaceID: String,
        entity: String,
        export: Bool? = nil,
        pageLimit: Int? = nil,
        includeCount: Bool? = nil,
        sort: String? = nil,
        cursor: String? = nil,
        includeAudit: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ValueCollection) -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let export = export {
            let queryParameter = URLQueryItem(name: "export", value: "\(export)")
            queryParameters.append(queryParameter)
        }
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let includeCount = includeCount {
            let queryParameter = URLQueryItem(name: "include_count", value: "\(includeCount)")
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/values"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<ValueCollection>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Add entity value.

     Create a new value for an entity.    This operation is limited to 1000 requests per 30 minutes. For more
     information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter properties: The new entity value.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func createValue(
        workspaceID: String,
        entity: String,
        properties: CreateValue,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Value) -> Void)
    {
        // construct body
        guard let body = try? JSONEncoder().encode(properties) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/values"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Value>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Get entity value.

     Get information about an entity value.    This operation is limited to 6000 requests per 5 minutes. For more
     information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter export: Whether to include all element content in the returned data. If **export**=`false`, the returned data includes only information about the element itself. If **export**=`true`, all content, including subelements, is included.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getValue(
        workspaceID: String,
        entity: String,
        value: String,
        export: Bool? = nil,
        includeAudit: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ValueExport) -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let export = export {
            let queryParameter = URLQueryItem(name: "export", value: "\(export)")
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/values/\(value)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<ValueExport>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Update entity value.

     Update an existing entity value with new or modified data. You must provide component objects defining the content
     of the updated entity value.    This operation is limited to 1000 requests per 30 minutes. For more information,
     see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter properties: The updated content of the entity value.    Any elements included in the new data will completely replace the equivalent existing elements, including all subelements. (Previously existing subelements are not retained unless they are also included in the new data.) For example, if you update the synonyms for an entity value, the previously existing synonyms are discarded and replaced with the new synonyms specified in the update.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func updateValue(
        workspaceID: String,
        entity: String,
        value: String,
        properties: UpdateValue,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Value) -> Void)
    {
        // construct body
        guard let body = try? JSONEncoder().encode(properties) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/values/\(value)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Value>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete entity value.

     Delete a value from an entity.    This operation is limited to 1000 requests per 30 minutes. For more information,
     see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func deleteValue(
        workspaceID: String,
        entity: String,
        value: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/values/\(value)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseVoid(responseToError: responseToError) {
            (response: RestResponse) in
            switch response.result {
            case .success: success()
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     List entity value synonyms.

     List the synonyms for an entity value.    This operation is limited to 2500 requests per 30 minutes. For more
     information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter pageLimit: The number of records to return in each page of results.
     - parameter includeCount: Whether to include information about the number of records returned.
     - parameter sort: The attribute by which returned results will be sorted. To reverse the sort order, prefix the value with a minus sign (`-`). Supported values are `name`, `updated`, and `workspace_id`.
     - parameter cursor: A token identifying the last object from the previous page of results.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listSynonyms(
        workspaceID: String,
        entity: String,
        value: String,
        pageLimit: Int? = nil,
        includeCount: Bool? = nil,
        sort: String? = nil,
        cursor: String? = nil,
        includeAudit: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SynonymCollection) -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let includeCount = includeCount {
            let queryParameter = URLQueryItem(name: "include_count", value: "\(includeCount)")
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/values/\(value)/synonyms"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<SynonymCollection>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Add entity value synonym.

     Add a new synonym to an entity value.    This operation is limited to 1000 requests per 30 minutes. For more
     information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter synonym: The text of the synonym. This string must conform to the following restrictions:  - It cannot contain carriage return, newline, or tab characters.  - It cannot consist of only whitespace characters.  - It must be no longer than 64 characters.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func createSynonym(
        workspaceID: String,
        entity: String,
        value: String,
        synonym: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Synonym) -> Void)
    {
        // construct body
        let createSynonymRequest = CreateSynonym(synonym: synonym)
        guard let body = try? JSONEncoder().encode(createSynonymRequest) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/values/\(value)/synonyms"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Synonym>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Get entity value synonym.

     Get information about a synonym of an entity value.    This operation is limited to 6000 requests per 5 minutes.
     For more information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter synonym: The text of the synonym.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getSynonym(
        workspaceID: String,
        entity: String,
        value: String,
        synonym: String,
        includeAudit: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Synonym) -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/values/\(value)/synonyms/\(synonym)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Synonym>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Update entity value synonym.

     Update an existing entity value synonym with new text.    This operation is limited to 1000 requests per 30
     minutes. For more information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter synonym: The text of the synonym.
     - parameter newSynonym: The text of the synonym. This string must conform to the following restrictions:  - It cannot contain carriage return, newline, or tab characters.  - It cannot consist of only whitespace characters.  - It must be no longer than 64 characters.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func updateSynonym(
        workspaceID: String,
        entity: String,
        value: String,
        synonym: String,
        newSynonym: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Synonym) -> Void)
    {
        // construct body
        let updateSynonymRequest = UpdateSynonym(synonym: newSynonym)
        guard let body = try? JSONEncoder().encode(updateSynonymRequest) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/values/\(value)/synonyms/\(synonym)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Synonym>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete entity value synonym.

     Delete a synonym from an entity value.    This operation is limited to 1000 requests per 30 minutes. For more
     information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter synonym: The text of the synonym.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func deleteSynonym(
        workspaceID: String,
        entity: String,
        value: String,
        synonym: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/entities/\(entity)/values/\(value)/synonyms/\(synonym)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseVoid(responseToError: responseToError) {
            (response: RestResponse) in
            switch response.result {
            case .success: success()
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     List dialog nodes.

     List the dialog nodes for a workspace.    This operation is limited to 2500 requests per 30 minutes. For more
     information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter pageLimit: The number of records to return in each page of results.
     - parameter includeCount: Whether to include information about the number of records returned.
     - parameter sort: The attribute by which returned results will be sorted. To reverse the sort order, prefix the value with a minus sign (`-`). Supported values are `name`, `updated`, and `workspace_id`.
     - parameter cursor: A token identifying the last object from the previous page of results.
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listDialogNodes(
        workspaceID: String,
        pageLimit: Int? = nil,
        includeCount: Bool? = nil,
        sort: String? = nil,
        cursor: String? = nil,
        includeAudit: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DialogNodeCollection) -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let includeCount = includeCount {
            let queryParameter = URLQueryItem(name: "include_count", value: "\(includeCount)")
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/dialog_nodes"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<DialogNodeCollection>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Create dialog node.

     Create a new dialog node.    This operation is limited to 500 requests per 30 minutes. For more information, see
     **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter properties: A CreateDialogNode object defining the content of the new dialog node.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func createDialogNode(
        workspaceID: String,
        properties: CreateDialogNode,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DialogNode) -> Void)
    {
        // construct body
        guard let body = try? JSONEncoder().encode(properties) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/dialog_nodes"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<DialogNode>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Get dialog node.

     Get information about a dialog node.    This operation is limited to 6000 requests per 5 minutes. For more
     information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter dialogNode: The dialog node ID (for example, `get_order`).
     - parameter includeAudit: Whether to include the audit properties (`created` and `updated` timestamps) in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getDialogNode(
        workspaceID: String,
        dialogNode: String,
        includeAudit: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DialogNode) -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let includeAudit = includeAudit {
            let queryParameter = URLQueryItem(name: "include_audit", value: "\(includeAudit)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/dialog_nodes/\(dialogNode)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<DialogNode>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Update dialog node.

     Update an existing dialog node with new or modified data.    This operation is limited to 500 requests per 30
     minutes. For more information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter dialogNode: The dialog node ID (for example, `get_order`).
     - parameter properties: The updated content of the dialog node.    Any elements included in the new data will completely replace the equivalent existing elements, including all subelements. (Previously existing subelements are not retained unless they are also included in the new data.) For example, if you update the actions for a dialog node, the previously existing actions are discarded and replaced with the new actions specified in the update.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func updateDialogNode(
        workspaceID: String,
        dialogNode: String,
        properties: UpdateDialogNode,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DialogNode) -> Void)
    {
        // construct body
        guard let body = try? JSONEncoder().encode(properties) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/dialog_nodes/\(dialogNode)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<DialogNode>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete dialog node.

     Delete a dialog node from a workspace.    This operation is limited to 500 requests per 30 minutes. For more
     information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter dialogNode: The dialog node ID (for example, `get_order`).
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func deleteDialogNode(
        workspaceID: String,
        dialogNode: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/dialog_nodes/\(dialogNode)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseVoid(responseToError: responseToError) {
            (response: RestResponse) in
            switch response.result {
            case .success: success()
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     List log events in a workspace.

     List the events from the log of a specific workspace.    If **cursor** is not specified, this operation is limited
     to 40 requests per 30 minutes. If **cursor** is specified, the limit is 120 requests per minute. For more
     information, see **Rate limiting**.

     - parameter workspaceID: Unique identifier of the workspace.
     - parameter sort: The attribute by which returned results will be sorted. To reverse the sort order, prefix the value with a minus sign (`-`). Supported values are `name`, `updated`, and `workspace_id`.
     - parameter filter: A cacheable parameter that limits the results to those matching the specified filter. For more information, see the [documentation](https://console.bluemix.net/docs/services/conversation/filter-reference.html#filter-query-syntax).
     - parameter pageLimit: The number of records to return in each page of results.
     - parameter cursor: A token identifying the last object from the previous page of results.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listLogs(
        workspaceID: String,
        sort: String? = nil,
        filter: String? = nil,
        pageLimit: Int? = nil,
        cursor: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (LogCollection) -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let filter = filter {
            let queryParameter = URLQueryItem(name: "filter", value: filter)
            queryParameters.append(queryParameter)
        }
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/workspaces/\(workspaceID)/logs"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<LogCollection>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     List log events in all workspaces.

     List the events from the logs of all workspaces in the service instance.    If **cursor** is not specified, this
     operation is limited to 40 requests per 30 minutes. If **cursor** is specified, the limit is 120 requests per
     minute. For more information, see **Rate limiting**.

     - parameter filter: A cacheable parameter that limits the results to those matching the specified filter. You must specify a filter query that includes a value for `language`, as well as a value for `workspace_id` or `request.context.metadata.deployment`. For more information, see the [documentation](https://console.bluemix.net/docs/services/conversation/filter-reference.html#filter-query-syntax).
     - parameter sort: The attribute by which returned results will be sorted. To reverse the sort order, prefix the value with a minus sign (`-`). Supported values are `name`, `updated`, and `workspace_id`.
     - parameter pageLimit: The number of records to return in each page of results.
     - parameter cursor: A token identifying the last object from the previous page of results.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listAllLogs(
        filter: String,
        sort: String? = nil,
        pageLimit: Int? = nil,
        cursor: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (LogCollection) -> Void)
    {
        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        queryParameters.append(URLQueryItem(name: "filter", value: filter))
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/logs",
            credentials: credentials,
            headerParameters: headers,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<LogCollection>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

}
