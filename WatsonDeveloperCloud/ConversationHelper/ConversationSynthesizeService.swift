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

// Class that bridges to the Watson TextToSpeech service
class ConversationSynthesizeService {
    
    private let tts: TextToSpeech
    private let session: NSURLSession
    
    init(username: String, password: String) {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let auth = BasicAuthenticationStrategy(tokenURL: ConversationHelperConstants.streamTokenURL, serviceURL: ConversationHelperConstants.ttsServiceURL, username: username, password: password)
        self.tts = TextToSpeech(username: username, password: password)
        let session = NSURLSession(configuration: config, delegate: auth, delegateQueue: nil)
        self.session = session
        
    }
    
    
    /**
     Send the given text message to Watson Engagement Advisor and receive an audio file of it.
     
     - parameter message: The text message to send. Watson Engagement Advisor will synthesize this message.
     - parameter completionHandler: A function that will be executed with the response returned
     from the Watson Engagement Advisor, or an error if an error occured.
     */
    func synthesizeText(message: String, completionHandler: (NSData?, NSError?) -> Void) {
        tts.synthesize(message, completionHandler: {data, error in
            
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            if let data = data {
                print(String(data: data, encoding: NSUTF8StringEncoding))
                completionHandler(data, error)
            }
        })
        
        
    }
}
