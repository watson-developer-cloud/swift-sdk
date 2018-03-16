/**
 * Copyright IBM Corporation 2018
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
 ### Service Overview
 The IBM Text to Speech service provides a Representational State Transfer (REST) Application Programming Interface
 (API) that uses IBM's speech-synthesis capabilities to synthesize text into natural-sounding speech in a variety of
 languages, dialects, and voices. The service currently synthesizes text from US English, UK English, French, German,
 Italian, Japanese, Spanish, or Brazilian Portuguese into audio spoken in a male or female voice (the service supports
 only a single gender for some languages). The audio is streamed back to the client with minimal delay.
 ### API Overview
 The Text to Speech service consists of the following related endpoints:
 * `/v1/voices` provides information about the voices available for synthesized speech.
 * `/v1/synthesize` synthesizes written text to audio speech.
 * `/v1/pronunciation` returns the pronunciation for a specified word. The `/v1/pronunciation` method is currently beta
 functionality.
 * `/v1/customizations` and `/v1/customizations/{customization_id}` lets users create custom voice models, which are
 dictionaries of words and their translations for use in speech synthesis. All `/v1/customizations` methods are
 currently beta functionality.
 * `/v1/customizations/{customization_id}/words` and `/v1/customizations/{customization_id}/words/{word}` lets users
 manage the words in a custom voice model.


 **Note about the Try It Out feature:** The `Try it out!` button lets you experiment with the methods of the API by
 making actual cURL calls to the service. The feature is **not** supported for use with the `POST /v1/synthesize`
 method. For examples of calls to this method, see the [Text to Speech API
 reference](http://www.ibm.com/watson/developercloud/text-to-speech/api/v1/).
 ### API Usage
 The following information provides details about using the service to synthesize audio:
 * **Audio formats:** The service supports a number of audio formats (MIME types). For more information about audio
 formats and sampling rates, including links to a number of Internet sites that provide technical and usage details
 about the different formats, see [Specifying an audio
 format](https://console.bluemix.net/docs/services/text-to-speech/http.html#format).
 * **SSML:** Many methods refer to the Speech Synthesis Markup Language (SSML), an XML-based markup language that
 provides annotations of text for speech-synthesis applications; for example, many methods accept or produce
 translations that use an SSML-based phoneme format. See [Using
 SSML](https://console.bluemix.net/docs/services/text-to-speech/SSML.html) and [Using IBM
 SPR](https://console.bluemix.net/docs/services/text-to-speech/SPRs.html).
 * **Word translations:** Many customization methods accept or return sounds-like or phonetic translations for words. A
 phonetic translation is based on the SSML format for representing the phonetic string of a word. Phonetic translations
 can use standard International Phonetic Alphabet (IPA) representation:

  &lt;phoneme alphabet="ipa" ph="t&#601;m&#712;&#593;to"&gt;&lt;/phoneme&gt;

  or the proprietary IBM Symbolic Phonetic Representation (SPR):

  &lt;phoneme alphabet="ibm" ph="1gAstroEntxrYFXs"&gt;&lt;/phoneme&gt;

 For more information about customization and about sounds-like and phonetic translations, see [Understanding
 customization](https://console.bluemix.net/docs/services/text-to-speech/custom-intro.html).
 * **GUIDs:** The pronunciation and customization methods accept or return a Globally Unique Identifier (GUID). For
 example, customization IDs (specified with the `customization_id` parameter) and service credentials are GUIDs. GUIDs
 are hexadecimal strings that have the format `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.
 * **WebSocket interface:** The service also offers a WebSocket interface as an alternative to its HTTP REST interface
 for speech synthesis. The WebSocket interface supports both plain text and SSML input, including the SSML &lt;mark&gt;
 element and word timings. See [The WebSocket
 interface](https://console.bluemix.net/docs/services/text-to-speech/websockets.html).
 * **Authentication:** You authenticate to the service by using your service credentials. You can use your credentials
 to authenticate via a proxy server that resides in IBM Cloud, or you can use your credentials to obtain a token and
 contact the service directly. See [Service credentials for Watson
 services](https://console.bluemix.net/docs/services/watson/getting-started-credentials.html) and [Tokens for
 authentication](https://console.bluemix.net/docs/services/watson/getting-started-tokens.html).
 * **Custom voice model ownership:** In all cases, you must use service credentials created for the instance of the
 service that owns a custom voice model to use the methods described in this documentation with that model. For more
 information, see [Ownership of custom voice
 models](https://console.bluemix.net/docs/services/text-to-speech/custom-models.html#customOwner).
 * **Request Logging:** By default, all Watson services log requests and their results. Data is collected only to
 improve the Watson services. If you do not want to share your data, set the header parameter
 `X-Watson-Learning-Opt-Out` to `true` for each request. Data is collected for any request that omits this header. See
 [Controlling request logging for Watson
 services](https://console.bluemix.net/docs/services/watson/getting-started-logging.html).

 The service does not log data (words and translations) that are used to build custom language models; your training
 data is never used to improve the service's base models. The service does log data when a custom model is used with a
 synthesize request; you must set the `X-Watson-Learning-Opt-Out` request header to prevent logging for recognition
 requests. For more information, see [Request logging and data
 privacy](https://console.bluemix.net/docs/services/text-to-speech/custom-models.html#customLogging).

 For more information about the service and its various interfaces, see [About Text to
 Speech](https://console.bluemix.net/docs/services/text-to-speech/index.html).
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
        self.credentials = .basicAuthentication(username: username, password: password)
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
            if (200..<300).contains(response.statusCode) {
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
            let json = try JSONWrapper(data: data)
            let code = response?.statusCode ?? 400
            let error = try json.getString(at: "error")
            let codeDescription = try? json.getString(at: "code_description")
            let userInfo = [
                NSLocalizedDescriptionKey: error,
                NSLocalizedFailureReasonErrorKey: codeDescription ?? "",
            ]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }

    /**
     Retrieves a specific voice available for speech synthesis.

     Lists information about the voice specified with the `voice` path parameter. Specify the `customization_id` query
     parameter to obtain information for that custom voice model of the specified voice. Use the `GET /v1/voices` method
     to see a list of all available voices.

     - parameter voice: The voice for which information is to be returned. Retrieve available voices with the `GET /v1/voices` method.
     - parameter customizationID: The GUID of a custom voice model for which information is to be returned. You must make the request with service credentials created for the instance of the service that owns the custom model. Omit the parameter to see information about the specified voice with no customization.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func getVoice(
        voice: String,
        customizationID: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Voice) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let customizationID = customizationID {
            let queryParameter = URLQueryItem(name: "customization_id", value: customizationID)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/voices/\(voice)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: queryParameters,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Voice>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Retrieves all voices available for speech synthesis.

     Lists information about all available voices. To see information about a specific voice, use the `GET
     /v1/voices/{voice}` method.

     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func listVoices(
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Voices) -> Void)
    {
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/voices",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: nil,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Voices>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Streaming speech synthesis of the text in the body parameter.

     Synthesizes text to spoken audio, returning the synthesized audio stream as an array of bytes. Identical to the
     `GET` method but passes longer text in the body of the request, not with the URL. Text size is limited to 5 KB.
     (For the `audio/l16` format, you can optionally specify `endianness=big-endian` or `endianness=little-endian`; the
     default is little endian.)   If a request includes invalid query parameters, the service returns a `Warnings`
     response header that provides messages about the invalid parameters. The warning includes a descriptive message and
     a list of invalid argument strings. For example, a message such as `\"Unknown arguments:\"` or `\"Unknown url query
     arguments:\"` followed by a list of the form `\"invalid_arg_1, invalid_arg_2.\"` The request succeeds despite the
     warnings.   **Note about the Try It Out feature:** The `Try it out!` button is **not** supported for use with the
     the `POST /v1/synthesize` method. For examples of calls to the method, see the [Text to Speech API
     reference](http://www.ibm.com/watson/developercloud/text-to-speech/api/v1/).

     - parameter text: The text to synthesize.
     - parameter accept: The type of the response: audio/basic, audio/flac, audio/l16;rate=nnnn, audio/ogg, audio/ogg;codecs=opus, audio/ogg;codecs=vorbis, audio/mp3, audio/mpeg, audio/mulaw;rate=nnnn, audio/wav, audio/webm, audio/webm;codecs=opus, or audio/webm;codecs=vorbis.
     - parameter voice: The voice to use for synthesis. Retrieve available voices with the `GET /v1/voices` method.
     - parameter customizationID: The GUID of a custom voice model to use for the synthesis. If a custom voice model is specified, it is guaranteed to work only if it matches the language of the indicated voice. You must make the request with service credentials created for the instance of the service that owns the custom model. Omit the parameter to use the specified voice with no customization.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func synthesize(
        text: String,
        accept: String? = nil,
        voice: String? = nil,
        customizationID: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Data) -> Void)
    {
        // construct body
        let synthesizeRequest = Text(text: text)
        guard let body = try? JSONEncoder().encode(synthesizeRequest) else {
            failure?(RestError.serializationError)
            return
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let voice = voice {
            let queryParameter = URLQueryItem(name: "voice", value: voice)
            queryParameters.append(queryParameter)
        }
        if let customizationID = customizationID {
            let queryParameter = URLQueryItem(name: "customization_id", value: customizationID)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/synthesize",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: accept,
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none:
                    if accept?.lowercased().contains("audio/wav") == true {
                        // repair the WAV header
                        var wav = data
                        guard WAVRepair.isWAVFile(data: wav) else {
                            let failureReason = "Returned audio is in an unexpected format."
                            let userInfo = [NSLocalizedDescriptionKey: failureReason]
                            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                            failure?(error)
                            return
                        }
                        WAVRepair.repairWAVHeader(data: &wav)
                        success(wav)
                    } else if accept?.lowercased().contains("ogg") == true && accept?.lowercased().contains("opus") == true {
                        do {
                            let decodedAudio = try TextToSpeechDecoder(audioData: data)
                            success(decodedAudio.pcmDataWithHeaders)
                        } catch {
                            let failureReason = "Returned audio is in an unexpected format."
                            let userInfo = [NSLocalizedDescriptionKey: failureReason]
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

    /**
     Gets the pronunciation for a word.

     Returns the phonetic pronunciation for the word specified by the `text` parameter. You can request the
     pronunciation for a specific format. You can also request the pronunciation for a specific voice to see the default
     translation for the language of that voice or for a specific custom voice model to see the translation for that
     voice model.   **Note:** This method is currently a beta release.

     - parameter text: The word for which the pronunciation is requested.
     - parameter voice: A voice that specifies the language in which the pronunciation is to be returned. All voices for the same language (for example, `en-US`) return the same translation. Retrieve available voices with the `GET /v1/voices` method.
     - parameter format: The phoneme format in which to return the pronunciation. Omit the parameter to obtain the pronunciation in the default format.
     - parameter customizationID: The GUID of a custom voice model for which the pronunciation is to be returned. The language of a specified custom model must match the language of the specified voice. If the word is not defined in the specified custom model, the service returns the default translation for the custom model's language. You must make the request with service credentials created for the instance of the service that owns the custom model. Omit the parameter to see the translation for the specified voice with no customization.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func getPronunciation(
        text: String,
        voice: String? = nil,
        format: String? = nil,
        customizationID: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Pronunciation) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "text", value: text))
        if let voice = voice {
            let queryParameter = URLQueryItem(name: "voice", value: voice)
            queryParameters.append(queryParameter)
        }
        if let format = format {
            let queryParameter = URLQueryItem(name: "format", value: format)
            queryParameters.append(queryParameter)
        }
        if let customizationID = customizationID {
            let queryParameter = URLQueryItem(name: "customization_id", value: customizationID)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/pronunciation",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: queryParameters,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Pronunciation>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Creates a new custom voice model.

     Creates a new empty custom voice model. The model is owned by the instance of the service whose credentials are
     used to create it.   **Note:** This method is currently a beta release.

     - parameter name: The name of the new custom voice model.
     - parameter language: The language of the new custom voice model. Omit the parameter to use the the default language, `en-US`.
     - parameter description: A description of the new custom voice model. Specifying a description is recommended.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func createVoiceModel(
        name: String,
        language: String? = nil,
        description: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (VoiceModel) -> Void)
    {
        // construct body
        let createVoiceModelRequest = CreateVoiceModel(name: name, language: language, description: description)
        guard let body = try? JSONEncoder().encode(createVoiceModelRequest) else {
            failure?(RestError.serializationError)
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
            queryItems: nil,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<VoiceModel>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Deletes a custom voice model.

     Deletes the custom voice model with the specified `customization_id`. You must use credentials for the instance of
     the service that owns a model to delete it.   **Note:** This method is currently a beta release.

     - parameter customizationID: The GUID of the custom voice model that is to be deleted. You must make the request with service credentials created for the instance of the service that owns the custom model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func deleteVoiceModel(
        customizationID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct REST request
        let path = "/v1/customizations/\(customizationID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: defaultHeaders,
            queryItems: nil,
            messageBody: nil
        )

        // execute REST request
        request.responseVoid(responseToError: responseToError) {
            (response: RestResponse) in
            switch response.result {
            case .success: success()
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Queries the contents of a custom voice model.

     Lists all information about the custom voice model with the specified `customization_id`. In addition to metadata
     such as the name and description of the voice model, the output includes the words in the model and their
     translations as defined in the model. To see just the metadata for a voice model, use the `GET /v1/customizations`
     method. You must use credentials for the instance of the service that owns a model to list information about it.
     **Note:** This method is currently a beta release.

     - parameter customizationID: The GUID of the custom voice model that is to be queried. You must make the request with service credentials created for the instance of the service that owns the custom model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func getVoiceModel(
        customizationID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (VoiceModel) -> Void)
    {
        // construct REST request
        let path = "/v1/customizations/\(customizationID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: nil,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<VoiceModel>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Lists all available custom voice models for a language or for all languages.

     Lists metadata such as the name and description for the custom voice models that you own. Use the `language` query
     parameter to list the voice models that you own for the specified language only. Omit the parameter to see all
     voice models that you own for all languages. To see the words in addition to the metadata for a specific voice
     model, use the `GET /v1/customizations/{customization_id}` method. You must use credentials for the instance of the
     service that owns a model to list information about it.   **Note:** This method is currently a beta release.

     - parameter language: The language for which custom voice models that are owned by the requesting service credentials are to be returned. Omit the parameter to see all custom voice models that are owned by the requester.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func listVoiceModels(
        language: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (VoiceModels) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let language = language {
            let queryParameter = URLQueryItem(name: "language", value: language)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/customizations",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: queryParameters,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<VoiceModels>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Updates information and words for a custom voice model.

     Updates information for the custom voice model with the specified `customization_id`. You can update the metadata
     such as the name and description of the voice model. You can also update the words in the model and their
     translations. Adding a new translation for a word that already exists in a custom model overwrites the word's
     existing translation. A custom model can contain no more than 20,000 entries. You must use credentials for the
     instance of the service that owns a model to update it.   **Note:** This method is currently a beta release.

     - parameter customizationID: The GUID of the custom voice model that is to be updated. You must make the request with service credentials created for the instance of the service that owns the custom model.
     - parameter name: A new name for the custom voice model.
     - parameter description: A new description for the custom voice model.
     - parameter words: An array of words and their translations that are to be added or updated for the custom voice model. Pass an empty array to make no additions or updates.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func updateVoiceModel(
        customizationID: String,
        name: String? = nil,
        description: String? = nil,
        words: [Word]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct body
        let updateVoiceModelRequest = UpdateVoiceModel(name: name, description: description, words: words)
        guard let body = try? JSONEncoder().encode(updateVoiceModelRequest) else {
            failure?(RestError.serializationError)
            return
        }

        // construct REST request
        let path = "/v1/customizations/\(customizationID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: defaultHeaders,
            contentType: "application/json",
            queryItems: nil,
            messageBody: body
        )

        // execute REST request
        request.responseVoid(responseToError: responseToError) {
            (response: RestResponse) in
            switch response.result {
            case .success: success()
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Adds a word to a custom voice model.

     Adds a single word and its translation to the custom voice model with the specified `customization_id`. Adding a
     new translation for a word that already exists in a custom model overwrites the word's existing translation. A
     custom model can contain no more than 20,000 entries. You must use credentials for the instance of the service that
     owns a model to add a word to it.   **Note:** This method is currently a beta release.

     - parameter customizationID: The GUID of the custom voice model that is to be updated. You must make the request with service credentials created for the instance of the service that owns the custom model.
     - parameter word: The word that is to be added or updated for the custom voice model.
     - parameter translation: The phonetic or sounds-like translation for the word. A phonetic translation is based on the SSML format for representing the phonetic string of a word either as an IPA translation or as an IBM SPR translation. A sounds-like is one or more words that, when combined, sound like the word.
     - parameter partOfSpeech: **Japanese only.** The part of speech for the word. The service uses the value to produce the correct intonation for the word. You can create only a single entry, with or without a single part of speech, for any word; you cannot create multiple entries with different parts of speech for the same word. For more information, see [Working with Japanese entries](https://console.bluemix.net/docs/services/text-to-speech/custom-rules.html#jaNotes).
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func addWord(
        customizationID: String,
        word: String,
        translation: String,
        partOfSpeech: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct body
        let addWordRequest = Translation(translation: translation, partOfSpeech: partOfSpeech)
        guard let body = try? JSONEncoder().encode(addWordRequest) else {
            failure?(RestError.serializationError)
            return
        }

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words/\(word)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "PUT",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: defaultHeaders,
            contentType: "application/json",
            queryItems: nil,
            messageBody: body
        )

        // execute REST request
        request.responseVoid(responseToError: responseToError) {
            (response: RestResponse) in
            switch response.result {
            case .success: success()
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Adds one or more words to a custom voice model.

     Adds one or more words and their translations to the custom voice model with the specified `customization_id`.
     Adding a new translation for a word that already exists in a custom model overwrites the word's existing
     translation. A custom model can contain no more than 20,000 entries. You must use credentials for the instance of
     the service that owns a model to add words to it.   **Note:** This method is currently a beta release.

     - parameter customizationID: The GUID of the custom voice model that is to be updated. You must make the request with service credentials created for the instance of the service that owns the custom model.
     - parameter words: An array of words and their translations from the custom voice model. The words are listed in alphabetical order, with uppercase letters listed before lowercase letters. The array is empty if the custom model contains no words.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func addWords(
        customizationID: String,
        words: [Word],
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct body
        let addWordsRequest = Words(words: words)
        guard let body = try? JSONEncoder().encode(addWordsRequest) else {
            failure?(RestError.serializationError)
            return
        }

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: defaultHeaders,
            contentType: "application/json",
            queryItems: nil,
            messageBody: body
        )

        // execute REST request
        request.responseVoid(responseToError: responseToError) {
            (response: RestResponse) in
            switch response.result {
            case .success: success()
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Deletes a word from a custom voice model.

     Deletes a single word from the custom voice model with the specified `customization_id`. You must use credentials
     for the instance of the service that owns a model to delete it.   **Note:** This method is currently a beta
     release.

     - parameter customizationID: The GUID of the custom voice model from which to delete a word. You must make the request with service credentials created for the instance of the service that owns the custom model.
     - parameter word: The word that is to be deleted from the custom voice model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func deleteWord(
        customizationID: String,
        word: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words/\(word)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: defaultHeaders,
            queryItems: nil,
            messageBody: nil
        )

        // execute REST request
        request.responseVoid(responseToError: responseToError) {
            (response: RestResponse) in
            switch response.result {
            case .success: success()
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Queries details about a word in a custom voice model.

     Returns the translation for a single word from the custom model with the specified `customization_id`. The output
     shows the translation as it is defined in the model. You must use credentials for the instance of the service that
     owns a model to query information about its words.   **Note:** This method is currently a beta release.

     - parameter customizationID: The GUID of the custom voice model from which to query a word. You must make the request with service credentials created for the instance of the service that owns the custom model.
     - parameter word: The word that is to be queried from the custom voice model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func getWord(
        customizationID: String,
        word: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Translation) -> Void)
    {
        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words/\(word)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: nil,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Translation>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Queries details about the words in a custom voice model.

     Lists all of the words and their translations for the custom voice model with the specified `customization_id`. The
     output shows the translations as they are defined in the model. You must use credentials for the instance of the
     service that owns a model to query information about its words.   **Note:** This method is currently a beta
     release.

     - parameter customizationID: The GUID of the custom voice model that is to be queried. You must make the request with service credentials created for the instance of the service that owns the custom model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func listWords(
        customizationID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Words) -> Void)
    {
        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: nil,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Words>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

}
