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

/// Class that bridges to the Dialog service and will be moved into the Dialog SDK once V2 is finalized
class DialogService {
    
    private let serviceURL: String
    private let workspaceID: String
    private let session: NSURLSession
    private var auth: AuthenticationStrategy?
    
    init(serviceURL: String, workspaceID: String, username: String, password: String) {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let auth = BasicAuthenticationStrategy(
            tokenURL  : ConversationHelperConstants.gatewayTokenURL,
            serviceURL: ConversationHelperConstants.dialogServiceURL,
            username  : username,
            password  : password)
        
        let session = NSURLSession(configuration: config, delegate: auth, delegateQueue: nil)
        self.workspaceID = workspaceID
        self.session = session
        if (serviceURL.characters.last == "/" ) {
            self.serviceURL = String(serviceURL.characters.dropLast())
        }
        else {
            self.serviceURL = serviceURL
        }
    }
    
    init(serviceURL: String, workspaceID: String, authenticationStrategy: AuthenticationStrategy) {
        self.auth = authenticationStrategy
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config, delegate: auth as? NSURLSessionDelegate, delegateQueue: nil)
        self.workspaceID = workspaceID
        self.session = session
        if (serviceURL.characters.last == "/" ) {
            self.serviceURL = String(serviceURL.characters.dropLast())
        }
        else {
            self.serviceURL = serviceURL
        }
    }

    /**
     Send the given text message to Watson Engagement Advisor and receive a response.
     
     - parameter message: The text message to send. Watson Engagement Advisor will respond to this
     message.
     - parameter completionHandler: A function that will be executed with the response returned
     from the Watson Engagement Advisor, or an error if an error occured.
     */
    func sendText(message: String, tags: [String]? = nil, context: [String: String]? = nil, completionHandler: (ConversationMessageResponse?, NSError?) -> Void) {

        let messageRequest = MessageRequest(message: message, tags: tags, context: context)
        let request : RestRequest
        
        if let auth = auth {
            request = RestRequest(
                method: .POST,
                serviceURL: serviceURL,
                endpoint: ConversationHelperConstants.message(workspaceID),
                accept: .JSON,
                authStrategy: auth,
                contentType: .JSON,
                messageBody: messageRequest.toJSONData() { error in
                    completionHandler(nil, error)
                })
        }
        else {
            request = RestRequest(
                method: .POST,
                serviceURL: serviceURL,
                endpoint: ConversationHelperConstants.message(workspaceID),
                accept: .JSON,
                contentType: .JSON,
                messageBody: messageRequest.toJSONData() { error in
                    completionHandler(nil, error)
                })
        }

        let task = session.dataTaskWithRequest(request.urlRequest) { data, response, error in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            let httpResponse = (response as? NSHTTPURLResponse)!
            guard httpResponse.statusCode == 200 else {
                let statusError = NSError(domain: "", code: 0, userInfo: [httpResponse.statusCode: "Error \(httpResponse.statusCode)"])
                completionHandler(nil, statusError)
                return
            }
            
            print(String(data: data!, encoding: NSUTF8StringEncoding))
            
            let response = ConversationMessageResponse(data: data!)
            completionHandler(response, error)
        }
        task.resume()
    }
    
  
}


