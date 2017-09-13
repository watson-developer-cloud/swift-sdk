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
import RestKit

/**
 The Text to Speech service provides an API that uses IBM's speech-synthesis capabilities to
 synthesize text into natural-sounding speech in a variety of languages, accents, and voices. The
 service supports at least one male or female voice, sometimes both, for each language. The audio
 is streamed back to the client with minimal delay.
*/
public class TextToSpeech {
    
    /// The base URL to use when contacting the service.
    public var serviceURL = "https://stream.watsonplatform.net/text-to-speech/api"
    
    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()
    
    private let credentials: Credentials
    private let domain = "com.ibm.watson.developer-cloud.TextToSpeechV1"

    /**
     Create a `TextToSpeech` object.
     
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     */
    public init(username: String, password: String) {
        self.credentials = Credentials.basicAuthentication(username: username, password: password)
    }
    
    /**
     If the response or data represents an error returned by the Text to Speech service,
     then return NSError with information about the error that occured. Otherwise, return nil.
     
     - parameter response: the URL response returned from the service.
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func responseToError(response: HTTPURLResponse?, data: Data?) -> NSError? {
        
        // First check http status code in response
        if let response = response {
            if response.statusCode >= 200 && response.statusCode < 300 {
                return nil
            }
        }
        
        // ensure data is not nil
        guard let data = data else {
            if let code = response?.statusCode {
                return NSError(domain: domain, code: code, userInfo: nil)
            }
            return nil  // RestKit will generate error for this case
        }
        
        do {
            let json = try JSON(data: data)
            let code = response?.statusCode ?? 400
            let message = try json.getString(at: "error")
            var userInfo = [NSLocalizedFailureReasonErrorKey: message]
            let codeDescription = try? json.getString(at: "code_description")
            let description = try? json.getString(at: "description")
            if let recoverySuggestion = codeDescription ?? description {
                userInfo[NSLocalizedRecoverySuggestionErrorKey] = recoverySuggestion
            }
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
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([Voice]) -> Void)
    {
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/voices",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )
        
        // execute REST request
        request.responseArray(responseToError: responseToError, path: ["voices"]) {
            (response: RestResponse<[Voice]>) in
            switch response.result {
            case .success(let voices): success(voices)
            case .failure(let error): failure?(error)
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
        _ voice: String,
        customizationID: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Voice) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let customizationID = customizationID {
            queryParameters.append(URLQueryItem(name: "customization_id", value: customizationID))
        }
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/voices/\(voice)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Voice>) in
            switch response.result {
            case .success(let voice): success(voice)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Get the phonetic pronunciation for the given text.
     
     You can request the pronunciation for a specific format. You can also request the pronunciation
     for a specific voice to see the default translation of the language of that voice.
     
     - parameter of: The word for which the pronunciation is requested.
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
        of text: String,
        voice: String? = nil,
        format: PhonemeFormat? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Pronunciation) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "text", value: text))
        if let voice = voice {
            queryParameters.append(URLQueryItem(name: "voice", value: voice))
        }
        if let format = format {
            queryParameters.append(URLQueryItem(name: "format", value: format.rawValue))
        }
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/pronunciation",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Pronunciation>) in
            switch response.result {
            case .success(let voice): success(voice)
            case .failure(let error): failure?(error)
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
        _ text: String,
        voice: String? = nil,
        customizationID: String? = nil,
        audioFormat: AudioFormat = .wav,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Data) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "text", value: text))
        if let voice = voice {
            queryParameters.append(URLQueryItem(name: "voice", value: voice))
        }
        if let customizationID = customizationID {
            queryParameters.append(URLQueryItem(name: "customization_id", value: customizationID))
        }

        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/synthesize",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: audioFormat.rawValue,
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none:
                    if audioFormat == .wav {
                        // repair the WAV header
                        var wav = data
                        guard TextToSpeech.isWAVFile(data: wav) else {
                            let failureReason = "Returned audio is in an unexpected format."
                            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                            failure?(error)
                            return
                        }
                        TextToSpeech.repairWAVHeader(data: &wav)
                        success(wav)
                    } else if audioFormat == .opus {
                        do {
                            let decodedAudio = try TextToSpeechDecoder(audioData: data)
                            success(decodedAudio.pcmDataWithHeaders)
                        } catch {
                            let failureReason = "Returned audio is in an unexpected format."
                            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                            failure?(error)
                            return
                        }
                    } else {
                        success(data)
                    }
                }
            case .failure(let error):
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
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([Customization]) -> Void) {
        
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let language = language {
            queryParameters.append(URLQueryItem(name: "language", value: language))
        }
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/customizations",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseArray(responseToError: responseToError, path: ["customizations"]) {
            (response: RestResponse<[Customization]>) in
            switch response.result {
            case .success(let customizations): success(customizations)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Creates a new empty custom voice model that is owned by the requesting user.
     
     - parameter withName: The name of the new custom voice model.
     - parameter language: The language of the new custom voice model. 'en-US' is the default.
     - parameter description: A description of the new custom voice model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a customization ID.
     */
    public func createCustomization(
        withName name: String,
        language: String? = nil,
        description: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (CustomizationID) -> Void) {
        
        // construct the body
        var dict = ["name": name]
        if let language = language {
            dict["language"] = language
        }
        if let description = description {
            dict["description"] = description
        }
        
        guard let body = try? JSON(dictionary: dict).serialize() else {
            let failureReason = "Custom voice model metadata could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/customizations",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            messageBody: body
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<CustomizationID>) in
            switch response.result {
            case .success(let customizationID): success(customizationID)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Deletes the custom voice model with the specified customizationID.
     
     - parameter withID: The ID of the custom voice model to be deleted.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func deleteCustomization(
        withID customizationID: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil) {
        
        // construct REST request
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + "/v1/customizations/\(customizationID)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )
        
        // execute REST request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    /**
     Lists all information about the custom voice model with the specified customizationID.
     
     - parameter withID: The ID of the custom voice model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a CustomizationWords object.
     */
    public func getCustomization(
        withID customizationID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (CustomizationWords) -> Void) {
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/customizations/\(customizationID)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<CustomizationWords>) in
            switch response.result {
            case .success(let customizationWords): success(customizationWords)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Updates information for the custom voice model with the specified customizationID.

     You can update metadata of the custom voice model, such as the name and description of the 
     voice model. You can also update or add words and translations in the model.
     
     - parameter withID: The ID of the custom voice model to be updated.
     - parameter name: An updated name for the custom voice model.
     - parameter description: A new description for the custom voice model.
     - parameter words: An array of Word objects to be added to or updated in the custom voice model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func updateCustomization(
        withID customizationID: String,
        name: String? = nil,
        description: String? = nil,
        words: [Word] = [],
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil) {
        
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
            method: "POST",
            url: serviceURL + "/v1/customizations/\(customizationID)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            contentType: "application/json",
            messageBody: body
        )
        
        // execute the request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    /**
     Lists all of the words and their translations for the custom voice model with the specified
     customizationID.
     
     - parameter forCustomizationID: The ID of the custom voice model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with an array of Word objects.
     */
    public func getWords(
        forCustomizationID customizationID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([Word]) -> Void) {
        
        // construct the request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/customizations/\(customizationID)/words",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )
        
        // execute the request
        request.responseArray(responseToError: responseToError, path: ["words"]) {
            (response: RestResponse<[Word]>) in
            switch response.result {
            case .success(let words): success(words)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Adds one or more words and their translations to the custom voice model with the specified
     customizationID.
     
     - parameter toCustomizationID: The ID of the custom voice model to be updated.
     - parameter words: An array of Word objects to be added to the custom voice model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func addWords(
        toCustomizationID customizationID: String,
        fromArray words: [Word],
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil) {
        
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
            method: "POST",
            url: serviceURL + "/v1/customizations/\(customizationID)/words",
            credentials: credentials,
            headerParameters: defaultHeaders,
            contentType: "application/json",
            messageBody: body
        )
        
        // execute the request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    /**
     Deletes the specified word from custom voice model.
     
     - parameter word: The word to be deleted from the custom voice model.
     - parameter customizationID: The ID of the custom voice model to be updated.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func deleteWord(
        _ word: String,
        fromCustomizationID customizationID: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil) {
        
        // construct the request
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + "/v1/customizations/\(customizationID)/words/\(word)",
            credentials: credentials,
            headerParameters: defaultHeaders
        )
        
        // execute the request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    /**
     Lists the translation for a single word from the custom model with the specified customizationID.
     
     - parameter for: The word in the custom voice model whose translation should be listed.
     - parameter withCustomizationID: The ID of the custom voice model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with a Translation object.
     */
    public func getTranslation(
        for word: String,
        withCustomizationID customizationID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Translation) -> Void) {
        
        // construct the request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/customizations/\(customizationID)/words/\(word)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )
        
        // execute the request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Translation>) in
            switch response.result {
            case .success(let translation): success(translation)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Adds a single word and its translation to the custom voice model with the specified customizationID.
     
     - parameter word: The new word to be added to the custom voice model.
     - parameter toCustomizationID: The ID of the custom voice model to be updated.
     - parameter translation: The translation of the new word.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed if no error occurs.
     */
    public func addWord(
        _ word: String,
        toCustomizationID customizationID: String,
        withTranslation translation: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil) {
        
        // construct the body
        let dict = ["translation": translation]
        guard let body = try? JSON(dictionary: dict).serialize() else {
            let failureReason = "Translation request could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct the request
        let request = RestRequest(
            method: "PUT",
            url: serviceURL + "/v1/customizations/\(customizationID)/words/\(word)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            contentType: "application/json",
            messageBody: body
        )
        
        // execute the request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
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
    private static func dataToUTF8String(data: Data, offset: Int, length: Int) -> String? {
        let range = Range(uncheckedBounds: (lower: offset, upper: offset + length))
        let subdata = data.subdata(in: range)
        return String(data: subdata, encoding: String.Encoding.utf8)
    }
    
    /**
     Convert a little-endian byte buffer to a UInt32 integer.
     
     - parameter data: The byte buffer that contains a little-endian 32-bit unsigned integer.
     - parameter offset: The location within the byte buffer where the integer begins.
     
     - returns: An Int initialized by converting the given little-endian byte buffer into
            an unsigned 32-bit integer.
     */
    private static func dataToUInt32(data: Data, offset: Int) -> Int {
        var num: UInt8 = 0
        let length = 4
        let range = Range(uncheckedBounds: (lower: offset, upper: offset + length))
        data.copyBytes(to: &num, from: range)
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
    private static func isWAVFile(data: Data) -> Bool {
        
        // resources for WAV header format:
        // [1] http://unusedino.de/ec64/technical/formats/wav.html
        // [2] http://soundfile.sapp.org/doc/WaveFormat/
        
        let riffHeaderChunkIDOffset = 0
        let riffHeaderChunkIDSize = 4
        let riffHeaderChunkSizeOffset = 8
        let riffHeaderChunkSizeSize = 4
        let riffHeaderSize = 12

        guard data.count >= riffHeaderSize else {
            return false
        }
        
        let riffChunkID = dataToUTF8String(data: data, offset: riffHeaderChunkIDOffset, length: riffHeaderChunkIDSize)
        guard riffChunkID == "RIFF" else {
            return false
        }
        
        let riffFormat = dataToUTF8String(data: data, offset: riffHeaderChunkSizeOffset, length: riffHeaderChunkSizeSize)
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
    private static func repairWAVHeader(data: inout Data) {
        
        // resources for WAV header format:
        // [1] http://unusedino.de/ec64/technical/formats/wav.html
        // [2] http://soundfile.sapp.org/doc/WaveFormat/
        
        // update RIFF chunk size
        let fileLength = data.count
        var riffChunkSize = UInt32(fileLength - 8)
        let riffChunkSizeData = Data(bytes: &riffChunkSize, count: MemoryLayout<UInt32>.stride)
        data.replaceSubrange(Range(uncheckedBounds: (lower: 4, upper: 8)), with: riffChunkSizeData)
        
        // find data subchunk
        var subchunkID: String?
        var subchunkSize = 0
        var fieldOffset = 12
        let fieldSize = 4
        while true {
            // prevent running off the end of the byte buffer
            if fieldOffset + 2*fieldSize >= data.count {
                return
            }
            
            // read subchunk ID
            subchunkID = dataToUTF8String(data: data, offset: fieldOffset, length: fieldSize)
            fieldOffset += fieldSize
            if subchunkID == "data" {
                break
            }
            
            // read subchunk size
            subchunkSize = dataToUInt32(data: data, offset: fieldOffset)
            fieldOffset += fieldSize + subchunkSize
        }
        
        // compute data subchunk size (excludes id and size fields)
        var dataSubchunkSize = UInt32(data.count - fieldOffset - fieldSize)
        
        // update data subchunk size
        let dataSubchunkSizeData = Data(bytes: &dataSubchunkSize, count: MemoryLayout<UInt32>.stride)
        data.replaceSubrange(Range(uncheckedBounds: (lower: fieldOffset, upper: fieldOffset+fieldSize)), with: dataSubchunkSizeData)
    }
}
