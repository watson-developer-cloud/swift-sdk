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

    public enum DefinedVoiceType: String {
        case DE_GIRGIT      = "de-DE_BirgitVoice"
        case DE_DIETER      = "de-DE_DieterVoice"
        case GB_KATE        = "en-GB_KateVoice"
        case ES_Enrique     = "es-ES_EnriqueVoice"
        case US_Allison     = "en-US_AllisonVoice"
        case US_Lisa        = "en-US_LisaVoice"
        case US_Michael     = "en-US_MichaelVoice"
        case ES_Laura       = "es-ES_LauraVoice"
        case US_Sofia       = "es-US_SofiaVoice"
        case FR_Renee       = "fr-FR_ReneeVoice"
        case IT_Francesca   = "it-IT_FrancescaVoice"
        case JP_Emi         = "ja-JP_EmiVoice"
        case BR_Isabela     = "pt-BR_IsabelaVoice"
        
        public static let allValues = [DE_GIRGIT, DE_DIETER, GB_KATE, ES_Enrique, US_Allison, US_Lisa, US_Michael,
                                ES_Laura, US_Sofia, FR_Renee, IT_Francesca, JP_Emi, BR_Isabela]
    }
    
    public enum VoiceType {
        case Defined(DefinedVoiceType)
        case Custom(String)
    }
    
    public enum PhonemeFormat: String {
        case ipa = "ipa"
        case spr = "spr"
    }
    
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
            let queryParameter = NSURLQueryItem(name: "customization_id", value: "\(customizationID)")
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
    
    /**
     Returns the phonetic pronunciation for the word specified by the text query parameter. To get the 
     pronunciation in the phoneme set for a language other than that of the default voice, use the voice 
     query parameter. To get the pronunciation in IBM SPR format rather than the default IPA format, 
     use the format query parameter.
     
     - parameter text:      The word for which the pronunciation is requested
     - parameter voiceType: Specify a voice to obtain the pronunciation for the specified word in 
                            the language of that voice. Omit the parameter to obtain the pronunciation 
                            in the language of the default voice. Retrieve available voices with the 
                            GET /v1/voices method.
     - parameter format:    Specify the phoneme set in which to return the pronunciation. Omit the 
                            parameter to obtain the pronunciation in the default format.
     - parameter failure:   A function executed if an error occurs.
     - parameter success:   A function executed with a Pronunciation object found based on input criteria.
     */
    public func getPronunciation(
        text:String,
        voiceType:TextToSpeechV1.VoiceType? = nil,
        format: PhonemeFormat? = nil,
        failure: (NSError -> Void)? = nil,
        success: Pronunciation -> Void) {
        
        // voice to use in the query params
        var voice:String
        
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        
        let queryParameter = NSURLQueryItem(name: "text", value: "\(text)")
        queryParameters.append(queryParameter)
        
        if let voiceType = voiceType {
            
            // get the correct voice string
            switch voiceType {
            case VoiceType.Defined(let definedVoice):
                voice = definedVoice.rawValue
            case VoiceType.Custom(let customVoice):
                voice = customVoice
            }

            let queryParameter = NSURLQueryItem(name: "voice", value: "\(voice)")
            queryParameters.append(queryParameter)
        }
        
        if let format = format {
            let queryParameter = NSURLQueryItem(name: "format", value: "\(format)")
            queryParameters.append(queryParameter)
        }
        
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/pronunciation",
            acceptType: "application/json",
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject(dataToError: dataToError) {
                (response: Response<Pronunciation, NSError>) in
                switch response.result {
                case .Success(let voice): success(voice)
                case .Failure(let error): failure?(error)
                }
        }
    }
}

/*

 
 public ServiceCall<InputStream> synthesize(final String text, final Voice voice) {
 
 public ServiceCall<InputStream> synthesize(final String text, final Voice voice, final AudioFormat audioFormat) {
 
 */

