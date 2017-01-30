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
    private let version: String
    private let domain = "com.ibm.watson.developer-cloud.ConversationV1"
    
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
     If the given data represents an error returned by the Visual Recognition service, then return
     an NSError with information about the error that occured. Otherwise, return nil.
     
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func dataToError(data: Data) -> NSError? {
        do {
            let json = try JSON(data: data)
            let error = try json.getString(at: "error")
            let code = (try? json.getInt(at: "code")) ?? 400
            let userInfo = [NSLocalizedFailureReasonErrorKey: error]
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
            failure?(RestError.encodingError)
            return
        }
        
        // construct query items
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "version", value: version))
        
        // construct rest request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/workspaces/\(workspaceID)/message",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryItems,
            messageBody: body
        )
        
        // execute rest request
        request.responseObject(dataToError: dataToError) {
            (response: RestResponse<MessageResponse>) in
            switch response.result {
            case .success(let response): success(response)
            case .failure(let error): failure?(error)
            }
        }
    }
}
