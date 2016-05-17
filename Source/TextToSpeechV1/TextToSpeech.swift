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

    public enum DefinedVoiceType: String, CustomStringConvertible {
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
        
        public var description : String {
            get {
                return self.rawValue
            }
        }
    }
    
    public enum VoiceType {
        case defined(DefinedVoiceType)
        case custom(String)
    }
    
    public enum PhonemeFormat: String {
        case ipa = "ipa"
        case spr = "spr"
    }
    
    // TODO: implement using other formats
    public enum AcceptFormat: String, CustomStringConvertible {
        case ogg  = "audio/ogg; codecs=opus"
        case wav  = "audio/wav"
        case flac = "audio/flac"
        public var description : String {
            get {
                return self.rawValue
            }
        }
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
            voice = getVoiceString(voiceType)
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
    
    public func synthesize(
        text:String,
        accept:AcceptFormat,
        voiceType:TextToSpeechV1.VoiceType? = nil,
        customizationID:String? = nil,
        format: PhonemeFormat? = nil,
        failure: (NSError -> Void)? = nil,
        success: NSData -> Void) {
        
        // voice to use in the query params
        var voice:String
        
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        
        let queryParameter = NSURLQueryItem(name: "text", value: "\(text)")

        queryParameters.append(queryParameter)
        
        if let voiceType = voiceType {
            voice = getVoiceString(voiceType)
            let queryParameter = NSURLQueryItem(name: "voice", value: "\(voice)")
            queryParameters.append(queryParameter)
        }
        
        if let customizationID = customizationID {
            let queryParameter = NSURLQueryItem(name: "customization_id", value: "\(customizationID)")
            queryParameters.append(queryParameter)
        }
        
        if let format = format {
            let queryParameter = NSURLQueryItem(name: "format", value: "\(format)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/synthesize",
            acceptType: accept.description,
            queryParameters: queryParameters
        )
        
        //TODO Update with other formats instead of forcing it to go through wav sanitizer
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseData { response in
                switch response.result {
                case .Success(let data):
                    switch self.dataToError(data) {
                    case .Some(let error): failure?(error)
                    case .None:
                        let wav = NSMutableData(data: data)
                        guard TextToSpeechV1.isWAVFile(wav) else {
                            let failureReason = "Returned audio is in an unexpected format."
                            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                            failure?(error)
                            return
                        }
                        TextToSpeechV1.repairWAVHeader(wav)
                        success(wav)
                    }
                case .Failure(let error):
                    failure?(error)
                }
        }
        
    }
    
    private func getVoiceString(voiceType: VoiceType) -> String {
        
        var voice = ""
        
        // get the correct voice string
        switch voiceType {
        case VoiceType.defined(let definedVoice):
            voice = definedVoice.description
        case VoiceType.custom(let customVoice):
            voice = customVoice
        }
        return voice
    }
    
    /**
     This helper method converts a PCM of UInt16s produced by the Opus codec
     to a WAVE file by prepending a WAVE header.
     
     - parameter data: Contains PCM (pulse coded modulation) raw data for audio
     - returns:        WAVE formatted header prepended to the data
     **/
    private func addWaveHeader(data: NSData) -> NSData {
        
        let headerSize: Int = 44
        let totalAudioLen: Int = data.length
        let totalDataLen: Int = totalAudioLen + headerSize - 8
        let longSampleRate: Int = 48000
        let channels = 1
        let byteRate = 16 * 11025 * channels / 8
        
        let byteArray = [UInt8]("RIFF".utf8)
        let byteArray2 = [UInt8]("WAVEfmt ".utf8)
        let byteArray3 = [UInt8]("data".utf8)
        var header : [UInt8] = [UInt8](count: 44, repeatedValue: 0)
        
        header[0] = byteArray[0]
        header[1] = byteArray[1]
        header[2] = byteArray[2]
        header[3] = byteArray[3]
        header[4] = (UInt8) (totalDataLen & 0xff)
        header[5] = (UInt8) ((totalDataLen >> 8) & 0xff)
        header[6] = (UInt8) ((totalDataLen >> 16) & 0xff)
        header[7] = (UInt8) ((totalDataLen >> 24) & 0xff)
        header[8] = byteArray2[0]
        header[9] = byteArray2[1]
        header[10] = byteArray2[2]
        header[11] = byteArray2[3]
        header[12] = byteArray2[4]
        header[13] = byteArray2[5]
        header[14] = byteArray2[6]
        header[15] = byteArray2[7]
        header[16] = 16
        header[17] = 0
        header[18] = 0
        header[19] = 0
        header[20] = 1
        header[21] = 0
        header[22] = (UInt8) (channels)
        header[23] = 0
        header[24] = (UInt8) (longSampleRate & 0xff)
        header[25] = (UInt8) ((longSampleRate >> 8) & 0xff)
        header[26] = (UInt8) ((longSampleRate >> 16) & 0xff)
        header[27] = (UInt8) ((longSampleRate >> 24) & 0xff)
        header[28] = (UInt8) (byteRate & 0xff)
        header[29] = (UInt8) (byteRate >> 8 & 0xff)
        header[30] = (UInt8) (byteRate >> 16 & 0xff)
        header[31] = (UInt8) (byteRate >> 24 & 0xff)
        header[32] = (UInt8) (2 * 8 / 8)
        header[33] = 0
        header[34] = 16 // bits per sample
        header[35] = 0
        header[36] = byteArray3[0]
        header[37] = byteArray3[1]
        header[38] = byteArray3[2]
        header[39] = byteArray3[3]
        header[40] = (UInt8) (totalAudioLen & 0xff)
        header[41] = (UInt8) (totalAudioLen >> 8 & 0xff)
        header[42] = (UInt8) (totalAudioLen >> 16 & 0xff)
        header[43] = (UInt8) (totalAudioLen >> 24 & 0xff)
        
        let newWavData = NSMutableData(bytes: header, length: 44)
        newWavData.appendData(data)
        
        return newWavData
    }
    
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
