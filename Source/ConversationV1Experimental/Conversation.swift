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
 With the IBM Watson™ Conversation service you can create cognitive agents–virtual agents that
 combine machine learning, natural language understanding, and integrated dialog scripting tools
 to provide outstanding customer engagements.
 */
public class Conversation {
    
    private let username: String
    private let password: String
    private let version: String
    private let serviceURL: String
    private let userAgent = buildUserAgent("watson-apis-ios-sdk/0.8.0 ConversationV1Experimental")
    private let domain = "com.ibm.watson.developer-cloud.ConversationV1Experimental"
    
    /**
     Create a `Conversation` object.
 
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter version: The release date of the version of the API to use. Specify the date
            in "YYYY-MM-DD" format.
     - parameter serviceURL: The base URL to use when contacting the service.
     */
    public init(
        username: String,
        password: String,
        version: String,
        serviceURL: String = "https://gateway.watsonplatform.net/conversation-experimental/api")
    {
        self.username = username
        self.password = password
        self.version = version
        self.serviceURL = serviceURL
    }
    
    /**
     If the given data represents an error returned by the Visual Recognition service, then return
     an NSError with information about the error that occured. Otherwise, return nil.
     
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func dataToError(data: NSData) -> NSError? {
        do {
            let json = try JSON(data: data)
            let error = try json.string("error")
            let code = (try? json.int("code")) ?? 400
            let userInfo = [NSLocalizedFailureReasonErrorKey: error]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }
    
    /**
     Get a response to a user's input.
     
     - parameter workspaceID: The unique identifier of the workspace to use.
     - parameter message: The user's input message.
     - parameter context: The context, or state, associated with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the conversation service's response.
     */
    public func message(
        workspaceID: WorkspaceID,
        message: String,
        context: JSON? = nil,
        failure: (NSError -> Void)? = nil,
        success: MessageResponse -> Void)
    {
        // construct body
        let messageRequest = MessageRequest(message: message, context: context)
        guard let body = try? messageRequest.toJSON().serialize() else {
            let failureReason = "MessageRequest could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v1/workspaces/\(workspaceID)/message",
            acceptType: "application/json",
            contentType: "application/json",
            userAgent: userAgent,
            queryParameters: queryParameters,
            messageBody: body
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject(dataToError: dataToError) {
                (response: Response<MessageResponse, NSError>) in
                switch response.result {
                case .Success(let response): success(response)
                case .Failure(let error): failure?(error)
                }
            }
    }
}
