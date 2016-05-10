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
import AlamofireObjectMapper
import ObjectMapper

public class Conversation: WatsonService {
    
    // The shared WatsonGateway singleton.
    let gateway = WatsonGateway.sharedInstance
    
    // The authentication strategy to obtain authorization tokens.
    let authStrategy: AuthenticationStrategy
    
    // TODO: comment this initializer
    public required init(authStrategy: AuthenticationStrategy) {
        self.authStrategy = authStrategy
    }
    
    // TODO: comment this initializer
    public convenience required init(username: String, password: String) {
        let authStrategy = BasicAuthenticationStrategy(tokenURL: Constants.tokenURL,
                                                       serviceURL: Constants.serviceURL, username: username, password: password)
        self.init(authStrategy: authStrategy)
    }
    
    public func sendText(workspaceID: WorkspaceID, context: [String : String]?, message: String! = nil,
                            completionHandler: (MessageResponse?, NSError?) -> Void) {
        
        let messageRequest = MessageRequest(message: message, context: context);
        
        let request = WatsonRequest(
            method: .POST,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.message(workspaceID),
            authStrategy: authStrategy,
            accept: .JSON,
            messageBody: messageRequest.toJSONData({ (error) in
                print(error)
            }));
        
        gateway.request(request, serviceError: ConversationError()) { data, error in
            let messageResponse = Mapper<MessageResponse>().mapData(data)
            completionHandler(messageResponse, error)
        }
    }
}