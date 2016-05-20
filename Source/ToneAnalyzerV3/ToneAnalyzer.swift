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

/**
 * The IBM Watson The Tone Analyzer service uses linguistic analysis to detect 
 * emotional tones, social propensities, and writing styles in written communication. 
 * Then it offers suggestions to help the writer improve their intended language tones.
**/
public class ToneAnalyzerV3 {
    
    private let username: String
    private let password: String
    private let versionDate: String
    
    private let serviceURL = "https://gateway.watsonplatform.net/tone-analyzer-beta/api"
    private let tokenURL = "https://gateway.watsonplatform.net/authorization/api/v1/token"
    private let errorDomain = "com.watsonplatform.toneanalyzer"
    
    /**
       Initializes the Watson Tone Analyzer service.
     
       - parameter username:    The username credential
       - parameter password:    The password credential
       - parameter versionDate: The release date of the version you wish to use of the service
                                in YYYY-MM-DD format
    */
    public init(username: String, password: String, versionDate: String) {
        self.username = username
        self.password = password
        self.versionDate = versionDate
    }
    
    private func dataToError(data: NSData) -> NSError? {
        do {
            let json = try JSON(data: data)
            let description = try json.string("description")
            let error = try json.string("error")
            let code = try json.int("code")
            let userInfo = [
                NSLocalizedFailureReasonErrorKey: error,
                NSLocalizedDescriptionKey: description
            ]
            return NSError(domain: errorDomain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }

    /**
       Analyzes the "tone" of a piece of text. The message is analyzed from several tones (social
       tone, emotional tone, writing tone), and for each of them various traits are derived (such as
       conscientiousness, agreeableness, openness).
     
     - parameter text:    The text to analyze
     - parameter failure: A function invoked when the service results in failure
     - parameter success: A function invoked when the service results in success
     */
    public func getTone(
        text: String,
        failure: (NSError -> Void)? = nil,
        success: ToneAnalysis -> Void)
    {
        // construct body
        guard let body = try? ["text": text].toJSON().serialize() else {
            let failureReason = "Classification text could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: errorDomain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v3/tone",
            acceptType: "application/json",
            contentType: "application/json",
            messageBody: body,
            queryParameters: [
                NSURLQueryItem(name: "version", value: versionDate)
            ]
        )
        
        // execute request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject(dataToError: dataToError) {
                (response: Response<ToneAnalysis, NSError>) in
                switch response.result {
                case .Success(let toneAnalysis): success(toneAnalysis)
                case .Failure(let error): failure?(error)
                }
            }
        
    }
    
}