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
            let userInfo = [NSLocalizedFailureReasonErrorKey: message]
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
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/workspaces/\(workspaceID)/message",
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
}
