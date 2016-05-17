/************************************************************************/
/*                                                                      */
/* IBM Confidential                                                     */
/* OCO Source Materials                                                 */
/*                                                                      */
/* (C) Copyright IBM Corp. 2001, 2016                                   */
/*                                                                      */
/* The source code for this program is not published or otherwise       */
/* divested of its trade secrets, irrespective of what has been         */
/* deposited with the U.S. Copyright Office.                            */
/*                                                                      */
/************************************************************************/

import Foundation
import Alamofire
import Freddy

public class Conversation {
    
    /// A WorkspaceID uniquely identifies a dialog application.
    public typealias WorkspaceID = String
    
    private let username: String
    private let password: String
    
    private let domain = "com.ibm.watson.developer-cloud.WatsonDeveloperCloud"
    private let serviceURL = "https://gateway.watsonplatform.net/conversation/api"
    
    // TODO: comment this initializer
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    private func dataToError(data: NSData) -> NSError? {
        do {
            let json = try JSON(data: data)
            let error = try json.string("error")
            let code = try json.int("code")
            let userInfo = [NSLocalizedFailureReasonErrorKey: error]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }
    
    public func sendText(
        message:     String! = nil,
        context:     [String : JSON]?,
        workspaceID: WorkspaceID,
        failure:     (NSError -> Void)? = nil,
        success:     MessageResponse -> Void)
    {
        
        do {
        let messageRequest = MessageRequest(message: message, context: context)
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v1/workspaces/\(workspaceID)/message",
            acceptType: "application/json",
            contentType: "application/json",
            messageBody: try messageRequest.toJSON().serialize()
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
        catch {
            print("Could not serialize message request")
        }
    }
}