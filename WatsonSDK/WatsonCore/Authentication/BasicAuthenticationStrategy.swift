/**
 * Copyright IBM Corporation 2015
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

/**
* BasicAuthenticationStrategy is an example implementation of obtaining a Watson token
* using basic authentication. A username and password pair that is generated automatically 
* for each Watson service in a Bluemix app. The strategy goes to the token service to request
* a token, and returns a temporary token valid for 1 hour. 
*
* WARNING: This authentication strategy has some serious security flaws in that if a username and 
* password are bundled in an App distribution, they can be munged by third parties to have the 
* information to generate new Watson keys and subsequent queries without limitation.
*/
public class BasicAuthenticationStrategy : AuthenticationStrategy {
    
    let username: String!
    let password: String!
    let serviceURL: String!
    let tokenURL: String!
    
    public var token: String?
    
    /**
     Creates a Basic Authentication handler that will request a token from the server. Requires 
     the URL for the token granter and the corresponsing service as well as the username and password
     pair.
     
     - parameter tokenURL:   URL for the granter of the token
     - parameter serviceURL: URL for the targetting service of the token
     - parameter username:   Watson basic auth username
     - parameter password:   Watson basic auth password
     
     */
    public init(tokenURL: String, serviceURL: String, username: String, password: String) {
        
        self.username = username
        self.password = password
        self.tokenURL = tokenURL
        self.serviceURL = serviceURL
        
    }
    
    /**
     getToken uses the username and password and fetches a temporary token from the
     Watson key generator at tokenURL.
     
     - parameter completionHandler: callback for when a token has been obtained
     - parameter error:           an error in case the token could not be obtained.
     */
    public func getToken(completionHandler: (token: String?, error: NSError?)->Void) {
        
        
        if token != nil {
            
            completionHandler(token: token, error: nil)
            
        }
        

        let authorizationString = username + ":" + password
        let apiKey = "Basic " + (authorizationString.dataUsingEncoding(NSASCIIStringEncoding)?
            .base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding76CharacterLineLength))!
        
        NetworkUtils.requestAuthToken(tokenURL, serviceURL: serviceURL,
            apiKey: apiKey, completionHandler: {
                
                token, error in
                
                Log.sharedLogger.info("Token received was \(token)")
                
                self.token = token
                
                completionHandler(token: token, error: error)
        })

        
    }
    
    

    
}