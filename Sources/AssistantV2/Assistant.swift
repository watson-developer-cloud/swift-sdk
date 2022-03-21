/**
 * (C) Copyright IBM Corp. 2018, 2022.
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
 The IBM Watson&trade; Assistant service combines machine learning, natural language understanding, and an integrated
 dialog editor to create conversation flows between your apps and your users.
 The Assistant v2 API provides runtime methods your client application can use to send user input to an assistant and
 receive a response.
 */
public class Assistant {

    /// The base URL to use when contacting the service.
    public var serviceURL: String? = "https://api.us-south.assistant.watson.cloud.ibm.com"

    /// Release date of the API version you want to use. Specify dates in YYYY-MM-DD format. The current version is
    /// `2021-11-27`.
    public var version: String

    /// Service identifiers
    public static let defaultServiceName = "conversation"
    // Service info for SDK headers
    internal let serviceName = defaultServiceName
    internal let serviceVersion = "v2"
    internal let serviceSdkName = "assistant"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    var session = URLSession(configuration: URLSessionConfiguration.default)
    public let authenticator: Authenticator

    #if os(Linux)
    /**
     Create a `Assistant` object.

     If an authenticator is not supplied, the initializer will retrieve credentials from the environment or
     a local credentials file and construct an appropriate authenticator using these credentials.
     The credentials file can be downloaded from your service instance on IBM Cloud as ibm-credentials.env.
     Make sure to add the credentials file to your project so that it can be loaded at runtime.

     If an authenticator is not supplied and credentials are not available in the environment or a local
     credentials file, initialization will fail by throwing an exception.
     In that case, try another initializer that directly passes in the credentials.

     - parameter version: Release date of the API version you want to use. Specify dates in YYYY-MM-DD format. The
       current version is `2021-11-27`.
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
     Create a `Assistant` object.

     - parameter version: Release date of the API version you want to use. Specify dates in YYYY-MM-DD format. The
       current version is `2021-11-27`.
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
     Use the HTTP response and data received by the Watson Assistant v2 service to extract
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
     Create a session.

     Create a new session. A session is used to send user input to a skill and receive responses. It also maintains the
     state of the conversation. A session persists until it is deleted, or until it times out because of inactivity.
     (For more information, see the
     [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-assistant-settings).

     - parameter assistantID: Unique identifier of the assistant. To find the assistant ID in the Watson Assistant
       user interface, open the assistant settings and click **API Details**. For information about creating assistants,
       see the [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-assistant-add#assistant-add-task).
       **Note:** Currently, the v2 API does not support creating assistants.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createSession(
        assistantID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<SessionResponse>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createSession")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/assistants/\(assistantID)/sessions"
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
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete session.

     Deletes a session explicitly before it times out. (For more information about the session inactivity timeout, see
     the [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-assistant-settings)).

     - parameter assistantID: Unique identifier of the assistant. To find the assistant ID in the Watson Assistant
       user interface, open the assistant settings and click **API Details**. For information about creating assistants,
       see the [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-assistant-add#assistant-add-task).
       **Note:** Currently, the v2 API does not support creating assistants.
     - parameter sessionID: Unique identifier of the session.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteSession(
        assistantID: String,
        sessionID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteSession")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/assistants/\(assistantID)/sessions/\(sessionID)"
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
     Send user input to assistant (stateful).

     Send user input to an assistant and receive a response, with conversation state (including context data) stored by
     Watson Assistant for the duration of the session.

     - parameter assistantID: Unique identifier of the assistant. To find the assistant ID in the Watson Assistant
       user interface, open the assistant settings and click **API Details**. For information about creating assistants,
       see the [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-assistant-add#assistant-add-task).
       **Note:** Currently, the v2 API does not support creating assistants.
     - parameter sessionID: Unique identifier of the session.
     - parameter input: An input object that includes the input text.
     - parameter context: Context data for the conversation. You can use this property to set or modify context
       variables, which can also be accessed by dialog nodes. The context is stored by the assistant on a per-session
       basis.
       **Note:** The total size of the context data stored for a stateful session cannot exceed 100KB.
     - parameter userID: A string value that identifies the user who is interacting with the assistant. The client
       must provide a unique identifier for each individual end user who accesses the application. For user-based plans,
       this user ID is used to identify unique users for billing purposes. This string cannot contain carriage return,
       newline, or tab characters. If no value is specified in the input, **user_id** is automatically set to the value
       of **context.global.session_id**.
       **Note:** This property is the same as the **user_id** property in the global system context. If **user_id** is
       specified in both locations, the value specified at the root is used.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func message(
        assistantID: String,
        sessionID: String,
        input: MessageInput? = nil,
        context: MessageContext? = nil,
        userID: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<MessageResponse>?, WatsonError?) -> Void)
    {
        // construct body
        let messageRequest = MessageRequest(
            input: input,
            context: context,
            user_id: userID)
        let body: Data?
        do {
            body = try JSON.encoder.encodeIfPresent(messageRequest)
        } catch {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "message")
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
        let path = "/v2/assistants/\(assistantID)/sessions/\(sessionID)/message"
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

    // Private struct for the message request body
    private struct MessageRequest: Encodable {
        // swiftlint:disable identifier_name
        let input: MessageInput?
        let context: MessageContext?
        let user_id: String?
        init? (input: MessageInput? = nil, context: MessageContext? = nil, user_id: String? = nil) {
            if input == nil && context == nil && user_id == nil {
                return nil
            }
            self.input = input
            self.context = context
            self.user_id = user_id
        }
        // swiftlint:enable identifier_name
    }

    /**
     Send user input to assistant (stateless).

     Send user input to an assistant and receive a response, with conversation state (including context data) managed by
     your application.

     - parameter assistantID: Unique identifier of the assistant. To find the assistant ID in the Watson Assistant
       user interface, open the assistant settings and click **API Details**. For information about creating assistants,
       see the [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-assistant-add#assistant-add-task).
       **Note:** Currently, the v2 API does not support creating assistants.
     - parameter input: An input object that includes the input text.
     - parameter context: Context data for the conversation. You can use this property to set or modify context
       variables, which can also be accessed by dialog nodes. The context is not stored by the assistant. To maintain
       session state, include the context from the previous response.
       **Note:** The total size of the context data for a stateless session cannot exceed 250KB.
     - parameter userID: A string value that identifies the user who is interacting with the assistant. The client
       must provide a unique identifier for each individual end user who accesses the application. For user-based plans,
       this user ID is used to identify unique users for billing purposes. This string cannot contain carriage return,
       newline, or tab characters. If no value is specified in the input, **user_id** is automatically set to the value
       of **context.global.session_id**.
       **Note:** This property is the same as the **user_id** property in the global system context. If **user_id** is
       specified in both locations in a message request, the value specified at the root is used.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func messageStateless(
        assistantID: String,
        input: MessageInputStateless? = nil,
        context: MessageContextStateless? = nil,
        userID: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<MessageResponseStateless>?, WatsonError?) -> Void)
    {
        // construct body
        let messageStatelessRequest = MessageStatelessRequest(
            input: input,
            context: context,
            user_id: userID)
        let body: Data?
        do {
            body = try JSON.encoder.encodeIfPresent(messageStatelessRequest)
        } catch {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "messageStateless")
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
        let path = "/v2/assistants/\(assistantID)/message"
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

    // Private struct for the messageStateless request body
    private struct MessageStatelessRequest: Encodable {
        // swiftlint:disable identifier_name
        let input: MessageInputStateless?
        let context: MessageContextStateless?
        let user_id: String?
        init? (input: MessageInputStateless? = nil, context: MessageContextStateless? = nil, user_id: String? = nil) {
            if input == nil && context == nil && user_id == nil {
                return nil
            }
            self.input = input
            self.context = context
            self.user_id = user_id
        }
        // swiftlint:enable identifier_name
    }

    /**
     Identify intents and entities in multiple user utterances.

     Send multiple user inputs to a dialog skill in a single request and receive information about the intents and
     entities recognized in each input. This method is useful for testing and comparing the performance of different
     skills or skill versions.
     This method is available only with Enterprise with Data Isolation plans.

     - parameter skillID: Unique identifier of the skill. To find the skill ID in the Watson Assistant user interface,
       open the skill settings and click **API Details**.
     - parameter input: An array of input utterances to classify.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func bulkClassify(
        skillID: String,
        input: [BulkClassifyUtterance]? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<BulkClassifyResponse>?, WatsonError?) -> Void)
    {
        // construct body
        let bulkClassifyRequest = BulkClassifyRequest(
            input: input)
        let body: Data?
        do {
            body = try JSON.encoder.encodeIfPresent(bulkClassifyRequest)
        } catch {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "bulkClassify")
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
        let path = "/v2/skills/\(skillID)/workspace/bulk_classify"
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

    // Private struct for the bulkClassify request body
    private struct BulkClassifyRequest: Encodable {
        // swiftlint:disable identifier_name
        let input: [BulkClassifyUtterance]?
        init? (input: [BulkClassifyUtterance]? = nil) {
            if input == nil {
                return nil
            }
            self.input = input
        }
        // swiftlint:enable identifier_name
    }

    /**
     List log events for an assistant.

     List the events from the log of an assistant.
     This method requires Manager access, and is available only with Enterprise plans.

     - parameter assistantID: Unique identifier of the assistant. To find the assistant ID in the Watson Assistant
       user interface, open the assistant settings and click **API Details**. For information about creating assistants,
       see the [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-assistant-add#assistant-add-task).
       **Note:** Currently, the v2 API does not support creating assistants.
     - parameter sort: How to sort the returned log events. You can sort by **request_timestamp**. To reverse the sort
       order, prefix the parameter value with a minus sign (`-`).
     - parameter filter: A cacheable parameter that limits the results to those matching the specified filter. For
       more information, see the
       [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-filter-reference#filter-reference).
     - parameter pageLimit: The number of records to return in each page of results.
     - parameter cursor: A token identifying the page of results to retrieve.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listLogs(
        assistantID: String,
        sort: String? = nil,
        filter: String? = nil,
        pageLimit: Int? = nil,
        cursor: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<LogCollection>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listLogs")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

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
        let path = "/v2/assistants/\(assistantID)/logs"
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
     Delete labeled data.

     Deletes all data associated with a specified customer ID. The method has no effect if no data is associated with
     the customer ID.
     You associate a customer ID with data by passing the `X-Watson-Metadata` header with a request that passes data.
     For more information about personal data and customer IDs, see [Information
     security](https://cloud.ibm.com/docs/assistant?topic=assistant-information-security#information-security).
     **Note:** This operation is intended only for deleting data associated with a single specific customer, not for
     deleting data associated with multiple customers or for any other purpose. For more information, see [Labeling and
     deleting data in Watson
     Assistant](https://cloud.ibm.com/docs/assistant?topic=assistant-information-security#information-security-gdpr-wa).

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
        headerParameters["Accept"] = "application/json"
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
