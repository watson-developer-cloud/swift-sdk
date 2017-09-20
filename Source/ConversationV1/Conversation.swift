/**
 * Copyright IBM Corporation 2016,2017
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

/// A Workspace is a container for all the artifacts that define the behavior of your service.
public typealias WorkspaceID = String

/**
 With the IBM Watson Conversation service you can create cognitive agents–virtual agents that
 combine machine learning, natural language understanding, and integrated dialog scripting tools
 to provide outstanding customer engagements.
 */
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
            let message = try json.getString(at: "error")
            let userInfo = [NSLocalizedDescriptionKey: message]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }

    /**
     Send a message to the Conversation service. To start a new conversation set the `request`
     parameter to `nil`.

     - parameter withWorkspace: The unique identifier of the workspace to use.
     - parameter request: The message requst to send to the server.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the conversation service's response.
     */
    public func message(
        withWorkspace workspaceID: WorkspaceID,
        request: MessageRequest? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (MessageResponse) -> Void)
    {
        // construct body
        guard let body = try? request?.toJSON().serialize() else {
            failure?(RestError.serializationError)
            return
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
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
     Create counterexample.

     Add a new counterexample to a workspace. Counterexamples are examples that have been marked as irrelevant input.

     - parameter workspaceID: The workspace ID.
     - parameter text: The text of a user input example.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func createCounterexample(
        workspaceID: String,
        text: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ExampleResponse) -> Void)
    {
        // construct body
        let createCounterexampleRequest = CreateExample(text: text)
        guard let body = try? createCounterexampleRequest.toJSON().serialize() else {
            failure?(RestError.serializationError)
            return
        }

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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<ExampleResponse>) in
                switch response.result {
                case .success(let retval): success(retval)
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     Delete counterexample.

     Delete a counterexample from a workspace. Counterexamples are examples that have been marked as irrelevant input.

     - parameter workspaceID: The workspace ID.
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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
        )

        // execute REST request
        request.responseVoid(responseToError: responseToError) {
            (response: RestResponse) in
                switch response.result {
                case .success(): success()
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     Get counterexample.

     Get information about a counterexample. Counterexamples are examples that have been marked as irrelevant input.

     - parameter workspaceID: The workspace ID.
     - parameter text: The text of a user input counterexample (for example, `What are you wearing?`).
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func getCounterexample(
        workspaceID: String,
        text: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ExampleResponse) -> Void)
    {
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
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<ExampleResponse>) in
                switch response.result {
                case .success(let retval): success(retval)
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     List counterexamples.

     List the counterexamples for a workspace. Counterexamples are examples that have been marked as irrelevant input.

     - parameter workspaceID: The workspace ID.
     - parameter pageLimit: The number of records to return in each page of results. The default page limit is 100.
     - parameter includeCount: Whether to include information about the number of records returned.
     - parameter sort: Sorts the response according to the value of the specified property, in ascending or descending order.
     - parameter cursor: A token identifying the last value from the previous page of results.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func listCounterexamples(
        workspaceID: String,
        pageLimit: Int? = nil,
        includeCount: Bool? = nil,
        sort: String? = nil,
        cursor: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (CounterexampleCollectionResponse) -> Void)
    {
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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<CounterexampleCollectionResponse>) in
                switch response.result {
                case .success(let retval): success(retval)
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     Update counterexample.

     Update the text of a counterexample. Counterexamples are examples that have been marked as irrelevant input.

     - parameter workspaceID: The workspace ID.
     - parameter text: The text of a user input counterexample (for example, `What are you wearing?`).
     - parameter newText: The text of the example to be marked as irrelevant input.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func updateCounterexample(
        workspaceID: String,
        text: String,
        newText: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ExampleResponse) -> Void)
    {
        // construct body
        let updateCounterexampleRequest = UpdateCounterexample(text: newText)
        guard let body = try? updateCounterexampleRequest.toJSON().serialize() else {
            failure?(RestError.serializationError)
            return
        }

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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<ExampleResponse>) in
                switch response.result {
                case .success(let retval): success(retval)
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     Create entity.

     Create a new entity.

     - parameter workspaceID: The workspace ID.
     - parameter body: A CreateEntity object defining the content of the new entity.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func createEntity(
        workspaceID: String,
        body: CreateEntity,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (EntityResponse) -> Void)
    {
        // construct body
        guard let body = try? body.toJSON().serialize() else {
            failure?(RestError.serializationError)
            return
        }

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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<EntityResponse>) in
                switch response.result {
                case .success(let retval): success(retval)
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     Delete entity.

     Delete an entity from a workspace.

     - parameter workspaceID: The workspace ID.
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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
        )

        // execute REST request
        request.responseVoid(responseToError: responseToError) {
            (response: RestResponse) in
                switch response.result {
                case .success(): success()
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     Get entity.

     Get information about an entity, optionally including all entity content.

     - parameter workspaceID: The workspace ID.
     - parameter entity: The name of the entity.
     - parameter export: Whether to include all element content in the returned data. If export=`false`, the returned data includes only information about the element itself. If export=`true`, all content, including subelements, is included. The default value is `false`.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func getEntity(
        workspaceID: String,
        entity: String,
        export: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (EntityExport) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let export = export {
            let queryParameter = URLQueryItem(name: "export", value: "\(export)")
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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
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
     List entities.

     List the entities for a workspace.

     - parameter workspaceID: The workspace ID.
     - parameter export: Whether to include all element content in the returned data. If export=`false`, the returned data includes only information about the element itself. If export=`true`, all content, including subelements, is included. The default value is `false`.
     - parameter pageLimit: The number of records to return in each page of results. The default page limit is 100.
     - parameter includeCount: Whether to include information about the number of records returned.
     - parameter sort: Sorts the response according to the value of the specified property, in ascending or descending order.
     - parameter cursor: A token identifying the last value from the previous page of results.
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
        failure: ((Error) -> Void)? = nil,
        success: @escaping (EntityCollection) -> Void)
    {
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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
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
     Update entity.

     Update an existing entity with new or modified data.

     - parameter workspaceID: The workspace ID.
     - parameter entity: The name of the entity.
     - parameter body: An UpdateEntity object defining the updated content of the entity.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func updateEntity(
        workspaceID: String,
        entity: String,
        body: UpdateEntity,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (EntityResponse) -> Void)
    {
        // construct body
        guard let body = try? body.toJSON().serialize() else {
            failure?(RestError.serializationError)
            return
        }

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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<EntityResponse>) in
                switch response.result {
                case .success(let retval): success(retval)
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     Create user input example.

     Add a new user input example to an intent.

     - parameter workspaceID: The workspace ID.
     - parameter intent: The intent name (for example, `pizza_order`).
     - parameter text: The text of a user input example.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func createExample(
        workspaceID: String,
        intent: String,
        text: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ExampleResponse) -> Void)
    {
        // construct body
        let createExampleRequest = CreateExample(text: text)
        guard let body = try? createExampleRequest.toJSON().serialize() else {
            failure?(RestError.serializationError)
            return
        }

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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<ExampleResponse>) in
                switch response.result {
                case .success(let retval): success(retval)
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     Delete user input example.

     Delete a user input example from an intent.

     - parameter workspaceID: The workspace ID.
     - parameter intent: The intent name (for example, `pizza_order`).
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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
        )

        // execute REST request
        request.responseVoid(responseToError: responseToError) {
            (response: RestResponse) in
                switch response.result {
                case .success(): success()
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     Get user input example.

     Get information about a user input example.

     - parameter workspaceID: The workspace ID.
     - parameter intent: The intent name (for example, `pizza_order`).
     - parameter text: The text of the user input example.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func getExample(
        workspaceID: String,
        intent: String,
        text: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ExampleResponse) -> Void)
    {
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
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<ExampleResponse>) in
                switch response.result {
                case .success(let retval): success(retval)
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     List user input examples.

     List the user input examples for an intent.

     - parameter workspaceID: The workspace ID.
     - parameter intent: The intent name (for example, `pizza_order`).
     - parameter pageLimit: The number of records to return in each page of results. The default page limit is 100.
     - parameter includeCount: Whether to include information about the number of records returned.
     - parameter sort: Sorts the response according to the value of the specified property, in ascending or descending order.
     - parameter cursor: A token identifying the last value from the previous page of results.
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
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ExampleCollectionResponse) -> Void)
    {
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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<ExampleCollectionResponse>) in
                switch response.result {
                case .success(let retval): success(retval)
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     Update user input example.

     Update the text of a user input example.

     - parameter workspaceID: The workspace ID.
     - parameter intent: The intent name (for example, `pizza_order`).
     - parameter text: The text of the user input example.
     - parameter newText: The text of the user input example.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func updateExample(
        workspaceID: String,
        intent: String,
        text: String,
        newText: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ExampleResponse) -> Void)
    {
        // construct body
        let updateExampleRequest = UpdateExample(text: newText)
        guard let body = try? updateExampleRequest.toJSON().serialize() else {
            failure?(RestError.serializationError)
            return
        }

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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<ExampleResponse>) in
                switch response.result {
                case .success(let retval): success(retval)
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     Create intent.

     Create a new intent.

     - parameter workspaceID: The workspace ID.
     - parameter intent: The name of the intent.
     - parameter description: The description of the intent.
     - parameter examples: An array of user input examples.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func createIntent(
        workspaceID: String,
        intent: String,
        description: String? = nil,
        examples: [CreateExample]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (IntentResponse) -> Void)
    {
        // construct body
        let createIntentRequest = CreateIntent(intent: intent, description: description, examples: examples)
        guard let body = try? createIntentRequest.toJSON().serialize() else {
            failure?(RestError.serializationError)
            return
        }

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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<IntentResponse>) in
                switch response.result {
                case .success(let retval): success(retval)
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     Delete intent.

     Delete an intent from a workspace.

     - parameter workspaceID: The workspace ID.
     - parameter intent: The intent name (for example, `pizza_order`).
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func deleteIntent(
        workspaceID: String,
        intent: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
        )

        // execute REST request
        request.responseVoid(responseToError: responseToError) {
            (response: RestResponse) in
                switch response.result {
                case .success(): success()
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     Get intent.

     Get information about an intent, optionally including all intent content.

     - parameter workspaceID: The workspace ID.
     - parameter intent: The intent name (for example, `pizza_order`).
     - parameter export: Whether to include all element content in the returned data. If export=`false`, the returned data includes only information about the element itself. If export=`true`, all content, including subelements, is included. The default value is `false`.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func getIntent(
        workspaceID: String,
        intent: String,
        export: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (IntentExportResponse) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let export = export {
            let queryParameter = URLQueryItem(name: "export", value: "\(export)")
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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<IntentExportResponse>) in
                switch response.result {
                case .success(let retval): success(retval)
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     List intents.

     List the intents for a workspace.

     - parameter workspaceID: The workspace ID.
     - parameter export: Whether to include all element content in the returned data. If export=`false`, the returned data includes only information about the element itself. If export=`true`, all content, including subelements, is included. The default value is `false`.
     - parameter pageLimit: The number of records to return in each page of results. The default page limit is 100.
     - parameter includeCount: Whether to include information about the number of records returned.
     - parameter sort: Sorts the response according to the value of the specified property, in ascending or descending order.
     - parameter cursor: A token identifying the last value from the previous page of results.
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
        failure: ((Error) -> Void)? = nil,
        success: @escaping (IntentCollectionResponse) -> Void)
    {
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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<IntentCollectionResponse>) in
                switch response.result {
                case .success(let retval): success(retval)
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     Update intent.

     Update an existing intent with new or modified data. You must provide data defining the content of the updated intent.

     - parameter workspaceID: The workspace ID.
     - parameter intent: The intent name (for example, `pizza_order`).
     - parameter newIntent: The name of the intent.
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
        success: @escaping (IntentResponse) -> Void)
    {
        // construct body
        let updateIntentRequest = UpdateIntent(intent: newIntent, description: newDescription, examples: newExamples)
        guard let body = try? updateIntentRequest.toJSON().serialize() else {
            failure?(RestError.serializationError)
            return
        }

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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<IntentResponse>) in
                switch response.result {
                case .success(let retval): success(retval)
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     List log events.

     - parameter workspaceID: The workspace ID.
     - parameter sort: Sorts the response according to the value of the specified property, in ascending or descending order.
     - parameter filter: A cacheable parameter that limits the results to those matching the specified filter.
     - parameter pageLimit: The number of records to return in each page of results. The default page limit is 100.
     - parameter cursor: A token identifying the last value from the previous page of results.
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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
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
     Add entity value synonym.

     Add a new synonym to an entity value.

     - parameter workspaceID: The workspace ID.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter synonym: The text of the synonym.
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
        guard let body = try? createSynonymRequest.toJSON().serialize() else {
            failure?(RestError.serializationError)
            return
        }

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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
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

     Delete a synonym for an entity value.

     - parameter workspaceID: The workspace ID.
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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
        )

        // execute REST request
        request.responseVoid(responseToError: responseToError) {
            (response: RestResponse) in
                switch response.result {
                case .success(): success()
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     Get entity value synonym.

     Get information about a synonym for an entity value.

     - parameter workspaceID: The workspace ID.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter synonym: The text of the synonym.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func getSynonym(
        workspaceID: String,
        entity: String,
        value: String,
        synonym: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Synonym) -> Void)
    {
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
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
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
     List entity value synonyms.

     List the synonyms for an entity value.

     - parameter workspaceID: The workspace ID.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter pageLimit: The number of records to return in each page of results. The default page limit is 100.
     - parameter includeCount: Whether to include information about the number of records returned.
     - parameter sort: Sorts the response according to the value of the specified property, in ascending or descending order.
     - parameter cursor: A token identifying the last value from the previous page of results.
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
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SynonymCollection) -> Void)
    {
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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
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
     Update entity value synonym.

     Update the information about a synonym for an entity value.

     - parameter workspaceID: The workspace ID.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter synonym: The text of the synonym.
     - parameter newSynonym: The text of the synonym.
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
        guard let body = try? updateSynonymRequest.toJSON().serialize() else {
            failure?(RestError.serializationError)
            return
        }

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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
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
     Add entity value.

     Create a new value for an entity.

     - parameter workspaceID: The workspace ID.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter metadata: Any metadata related to the entity value.
     - parameter synonyms: An array of synonyms for the entity value.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func createValue(
        workspaceID: String,
        entity: String,
        value: String,
        metadata: [String: Any]? = nil,
        synonyms: [String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Value) -> Void)
    {
        // construct body
        let createValueRequest = CreateValue(value: value, metadata: metadata, synonyms: synonyms)
        guard let body = try? createValueRequest.toJSON().serialize() else {
            failure?(RestError.serializationError)
            return
        }

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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
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

     Delete a value for an entity.

     - parameter workspaceID: The workspace ID.
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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
        )

        // execute REST request
        request.responseVoid(responseToError: responseToError) {
            (response: RestResponse) in
                switch response.result {
                case .success(): success()
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     Get entity value.

     Get information about an entity value.

     - parameter workspaceID: The workspace ID.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter export: Whether to include all element content in the returned data. If export=`false`, the returned data includes only information about the element itself. If export=`true`, all content, including subelements, is included. The default value is `false`.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func getValue(
        workspaceID: String,
        entity: String,
        value: String,
        export: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ValueExport) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let export = export {
            let queryParameter = URLQueryItem(name: "export", value: "\(export)")
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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
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
     List entity values.

     List the values for an entity.

     - parameter workspaceID: The workspace ID.
     - parameter entity: The name of the entity.
     - parameter export: Whether to include all element content in the returned data. If export=`false`, the returned data includes only information about the element itself. If export=`true`, all content, including subelements, is included. The default value is `false`.
     - parameter pageLimit: The number of records to return in each page of results. The default page limit is 100.
     - parameter includeCount: Whether to include information about the number of records returned.
     - parameter sort: Sorts the response according to the value of the specified property, in ascending or descending order.
     - parameter cursor: A token identifying the last value from the previous page of results.
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
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ValueCollection) -> Void)
    {
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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
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
     Update entity value.

     Update the content of a value for an entity.

     - parameter workspaceID: The workspace ID.
     - parameter entity: The name of the entity.
     - parameter value: The text of the entity value.
     - parameter newValue: The text of the entity value.
     - parameter newMetadata: Any metadata related to the entity value.
     - parameter newSynonyms: An array of synonyms for the entity value.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func updateValue(
        workspaceID: String,
        entity: String,
        value: String,
        newValue: String? = nil,
        newMetadata: [String: Any]? = nil,
        newSynonyms: [String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Value) -> Void)
    {
        // construct body
        let updateValueRequest = UpdateValue(value: newValue, metadata: newMetadata, synonyms: newSynonyms)
        guard let body = try? updateValueRequest.toJSON().serialize() else {
            failure?(RestError.serializationError)
            return
        }

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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
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
     Create workspace.

     Create a workspace based on component objects. You must provide workspace components defining the content of the new workspace.

     - parameter body: Valid data defining the content of the new workspace.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func createWorkspace(
        body: CreateWorkspace? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (WorkspaceResponse) -> Void)
    {
        // construct body
        guard let body = try? body?.toJSON().serialize() else {
            failure?(RestError.serializationError)
            return
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/workspaces",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<WorkspaceResponse>) in
                switch response.result {
                case .success(let retval): success(retval)
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     Delete workspace.

     Delete a workspace from the service instance.

     - parameter workspaceID: The workspace ID.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func deleteWorkspace(
        workspaceID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
        )

        // execute REST request
        request.responseVoid(responseToError: responseToError) {
            (response: RestResponse) in
                switch response.result {
                case .success(): success()
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     Get information about a workspace.

     Get information about a workspace, optionally including all workspace content.

     - parameter workspaceID: The workspace ID.
     - parameter export: Whether to include all element content in the returned data. If export=`false`, the returned data includes only information about the element itself. If export=`true`, all content, including subelements, is included. The default value is `false`.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func getWorkspace(
        workspaceID: String,
        export: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (WorkspaceExportResponse) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let export = export {
            let queryParameter = URLQueryItem(name: "export", value: "\(export)")
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
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<WorkspaceExportResponse>) in
                switch response.result {
                case .success(let retval): success(retval)
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     List workspaces.

     List the workspaces associated with a Conversation service instance.

     - parameter pageLimit: The number of records to return in each page of results. The default page limit is 100.
     - parameter includeCount: Whether to include information about the number of records returned.
     - parameter sort: Sorts the response according to the value of the specified property, in ascending or descending order.
     - parameter cursor: A token identifying the last value from the previous page of results.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func listWorkspaces(
        pageLimit: Int? = nil,
        includeCount: Bool? = nil,
        sort: String? = nil,
        cursor: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (WorkspaceCollectionResponse) -> Void)
    {
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

        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/workspaces",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<WorkspaceCollectionResponse>) in
                switch response.result {
                case .success(let retval): success(retval)
                case .failure(let error): failure?(error)
                }
        }
    }

    /**
     Update workspace.

     Update an existing workspace with new or modified data. You must provide component objects defining the content of the updated workspace.

     - parameter workspaceID: The workspace ID.
     - parameter body: Valid data defining the new workspace content. Any elements included in the new data will completely replace the existing elements, including all subelements. Previously existing subelements are not retained unless they are included in the new data.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func updateWorkspace(
        workspaceID: String,
        body: UpdateWorkspace? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (WorkspaceResponse) -> Void)
    {
        // construct body
        guard let body = try? body?.toJSON().serialize() else {
            failure?(RestError.serializationError)
            return
        }

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
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<WorkspaceResponse>) in
                switch response.result {
                case .success(let retval): success(retval)
                case .failure(let error): failure?(error)
                }
        }
    }

}
