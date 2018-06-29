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
// swiftlint:disable file_length

import Foundation

/**
 ### Service Overview
 The IBM&reg; Text to Speech service provides an API that uses IBM's speech-synthesis capabilities to synthesize text
 into natural-sounding speech in a variety of languages, dialects, and voices. The service supports at least one male or
 female voice, sometimes both, for each language. The audio is streamed back to the client with minimal delay. For more
 information about the service, see the [IBM&reg; Cloud
 documentation](https://console.bluemix.net/docs/services/text-to-speech/index.html).
 ### API usage guidelines
 * **Audio formats:** The service can produce audio in many formats (MIME types). See [Specifying an audio
 format](https://console.bluemix.net/docs/services/text-to-speech/http.html#format).
 * **SSML:** Many methods refer to the Speech Synthesis Markup Language (SSML). SSML is an XML-based markup language
 that provides text annotation for speech-synthesis applications. See [Using
 SSML](https://console.bluemix.net/docs/services/text-to-speech/SSML.html) and [Using IBM
 SPR](https://console.bluemix.net/docs/services/text-to-speech/SPRs.html).
 * **Word translations:** Many customization methods accept sounds-like or phonetic translations for words. Phonetic
 translations are based on the SSML phoneme format for representing a word. You can specify them in standard
 International Phonetic Alphabet (IPA) representation
   &lt;phoneme alphabet="ipa" ph="t&#601;m&#712;&#593;to"&gt;&lt;/phoneme&gt;
   or in the proprietary IBM Symbolic Phonetic Representation (SPR)
   &lt;phoneme alphabet="ibm" ph="1gAstroEntxrYFXs"&gt;&lt;/phoneme&gt;
   See [Understanding customization](https://console.bluemix.net/docs/services/text-to-speech/custom-intro.html).
 * **WebSocket interface:** The service also offers a WebSocket interface for speech synthesis. The WebSocket interface
 supports both plain text and SSML input, including the SSML &lt;mark&gt; element and word timings. See [The WebSocket
 interface](https://console.bluemix.net/docs/services/text-to-speech/websockets.html).
 * **Customization IDs:** Many methods accept a customization ID, which is a Globally Unique Identifier (GUID).
 Customization IDs are hexadecimal strings that have the format `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.
 * **`X-Watson-Learning-Opt-Out`:** By default, all Watson services log requests and their results. Logging is done only
 to improve the services for future users. The logged data is not shared or made public. To prevent IBM from accessing
 your data for general service improvements, set the `X-Watson-Learning-Opt-Out` request header to `true` for all
 requests. You must set the header on each request that you do not want IBM to access for general service improvements.
   Methods of the customization interface do not log words and translations that you use to build custom voice models.
 Your training data is never used to improve the service's base models. However, the service does log such data when a
 custom model is used with a synthesize request. You must set the `X-Watson-Learning-Opt-Out` request header to `true`
 to prevent IBM from accessing the data to improve the service.
 * **`X-Watson-Metadata`:** This header allows you to associate a customer ID with data that is passed with a request.
 If necessary, you can use the **Delete labeled data** method to delete the data for a customer ID. See [Information
 security](https://console.bluemix.net/docs/services/text-to-speech/information-security.html).
 */
public class TextToSpeech {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://stream.watsonplatform.net/text-to-speech/api"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    private let session = URLSession(configuration: URLSessionConfiguration.default)
    private var authMethod: AuthenticationMethod
    private let domain = "com.ibm.watson.developer-cloud.TextToSpeechV1"

    /**
     Create a `TextToSpeech` object.

     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     */
    public init(username: String, password: String) {
        self.authMethod = BasicAuthentication(username: username, password: password)
    }

    /**
     Create a `TextToSpeech` object.

     - parameter apiKey: An API key for IAM that can be used to obtain access tokens for the service.
     - parameter iamUrl: The URL for the IAM service.
     */
    public init(version: String, apiKey: String, iamUrl: String? = nil) {
        self.authMethod = IAMAuthentication(apiKey: apiKey, url: iamUrl)
    }

    /**
     Create a `TextToSpeech` object.

     - parameter accessToken: An access token for the service.
     */
    public init(version: String, accessToken: String) {
        self.authMethod = IAMAccessToken(accessToken: accessToken)
    }

    public func accessToken(_ newToken: String) {
        if self.authMethod is IAMAccessToken {
            self.authMethod = IAMAccessToken(accessToken: newToken)
        }
    }

    /**
     If the response or data represents an error returned by the Text to Speech service,
     then return NSError with information about the error that occured. Otherwise, return nil.

     - parameter data: Raw data returned from the service that may represent an error.
     - parameter response: the URL response returned from the service.
     */
    private func errorResponseDecoder(data: Data, response: HTTPURLResponse) -> Error {

        let code = response.statusCode
        do {
            let json = try JSONDecoder().decode([String: JSON].self, from: data)
            var userInfo: [String: Any] = [:]
            if case let .some(.string(message)) = json["error"] {
                userInfo[NSLocalizedDescriptionKey] = message
            }
            if case let .some(.string(description)) = json["code_description"] {
                userInfo[NSLocalizedFailureReasonErrorKey] = description
            }
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return NSError(domain: domain, code: code, userInfo: nil)
        }
    }

    /**
     List voices.

     Lists all voices available for use with the service. The information includes the name, language, gender, and other
     details about the voice. To see information about a specific voice, use the **Get a voice** method.

     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listVoices(
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Voices) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + "/v1/voices",
            headerParameters: headerParameters
        )

        // execute REST request
        request.responseObject {
            (response: RestResponse<Voices>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Get a voice.

     Gets information about the specified voice. The information includes the name, language, gender, and other details
     about the voice. Specify a customization ID to obtain information for that custom voice model of the specified
     voice. To list information about all available voices, use the **List voices** method.

     - parameter voice: The voice for which information is to be returned.
     - parameter customizationID: The customization ID (GUID) of a custom voice model for which information is to be
       returned. You must make the request with service credentials created for the instance of the service that owns
       the custom model. Omit the parameter to see information about the specified voice with no customization.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getVoice(
        voice: String,
        customizationID: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Voice) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

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
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject {
            (response: RestResponse<Voice>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Synthesize audio.

     Synthesizes text to spoken audio, returning the synthesized audio stream as an array of bytes. You can pass a
     maximum of 5 KB of text.  Use the `Accept` header or the `accept` query parameter to specify the requested format
     (MIME type) of the response audio. By default, the service uses `audio/ogg;codecs=opus`. For detailed information
     about the supported audio formats and sampling rates, see [Specifying an audio
     format](https://console.bluemix.net/docs/services/text-to-speech/http.html#format).
     If a request includes invalid query parameters, the service returns a `Warnings` response header that provides
     messages about the invalid parameters. The warning includes a descriptive message and a list of invalid argument
     strings. For example, a message such as `\"Unknown arguments:\"` or `\"Unknown url query arguments:\"` followed by
     a list of the form `\"invalid_arg_1, invalid_arg_2.\"` The request succeeds despite the warnings.

     - parameter text: The text to synthesize.
     - parameter accept: The requested audio format (MIME type) of the audio. You can use the `Accept` header or the
       `accept` query parameter to specify the audio format. (For the `audio/l16` format, you can optionally specify
       `endianness=big-endian` or `endianness=little-endian`; the default is little endian.) For detailed information
       about the supported audio formats and sampling rates, see [Specifying an audio
       format](https://console.bluemix.net/docs/services/text-to-speech/http.html#format).
     - parameter voice: The voice to use for synthesis.
     - parameter customizationID: The customization ID (GUID) of a custom voice model to use for the synthesis. If a
       custom voice model is specified, it is guaranteed to work only if it matches the language of the indicated voice.
       You must make the request with service credentials created for the instance of the service that owns the custom
       model. Omit the parameter to use the specified voice with no customization.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func synthesize(
        text: String,
        accept: String? = nil,
        voice: String? = nil,
        customizationID: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Data) -> Void)
    {
        // construct body
        let synthesizeRequest = Text(text: text)
        guard let body = try? JSONEncoder().encode(synthesizeRequest) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Content-Type"] = "application/json"
        if let accept = accept {
            headerParameters["Accept"] = accept
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
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v1/synthesize",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseData {
            (response: RestResponse<Data>) in
            switch response.result {
            case .success(let data):
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
            case .failure(let error):
                failure?(error)
            }
        }
    }

    /**
     Get pronunciation.

     Gets the phonetic pronunciation for the specified word. You can request the pronunciation for a specific format.
     You can also request the pronunciation for a specific voice to see the default translation for the language of that
     voice or for a specific custom voice model to see the translation for that voice model.
     **Note:** This method is currently a beta release.

     - parameter text: The word for which the pronunciation is requested.
     - parameter voice: A voice that specifies the language in which the pronunciation is to be returned. All voices
       for the same language (for example, `en-US`) return the same translation.
     - parameter format: The phoneme format in which to return the pronunciation. Omit the parameter to obtain the
       pronunciation in the default format.
     - parameter customizationID: The customization ID (GUID) of a custom voice model for which the pronunciation is
       to be returned. The language of a specified custom model must match the language of the specified voice. If the
       word is not defined in the specified custom model, the service returns the default translation for the custom
       model's language. You must make the request with service credentials created for the instance of the service that
       owns the custom model. Omit the parameter to see the translation for the specified voice with no customization.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getPronunciation(
        text: String,
        voice: String? = nil,
        format: String? = nil,
        customizationID: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Pronunciation) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

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
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + "/v1/pronunciation",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject {
            (response: RestResponse<Pronunciation>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Create a custom model.

     Creates a new empty custom voice model. You must specify a name for the new custom model. You can optionally
     specify the language and a description for the new model. The model is owned by the instance of the service whose
     credentials are used to create it.
     **Note:** This method is currently a beta release.

     - parameter name: The name of the new custom voice model.
     - parameter language: The language of the new custom voice model. Omit the parameter to use the the default
       language, `en-US`.
     - parameter description: A description of the new custom voice model. Specifying a description is recommended.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func createVoiceModel(
        name: String,
        language: String? = nil,
        description: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (VoiceModel) -> Void)
    {
        // construct body
        let createVoiceModelRequest = CreateVoiceModel(name: name, language: language, description: description)
        guard let body = try? JSONEncoder().encode(createVoiceModelRequest) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v1/customizations",
            headerParameters: headerParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject {
            (response: RestResponse<VoiceModel>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     List custom models.

     Lists metadata such as the name and description for all custom voice models that are owned by an instance of the
     service. Specify a language to list the voice models for that language only. To see the words in addition to the
     metadata for a specific voice model, use the **List a custom model** method. You must use credentials for the
     instance of the service that owns a model to list information about it.
     **Note:** This method is currently a beta release.

     - parameter language: The language for which custom voice models that are owned by the requesting service
       credentials are to be returned. Omit the parameter to see all custom voice models that are owned by the
       requester.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listVoiceModels(
        language: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (VoiceModels) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let language = language {
            let queryParameter = URLQueryItem(name: "language", value: language)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + "/v1/customizations",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject {
            (response: RestResponse<VoiceModels>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Update a custom model.

     Updates information for the specified custom voice model. You can update metadata such as the name and description
     of the voice model. You can also update the words in the model and their translations. Adding a new translation for
     a word that already exists in a custom model overwrites the word's existing translation. A custom model can contain
     no more than 20,000 entries. You must use credentials for the instance of the service that owns a model to update
     it.
     **Note:** This method is currently a beta release.

     - parameter customizationID: The customization ID (GUID) of the custom voice model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter name: A new name for the custom voice model.
     - parameter description: A new description for the custom voice model.
     - parameter words: An array of `Word` objects that provides the words and their translations that are to be added
       or updated for the custom voice model. Pass an empty array to make no additions or updates.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func updateVoiceModel(
        customizationID: String,
        name: String? = nil,
        description: String? = nil,
        words: [Word]? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct body
        let updateVoiceModelRequest = UpdateVoiceModel(name: name, description: description, words: words)
        guard let body = try? JSONEncoder().encode(updateVoiceModelRequest) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            messageBody: body
        )

        // execute REST request
        request.responseVoid {
            (response: RestResponse) in
            switch response.result {
            case .success: success()
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Get a custom model.

     Gets all information about a specified custom voice model. In addition to metadata such as the name and description
     of the voice model, the output includes the words and their translations as defined in the model. To see just the
     metadata for a voice model, use the **List custom models** method.
     **Note:** This method is currently a beta release.

     - parameter customizationID: The customization ID (GUID) of the custom voice model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getVoiceModel(
        customizationID: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (VoiceModel) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters
        )

        // execute REST request
        request.responseObject {
            (response: RestResponse<VoiceModel>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete a custom model.

     Deletes the specified custom voice model. You must use credentials for the instance of the service that owns a
     model to delete it.
     **Note:** This method is currently a beta release.

     - parameter customizationID: The customization ID (GUID) of the custom voice model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func deleteVoiceModel(
        customizationID: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct REST request
        let path = "/v1/customizations/\(customizationID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters
        )

        // execute REST request
        request.responseVoid {
            (response: RestResponse) in
            switch response.result {
            case .success: success()
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Add custom words.

     Adds one or more words and their translations to the specified custom voice model. Adding a new translation for a
     word that already exists in a custom model overwrites the word's existing translation. A custom model can contain
     no more than 20,000 entries. You must use credentials for the instance of the service that owns a model to add
     words to it.
     **Note:** This method is currently a beta release.

     - parameter customizationID: The customization ID (GUID) of the custom voice model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter words: The **Add custom words** method accepts an array of `Word` objects. Each object provides a
       word that is to be added or updated for the custom voice model and the word's translation.
       The **List custom words** method returns an array of `Word` objects. Each object shows a word and its translation
       from the custom voice model. The words are listed in alphabetical order, with uppercase letters listed before
       lowercase letters. The array is empty if the custom model contains no words.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func addWords(
        customizationID: String,
        words: [Word],
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct body
        let addWordsRequest = Words(words: words)
        guard let body = try? JSONEncoder().encode(addWordsRequest) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            messageBody: body
        )

        // execute REST request
        request.responseVoid {
            (response: RestResponse) in
            switch response.result {
            case .success: success()
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     List custom words.

     Lists all of the words and their translations for the specified custom voice model. The output shows the
     translations as they are defined in the model. You must use credentials for the instance of the service that owns a
     model to list its words.
     **Note:** This method is currently a beta release.

     - parameter customizationID: The customization ID (GUID) of the custom voice model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listWords(
        customizationID: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Words) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters
        )

        // execute REST request
        request.responseObject {
            (response: RestResponse<Words>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Add a custom word.

     Adds a single word and its translation to the specified custom voice model. Adding a new translation for a word
     that already exists in a custom model overwrites the word's existing translation. A custom model can contain no
     more than 20,000 entries. You must use credentials for the instance of the service that owns a model to add a word
     to it.
     **Note:** This method is currently a beta release.

     - parameter customizationID: The customization ID (GUID) of the custom voice model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter word: The word that is to be added or updated for the custom voice model.
     - parameter translation: The phonetic or sounds-like translation for the word. A phonetic translation is based on
       the SSML format for representing the phonetic string of a word either as an IPA translation or as an IBM SPR
       translation. A sounds-like is one or more words that, when combined, sound like the word.
     - parameter partOfSpeech: **Japanese only.** The part of speech for the word. The service uses the value to
       produce the correct intonation for the word. You can create only a single entry, with or without a single part of
       speech, for any word; you cannot create multiple entries with different parts of speech for the same word. For
       more information, see [Working with Japanese
       entries](https://console.bluemix.net/docs/services/text-to-speech/custom-rules.html#jaNotes).
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func addWord(
        customizationID: String,
        word: String,
        translation: String,
        partOfSpeech: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct body
        let addWordRequest = Translation(translation: translation, partOfSpeech: partOfSpeech)
        guard let body = try? JSONEncoder().encode(addWordRequest) else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Content-Type"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words/\(word)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "PUT",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            messageBody: body
        )

        // execute REST request
        request.responseVoid {
            (response: RestResponse) in
            switch response.result {
            case .success: success()
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Get a custom word.

     Gets the translation for a single word from the specified custom model. The output shows the translation as it is
     defined in the model. You must use credentials for the instance of the service that owns a model to list its words.
     **Note:** This method is currently a beta release.

     - parameter customizationID: The customization ID (GUID) of the custom voice model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter word: The word that is to be queried from the custom voice model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getWord(
        customizationID: String,
        word: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Translation) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words/\(word)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters
        )

        // execute REST request
        request.responseObject {
            (response: RestResponse<Translation>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete a custom word.

     Deletes a single word from the specified custom voice model. You must use credentials for the instance of the
     service that owns a model to delete its words.
     **Note:** This method is currently a beta release.

     - parameter customizationID: The customization ID (GUID) of the custom voice model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter word: The word that is to be deleted from the custom voice model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func deleteWord(
        customizationID: String,
        word: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words/\(word)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters
        )

        // execute REST request
        request.responseVoid {
            (response: RestResponse) in
            switch response.result {
            case .success: success()
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete labeled data.

     Deletes all data that is associated with a specified customer ID. The method deletes all data for the customer ID,
     regardless of the method by which the information was added. The method has no effect if no data is associated with
     the customer ID. You must issue the request with credentials for the same instance of the service that was used to
     associate the customer ID with the data.
     You associate a customer ID with data by passing the `X-Watson-Metadata` header with a request that passes the
     data. For more information about customer IDs and about using this method, see [Information
     security](https://console.bluemix.net/docs/services/text-to-speech/information-security.html).

     - parameter customerID: The customer ID for which all data is to be deleted.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func deleteUserData(
        customerID: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "customer_id", value: customerID))

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceURL + "/v1/user_data",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseVoid {
            (response: RestResponse) in
            switch response.result {
            case .success: success()
            case .failure(let error): failure?(error)
            }
        }
    }

}
