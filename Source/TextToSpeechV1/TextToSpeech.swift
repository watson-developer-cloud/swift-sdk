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
 The Text to Speech service provides an API that uses IBM's speech-synthesis capabilities to
 synthesize text into natural-sounding speech in a variety of languages, accents, and voices. The
 service supports at least one male or female voice, sometimes both, for each language. The audio
 is streamed back to the client with minimal delay.
*/
public class TextToSpeech {
    
    private let username: String
    private let password: String
    private let serviceURL: String
    private let userAgent = buildUserAgent("watson-apis-ios-sdk/0.6.0 TextToSpeechV1")
    private let domain = "com.ibm.watson.developer-cloud.TextToSpeechV1"

    /**
     Create a `TextToSpeech` object.
     
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter serviceURL: The base URL to use when contacting the service.
     */
    public init(
        username: String,
        password: String,
        serviceURL: String = "https://stream.watsonplatform.net/text-to-speech/api")
    {
        self.username = username
        self.password = password
        self.serviceURL = serviceURL
    }
    
    /**
     If the given data represents an error returned by the Text to Speech service, then return
     an NSError object with information about the error that occured. Otherwise, return nil.
 
     - parameter data: Raw data returned from the service that may represent an error.
     */
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
     Retrieve information about all available voices.
    
    - parameter failure: A function executed if an error occurs.
    - parameter success: A function executed with the available voices.
     */
    public func getVoices(
        failure: (NSError -> Void)? = nil,
        success: [Voice] -> Void)
    {
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/voices",
            acceptType: "application/json",
            userAgent: userAgent
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
     Get information about the given voice.
     
     Specify a `customizationID` to obtain information for that custom voice model of the specified
     voice. To see information about all available voices, use the `getVoices()` method.
     
     - parameter voice: The voice about which information is to be returned.
     - parameter customizationID: The GUID of a custom voice model about which information is to
            be returned. You must make the request with the service credentials of the model's
            owner. Omit the parameter to see information about the voice with no customization.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the given voice.
     */
    public func getVoice(
        voice: SynthesisVoice,
        customizationID: String? = nil,
        failure: (NSError -> Void)? = nil,
        success: Voice -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        if let customizationID = customizationID {
            let queryParameter = NSURLQueryItem(name: "customization_id", value: customizationID)
            queryParameters.append(queryParameter)
        }
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/voices/\(voice.description())",
            acceptType: "application/json",
            userAgent: userAgent,
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
     Get the phonetic pronunciation for the given text.
     
     You can request the pronunciation for a specific format. You can also request the pronunciation
     for a specific voice to see the default translation of the language of that voice.
     
     - parameter text: The word for which the pronunciation is requested
     - parameter voice: The voice in which the pronunciation for the specified word is to be
            returned. Specify a voice to obtain the pronunciation for the specified word in
            the language of that voice. Omit the parameter to obtain the pronunciation in the
            language of the default voice. Retrieve available voices with the `getVoices()` function.
     - parameter format: Specify the phoneme set in which to return the pronunciation. Omit the
            parameter to obtain the pronunciation in the default format.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a Pronunciation object found based on input
            criteria.
     */
    public func getPronunciation(
        text: String,
        voice: SynthesisVoice? = nil,
        format: PhonemeFormat? = nil,
        failure: (NSError -> Void)? = nil,
        success: Pronunciation -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "text", value: text))
        if let voice = voice {
            queryParameters.append(NSURLQueryItem(name: "voice", value: voice.description()))
        }
        if let format = format {
            queryParameters.append(NSURLQueryItem(name: "format", value: format.rawValue))
        }
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/pronunciation",
            acceptType: "application/json",
            userAgent: userAgent,
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
    
    /**
     Synthesize text to spoken audio.
 
     - parameter text: The text to be synthesized. Can be plain text or a subset of SSML.
     - parameter voice: The voice to be used for synthesis.
     - parameter customizationID: The GUID of a custom voice model to be used for the synthesis.
            If you specify a custom voice model, it is guaranteed to work only if it matches the
            language of the indicated voice. You must make the request with the service credentials
            of the model's owner. Omit the parameter to use the specified voice with no
            customization.
     - parameter audioFormat: The audio format in which the synthesized text should be returned.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the spoken audio.
     */
    public func synthesize(
        text: String,
        voice: SynthesisVoice? = nil,
        customizationID: String? = nil,
        audioFormat: AudioFormat = .WAV,
        failure: (NSError -> Void)? = nil,
        success: NSData -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "text", value: text))
        if let voice = voice {
            queryParameters.append(NSURLQueryItem(name: "voice", value: voice.description()))
        }
        if let customizationID = customizationID {
            queryParameters.append(NSURLQueryItem(name: "customization_id", value: customizationID))
        }

        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/synthesize",
            acceptType: audioFormat.rawValue,
            userAgent: userAgent,
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseData { response in
                switch response.result {
                case .Success(let data):
                    switch self.dataToError(data) {
                    case .Some(let error): failure?(error)
                    case .None:
                        if audioFormat == .WAV {
                            // repair the WAV header
                            let wav = NSMutableData(data: data)
                            guard TextToSpeech.isWAVFile(wav) else {
                                let failureReason = "Returned audio is in an unexpected format."
                                let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                                failure?(error)
                                return
                            }
                            TextToSpeech.repairWAVHeader(wav)
                            success(wav)
                        } else {
                            success(data)
                        }
                    }
                case .Failure(let error):
                    failure?(error)
                }
        }
        
    }
    
    // MARK: - Customizations
    
    /**
     Lists metadata, such as name and description, for the custom voice models that you own.
     
     You can use the language query parameter to list voice models for the specified language. If
     you leave language as nil, this will list all custom voice models you own for all languages.
     
     - parameter language: The language of the voice models that you want listed.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with an array of information about your custom voice 
            models.
     */
    public func getCustomizations(
        language: String? = nil,
        failure: (NSError -> Void)? = nil,
        success: [Customization] -> Void) {
        
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        if let language = language {
            queryParameters.append(NSURLQueryItem(name: "language", value: language))
        }
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/customizations",
            acceptType: "application/json",
            userAgent: userAgent,
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseArray(dataToError: dataToError, path: ["customizations"]) {
                (response: Response<[Customization], NSError>) in
                switch response.result {
                case .Success(let customizations): success(customizations)
                case .Failure(let error): failure?(error)
                }
        }
    }
    
    /**
     Creates a new empty custom voice model that is owned by the requesting user.
     
     - parameter name: The name of the new custom voice model.
     - parameter language: The language of the new custom voice model. 'en-US' is the default.
     - parameter description: A description of the new custom voice model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a customization ID.
     */
    public func createCustomization(
        name: String,
        language: String? = nil,
        description: String? = nil,
        failure: (NSError -> Void)? = nil,
        success: CustomizationID -> Void) {
        
        // construct the body
        var dict = ["name": name]
        if let language = language {
            dict["language"] = language
        }
        if let description = description {
            dict["description"] = description
        }
        
        guard let body = try? dict.toJSON().serialize() else {
            let failureReason = "Custom voice model metadata could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v1/customizations",
            acceptType: "application/json",
            contentType: "application/json",
            userAgent: userAgent,
            messageBody: body
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject(dataToError: dataToError) {
                (response: Response<CustomizationID, NSError>) in
                switch response.result {
                case .Success(let customizationID): success(customizationID)
                case .Failure(let error): failure?(error)
                }
        }
    }
    
    /**
     Deletes the custom voice model with the specified customizationID.
     
     - parameter customizationID: The ID of the custom voice model to be deleted.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func deleteCustomization(
        customizationID: String,
        failure: (NSError -> Void)? = nil,
        success: (Void -> Void)? = nil) {
        
        // construct REST request
        let request = RestRequest(
            method: .DELETE,
            url: serviceURL + "/v1/customizations/\(customizationID)",
            acceptType: "application/json",
            userAgent: userAgent
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseData { response in
                switch response.result {
                case .Success(let data):
                    switch self.dataToError(data) {
                    case .Some(let error): failure?(error)
                    case .None: success?()
                    }
                case .Failure(let error):
                    failure?(error)
                }
        }
    }
    
    /**
     Lists all information about the custom voice model with the specified customizationID.
     
     - parameter customizationID: The ID of the custom voice model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a CustomizationWords object.
     */
    public func getCustomization(
        customizationID: String,
        failure: (NSError -> Void)? = nil,
        success: CustomizationWords -> Void) {
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/customizations/\(customizationID)",
            acceptType: "application/json",
            userAgent: userAgent
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject(dataToError: dataToError) {
                (response: Response<CustomizationWords, NSError>) in
                switch response.result {
                case .Success(let customizationWords): success(customizationWords)
                case .Failure(let error): failure?(error)
                }
        }
    }
    
    /** 
     Updates information for the custom voice model with the specified customizationID.

     You can update metadata of the custom voice model, such as the name and description of the 
     voice model. You can also update or add words and translations in the model.
     
     - parameter customizationID: The ID of the custom voice model to be updated.
     - parameter name: An updated name for the custom voice model.
     - parameter description: A new description for the custom voice model.
     - parameter words: An array of Word objects to be added to or updated in the custom voice model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func updateCustomization(
        customizationID: String,
        name: String? = nil,
        description: String? = nil,
        words: [Word] = [],
        failure: (NSError -> Void)? = nil,
        success: (Void -> Void)? = nil) {
        
        // construct the body
        let customVoiceUpdate = CustomVoiceUpdate(name: name, description: description, words: words)
        guard let body = try? customVoiceUpdate.toJSON().serialize() else {
            let failureReason = "Translation request could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        // construct the request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v1/customizations/\(customizationID)",
            contentType: "application/json",
            userAgent: userAgent,
            messageBody: body
        )
        
        // execute the request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseData { response in
                switch response.result {
                case .Success(let data):
                    switch self.dataToError(data) {
                    case .Some(let error): failure?(error)
                    case .None: success?()
                    }
                case .Failure(let error):
                    failure?(error)
                }
        }
    }
    
    /**
     Lists all of the words and their translations for the custom voice model with the specified
     customizationID.
     
     - parameter customizationID: The ID of the custom voice model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with an array of Word objects.
     */
    public func getWords(
        customizationID: String,
        failure: (NSError -> Void)? = nil,
        success: [Word] -> Void) {
        
        // construct the request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/customizations/\(customizationID)/words",
            acceptType: "application/json",
            userAgent: userAgent
        )
        
        // execute the request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseArray(dataToError: dataToError, path: ["words"]) {
                (response: Response<[Word], NSError>) in
                switch response.result {
                case .Success(let words): success(words)
                case .Failure(let error): failure?(error)
                }
        }
    }
    
    /**
     Adds one or more words and their translations to the custom voice model with the specified
     customizationID.
     
     - parameter customizationID: The ID of the custom voice model to be updated.
     - parameter words: An array of Word objects to be added to the custom voice model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func addWords(
        customizationID: String,
        words: [Word],
        failure: (NSError -> Void)? = nil,
        success: (Void -> Void)? = nil) {
        
        // construct the body
        let customVoiceUpdate = CustomVoiceUpdate(words: words)
        guard let body = try? customVoiceUpdate.toJSON().serialize() else {
            let failureReason = "Translation request could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct the request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v1/customizations/\(customizationID)/words",
            contentType: "application/json",
            userAgent: userAgent,
            messageBody: body
        )
        
        // execute the request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseData { response in
                switch response.result {
                case .Success(let data):
                    switch self.dataToError(data) {
                    case .Some(let error): failure?(error)
                    case .None: success?()
                    }
                case .Failure(let error):
                    failure?(error)
                }
        }
    }
    
    /**
     Deletes the specified word from custom voice model.
     
     - parameter customizationID: The ID of the custom voice model to be updated.
     - parameter word: The word to be deleted from the custom voice model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func deleteWord(
        customizationID: String,
        word: String,
        failure: (NSError -> Void)? = nil,
        success: (Void -> Void)? = nil) {
        
        // construct the request
        let request = RestRequest(
            method: .DELETE,
            url: serviceURL + "/v1/customizations/\(customizationID)/words/\(word)",
            userAgent: userAgent
        )
        
        // execute the request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseData { response in
                switch response.result {
                case .Success(let data):
                    switch self.dataToError(data) {
                    case .Some(let error): failure?(error)
                    case .None: success?()
                    }
                case .Failure(let error):
                    failure?(error)
                }
        }
    }
    
    /**
     Lists the translation for a single word from the custom model with the specified customizationID.
     
     - parameter customizationID: The ID of the custom voice model.
     - parameter word: The word in the custom voice model whose translation should be listed.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a Translation object.
     */
    public func getTranslation(
        customizationID: String,
        word: String,
        failure: (NSError -> Void)? = nil,
        success: Translation -> Void) {
        
        // construct the request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/customizations/\(customizationID)/words/\(word)",
            acceptType: "application/json",
            userAgent: userAgent
        )
        
        // execute the request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject(dataToError: dataToError) {
                (response: Response<Translation, NSError>) in
                switch response.result {
                case .Success(let translation): success(translation)
                case .Failure(let error): failure?(error)
                }
        }
    }
    
    /**
     Adds a single word and its translation to the custom voice model with the specified customizationID.
     
     - parameter customizationID: The ID of the custom voice model to be updated.
     - parameter word: The new word to be added to the custom voice model.
     - parameter translation: The translation of the new word.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func addWord(
        customizationID: String,
        word: String,
        translation: String,
        failure: (NSError -> Void)? = nil,
        success: (Void -> Void)? = nil) {
        
        // construct the body
        let dict = ["translation": translation]
        guard let body = try? dict.toJSON().serialize() else {
            let failureReason = "Translation request could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct the request
        let request = RestRequest(
            method: .PUT,
            url: serviceURL + "/v1/customizations/\(customizationID)/words/\(word)",
            contentType: "application/json",
            userAgent: userAgent,
            messageBody: body
        )
        
        // execute the request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseData { response in
                switch response.result {
                case .Success(let data):
                    switch self.dataToError(data) {
                    case .Some(let error): failure?(error)
                    case .None: success?()
                    }
                case .Failure(let error):
                    failure?(error)
                }
        }
    }
    
    // MARK: - Internal methods
    
    /**
     Convert a big-endian byte buffer to a UTF-8 encoded string.
     
     - parameter data: The byte buffer that contains a big-endian UTF-8 encoded string.
     - parameter offset: The location within the byte buffer where the string begins.
     - parameter length: The length of the string (without a null-terminating character).
     
     - returns: A String initialized by converting the given big-endian byte buffer into
            Unicode characters using a UTF-8 encoding.
     */
    private static func dataToUTF8String(data: NSData, offset: Int, length: Int) -> String? {
        let range = NSMakeRange(offset, length)
        let subdata = data.subdataWithRange(range)
        return String(data: subdata, encoding: NSUTF8StringEncoding)
    }
    
    /**
     Convert a little-endian byte buffer to a UInt32 integer.
     
     - parameter data: The byte buffer that contains a little-endian 32-bit unsigned integer.
     - parameter offset: The location within the byte buffer where the integer begins.
     
     - returns: An Int initialized by converting the given little-endian byte buffer into
            an unsigned 32-bit integer.
     */
    private static func dataToUInt32(data: NSData, offset: Int) -> Int {
        var num: UInt32 = 0
        let length = 4
        let range = NSMakeRange(offset, length)
        data.getBytes(&num, range: range)
        return Int(num)
    }
    
    /**
     Returns true if the given data is a WAV-formatted audio file.
     
     To verify that the data is a WAV-formatted audio file, we simply check the "RIFF" chunk
     descriptor. That is, we verify that the "ChunkID" field is "RIFF" and the "Format" is "WAVE".
     Note that this does not require the "ChunkSize" to be valid and does not guarantee that any
     sub-chunks are valid.
     
     - parameter data: The byte buffer that may contain a WAV-formatted audio file.
     
     - returns: `true` if the given data is a WAV-formatted audio file; otherwise, false.
     */
    private static func isWAVFile(data: NSData) -> Bool {
        
        // resources for WAV header format:
        // [1] http://unusedino.de/ec64/technical/formats/wav.html
        // [2] http://soundfile.sapp.org/doc/WaveFormat/
        
        let riffChunkID = dataToUTF8String(data, offset: 0, length: 4)
        guard riffChunkID == "RIFF" else {
            return false
        }
        
        let riffFormat = dataToUTF8String(data, offset: 8, length: 4)
        guard riffFormat == "WAVE" else {
            return false
        }
        
        return true
    }
    
    /**
     Repair the WAV header for a WAV-formatted audio file produced by Watson Text to Speech.
     
     - parameter data: The WAV-formatted audio file produced by Watson Text to Speech. The
            byte data will be analyzed and repaired in-place.
     */
    private static func repairWAVHeader(data: NSMutableData) {
        
        // resources for WAV header format:
        // [1] http://unusedino.de/ec64/technical/formats/wav.html
        // [2] http://soundfile.sapp.org/doc/WaveFormat/
        
        // update RIFF chunk size
        let fileLength = data.length
        var riffChunkSize = UInt32(fileLength - 8)
        let riffChunkSizeRange = NSMakeRange(4, 4)
        data.replaceBytesInRange(riffChunkSizeRange, withBytes: &riffChunkSize)
        
        // find data subchunk
        var subchunkID: String?
        var subchunkSize = 0
        var fieldOffset = 12
        let fieldSize = 4
        while true {
            // prevent running off the end of the byte buffer
            if fieldOffset + 2*fieldSize >= data.length {
                return
            }
            
            // read subchunk ID
            subchunkID = dataToUTF8String(data, offset: fieldOffset, length: fieldSize)
            fieldOffset += fieldSize
            if subchunkID == "data" {
                break
            }
            
            // read subchunk size
            subchunkSize = dataToUInt32(data, offset: fieldOffset)
            fieldOffset += fieldSize + subchunkSize
        }
        
        // compute data subchunk size (excludes id and size fields)
        var dataSubchunkSize = UInt32(data.length - fieldOffset - fieldSize)
        
        // update data subchunk size
        let dataSubchunkSizeRange = NSMakeRange(fieldOffset, fieldSize)
        data.replaceBytesInRange(dataSubchunkSizeRange, withBytes: &dataSubchunkSize)
    }
}
