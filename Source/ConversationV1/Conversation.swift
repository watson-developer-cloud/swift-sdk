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
import Alamofire
import Freddy
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
    
    private let username: String
    private let password: String
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
        self.username = username
        self.password = password
        self.version = version
    }
    
    /**
     Start a new conversation or get a response to a user's input.
     
     - parameter workspaceID: The unique identifier of the workspace to use.
     - parameter text: The user's input message.
     - parameter context: The context, or state, associated with this request.
        Use a `nil` context to start a new conversation.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the conversation service's response.
     */
    public func message(
        withWorkspaceID workspaceID: WorkspaceID,
        text: String? = nil,
        context: Context? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (MessageResponse) -> Void)
    {
        let input = InputData(text: text)
        message(withWorkspaceID: workspaceID, input: input, context: context, failure: failure, success: success)
    }
    
    /**
     Start a new conversation or get a response to a user's input.
     
     - parameter workspaceID: The unique identifier of the workspace to use.
     - parameter input: An input object that includes the input text.
     - parameter context: The context, or state, associated with this request.
     - parameter entities: An array of terms that shall be identified as entities
     - parameter intents: An array of terms that shall be identified as intents.
     - parameter output: An output object that includes the response to the user,
        the nodes that were hit, and messages from the log.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the conversation service's response.
     */
    public func message(
        withWorkspaceID workspaceID: WorkspaceID,
        input: InputData,
        context: Context? = nil,
        entities: [Entity]? = nil,
        intents: [Intent]? = nil,
        output: OutputData? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (MessageResponse) -> Void)
    {
        // construct message request
        let messageRequest = MessageRequest(
            input: input,
            context: context,
            entities: entities,
            intents: intents,
            output: output
        )
        
        // construct body
        guard let body = try? messageRequest.toJSON().serialize() else {
            let failureReason = "MessageRequest could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: .post,
            url: serviceURL + "/v1/workspaces/\(workspaceID)/message",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryParameters: queryParameters,
            messageBody: body
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject() { (response: DataResponse<MessageResponse>) in
                switch response.result {
                case .success(let response): success(response)
                case .failure(let error): failure?(error)
                }
            }
    }
}
