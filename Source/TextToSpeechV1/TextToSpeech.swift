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

/**
 The IBM® Text to Speech service provides an API that uses IBM's speech-synthesis capabilities to
 synthesize text into natural-sounding speech in a variety of languages, accents, and voices. The
 service supports at least one male or female voice, sometimes both, for each language. The audio is
 streamed back to the client with minimal delay.
*/
public class TextToSpeechV1 {
    
    private let username: String
    private let password: String
    
    private let domain = "com.ibm.watson.developer-cloud.WatsonDeveloperCloud"
    private let serviceURL = "https://stream.watsonplatform.net/text-to-speech/api"
    
    /**
     Initializes the Watson Text to Speech Service.
     
     - parameter username:    The username credential
     - parameter password:    The password credential
     - parameter versionDate: The release date of the version you wish to use of the service
     in YYYY-MM-DD format
     */
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    private func dataToError(data: NSData) -> NSError? {
        do {
            let json = try JSON(data: data)
            let error = try json.string("error")
            let code = try json.int("code")
            let description = try json.string("code_description")
            let userInfo = [
                NSLocalizedFailureReasonErrorKey: error,
                NSLocalizedRecoverySuggestionErrorKey: description
            ]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }
    
    /**
     Retrieves an array of voices that are avaialable
    
    - parameter failure: A function executed if an error occurs.
    - parameter success: A function executed with an array of available voice objects.
     */
    public func getVoices(
        failure: (NSError -> Void)? = nil,
        success: [Voice] -> Void) {
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/voices",
            acceptType: "application/json"
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseArray(dataToError: dataToError, path: ["voices"]) {
                (response: Response<[Voice], NSError>) in
                switch response.result {
                case .Success(let voices): success(voices)
                case .Failure(let error): failure?(error)
                }
        }
    }
    
    /**
     Lists information about the voice specified with the voice path parameter. Specify the 
     customization_id query parameter to obtain information for that custom voice model of the 
     specified voice. Use the /v1/voices method to see a list of all available voices.
     
     - parameter voice: The name of the voice. Use this value as the voice identifier
     - parameter customizationID: GUID of the custom voice
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a Voice object found based on input criteria.
     */
    public func getVoice(
        voice:String,
        customizationID: String? = nil,
        failure: (NSError -> Void)? = nil,
        success: Voice -> Void) {
        
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        if let customizationID = customizationID {
            let queryParameter = NSURLQueryItem(name: "include_raw", value: "\(customizationID)")
            queryParameters.append(queryParameter)
        }
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/voices/\(voice)",
            acceptType: "application/json",
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject(dataToError: dataToError) {
                (response: Response<Voice, NSError>) in
                switch response.result {
                case .Success(let voice): success(voice)
                case .Failure(let error): failure?(error)
                }
        }
    }
    
}

/*
 
 public ServiceCall<List<Voice>> getVoices()
 
 public ServiceCall<Pronunciation> getPronunciation(String word, Voice voice, Phoneme phoneme) {
 
 public ServiceCall<InputStream> synthesize(final String text, final Voice voice) {
 
 public ServiceCall<InputStream> synthesize(final String text, final Voice voice, final AudioFormat audioFormat) {
 
 */

