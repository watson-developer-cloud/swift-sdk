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
// swiftlint:disable file_length

import Foundation
import RestKit

/**
 The IBM Watson&trade; Assistant service combines machine learning, natural language understanding, and integrated
 dialog tools to create conversation flows between your apps and your users.
 */
public class Assistant {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/assistant/api"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    private let session = URLSession(configuration: URLSessionConfiguration.default)
    private var authMethod: AuthenticationMethod
    private let domain = "com.ibm.watson.developer-cloud.AssistantV2"
    private let version: String

    /**
     Create a `Assistant` object.

     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     */
    public init(username: String, password: String, version: String) {
        self.authMethod = Shared.getAuthMethod(username: username, password: password)
        self.version = version
        Shared.configureRestRequest()
    }

    /**
     Create a `Assistant` object.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     - parameter apiKey: An API key for IAM that can be used to obtain access tokens for the service.
     - parameter iamUrl: The URL for the IAM service.
     */
    public init(version: String, apiKey: String, iamUrl: String? = nil) {
        self.authMethod = Shared.getAuthMethod(apiKey: apiKey, iamURL: iamUrl)
        self.version = version
        Shared.configureRestRequest()
    }

    /**
     Create a `Assistant` object.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     - parameter accessToken: An access token for the service.
     */
    public init(version: String, accessToken: String) {
        self.authMethod = IAMAccessToken(accessToken: accessToken)
        self.version = version
        Shared.configureRestRequest()
    }

    public func accessToken(_ newToken: String) {
        if self.authMethod is IAMAccessToken {
            self.authMethod = IAMAccessToken(accessToken: newToken)
        }
    }

    /**
     Use the HTTP response and data received by the Watson Assistant service to extract
     information about the error that occurred.

     - parameter data: Raw data returned by the service that may represent an error.
     - parameter response: the URL response returned by the service.
     */
    func errorResponseDecoder(data: Data, response: HTTPURLResponse) -> RestError {

        let statusCode = response.statusCode
        var errorMessage: String?
        var metadata = [String: JSON]()

        do {
            let json = try JSONDecoder().decode([String: JSON].self, from: data)
            if case let .some(.string(message)) = json["error"] {
                errorMessage = message
                metadata["error"] = JSON.string(message)
            }
            return RestError.http(statusCode: statusCode, message: errorMessage, metadata: metadata)
        } catch {
            return RestError.http(statusCode: statusCode, message: nil, metadata: nil)
        }
    }

    /**
     Create a session.

     Create a new session. A session is used to send user input to a skill and receive responses. It also maintains the
     state of the conversation.

     - parameter assistantID: Unique identifier of the assistant. You can find the assistant ID of an assistant on the
       **Assistants** tab of the Watson Assistant tool. For information about creating assistants, see the
       [documentation](https://console.bluemix.net/docs/services/assistant/create-assistant.html#creating-assistants).
       **Note:** Currently, the v2 API does not support creating assistants.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createSession(
        assistantID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<SessionResponse>?, Error?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/assistants/\(assistantID)/sessions"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.encodingError)
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete session.

     Deletes a session explicitly before it times out.

     - parameter assistantID: Unique identifier of the assistant. You can find the assistant ID of an assistant on the
       **Assistants** tab of the Watson Assistant tool. For information about creating assistants, see the
       [documentation](https://console.bluemix.net/docs/services/assistant/create-assistant.html#creating-assistants).
       **Note:** Currently, the v2 API does not support creating assistants.
     - parameter sessionID: Unique identifier of the session.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteSession(
        assistantID: String,
        sessionID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, Error?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/assistants/\(assistantID)/sessions/\(sessionID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.encodingError)
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
        request.responseVoid(completionHandler: completionHandler)
    }

    /**
     Send user input to assistant.

     Send user input to an assistant and receive a response.
     There is no rate limit for this operation.

     - parameter assistantID: Unique identifier of the assistant. You can find the assistant ID of an assistant on the
       **Assistants** tab of the Watson Assistant tool. For information about creating assistants, see the
       [documentation](https://console.bluemix.net/docs/services/assistant/create-assistant.html#creating-assistants).
       **Note:** Currently, the v2 API does not support creating assistants.
     - parameter sessionID: Unique identifier of the session.
     - parameter input: An input object that includes the input text.
     - parameter context: State information for the conversation.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func message(
        assistantID: String,
        sessionID: String,
        input: MessageInput? = nil,
        context: MessageContext? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<MessageResponse>?, Error?) -> Void)
    {
        // construct body
        let messageRequest = MessageRequest(input: input, context: context)
        guard let body = try? JSONEncoder().encodeIfPresent(messageRequest) else {
            completionHandler(nil, RestError.serializationError)
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v2/assistants/\(assistantID)/sessions/\(sessionID)/message"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.encodingError)
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

}
