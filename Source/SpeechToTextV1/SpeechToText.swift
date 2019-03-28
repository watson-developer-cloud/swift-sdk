/**
 * Copyright IBM Corporation 2019
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
import RestKit

/**
 The IBM&reg; Speech to Text service provides APIs that use IBM's speech-recognition capabilities to produce transcripts
 of spoken audio. The service can transcribe speech from various languages and audio formats. In addition to basic
 transcription, the service can produce detailed information about many different aspects of the audio. For most
 languages, the service supports two sampling rates, broadband and narrowband. It returns all JSON response content in
 the UTF-8 character set.
 For speech recognition, the service supports synchronous and asynchronous HTTP Representational State Transfer (REST)
 interfaces. It also supports a WebSocket interface that provides a full-duplex, low-latency communication channel:
 Clients send requests and audio to the service and receive results over a single connection asynchronously.
 The service also offers two customization interfaces. Use language model customization to expand the vocabulary of a
 base model with domain-specific terminology. Use acoustic model customization to adapt a base model for the acoustic
 characteristics of your audio. For language model customization, the service also supports grammars. A grammar is a
 formal language specification that lets you restrict the phrases that the service can recognize.
 Language model customization is generally available for production use with most supported languages. Acoustic model
 customization is beta functionality that is available for all supported languages.
 */
public class SpeechToText {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://stream.watsonplatform.net/speech-to-text/api"
    internal let serviceName = "SpeechToText"
    internal let serviceVersion = "v1"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    var session = URLSession(configuration: URLSessionConfiguration.default)
    var authMethod: AuthenticationMethod

    #if os(Linux)
    /**
     Create a `SpeechToText` object.

     This initializer will retrieve credentials from the environment or a local credentials file.
     The credentials file can be downloaded from your service instance on IBM Cloud as ibm-credentials.env.
     Make sure to add the credentials file to your project so that it can be loaded at runtime.

     If credentials are not available in the environment or a local credentials file, initialization will fail.
     In that case, try another initializer that directly passes in the credentials.

     */
    public init?() {
        guard let credentials = Shared.extractCredentials(serviceName: "speech_to_text") else {
            return nil
        }
        guard let authMethod = Shared.getAuthMethod(from: credentials) else {
            return nil
        }
        if let serviceURL = Shared.getServiceURL(from: credentials) {
            self.serviceURL = serviceURL
        }
        self.authMethod = authMethod
        RestRequest.userAgent = Shared.userAgent
    }
    #endif

    /**
     Create a `SpeechToText` object.

     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     */
    public init(username: String, password: String) {
        self.authMethod = Shared.getAuthMethod(username: username, password: password)
        RestRequest.userAgent = Shared.userAgent
    }

    /**
     Create a `SpeechToText` object.

     - parameter apiKey: An API key for IAM that can be used to obtain access tokens for the service.
     - parameter iamUrl: The URL for the IAM service.
     */
    public init(apiKey: String, iamUrl: String? = nil) {
        self.authMethod = Shared.getAuthMethod(apiKey: apiKey, iamURL: iamUrl)
        RestRequest.userAgent = Shared.userAgent
    }

    /**
     Create a `SpeechToText` object.

     - parameter accessToken: An access token for the service.
     */
    public init(accessToken: String) {
        self.authMethod = IAMAccessToken(accessToken: accessToken)
        RestRequest.userAgent = Shared.userAgent
    }

    public func accessToken(_ newToken: String) {
        if self.authMethod is IAMAccessToken {
            self.authMethod = IAMAccessToken(accessToken: newToken)
        }
    }

    /**
     Use the HTTP response and data received by the Speech to Text service to extract
     information about the error that occurred.

     - parameter data: Raw data returned by the service that may represent an error.
     - parameter response: the URL response returned by the service.
     */
    func errorResponseDecoder(data: Data, response: HTTPURLResponse) -> WatsonError {

        let statusCode = response.statusCode
        var errorMessage: String?
        var metadata = [String: Any]()

        do {
            let json = try JSON.decoder.decode([String: JSON].self, from: data)
            metadata["response"] = json
            if case let .some(.array(errors)) = json["errors"],
                case let .some(.object(error)) = errors.first,
                case let .some(.string(message)) = error["message"] {
                errorMessage = message
            } else if case let .some(.string(message)) = json["error"] {
                errorMessage = message
            } else if case let .some(.string(message)) = json["message"] {
                errorMessage = message
            } else {
                errorMessage = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
            }
        } catch {
            metadata["response"] = data
            errorMessage = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
        }

        return WatsonError.http(statusCode: statusCode, message: errorMessage, metadata: metadata)
    }

    /**
     List models.

     Lists all language models that are available for use with the service. The information includes the name of the
     model and its minimum sampling rate in Hertz, among other things.
     **See also:** [Languages and models](https://cloud.ibm.com/docs/services/speech-to-text/models.html).

     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listModels(
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<SpeechModels>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listModels")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + "/v1/models",
            headerParameters: headerParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Get a model.

     Gets information for a single specified language model that is available for use with the service. The information
     includes the name of the model and its minimum sampling rate in Hertz, among other things.
     **See also:** [Languages and models](https://cloud.ibm.com/docs/services/speech-to-text/models.html).

     - parameter modelID: The identifier of the model in the form of its name from the output of the **Get a model**
       method.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getModel(
        modelID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<SpeechModel>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/models/\(modelID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Recognize audio.

     Sends audio and returns transcription results for a recognition request. You can pass a maximum of 100 MB and a
     minimum of 100 bytes of audio with a request. The service automatically detects the endianness of the incoming
     audio and, for audio that includes multiple channels, downmixes the audio to one-channel mono during transcoding.
     The method returns only final results; to enable interim results, use the WebSocket API.
     **See also:** [Making a basic HTTP
     request](https://cloud.ibm.com/docs/services/speech-to-text/http.html#HTTP-basic).
     ### Streaming mode
      For requests to transcribe live audio as it becomes available, you must set the `Transfer-Encoding` header to
     `chunked` to use streaming mode. In streaming mode, the service closes the connection (status code 408) if it does
     not receive at least 15 seconds of audio (including silence) in any 30-second period. The service also closes the
     connection (status code 400) if it detects no speech for `inactivity_timeout` seconds of streaming audio; use the
     `inactivity_timeout` parameter to change the default of 30 seconds.
     **See also:**
     * [Audio transmission](https://cloud.ibm.com/docs/services/speech-to-text/input.html#transmission)
     * [Timeouts](https://cloud.ibm.com/docs/services/speech-to-text/input.html#timeouts)
     ### Audio formats (content types)
      The service accepts audio in the following formats (MIME types).
     * For formats that are labeled **Required**, you must use the `Content-Type` header with the request to specify the
     format of the audio.
     * For all other formats, you can omit the `Content-Type` header or specify `application/octet-stream` with the
     header to have the service automatically detect the format of the audio. (With the `curl` command, you can specify
     either `\"Content-Type:\"` or `\"Content-Type: application/octet-stream\"`.)
     Where indicated, the format that you specify must include the sampling rate and can optionally include the number
     of channels and the endianness of the audio.
     * `audio/alaw` (**Required.** Specify the sampling rate (`rate`) of the audio.)
     * `audio/basic` (**Required.** Use only with narrowband models.)
     * `audio/flac`
     * `audio/g729` (Use only with narrowband models.)
     * `audio/l16` (**Required.** Specify the sampling rate (`rate`) and optionally the number of channels (`channels`)
     and endianness (`endianness`) of the audio.)
     * `audio/mp3`
     * `audio/mpeg`
     * `audio/mulaw` (**Required.** Specify the sampling rate (`rate`) of the audio.)
     * `audio/ogg` (The service automatically detects the codec of the input audio.)
     * `audio/ogg;codecs=opus`
     * `audio/ogg;codecs=vorbis`
     * `audio/wav` (Provide audio with a maximum of nine channels.)
     * `audio/webm` (The service automatically detects the codec of the input audio.)
     * `audio/webm;codecs=opus`
     * `audio/webm;codecs=vorbis`
     The sampling rate of the audio must match the sampling rate of the model for the recognition request: for broadband
     models, at least 16 kHz; for narrowband models, at least 8 kHz. If the sampling rate of the audio is higher than
     the minimum required rate, the service down-samples the audio to the appropriate rate. If the sampling rate of the
     audio is lower than the minimum required rate, the request fails.
      **See also:** [Audio formats](https://cloud.ibm.com/docs/services/speech-to-text/audio-formats.html).
     ### Multipart speech recognition
      **Note:** The Watson SDKs do not support multipart speech recognition.
     The HTTP `POST` method of the service also supports multipart speech recognition. With multipart requests, you pass
     all audio data as multipart form data. You specify some parameters as request headers and query parameters, but you
     pass JSON metadata as form data to control most aspects of the transcription.
     The multipart approach is intended for use with browsers for which JavaScript is disabled or when the parameters
     used with the request are greater than the 8 KB limit imposed by most HTTP servers and proxies. You can encounter
     this limit, for example, if you want to spot a very large number of keywords.
     **See also:** [Making a multipart HTTP
     request](https://cloud.ibm.com/docs/services/speech-to-text/http.html#HTTP-multi).

     - parameter audio: The audio to transcribe.
     - parameter model: The identifier of the model that is to be used for the recognition request. See [Languages and
       models](https://cloud.ibm.com/docs/services/speech-to-text/models.html).
     - parameter languageCustomizationID: The customization ID (GUID) of a custom language model that is to be used
       with the recognition request. The base model of the specified custom language model must match the model
       specified with the `model` parameter. You must make the request with credentials for the instance of the service
       that owns the custom model. By default, no custom language model is used. See [Custom
       models](https://cloud.ibm.com/docs/services/speech-to-text/input.html#custom-input).
       **Note:** Use this parameter instead of the deprecated `customization_id` parameter.
     - parameter acousticCustomizationID: The customization ID (GUID) of a custom acoustic model that is to be used
       with the recognition request. The base model of the specified custom acoustic model must match the model
       specified with the `model` parameter. You must make the request with credentials for the instance of the service
       that owns the custom model. By default, no custom acoustic model is used. See [Custom
       models](https://cloud.ibm.com/docs/services/speech-to-text/input.html#custom-input).
     - parameter baseModelVersion: The version of the specified base model that is to be used with recognition
       request. Multiple versions of a base model can exist when a model is updated for internal improvements. The
       parameter is intended primarily for use with custom models that have been upgraded for a new base model. The
       default value depends on whether the parameter is used with or without a custom model. See [Base model
       version](https://cloud.ibm.com/docs/services/speech-to-text/input.html#version).
     - parameter customizationWeight: If you specify the customization ID (GUID) of a custom language model with the
       recognition request, the customization weight tells the service how much weight to give to words from the custom
       language model compared to those from the base model for the current request.
       Specify a value between 0.0 and 1.0. Unless a different customization weight was specified for the custom model
       when it was trained, the default value is 0.3. A customization weight that you specify overrides a weight that
       was specified when the custom model was trained.
       The default value yields the best performance in general. Assign a higher value if your audio makes frequent use
       of OOV words from the custom model. Use caution when setting the weight: a higher value can improve the accuracy
       of phrases from the custom model's domain, but it can negatively affect performance on non-domain phrases.
       See [Custom models](https://cloud.ibm.com/docs/services/speech-to-text/input.html#custom-input).
     - parameter inactivityTimeout: The time in seconds after which, if only silence (no speech) is detected in
       streaming audio, the connection is closed with a 400 error. The parameter is useful for stopping audio submission
       from a live microphone when a user simply walks away. Use `-1` for infinity. See [Inactivity
       timeout](https://cloud.ibm.com/docs/services/speech-to-text/input.html#timeouts-inactivity).
     - parameter keywords: An array of keyword strings to spot in the audio. Each keyword string can include one or
       more string tokens. Keywords are spotted only in the final results, not in interim hypotheses. If you specify any
       keywords, you must also specify a keywords threshold. You can spot a maximum of 1000 keywords. Omit the parameter
       or specify an empty array if you do not need to spot keywords. See [Keyword
       spotting](https://cloud.ibm.com/docs/services/speech-to-text/output.html#keyword_spotting).
     - parameter keywordsThreshold: A confidence value that is the lower bound for spotting a keyword. A word is
       considered to match a keyword if its confidence is greater than or equal to the threshold. Specify a probability
       between 0.0 and 1.0. If you specify a threshold, you must also specify one or more keywords. The service performs
       no keyword spotting if you omit either parameter. See [Keyword
       spotting](https://cloud.ibm.com/docs/services/speech-to-text/output.html#keyword_spotting).
     - parameter maxAlternatives: The maximum number of alternative transcripts that the service is to return. By
       default, the service returns a single transcript. If you specify a value of `0`, the service uses the default
       value, `1`. See [Maximum
       alternatives](https://cloud.ibm.com/docs/services/speech-to-text/output.html#max_alternatives).
     - parameter wordAlternativesThreshold: A confidence value that is the lower bound for identifying a hypothesis as
       a possible word alternative (also known as \"Confusion Networks\"). An alternative word is considered if its
       confidence is greater than or equal to the threshold. Specify a probability between 0.0 and 1.0. By default, the
       service computes no alternative words. See [Word
       alternatives](https://cloud.ibm.com/docs/services/speech-to-text/output.html#word_alternatives).
     - parameter wordConfidence: If `true`, the service returns a confidence measure in the range of 0.0 to 1.0 for
       each word. By default, the service returns no word confidence scores. See [Word
       confidence](https://cloud.ibm.com/docs/services/speech-to-text/output.html#word_confidence).
     - parameter timestamps: If `true`, the service returns time alignment for each word. By default, no timestamps
       are returned. See [Word
       timestamps](https://cloud.ibm.com/docs/services/speech-to-text/output.html#word_timestamps).
     - parameter profanityFilter: If `true`, the service filters profanity from all output except for keyword results
       by replacing inappropriate words with a series of asterisks. Set the parameter to `false` to return results with
       no censoring. Applies to US English transcription only. See [Profanity
       filtering](https://cloud.ibm.com/docs/services/speech-to-text/output.html#profanity_filter).
     - parameter smartFormatting: If `true`, the service converts dates, times, series of digits and numbers, phone
       numbers, currency values, and internet addresses into more readable, conventional representations in the final
       transcript of a recognition request. For US English, the service also converts certain keyword strings to
       punctuation symbols. By default, the service performs no smart formatting.
       **Note:** Applies to US English, Japanese, and Spanish transcription only.
       See [Smart formatting](https://cloud.ibm.com/docs/services/speech-to-text/output.html#smart_formatting).
     - parameter speakerLabels: If `true`, the response includes labels that identify which words were spoken by which
       participants in a multi-person exchange. By default, the service returns no speaker labels. Setting
       `speaker_labels` to `true` forces the `timestamps` parameter to be `true`, regardless of whether you specify
       `false` for the parameter.
       **Note:** Applies to US English, Japanese, and Spanish transcription only. To determine whether a language model
       supports speaker labels, you can also use the **Get a model** method and check that the attribute
       `speaker_labels` is set to `true`.
       See [Speaker labels](https://cloud.ibm.com/docs/services/speech-to-text/output.html#speaker_labels).
     - parameter grammarName: The name of a grammar that is to be used with the recognition request. If you specify a
       grammar, you must also use the `language_customization_id` parameter to specify the name of the custom language
       model for which the grammar is defined. The service recognizes only strings that are recognized by the specified
       grammar; it does not recognize other custom words from the model's words resource. See
       [Grammars](https://cloud.ibm.com/docs/services/speech-to-text/input.html#grammars-input).
     - parameter redaction: If `true`, the service redacts, or masks, numeric data from final transcripts. The feature
       redacts any number that has three or more consecutive digits by replacing each digit with an `X` character. It is
       intended to redact sensitive numeric data, such as credit card numbers. By default, the service performs no
       redaction.
       When you enable redaction, the service automatically enables smart formatting, regardless of whether you
       explicitly disable that feature. To ensure maximum security, the service also disables keyword spotting (ignores
       the `keywords` and `keywords_threshold` parameters) and returns only a single final transcript (forces the
       `max_alternatives` parameter to be `1`).
       **Note:** Applies to US English, Japanese, and Korean transcription only.
       See [Numeric redaction](https://cloud.ibm.com/docs/services/speech-to-text/output.html#redaction).
     - parameter contentType: The format (MIME type) of the audio. For more information about specifying an audio
       format, see **Audio formats (content types)** in the method description.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func recognize(
        audio: Data,
        model: String? = nil,
        languageCustomizationID: String? = nil,
        acousticCustomizationID: String? = nil,
        baseModelVersion: String? = nil,
        customizationWeight: Double? = nil,
        inactivityTimeout: Int? = nil,
        keywords: [String]? = nil,
        keywordsThreshold: Double? = nil,
        maxAlternatives: Int? = nil,
        wordAlternativesThreshold: Double? = nil,
        wordConfidence: Bool? = nil,
        timestamps: Bool? = nil,
        profanityFilter: Bool? = nil,
        smartFormatting: Bool? = nil,
        speakerLabels: Bool? = nil,
        grammarName: String? = nil,
        redaction: Bool? = nil,
        contentType: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<SpeechRecognitionResults>?, WatsonError?) -> Void)
    {
        // construct body
        let body = audio

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "recognize")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let contentType = contentType {
            headerParameters["Content-Type"] = contentType
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let model = model {
            let queryParameter = URLQueryItem(name: "model", value: model)
            queryParameters.append(queryParameter)
        }
        if let languageCustomizationID = languageCustomizationID {
            let queryParameter = URLQueryItem(name: "language_customization_id", value: languageCustomizationID)
            queryParameters.append(queryParameter)
        }
        if let acousticCustomizationID = acousticCustomizationID {
            let queryParameter = URLQueryItem(name: "acoustic_customization_id", value: acousticCustomizationID)
            queryParameters.append(queryParameter)
        }
        if let baseModelVersion = baseModelVersion {
            let queryParameter = URLQueryItem(name: "base_model_version", value: baseModelVersion)
            queryParameters.append(queryParameter)
        }
        if let customizationWeight = customizationWeight {
            let queryParameter = URLQueryItem(name: "customization_weight", value: "\(customizationWeight)")
            queryParameters.append(queryParameter)
        }
        if let inactivityTimeout = inactivityTimeout {
            let queryParameter = URLQueryItem(name: "inactivity_timeout", value: "\(inactivityTimeout)")
            queryParameters.append(queryParameter)
        }
        if let keywords = keywords {
            let queryParameter = URLQueryItem(name: "keywords", value: keywords.joined(separator: ","))
            queryParameters.append(queryParameter)
        }
        if let keywordsThreshold = keywordsThreshold {
            let queryParameter = URLQueryItem(name: "keywords_threshold", value: "\(keywordsThreshold)")
            queryParameters.append(queryParameter)
        }
        if let maxAlternatives = maxAlternatives {
            let queryParameter = URLQueryItem(name: "max_alternatives", value: "\(maxAlternatives)")
            queryParameters.append(queryParameter)
        }
        if let wordAlternativesThreshold = wordAlternativesThreshold {
            let queryParameter = URLQueryItem(name: "word_alternatives_threshold", value: "\(wordAlternativesThreshold)")
            queryParameters.append(queryParameter)
        }
        if let wordConfidence = wordConfidence {
            let queryParameter = URLQueryItem(name: "word_confidence", value: "\(wordConfidence)")
            queryParameters.append(queryParameter)
        }
        if let timestamps = timestamps {
            let queryParameter = URLQueryItem(name: "timestamps", value: "\(timestamps)")
            queryParameters.append(queryParameter)
        }
        if let profanityFilter = profanityFilter {
            let queryParameter = URLQueryItem(name: "profanity_filter", value: "\(profanityFilter)")
            queryParameters.append(queryParameter)
        }
        if let smartFormatting = smartFormatting {
            let queryParameter = URLQueryItem(name: "smart_formatting", value: "\(smartFormatting)")
            queryParameters.append(queryParameter)
        }
        if let speakerLabels = speakerLabels {
            let queryParameter = URLQueryItem(name: "speaker_labels", value: "\(speakerLabels)")
            queryParameters.append(queryParameter)
        }
        if let grammarName = grammarName {
            let queryParameter = URLQueryItem(name: "grammar_name", value: grammarName)
            queryParameters.append(queryParameter)
        }
        if let redaction = redaction {
            let queryParameter = URLQueryItem(name: "redaction", value: "\(redaction)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v1/recognize",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Register a callback.

     Registers a callback URL with the service for use with subsequent asynchronous recognition requests. The service
     attempts to register, or white-list, the callback URL if it is not already registered by sending a `GET` request to
     the callback URL. The service passes a random alphanumeric challenge string via the `challenge_string` parameter of
     the request. The request includes an `Accept` header that specifies `text/plain` as the required response type.
     To be registered successfully, the callback URL must respond to the `GET` request from the service. The response
     must send status code 200 and must include the challenge string in its body. Set the `Content-Type` response header
     to `text/plain`. Upon receiving this response, the service responds to the original registration request with
     response code 201.
     The service sends only a single `GET` request to the callback URL. If the service does not receive a reply with a
     response code of 200 and a body that echoes the challenge string sent by the service within five seconds, it does
     not white-list the URL; it instead sends status code 400 in response to the **Register a callback** request. If the
     requested callback URL is already white-listed, the service responds to the initial registration request with
     response code 200.
     If you specify a user secret with the request, the service uses it as a key to calculate an HMAC-SHA1 signature of
     the challenge string in its response to the `POST` request. It sends this signature in the `X-Callback-Signature`
     header of its `GET` request to the URL during registration. It also uses the secret to calculate a signature over
     the payload of every callback notification that uses the URL. The signature provides authentication and data
     integrity for HTTP communications.
     After you successfully register a callback URL, you can use it with an indefinite number of recognition requests.
     You can register a maximum of 20 callback URLS in a one-hour span of time.
     **See also:** [Registering a callback URL](https://cloud.ibm.com/docs/services/speech-to-text/async.html#register).

     - parameter callbackURL: An HTTP or HTTPS URL to which callback notifications are to be sent. To be white-listed,
       the URL must successfully echo the challenge string during URL verification. During verification, the client can
       also check the signature that the service sends in the `X-Callback-Signature` header to verify the origin of the
       request.
     - parameter userSecret: A user-specified string that the service uses to generate the HMAC-SHA1 signature that it
       sends via the `X-Callback-Signature` header. The service includes the header during URL verification and with
       every notification sent to the callback URL. It calculates the signature over the payload of the notification. If
       you omit the parameter, the service does not send the header.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func registerCallback(
        callbackURL: String,
        userSecret: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<RegisterStatus>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "registerCallback")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "callback_url", value: callbackURL))
        if let userSecret = userSecret {
            let queryParameter = URLQueryItem(name: "user_secret", value: userSecret)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v1/register_callback",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Unregister a callback.

     Unregisters a callback URL that was previously white-listed with a **Register a callback** request for use with the
     asynchronous interface. Once unregistered, the URL can no longer be used with asynchronous recognition requests.
     **See also:** [Unregistering a callback
     URL](https://cloud.ibm.com/docs/services/speech-to-text/async.html#unregister).

     - parameter callbackURL: The callback URL that is to be unregistered.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func unregisterCallback(
        callbackURL: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "unregisterCallback")
        headerParameters.merge(sdkHeaders) { (_, new) in new }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "callback_url", value: callbackURL))

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v1/unregister_callback",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     Create a job.

     Creates a job for a new asynchronous recognition request. The job is owned by the instance of the service whose
     credentials are used to create it. How you learn the status and results of a job depends on the parameters you
     include with the job creation request:
     * By callback notification: Include the `callback_url` parameter to specify a URL to which the service is to send
     callback notifications when the status of the job changes. Optionally, you can also include the `events` and
     `user_token` parameters to subscribe to specific events and to specify a string that is to be included with each
     notification for the job.
     * By polling the service: Omit the `callback_url`, `events`, and `user_token` parameters. You must then use the
     **Check jobs** or **Check a job** methods to check the status of the job, using the latter to retrieve the results
     when the job is complete.
     The two approaches are not mutually exclusive. You can poll the service for job status or obtain results from the
     service manually even if you include a callback URL. In both cases, you can include the `results_ttl` parameter to
     specify how long the results are to remain available after the job is complete. Using the HTTPS **Check a job**
     method to retrieve results is more secure than receiving them via callback notification over HTTP because it
     provides confidentiality in addition to authentication and data integrity.
     The method supports the same basic parameters as other HTTP and WebSocket recognition requests. It also supports
     the following parameters specific to the asynchronous interface:
     * `callback_url`
     * `events`
     * `user_token`
     * `results_ttl`
     You can pass a maximum of 1 GB and a minimum of 100 bytes of audio with a request. The service automatically
     detects the endianness of the incoming audio and, for audio that includes multiple channels, downmixes the audio to
     one-channel mono during transcoding. The method returns only final results; to enable interim results, use the
     WebSocket API.
     **See also:** [Creating a job](https://cloud.ibm.com/docs/services/speech-to-text/async.html#create).
     ### Streaming mode
      For requests to transcribe live audio as it becomes available, you must set the `Transfer-Encoding` header to
     `chunked` to use streaming mode. In streaming mode, the service closes the connection (status code 408) if it does
     not receive at least 15 seconds of audio (including silence) in any 30-second period. The service also closes the
     connection (status code 400) if it detects no speech for `inactivity_timeout` seconds of streaming audio; use the
     `inactivity_timeout` parameter to change the default of 30 seconds.
     **See also:**
     * [Audio transmission](https://cloud.ibm.com/docs/services/speech-to-text/input.html#transmission)
     * [Timeouts](https://cloud.ibm.com/docs/services/speech-to-text/input.html#timeouts)
     ### Audio formats (content types)
      The service accepts audio in the following formats (MIME types).
     * For formats that are labeled **Required**, you must use the `Content-Type` header with the request to specify the
     format of the audio.
     * For all other formats, you can omit the `Content-Type` header or specify `application/octet-stream` with the
     header to have the service automatically detect the format of the audio. (With the `curl` command, you can specify
     either `\"Content-Type:\"` or `\"Content-Type: application/octet-stream\"`.)
     Where indicated, the format that you specify must include the sampling rate and can optionally include the number
     of channels and the endianness of the audio.
     * `audio/alaw` (**Required.** Specify the sampling rate (`rate`) of the audio.)
     * `audio/basic` (**Required.** Use only with narrowband models.)
     * `audio/flac`
     * `audio/g729` (Use only with narrowband models.)
     * `audio/l16` (**Required.** Specify the sampling rate (`rate`) and optionally the number of channels (`channels`)
     and endianness (`endianness`) of the audio.)
     * `audio/mp3`
     * `audio/mpeg`
     * `audio/mulaw` (**Required.** Specify the sampling rate (`rate`) of the audio.)
     * `audio/ogg` (The service automatically detects the codec of the input audio.)
     * `audio/ogg;codecs=opus`
     * `audio/ogg;codecs=vorbis`
     * `audio/wav` (Provide audio with a maximum of nine channels.)
     * `audio/webm` (The service automatically detects the codec of the input audio.)
     * `audio/webm;codecs=opus`
     * `audio/webm;codecs=vorbis`
     The sampling rate of the audio must match the sampling rate of the model for the recognition request: for broadband
     models, at least 16 kHz; for narrowband models, at least 8 kHz. If the sampling rate of the audio is higher than
     the minimum required rate, the service down-samples the audio to the appropriate rate. If the sampling rate of the
     audio is lower than the minimum required rate, the request fails.
      **See also:** [Audio formats](https://cloud.ibm.com/docs/services/speech-to-text/audio-formats.html).

     - parameter audio: The audio to transcribe.
     - parameter model: The identifier of the model that is to be used for the recognition request. See [Languages and
       models](https://cloud.ibm.com/docs/services/speech-to-text/models.html).
     - parameter callbackURL: A URL to which callback notifications are to be sent. The URL must already be
       successfully white-listed by using the **Register a callback** method. You can include the same callback URL with
       any number of job creation requests. Omit the parameter to poll the service for job completion and results.
       Use the `user_token` parameter to specify a unique user-specified string with each job to differentiate the
       callback notifications for the jobs.
     - parameter events: If the job includes a callback URL, a comma-separated list of notification events to which to
       subscribe. Valid events are
       * `recognitions.started` generates a callback notification when the service begins to process the job.
       * `recognitions.completed` generates a callback notification when the job is complete. You must use the **Check a
       job** method to retrieve the results before they time out or are deleted.
       * `recognitions.completed_with_results` generates a callback notification when the job is complete. The
       notification includes the results of the request.
       * `recognitions.failed` generates a callback notification if the service experiences an error while processing
       the job.
       The `recognitions.completed` and `recognitions.completed_with_results` events are incompatible. You can specify
       only of the two events.
       If the job includes a callback URL, omit the parameter to subscribe to the default events:
       `recognitions.started`, `recognitions.completed`, and `recognitions.failed`. If the job does not include a
       callback URL, omit the parameter.
     - parameter userToken: If the job includes a callback URL, a user-specified string that the service is to include
       with each callback notification for the job; the token allows the user to maintain an internal mapping between
       jobs and notification events. If the job does not include a callback URL, omit the parameter.
     - parameter resultsTtl: The number of minutes for which the results are to be available after the job has
       finished. If not delivered via a callback, the results must be retrieved within this time. Omit the parameter to
       use a time to live of one week. The parameter is valid with or without a callback URL.
     - parameter languageCustomizationID: The customization ID (GUID) of a custom language model that is to be used
       with the recognition request. The base model of the specified custom language model must match the model
       specified with the `model` parameter. You must make the request with credentials for the instance of the service
       that owns the custom model. By default, no custom language model is used. See [Custom
       models](https://cloud.ibm.com/docs/services/speech-to-text/input.html#custom-input).
       **Note:** Use this parameter instead of the deprecated `customization_id` parameter.
     - parameter acousticCustomizationID: The customization ID (GUID) of a custom acoustic model that is to be used
       with the recognition request. The base model of the specified custom acoustic model must match the model
       specified with the `model` parameter. You must make the request with credentials for the instance of the service
       that owns the custom model. By default, no custom acoustic model is used. See [Custom
       models](https://cloud.ibm.com/docs/services/speech-to-text/input.html#custom-input).
     - parameter baseModelVersion: The version of the specified base model that is to be used with recognition
       request. Multiple versions of a base model can exist when a model is updated for internal improvements. The
       parameter is intended primarily for use with custom models that have been upgraded for a new base model. The
       default value depends on whether the parameter is used with or without a custom model. See [Base model
       version](https://cloud.ibm.com/docs/services/speech-to-text/input.html#version).
     - parameter customizationWeight: If you specify the customization ID (GUID) of a custom language model with the
       recognition request, the customization weight tells the service how much weight to give to words from the custom
       language model compared to those from the base model for the current request.
       Specify a value between 0.0 and 1.0. Unless a different customization weight was specified for the custom model
       when it was trained, the default value is 0.3. A customization weight that you specify overrides a weight that
       was specified when the custom model was trained.
       The default value yields the best performance in general. Assign a higher value if your audio makes frequent use
       of OOV words from the custom model. Use caution when setting the weight: a higher value can improve the accuracy
       of phrases from the custom model's domain, but it can negatively affect performance on non-domain phrases.
       See [Custom models](https://cloud.ibm.com/docs/services/speech-to-text/input.html#custom-input).
     - parameter inactivityTimeout: The time in seconds after which, if only silence (no speech) is detected in
       streaming audio, the connection is closed with a 400 error. The parameter is useful for stopping audio submission
       from a live microphone when a user simply walks away. Use `-1` for infinity. See [Inactivity
       timeout](https://cloud.ibm.com/docs/services/speech-to-text/input.html#timeouts-inactivity).
     - parameter keywords: An array of keyword strings to spot in the audio. Each keyword string can include one or
       more string tokens. Keywords are spotted only in the final results, not in interim hypotheses. If you specify any
       keywords, you must also specify a keywords threshold. You can spot a maximum of 1000 keywords. Omit the parameter
       or specify an empty array if you do not need to spot keywords. See [Keyword
       spotting](https://cloud.ibm.com/docs/services/speech-to-text/output.html#keyword_spotting).
     - parameter keywordsThreshold: A confidence value that is the lower bound for spotting a keyword. A word is
       considered to match a keyword if its confidence is greater than or equal to the threshold. Specify a probability
       between 0.0 and 1.0. If you specify a threshold, you must also specify one or more keywords. The service performs
       no keyword spotting if you omit either parameter. See [Keyword
       spotting](https://cloud.ibm.com/docs/services/speech-to-text/output.html#keyword_spotting).
     - parameter maxAlternatives: The maximum number of alternative transcripts that the service is to return. By
       default, the service returns a single transcript. If you specify a value of `0`, the service uses the default
       value, `1`. See [Maximum
       alternatives](https://cloud.ibm.com/docs/services/speech-to-text/output.html#max_alternatives).
     - parameter wordAlternativesThreshold: A confidence value that is the lower bound for identifying a hypothesis as
       a possible word alternative (also known as \"Confusion Networks\"). An alternative word is considered if its
       confidence is greater than or equal to the threshold. Specify a probability between 0.0 and 1.0. By default, the
       service computes no alternative words. See [Word
       alternatives](https://cloud.ibm.com/docs/services/speech-to-text/output.html#word_alternatives).
     - parameter wordConfidence: If `true`, the service returns a confidence measure in the range of 0.0 to 1.0 for
       each word. By default, the service returns no word confidence scores. See [Word
       confidence](https://cloud.ibm.com/docs/services/speech-to-text/output.html#word_confidence).
     - parameter timestamps: If `true`, the service returns time alignment for each word. By default, no timestamps
       are returned. See [Word
       timestamps](https://cloud.ibm.com/docs/services/speech-to-text/output.html#word_timestamps).
     - parameter profanityFilter: If `true`, the service filters profanity from all output except for keyword results
       by replacing inappropriate words with a series of asterisks. Set the parameter to `false` to return results with
       no censoring. Applies to US English transcription only. See [Profanity
       filtering](https://cloud.ibm.com/docs/services/speech-to-text/output.html#profanity_filter).
     - parameter smartFormatting: If `true`, the service converts dates, times, series of digits and numbers, phone
       numbers, currency values, and internet addresses into more readable, conventional representations in the final
       transcript of a recognition request. For US English, the service also converts certain keyword strings to
       punctuation symbols. By default, the service performs no smart formatting.
       **Note:** Applies to US English, Japanese, and Spanish transcription only.
       See [Smart formatting](https://cloud.ibm.com/docs/services/speech-to-text/output.html#smart_formatting).
     - parameter speakerLabels: If `true`, the response includes labels that identify which words were spoken by which
       participants in a multi-person exchange. By default, the service returns no speaker labels. Setting
       `speaker_labels` to `true` forces the `timestamps` parameter to be `true`, regardless of whether you specify
       `false` for the parameter.
       **Note:** Applies to US English, Japanese, and Spanish transcription only. To determine whether a language model
       supports speaker labels, you can also use the **Get a model** method and check that the attribute
       `speaker_labels` is set to `true`.
       See [Speaker labels](https://cloud.ibm.com/docs/services/speech-to-text/output.html#speaker_labels).
     - parameter grammarName: The name of a grammar that is to be used with the recognition request. If you specify a
       grammar, you must also use the `language_customization_id` parameter to specify the name of the custom language
       model for which the grammar is defined. The service recognizes only strings that are recognized by the specified
       grammar; it does not recognize other custom words from the model's words resource. See
       [Grammars](https://cloud.ibm.com/docs/services/speech-to-text/input.html#grammars-input).
     - parameter redaction: If `true`, the service redacts, or masks, numeric data from final transcripts. The feature
       redacts any number that has three or more consecutive digits by replacing each digit with an `X` character. It is
       intended to redact sensitive numeric data, such as credit card numbers. By default, the service performs no
       redaction.
       When you enable redaction, the service automatically enables smart formatting, regardless of whether you
       explicitly disable that feature. To ensure maximum security, the service also disables keyword spotting (ignores
       the `keywords` and `keywords_threshold` parameters) and returns only a single final transcript (forces the
       `max_alternatives` parameter to be `1`).
       **Note:** Applies to US English, Japanese, and Korean transcription only.
       See [Numeric redaction](https://cloud.ibm.com/docs/services/speech-to-text/output.html#redaction).
     - parameter contentType: The format (MIME type) of the audio. For more information about specifying an audio
       format, see **Audio formats (content types)** in the method description.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createJob(
        audio: Data,
        model: String? = nil,
        callbackURL: String? = nil,
        events: String? = nil,
        userToken: String? = nil,
        resultsTtl: Int? = nil,
        languageCustomizationID: String? = nil,
        acousticCustomizationID: String? = nil,
        baseModelVersion: String? = nil,
        customizationWeight: Double? = nil,
        inactivityTimeout: Int? = nil,
        keywords: [String]? = nil,
        keywordsThreshold: Double? = nil,
        maxAlternatives: Int? = nil,
        wordAlternativesThreshold: Double? = nil,
        wordConfidence: Bool? = nil,
        timestamps: Bool? = nil,
        profanityFilter: Bool? = nil,
        smartFormatting: Bool? = nil,
        speakerLabels: Bool? = nil,
        grammarName: String? = nil,
        redaction: Bool? = nil,
        contentType: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<RecognitionJob>?, WatsonError?) -> Void)
    {
        // construct body
        let body = audio

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createJob")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let contentType = contentType {
            headerParameters["Content-Type"] = contentType
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let model = model {
            let queryParameter = URLQueryItem(name: "model", value: model)
            queryParameters.append(queryParameter)
        }
        if let callbackURL = callbackURL {
            let queryParameter = URLQueryItem(name: "callback_url", value: callbackURL)
            queryParameters.append(queryParameter)
        }
        if let events = events {
            let queryParameter = URLQueryItem(name: "events", value: events)
            queryParameters.append(queryParameter)
        }
        if let userToken = userToken {
            let queryParameter = URLQueryItem(name: "user_token", value: userToken)
            queryParameters.append(queryParameter)
        }
        if let resultsTtl = resultsTtl {
            let queryParameter = URLQueryItem(name: "results_ttl", value: "\(resultsTtl)")
            queryParameters.append(queryParameter)
        }
        if let languageCustomizationID = languageCustomizationID {
            let queryParameter = URLQueryItem(name: "language_customization_id", value: languageCustomizationID)
            queryParameters.append(queryParameter)
        }
        if let acousticCustomizationID = acousticCustomizationID {
            let queryParameter = URLQueryItem(name: "acoustic_customization_id", value: acousticCustomizationID)
            queryParameters.append(queryParameter)
        }
        if let baseModelVersion = baseModelVersion {
            let queryParameter = URLQueryItem(name: "base_model_version", value: baseModelVersion)
            queryParameters.append(queryParameter)
        }
        if let customizationWeight = customizationWeight {
            let queryParameter = URLQueryItem(name: "customization_weight", value: "\(customizationWeight)")
            queryParameters.append(queryParameter)
        }
        if let inactivityTimeout = inactivityTimeout {
            let queryParameter = URLQueryItem(name: "inactivity_timeout", value: "\(inactivityTimeout)")
            queryParameters.append(queryParameter)
        }
        if let keywords = keywords {
            let queryParameter = URLQueryItem(name: "keywords", value: keywords.joined(separator: ","))
            queryParameters.append(queryParameter)
        }
        if let keywordsThreshold = keywordsThreshold {
            let queryParameter = URLQueryItem(name: "keywords_threshold", value: "\(keywordsThreshold)")
            queryParameters.append(queryParameter)
        }
        if let maxAlternatives = maxAlternatives {
            let queryParameter = URLQueryItem(name: "max_alternatives", value: "\(maxAlternatives)")
            queryParameters.append(queryParameter)
        }
        if let wordAlternativesThreshold = wordAlternativesThreshold {
            let queryParameter = URLQueryItem(name: "word_alternatives_threshold", value: "\(wordAlternativesThreshold)")
            queryParameters.append(queryParameter)
        }
        if let wordConfidence = wordConfidence {
            let queryParameter = URLQueryItem(name: "word_confidence", value: "\(wordConfidence)")
            queryParameters.append(queryParameter)
        }
        if let timestamps = timestamps {
            let queryParameter = URLQueryItem(name: "timestamps", value: "\(timestamps)")
            queryParameters.append(queryParameter)
        }
        if let profanityFilter = profanityFilter {
            let queryParameter = URLQueryItem(name: "profanity_filter", value: "\(profanityFilter)")
            queryParameters.append(queryParameter)
        }
        if let smartFormatting = smartFormatting {
            let queryParameter = URLQueryItem(name: "smart_formatting", value: "\(smartFormatting)")
            queryParameters.append(queryParameter)
        }
        if let speakerLabels = speakerLabels {
            let queryParameter = URLQueryItem(name: "speaker_labels", value: "\(speakerLabels)")
            queryParameters.append(queryParameter)
        }
        if let grammarName = grammarName {
            let queryParameter = URLQueryItem(name: "grammar_name", value: grammarName)
            queryParameters.append(queryParameter)
        }
        if let redaction = redaction {
            let queryParameter = URLQueryItem(name: "redaction", value: "\(redaction)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v1/recognitions",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Check jobs.

     Returns the ID and status of the latest 100 outstanding jobs associated with the credentials with which it is
     called. The method also returns the creation and update times of each job, and, if a job was created with a
     callback URL and a user token, the user token for the job. To obtain the results for a job whose status is
     `completed` or not one of the latest 100 outstanding jobs, use the **Check a job** method. A job and its results
     remain available until you delete them with the **Delete a job** method or until the job's time to live expires,
     whichever comes first.
     **See also:** [Checking the status of the latest
     jobs](https://cloud.ibm.com/docs/services/speech-to-text/async.html#jobs).

     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func checkJobs(
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<RecognitionJobs>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "checkJobs")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + "/v1/recognitions",
            headerParameters: headerParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Check a job.

     Returns information about the specified job. The response always includes the status of the job and its creation
     and update times. If the status is `completed`, the response includes the results of the recognition request. You
     must use credentials for the instance of the service that owns a job to list information about it.
     You can use the method to retrieve the results of any job, regardless of whether it was submitted with a callback
     URL and the `recognitions.completed_with_results` event, and you can retrieve the results multiple times for as
     long as they remain available. Use the **Check jobs** method to request information about the most recent jobs
     associated with the calling credentials.
     **See also:** [Checking the status and retrieving the results of a
     job](https://cloud.ibm.com/docs/services/speech-to-text/async.html#job).

     - parameter id: The identifier of the asynchronous job that is to be used for the request. You must make the
       request with credentials for the instance of the service that owns the job.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func checkJob(
        id: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<RecognitionJob>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "checkJob")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/recognitions/\(id)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete a job.

     Deletes the specified job. You cannot delete a job that the service is actively processing. Once you delete a job,
     its results are no longer available. The service automatically deletes a job and its results when the time to live
     for the results expires. You must use credentials for the instance of the service that owns a job to delete it.
     **See also:** [Deleting a job](https://cloud.ibm.com/docs/services/speech-to-text/async.html#delete-async).

     - parameter id: The identifier of the asynchronous job that is to be used for the request. You must make the
       request with credentials for the instance of the service that owns the job.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteJob(
        id: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteJob")
        headerParameters.merge(sdkHeaders) { (_, new) in new }

        // construct REST request
        let path = "/v1/recognitions/\(id)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.response(completionHandler: completionHandler)
    }

    /**
     Create a custom language model.

     Creates a new custom language model for a specified base model. The custom language model can be used only with the
     base model for which it is created. The model is owned by the instance of the service whose credentials are used to
     create it.
     **See also:** [Create a custom language
     model](https://cloud.ibm.com/docs/services/speech-to-text/language-create.html#createModel-language).

     - parameter name: A user-defined name for the new custom language model. Use a name that is unique among all
       custom language models that you own. Use a localized name that matches the language of the custom model. Use a
       name that describes the domain of the custom model, such as `Medical custom model` or `Legal custom model`.
     - parameter baseModelName: The name of the base language model that is to be customized by the new custom
       language model. The new custom model can be used only with the base model that it customizes.
       To determine whether a base model supports language model customization, use the **Get a model** method and check
       that the attribute `custom_language_model` is set to `true`. You can also refer to [Language support for
       customization](https://cloud.ibm.com/docs/services/speech-to-text/custom.html#languageSupport).
     - parameter dialect: The dialect of the specified language that is to be used with the custom language model. The
       parameter is meaningful only for Spanish models, for which the service creates a custom language model that is
       suited for speech in one of the following dialects:
       * `es-ES` for Castilian Spanish (the default)
       * `es-LA` for Latin American Spanish
       * `es-US` for North American (Mexican) Spanish
       A specified dialect must be valid for the base model. By default, the dialect matches the language of the base
       model; for example, `en-US` for either of the US English language models.
     - parameter description: A description of the new custom language model. Use a localized description that matches
       the language of the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createLanguageModel(
        name: String,
        baseModelName: String,
        dialect: String? = nil,
        description: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<LanguageModel>?, WatsonError?) -> Void)
    {
        // construct body
        let createLanguageModelRequest = CreateLanguageModel(
            name: name,
            baseModelName: baseModelName,
            dialect: dialect,
            description: description)
        guard let body = try? JSON.encoder.encode(createLanguageModelRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createLanguageModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
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
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List custom language models.

     Lists information about all custom language models that are owned by an instance of the service. Use the `language`
     parameter to see all custom language models for the specified language. Omit the parameter to see all custom
     language models for all languages. You must use credentials for the instance of the service that owns a model to
     list information about it.
     **See also:** [Listing custom language
     models](https://cloud.ibm.com/docs/services/speech-to-text/language-models.html#listModels-language).

     - parameter language: The identifier of the language for which custom language or custom acoustic models are to
       be returned (for example, `en-US`). Omit the parameter to see all custom language or custom acoustic models that
       are owned by the requesting credentials.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listLanguageModels(
        language: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<LanguageModels>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listLanguageModels")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
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
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Get a custom language model.

     Gets information about a specified custom language model. You must use credentials for the instance of the service
     that owns a model to list information about it.
     **See also:** [Listing custom language
     models](https://cloud.ibm.com/docs/services/speech-to-text/language-models.html#listModels-language).

     - parameter customizationID: The customization ID (GUID) of the custom language model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getLanguageModel(
        customizationID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<LanguageModel>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getLanguageModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete a custom language model.

     Deletes an existing custom language model. The custom model cannot be deleted if another request, such as adding a
     corpus or grammar to the model, is currently being processed. You must use credentials for the instance of the
     service that owns a model to delete it.
     **See also:** [Deleting a custom language
     model](https://cloud.ibm.com/docs/services/speech-to-text/language-models.html#deleteModel-language).

     - parameter customizationID: The customization ID (GUID) of the custom language model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteLanguageModel(
        customizationID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteLanguageModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.response(completionHandler: completionHandler)
    }

    /**
     Train a custom language model.

     Initiates the training of a custom language model with new resources such as corpora, grammars, and custom words.
     After adding, modifying, or deleting resources for a custom language model, use this method to begin the actual
     training of the model on the latest data. You can specify whether the custom language model is to be trained with
     all words from its words resource or only with words that were added or modified by the user directly. You must use
     credentials for the instance of the service that owns a model to train it.
     The training method is asynchronous. It can take on the order of minutes to complete depending on the amount of
     data on which the service is being trained and the current load on the service. The method returns an HTTP 200
     response code to indicate that the training process has begun.
     You can monitor the status of the training by using the **Get a custom language model** method to poll the model's
     status. Use a loop to check the status every 10 seconds. The method returns a `LanguageModel` object that includes
     `status` and `progress` fields. A status of `available` means that the custom model is trained and ready to use.
     The service cannot accept subsequent training requests or requests to add new resources until the existing request
     completes.
     Training can fail to start for the following reasons:
     * The service is currently handling another request for the custom model, such as another training request or a
     request to add a corpus or grammar to the model.
     * No training data have been added to the custom model.
     * One or more words that were added to the custom model have invalid sounds-like pronunciations that you must fix.
     **See also:** [Train the custom language
     model](https://cloud.ibm.com/docs/services/speech-to-text/language-create.html#trainModel-language).

     - parameter customizationID: The customization ID (GUID) of the custom language model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter wordTypeToAdd: The type of words from the custom language model's words resource on which to train
       the model:
       * `all` (the default) trains the model on all new words, regardless of whether they were extracted from corpora
       or grammars or were added or modified by the user.
       * `user` trains the model only on new words that were added or modified by the user directly. The model is not
       trained on new words extracted from corpora or grammars.
     - parameter customizationWeight: Specifies a customization weight for the custom language model. The
       customization weight tells the service how much weight to give to words from the custom language model compared
       to those from the base model for speech recognition. Specify a value between 0.0 and 1.0; the default is 0.3.
       The default value yields the best performance in general. Assign a higher value if your audio makes frequent use
       of OOV words from the custom model. Use caution when setting the weight: a higher value can improve the accuracy
       of phrases from the custom model's domain, but it can negatively affect performance on non-domain phrases.
       The value that you assign is used for all recognition requests that use the model. You can override it for any
       recognition request by specifying a customization weight for that request.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func trainLanguageModel(
        customizationID: String,
        wordTypeToAdd: String? = nil,
        customizationWeight: Double? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "trainLanguageModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let wordTypeToAdd = wordTypeToAdd {
            let queryParameter = URLQueryItem(name: "word_type_to_add", value: wordTypeToAdd)
            queryParameters.append(queryParameter)
        }
        if let customizationWeight = customizationWeight {
            let queryParameter = URLQueryItem(name: "customization_weight", value: "\(customizationWeight)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/train"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     Reset a custom language model.

     Resets a custom language model by removing all corpora, grammars, and words from the model. Resetting a custom
     language model initializes the model to its state when it was first created. Metadata such as the name and language
     of the model are preserved, but the model's words resource is removed and must be re-created. You must use
     credentials for the instance of the service that owns a model to reset it.
     **See also:** [Resetting a custom language
     model](https://cloud.ibm.com/docs/services/speech-to-text/language-models.html#resetModel-language).

     - parameter customizationID: The customization ID (GUID) of the custom language model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func resetLanguageModel(
        customizationID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "resetLanguageModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/reset"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     Upgrade a custom language model.

     Initiates the upgrade of a custom language model to the latest version of its base language model. The upgrade
     method is asynchronous. It can take on the order of minutes to complete depending on the amount of data in the
     custom model and the current load on the service. A custom model must be in the `ready` or `available` state to be
     upgraded. You must use credentials for the instance of the service that owns a model to upgrade it.
     The method returns an HTTP 200 response code to indicate that the upgrade process has begun successfully. You can
     monitor the status of the upgrade by using the **Get a custom language model** method to poll the model's status.
     The method returns a `LanguageModel` object that includes `status` and `progress` fields. Use a loop to check the
     status every 10 seconds. While it is being upgraded, the custom model has the status `upgrading`. When the upgrade
     is complete, the model resumes the status that it had prior to upgrade. The service cannot accept subsequent
     requests for the model until the upgrade completes.
     **See also:** [Upgrading a custom language
     model](https://cloud.ibm.com/docs/services/speech-to-text/custom-upgrade.html#upgradeLanguage).

     - parameter customizationID: The customization ID (GUID) of the custom language model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func upgradeLanguageModel(
        customizationID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "upgradeLanguageModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/upgrade_model"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     List corpora.

     Lists information about all corpora from a custom language model. The information includes the total number of
     words and out-of-vocabulary (OOV) words, name, and status of each corpus. You must use credentials for the instance
     of the service that owns a model to list its corpora.
     **See also:** [Listing corpora for a custom language
     model](https://cloud.ibm.com/docs/services/speech-to-text/language-corpora.html#listCorpora).

     - parameter customizationID: The customization ID (GUID) of the custom language model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listCorpora(
        customizationID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Corpora>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listCorpora")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/corpora"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Add a corpus.

     Adds a single corpus text file of new training data to a custom language model. Use multiple requests to submit
     multiple corpus text files. You must use credentials for the instance of the service that owns a model to add a
     corpus to it. Adding a corpus does not affect the custom language model until you train the model for the new data
     by using the **Train a custom language model** method.
     Submit a plain text file that contains sample sentences from the domain of interest to enable the service to
     extract words in context. The more sentences you add that represent the context in which speakers use words from
     the domain, the better the service's recognition accuracy.
     The call returns an HTTP 201 response code if the corpus is valid. The service then asynchronously processes the
     contents of the corpus and automatically extracts new words that it finds. This can take on the order of a minute
     or two to complete depending on the total number of words and the number of new words in the corpus, as well as the
     current load on the service. You cannot submit requests to add additional resources to the custom model or to train
     the model until the service's analysis of the corpus for the current request completes. Use the **List a corpus**
     method to check the status of the analysis.
     The service auto-populates the model's words resource with words from the corpus that are not found in its base
     vocabulary. These are referred to as out-of-vocabulary (OOV) words. You can use the **List custom words** method to
     examine the words resource. You can use other words method to eliminate typos and modify how words are pronounced
     as needed.
     To add a corpus file that has the same name as an existing corpus, set the `allow_overwrite` parameter to `true`;
     otherwise, the request fails. Overwriting an existing corpus causes the service to process the corpus text file and
     extract OOV words anew. Before doing so, it removes any OOV words associated with the existing corpus from the
     model's words resource unless they were also added by another corpus or grammar, or they have been modified in some
     way with the **Add custom words** or **Add a custom word** method.
     The service limits the overall amount of data that you can add to a custom model to a maximum of 10 million total
     words from all sources combined. Also, you can add no more than 30 thousand custom (OOV) words to a model. This
     includes words that the service extracts from corpora and grammars, and words that you add directly.
     **See also:**
     * [Working with corpora](https://cloud.ibm.com/docs/services/speech-to-text/language-resource.html#workingCorpora)
     * [Add corpora to the custom language
     model](https://cloud.ibm.com/docs/services/speech-to-text/language-create.html#addCorpora).

     - parameter customizationID: The customization ID (GUID) of the custom language model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter corpusName: The name of the new corpus for the custom language model. Use a localized name that
       matches the language of the custom model and reflects the contents of the corpus.
       * Include a maximum of 128 characters in the name.
       * Do not include spaces, slashes, or backslashes in the name.
       * Do not use the name of an existing corpus or grammar that is already defined for the custom model.
       * Do not use the name `user`, which is reserved by the service to denote custom words that are added or modified
       by the user.
     - parameter corpusFile: A plain text file that contains the training data for the corpus. Encode the file in
       UTF-8 if it contains non-ASCII characters; the service assumes UTF-8 encoding if it encounters non-ASCII
       characters.
       Make sure that you know the character encoding of the file. You must use that encoding when working with the
       words in the custom language model. For more information, see [Character
       encoding](https://cloud.ibm.com/docs/services/speech-to-text/language-resource.html#charEncoding).
       With the `curl` command, use the `--data-binary` option to upload the file for the request.
     - parameter allowOverwrite: If `true`, the specified corpus overwrites an existing corpus with the same name. If
       `false`, the request fails if a corpus with the same name already exists. The parameter has no effect if a corpus
       with the same name does not already exist.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func addCorpus(
        customizationID: String,
        corpusName: String,
        corpusFile: Data,
        allowOverwrite: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(corpusFile, withName: "corpus_file", fileName: "filename")
        guard let body = try? multipartFormData.toData() else {
            completionHandler(nil, WatsonError.serialization(values: "request multipart form data"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "addCorpus")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let allowOverwrite = allowOverwrite {
            let queryParameter = URLQueryItem(name: "allow_overwrite", value: "\(allowOverwrite)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/corpora/\(corpusName)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     Get a corpus.

     Gets information about a corpus from a custom language model. The information includes the total number of words
     and out-of-vocabulary (OOV) words, name, and status of the corpus. You must use credentials for the instance of the
     service that owns a model to list its corpora.
     **See also:** [Listing corpora for a custom language
     model](https://cloud.ibm.com/docs/services/speech-to-text/language-corpora.html#listCorpora).

     - parameter customizationID: The customization ID (GUID) of the custom language model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter corpusName: The name of the corpus for the custom language model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getCorpus(
        customizationID: String,
        corpusName: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Corpus>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getCorpus")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/corpora/\(corpusName)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete a corpus.

     Deletes an existing corpus from a custom language model. The service removes any out-of-vocabulary (OOV) words that
     are associated with the corpus from the custom model's words resource unless they were also added by another corpus
     or grammar, or they were modified in some way with the **Add custom words** or **Add a custom word** method.
     Removing a corpus does not affect the custom model until you train the model with the **Train a custom language
     model** method. You must use credentials for the instance of the service that owns a model to delete its corpora.
     **See also:** [Deleting a corpus from a custom language
     model](https://cloud.ibm.com/docs/services/speech-to-text/language-corpora.html#deleteCorpus).

     - parameter customizationID: The customization ID (GUID) of the custom language model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter corpusName: The name of the corpus for the custom language model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteCorpus(
        customizationID: String,
        corpusName: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteCorpus")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/corpora/\(corpusName)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.response(completionHandler: completionHandler)
    }

    /**
     List custom words.

     Lists information about custom words from a custom language model. You can list all words from the custom model's
     words resource, only custom words that were added or modified by the user, or only out-of-vocabulary (OOV) words
     that were extracted from corpora or are recognized by grammars. You can also indicate the order in which the
     service is to return words; by default, the service lists words in ascending alphabetical order. You must use
     credentials for the instance of the service that owns a model to list information about its words.
     **See also:** [Listing words from a custom language
     model](https://cloud.ibm.com/docs/services/speech-to-text/language-words.html#listWords).

     - parameter customizationID: The customization ID (GUID) of the custom language model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter wordType: The type of words to be listed from the custom language model's words resource:
       * `all` (the default) shows all words.
       * `user` shows only custom words that were added or modified by the user directly.
       * `corpora` shows only OOV that were extracted from corpora.
       * `grammars` shows only OOV words that are recognized by grammars.
     - parameter sort: Indicates the order in which the words are to be listed, `alphabetical` or by `count`. You can
       prepend an optional `+` or `-` to an argument to indicate whether the results are to be sorted in ascending or
       descending order. By default, words are sorted in ascending alphabetical order. For alphabetical ordering, the
       lexicographical precedence is numeric values, uppercase letters, and lowercase letters. For count ordering,
       values with the same count are ordered alphabetically. With the `curl` command, URL encode the `+` symbol as
       `%2B`.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listWords(
        customizationID: String,
        wordType: String? = nil,
        sort: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Words>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listWords")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let wordType = wordType {
            let queryParameter = URLQueryItem(name: "word_type", value: wordType)
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Add custom words.

     Adds one or more custom words to a custom language model. The service populates the words resource for a custom
     model with out-of-vocabulary (OOV) words from each corpus or grammar that is added to the model. You can use this
     method to add additional words or to modify existing words in the words resource. The words resource for a model
     can contain a maximum of 30 thousand custom (OOV) words. This includes words that the service extracts from corpora
     and grammars and words that you add directly.
     You must use credentials for the instance of the service that owns a model to add or modify custom words for the
     model. Adding or modifying custom words does not affect the custom model until you train the model for the new data
     by using the **Train a custom language model** method.
     You add custom words by providing a `CustomWords` object, which is an array of `CustomWord` objects, one per word.
     You must use the object's `word` parameter to identify the word that is to be added. You can also provide one or
     both of the optional `sounds_like` and `display_as` fields for each word.
     * The `sounds_like` field provides an array of one or more pronunciations for the word. Use the parameter to
     specify how the word can be pronounced by users. Use the parameter for words that are difficult to pronounce,
     foreign words, acronyms, and so on. For example, you might specify that the word `IEEE` can sound like `i triple
     e`. You can specify a maximum of five sounds-like pronunciations for a word.
     * The `display_as` field provides a different way of spelling the word in a transcript. Use the parameter when you
     want the word to appear different from its usual representation or from its spelling in training data. For example,
     you might indicate that the word `IBM(trademark)` is to be displayed as `IBM&trade;`.
     If you add a custom word that already exists in the words resource for the custom model, the new definition
     overwrites the existing data for the word. If the service encounters an error with the input data, it returns a
     failure code and does not add any of the words to the words resource.
     The call returns an HTTP 201 response code if the input data is valid. It then asynchronously processes the words
     to add them to the model's words resource. The time that it takes for the analysis to complete depends on the
     number of new words that you add but is generally faster than adding a corpus or grammar.
     You can monitor the status of the request by using the **List a custom language model** method to poll the model's
     status. Use a loop to check the status every 10 seconds. The method returns a `Customization` object that includes
     a `status` field. A status of `ready` means that the words have been added to the custom model. The service cannot
     accept requests to add new data or to train the model until the existing request completes.
     You can use the **List custom words** or **List a custom word** method to review the words that you add. Words with
     an invalid `sounds_like` field include an `error` field that describes the problem. You can use other words-related
     methods to correct errors, eliminate typos, and modify how words are pronounced as needed.
     **See also:**
     * [Working with custom
     words](https://cloud.ibm.com/docs/services/speech-to-text/language-resource.html#workingWords)
     * [Add words to the custom language
     model](https://cloud.ibm.com/docs/services/speech-to-text/language-create.html#addWords).

     - parameter customizationID: The customization ID (GUID) of the custom language model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter words: An array of `CustomWord` objects that provides information about each custom word that is to
       be added to or updated in the custom language model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func addWords(
        customizationID: String,
        words: [CustomWord],
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct body
        let addWordsRequest = CustomWords(
            words: words)
        guard let body = try? JSON.encoder.encode(addWordsRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "addWords")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.response(completionHandler: completionHandler)
    }

    /**
     Add a custom word.

     Adds a custom word to a custom language model. The service populates the words resource for a custom model with
     out-of-vocabulary (OOV) words from each corpus or grammar that is added to the model. You can use this method to
     add a word or to modify an existing word in the words resource. The words resource for a model can contain a
     maximum of 30 thousand custom (OOV) words. This includes words that the service extracts from corpora and grammars
     and words that you add directly.
     You must use credentials for the instance of the service that owns a model to add or modify a custom word for the
     model. Adding or modifying a custom word does not affect the custom model until you train the model for the new
     data by using the **Train a custom language model** method.
     Use the `word_name` parameter to specify the custom word that is to be added or modified. Use the `CustomWord`
     object to provide one or both of the optional `sounds_like` and `display_as` fields for the word.
     * The `sounds_like` field provides an array of one or more pronunciations for the word. Use the parameter to
     specify how the word can be pronounced by users. Use the parameter for words that are difficult to pronounce,
     foreign words, acronyms, and so on. For example, you might specify that the word `IEEE` can sound like `i triple
     e`. You can specify a maximum of five sounds-like pronunciations for a word.
     * The `display_as` field provides a different way of spelling the word in a transcript. Use the parameter when you
     want the word to appear different from its usual representation or from its spelling in training data. For example,
     you might indicate that the word `IBM(trademark)` is to be displayed as `IBM&trade;`.
     If you add a custom word that already exists in the words resource for the custom model, the new definition
     overwrites the existing data for the word. If the service encounters an error, it does not add the word to the
     words resource. Use the **List a custom word** method to review the word that you add.
     **See also:**
     * [Working with custom
     words](https://cloud.ibm.com/docs/services/speech-to-text/language-resource.html#workingWords)
     * [Add words to the custom language
     model](https://cloud.ibm.com/docs/services/speech-to-text/language-create.html#addWords).

     - parameter customizationID: The customization ID (GUID) of the custom language model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter wordName: The custom word that is to be added to or updated in the custom language model. Do not
       include spaces in the word. Use a `-` (dash) or `_` (underscore) to connect the tokens of compound words.
       URL-encode the word if it includes non-ASCII characters. For more information, see [Character
       encoding](https://cloud.ibm.com/docs/services/speech-to-text/language-resource.html#charEncoding).
     - parameter word: For the **Add custom words** method, you must specify the custom word that is to be added to or
       updated in the custom model. Do not include spaces in the word. Use a `-` (dash) or `_` (underscore) to connect
       the tokens of compound words.
       Omit this parameter for the **Add a custom word** method.
     - parameter soundsLike: An array of sounds-like pronunciations for the custom word. Specify how words that are
       difficult to pronounce, foreign words, acronyms, and so on can be pronounced by users.
       * For a word that is not in the service's base vocabulary, omit the parameter to have the service automatically
       generate a sounds-like pronunciation for the word.
       * For a word that is in the service's base vocabulary, use the parameter to specify additional pronunciations for
       the word. You cannot override the default pronunciation of a word; pronunciations you add augment the
       pronunciation from the base vocabulary.
       A word can have at most five sounds-like pronunciations. A pronunciation can include at most 40 characters not
       including spaces.
     - parameter displayAs: An alternative spelling for the custom word when it appears in a transcript. Use the
       parameter when you want the word to have a spelling that is different from its usual representation or from its
       spelling in corpora training data.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func addWord(
        customizationID: String,
        wordName: String,
        word: String? = nil,
        soundsLike: [String]? = nil,
        displayAs: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct body
        let addWordRequest = CustomWord(
            word: word,
            soundsLike: soundsLike,
            displayAs: displayAs)
        guard let body = try? JSON.encoder.encode(addWordRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "addWord")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words/\(wordName)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.response(completionHandler: completionHandler)
    }

    /**
     Get a custom word.

     Gets information about a custom word from a custom language model. You must use credentials for the instance of the
     service that owns a model to list information about its words.
     **See also:** [Listing words from a custom language
     model](https://cloud.ibm.com/docs/services/speech-to-text/language-words.html#listWords).

     - parameter customizationID: The customization ID (GUID) of the custom language model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter wordName: The custom word that is to be read from the custom language model. URL-encode the word if
       it includes non-ASCII characters. For more information, see [Character
       encoding](https://cloud.ibm.com/docs/services/speech-to-text/language-resource.html#charEncoding).
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getWord(
        customizationID: String,
        wordName: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Word>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getWord")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words/\(wordName)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete a custom word.

     Deletes a custom word from a custom language model. You can remove any word that you added to the custom model's
     words resource via any means. However, if the word also exists in the service's base vocabulary, the service
     removes only the custom pronunciation for the word; the word remains in the base vocabulary. Removing a custom word
     does not affect the custom model until you train the model with the **Train a custom language model** method. You
     must use credentials for the instance of the service that owns a model to delete its words.
     **See also:** [Deleting a word from a custom language
     model](https://cloud.ibm.com/docs/services/speech-to-text/language-words.html#deleteWord).

     - parameter customizationID: The customization ID (GUID) of the custom language model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter wordName: The custom word that is to be deleted from the custom language model. URL-encode the word
       if it includes non-ASCII characters. For more information, see [Character
       encoding](https://cloud.ibm.com/docs/services/speech-to-text/language-resource.html#charEncoding).
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteWord(
        customizationID: String,
        wordName: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteWord")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words/\(wordName)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.response(completionHandler: completionHandler)
    }

    /**
     List grammars.

     Lists information about all grammars from a custom language model. The information includes the total number of
     out-of-vocabulary (OOV) words, name, and status of each grammar. You must use credentials for the instance of the
     service that owns a model to list its grammars.
     **See also:** [Listing grammars from a custom language model](https://cloud.ibm.com/docs/services/speech-to-text/).

     - parameter customizationID: The customization ID (GUID) of the custom language model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listGrammars(
        customizationID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Grammars>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listGrammars")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/grammars"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Add a grammar.

     Adds a single grammar file to a custom language model. Submit a plain text file in UTF-8 format that defines the
     grammar. Use multiple requests to submit multiple grammar files. You must use credentials for the instance of the
     service that owns a model to add a grammar to it. Adding a grammar does not affect the custom language model until
     you train the model for the new data by using the **Train a custom language model** method.
     The call returns an HTTP 201 response code if the grammar is valid. The service then asynchronously processes the
     contents of the grammar and automatically extracts new words that it finds. This can take a few seconds to complete
     depending on the size and complexity of the grammar, as well as the current load on the service. You cannot submit
     requests to add additional resources to the custom model or to train the model until the service's analysis of the
     grammar for the current request completes. Use the **Get a grammar** method to check the status of the analysis.
     The service populates the model's words resource with any word that is recognized by the grammar that is not found
     in the model's base vocabulary. These are referred to as out-of-vocabulary (OOV) words. You can use the **List
     custom words** method to examine the words resource and use other words-related methods to eliminate typos and
     modify how words are pronounced as needed.
     To add a grammar that has the same name as an existing grammar, set the `allow_overwrite` parameter to `true`;
     otherwise, the request fails. Overwriting an existing grammar causes the service to process the grammar file and
     extract OOV words anew. Before doing so, it removes any OOV words associated with the existing grammar from the
     model's words resource unless they were also added by another resource or they have been modified in some way with
     the **Add custom words** or **Add a custom word** method.
     The service limits the overall amount of data that you can add to a custom model to a maximum of 10 million total
     words from all sources combined. Also, you can add no more than 30 thousand OOV words to a model. This includes
     words that the service extracts from corpora and grammars and words that you add directly.
     **See also:**
     * [Working with grammars](https://cloud.ibm.com/docs/services/speech-to-text/)
     * [Add grammars to the custom language model](https://cloud.ibm.com/docs/services/speech-to-text/).

     - parameter customizationID: The customization ID (GUID) of the custom language model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter grammarName: The name of the new grammar for the custom language model. Use a localized name that
       matches the language of the custom model and reflects the contents of the grammar.
       * Include a maximum of 128 characters in the name.
       * Do not include spaces, slashes, or backslashes in the name.
       * Do not use the name of an existing grammar or corpus that is already defined for the custom model.
       * Do not use the name `user`, which is reserved by the service to denote custom words that are added or modified
       by the user.
     - parameter grammarFile: A plain text file that contains the grammar in the format specified by the
       `Content-Type` header. Encode the file in UTF-8 (ASCII is a subset of UTF-8). Using any other encoding can lead
       to issues when compiling the grammar or to unexpected results in decoding. The service ignores an encoding that
       is specified in the header of the grammar.
     - parameter contentType: The format (MIME type) of the grammar file:
       * `application/srgs` for Augmented Backus-Naur Form (ABNF), which uses a plain-text representation that is
       similar to traditional BNF grammars.
       * `application/srgs+xml` for XML Form, which uses XML elements to represent the grammar.
     - parameter allowOverwrite: If `true`, the specified grammar overwrites an existing grammar with the same name.
       If `false`, the request fails if a grammar with the same name already exists. The parameter has no effect if a
       grammar with the same name does not already exist.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func addGrammar(
        customizationID: String,
        grammarName: String,
        grammarFile: String,
        contentType: String,
        allowOverwrite: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct body
        // convert body parameter to Data with UTF-8 encoding
        guard let body = grammarFile.data(using: .utf8) else {
            let error = WatsonError.serialization(values: "grammarFile could not be encoded with UTF8.")
            completionHandler(nil, error)
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "addGrammar")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let allowOverwrite = allowOverwrite {
            let queryParameter = URLQueryItem(name: "allow_overwrite", value: "\(allowOverwrite)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/grammars/\(grammarName)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     Get a grammar.

     Gets information about a grammar from a custom language model. The information includes the total number of
     out-of-vocabulary (OOV) words, name, and status of the grammar. You must use credentials for the instance of the
     service that owns a model to list its grammars.
     **See also:** [Listing grammars from a custom language model](https://cloud.ibm.com/docs/services/speech-to-text/).

     - parameter customizationID: The customization ID (GUID) of the custom language model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter grammarName: The name of the grammar for the custom language model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getGrammar(
        customizationID: String,
        grammarName: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Grammar>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getGrammar")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/grammars/\(grammarName)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete a grammar.

     Deletes an existing grammar from a custom language model. The service removes any out-of-vocabulary (OOV) words
     associated with the grammar from the custom model's words resource unless they were also added by another resource
     or they were modified in some way with the **Add custom words** or **Add a custom word** method. Removing a grammar
     does not affect the custom model until you train the model with the **Train a custom language model** method. You
     must use credentials for the instance of the service that owns a model to delete its grammar.
     **See also:** [Deleting a grammar from a custom language
     model](https://cloud.ibm.com/docs/services/speech-to-text/).

     - parameter customizationID: The customization ID (GUID) of the custom language model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter grammarName: The name of the grammar for the custom language model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteGrammar(
        customizationID: String,
        grammarName: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteGrammar")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/grammars/\(grammarName)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.response(completionHandler: completionHandler)
    }

    /**
     Create a custom acoustic model.

     Creates a new custom acoustic model for a specified base model. The custom acoustic model can be used only with the
     base model for which it is created. The model is owned by the instance of the service whose credentials are used to
     create it.
     **See also:** [Create a custom acoustic
     model](https://cloud.ibm.com/docs/services/speech-to-text/acoustic-create.html#createModel-acoustic).

     - parameter name: A user-defined name for the new custom acoustic model. Use a name that is unique among all
       custom acoustic models that you own. Use a localized name that matches the language of the custom model. Use a
       name that describes the acoustic environment of the custom model, such as `Mobile custom model` or `Noisy car
       custom model`.
     - parameter baseModelName: The name of the base language model that is to be customized by the new custom
       acoustic model. The new custom model can be used only with the base model that it customizes.
       To determine whether a base model supports acoustic model customization, refer to [Language support for
       customization](https://cloud.ibm.com/docs/services/speech-to-text/custom.html#languageSupport).
     - parameter description: A description of the new custom acoustic model. Use a localized description that matches
       the language of the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createAcousticModel(
        name: String,
        baseModelName: String,
        description: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<AcousticModel>?, WatsonError?) -> Void)
    {
        // construct body
        let createAcousticModelRequest = CreateAcousticModel(
            name: name,
            baseModelName: baseModelName,
            description: description)
        guard let body = try? JSON.encoder.encode(createAcousticModelRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createAcousticModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v1/acoustic_customizations",
            headerParameters: headerParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List custom acoustic models.

     Lists information about all custom acoustic models that are owned by an instance of the service. Use the `language`
     parameter to see all custom acoustic models for the specified language. Omit the parameter to see all custom
     acoustic models for all languages. You must use credentials for the instance of the service that owns a model to
     list information about it.
     **See also:** [Listing custom acoustic
     models](https://cloud.ibm.com/docs/services/speech-to-text/acoustic-models.html#listModels-acoustic).

     - parameter language: The identifier of the language for which custom language or custom acoustic models are to
       be returned (for example, `en-US`). Omit the parameter to see all custom language or custom acoustic models that
       are owned by the requesting credentials.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listAcousticModels(
        language: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<AcousticModels>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listAcousticModels")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
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
            url: serviceURL + "/v1/acoustic_customizations",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Get a custom acoustic model.

     Gets information about a specified custom acoustic model. You must use credentials for the instance of the service
     that owns a model to list information about it.
     **See also:** [Listing custom acoustic
     models](https://cloud.ibm.com/docs/services/speech-to-text/acoustic-models.html#listModels-acoustic).

     - parameter customizationID: The customization ID (GUID) of the custom acoustic model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getAcousticModel(
        customizationID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<AcousticModel>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getAcousticModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/acoustic_customizations/\(customizationID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete a custom acoustic model.

     Deletes an existing custom acoustic model. The custom model cannot be deleted if another request, such as adding an
     audio resource to the model, is currently being processed. You must use credentials for the instance of the service
     that owns a model to delete it.
     **See also:** [Deleting a custom acoustic
     model](https://cloud.ibm.com/docs/services/speech-to-text/acoustic-models.html#deleteModel-acoustic).

     - parameter customizationID: The customization ID (GUID) of the custom acoustic model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteAcousticModel(
        customizationID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteAcousticModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/acoustic_customizations/\(customizationID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.response(completionHandler: completionHandler)
    }

    /**
     Train a custom acoustic model.

     Initiates the training of a custom acoustic model with new or changed audio resources. After adding or deleting
     audio resources for a custom acoustic model, use this method to begin the actual training of the model on the
     latest audio data. The custom acoustic model does not reflect its changed data until you train it. You must use
     credentials for the instance of the service that owns a model to train it.
     The training method is asynchronous. It can take on the order of minutes or hours to complete depending on the
     total amount of audio data on which the custom acoustic model is being trained and the current load on the service.
     Typically, training a custom acoustic model takes approximately two to four times the length of its audio data. The
     range of time depends on the model being trained and the nature of the audio, such as whether the audio is clean or
     noisy. The method returns an HTTP 200 response code to indicate that the training process has begun.
     You can monitor the status of the training by using the **Get a custom acoustic model** method to poll the model's
     status. Use a loop to check the status once a minute. The method returns an `AcousticModel` object that includes
     `status` and `progress` fields. A status of `available` indicates that the custom model is trained and ready to
     use. The service cannot accept subsequent training requests, or requests to add new audio resources, until the
     existing request completes.
     You can use the optional `custom_language_model_id` parameter to specify the GUID of a separately created custom
     language model that is to be used during training. Train with a custom language model if you have verbatim
     transcriptions of the audio files that you have added to the custom model or you have either corpora (text files)
     or a list of words that are relevant to the contents of the audio files. Both of the custom models must be based on
     the same version of the same base model for training to succeed.
     Training can fail to start for the following reasons:
     * The service is currently handling another request for the custom model, such as another training request or a
     request to add audio resources to the model.
     * The custom model contains less than 10 minutes or more than 100 hours of audio data.
     * One or more of the custom model's audio resources is invalid.
     * You passed an incompatible custom language model with the `custom_language_model_id` query parameter. Both custom
     models must be based on the same version of the same base model.
     **See also:** [Train the custom acoustic
     model](https://cloud.ibm.com/docs/services/speech-to-text/acoustic-create.html#trainModel-acoustic).

     - parameter customizationID: The customization ID (GUID) of the custom acoustic model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter customLanguageModelID: The customization ID (GUID) of a custom language model that is to be used
       during training of the custom acoustic model. Specify a custom language model that has been trained with verbatim
       transcriptions of the audio resources or that contains words that are relevant to the contents of the audio
       resources. The custom language model must be based on the same version of the same base model as the custom
       acoustic model. The credentials specified with the request must own both custom models.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func trainAcousticModel(
        customizationID: String,
        customLanguageModelID: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "trainAcousticModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let customLanguageModelID = customLanguageModelID {
            let queryParameter = URLQueryItem(name: "custom_language_model_id", value: customLanguageModelID)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/acoustic_customizations/\(customizationID)/train"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     Reset a custom acoustic model.

     Resets a custom acoustic model by removing all audio resources from the model. Resetting a custom acoustic model
     initializes the model to its state when it was first created. Metadata such as the name and language of the model
     are preserved, but the model's audio resources are removed and must be re-created. You must use credentials for the
     instance of the service that owns a model to reset it.
     **See also:** [Resetting a custom acoustic
     model](https://cloud.ibm.com/docs/services/speech-to-text/acoustic-models.html#resetModel-acoustic).

     - parameter customizationID: The customization ID (GUID) of the custom acoustic model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func resetAcousticModel(
        customizationID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "resetAcousticModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/acoustic_customizations/\(customizationID)/reset"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     Upgrade a custom acoustic model.

     Initiates the upgrade of a custom acoustic model to the latest version of its base language model. The upgrade
     method is asynchronous. It can take on the order of minutes or hours to complete depending on the amount of data in
     the custom model and the current load on the service; typically, upgrade takes approximately twice the length of
     the total audio contained in the custom model. A custom model must be in the `ready` or `available` state to be
     upgraded. You must use credentials for the instance of the service that owns a model to upgrade it.
     The method returns an HTTP 200 response code to indicate that the upgrade process has begun successfully. You can
     monitor the status of the upgrade by using the **Get a custom acoustic model** method to poll the model's status.
     The method returns an `AcousticModel` object that includes `status` and `progress` fields. Use a loop to check the
     status once a minute. While it is being upgraded, the custom model has the status `upgrading`. When the upgrade is
     complete, the model resumes the status that it had prior to upgrade. The service cannot accept subsequent requests
     for the model until the upgrade completes.
     If the custom acoustic model was trained with a separately created custom language model, you must use the
     `custom_language_model_id` parameter to specify the GUID of that custom language model. The custom language model
     must be upgraded before the custom acoustic model can be upgraded. Omit the parameter if the custom acoustic model
     was not trained with a custom language model.
     **See also:** [Upgrading a custom acoustic
     model](https://cloud.ibm.com/docs/services/speech-to-text/custom-upgrade.html#upgradeAcoustic).

     - parameter customizationID: The customization ID (GUID) of the custom acoustic model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter customLanguageModelID: If the custom acoustic model was trained with a custom language model, the
       customization ID (GUID) of that custom language model. The custom language model must be upgraded before the
       custom acoustic model can be upgraded. The credentials specified with the request must own both custom models.
     - parameter force: If `true`, forces the upgrade of a custom acoustic model for which no input data has been
       modified since it was last trained. Use this parameter only to force the upgrade of a custom acoustic model that
       is trained with a custom language model, and only if you receive a 400 response code and the message `No input
       data modified since last training`. See [Upgrading a custom acoustic
       model](https://cloud.ibm.com/docs/services/speech-to-text/custom-upgrade.html#upgradeAcoustic).
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func upgradeAcousticModel(
        customizationID: String,
        customLanguageModelID: String? = nil,
        force: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "upgradeAcousticModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let customLanguageModelID = customLanguageModelID {
            let queryParameter = URLQueryItem(name: "custom_language_model_id", value: customLanguageModelID)
            queryParameters.append(queryParameter)
        }
        if let force = force {
            let queryParameter = URLQueryItem(name: "force", value: "\(force)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/acoustic_customizations/\(customizationID)/upgrade_model"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     List audio resources.

     Lists information about all audio resources from a custom acoustic model. The information includes the name of the
     resource and information about its audio data, such as its duration. It also includes the status of the audio
     resource, which is important for checking the service's analysis of the resource in response to a request to add it
     to the custom acoustic model. You must use credentials for the instance of the service that owns a model to list
     its audio resources.
     **See also:** [Listing audio resources for a custom acoustic
     model](https://cloud.ibm.com/docs/services/speech-to-text/acoustic-audio.html#listAudio).

     - parameter customizationID: The customization ID (GUID) of the custom acoustic model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listAudio(
        customizationID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<AudioResources>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listAudio")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/acoustic_customizations/\(customizationID)/audio"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Add an audio resource.

     Adds an audio resource to a custom acoustic model. Add audio content that reflects the acoustic characteristics of
     the audio that you plan to transcribe. You must use credentials for the instance of the service that owns a model
     to add an audio resource to it. Adding audio data does not affect the custom acoustic model until you train the
     model for the new data by using the **Train a custom acoustic model** method.
     You can add individual audio files or an archive file that contains multiple audio files. Adding multiple audio
     files via a single archive file is significantly more efficient than adding each file individually. You can add
     audio resources in any format that the service supports for speech recognition.
     You can use this method to add any number of audio resources to a custom model by calling the method once for each
     audio or archive file. But the addition of one audio resource must be fully complete before you can add another.
     You must add a minimum of 10 minutes and a maximum of 100 hours of audio that includes speech, not just silence, to
     a custom acoustic model before you can train it. No audio resource, audio- or archive-type, can be larger than 100
     MB. To add an audio resource that has the same name as an existing audio resource, set the `allow_overwrite`
     parameter to `true`; otherwise, the request fails.
     The method is asynchronous. It can take several seconds to complete depending on the duration of the audio and, in
     the case of an archive file, the total number of audio files being processed. The service returns a 201 response
     code if the audio is valid. It then asynchronously analyzes the contents of the audio file or files and
     automatically extracts information about the audio such as its length, sampling rate, and encoding. You cannot
     submit requests to add additional audio resources to a custom acoustic model, or to train the model, until the
     service's analysis of all audio files for the current request completes.
     To determine the status of the service's analysis of the audio, use the **Get an audio resource** method to poll
     the status of the audio. The method accepts the customization ID of the custom model and the name of the audio
     resource, and it returns the status of the resource. Use a loop to check the status of the audio every few seconds
     until it becomes `ok`.
     **See also:** [Add audio to the custom acoustic
     model](https://cloud.ibm.com/docs/services/speech-to-text/acoustic-create.html#addAudio).
     ### Content types for audio-type resources
      You can add an individual audio file in any format that the service supports for speech recognition. For an
     audio-type resource, use the `Content-Type` parameter to specify the audio format (MIME type) of the audio file,
     including specifying the sampling rate, channels, and endianness where indicated.
     * `audio/alaw` (Specify the sampling rate (`rate`) of the audio.)
     * `audio/basic` (Use only with narrowband models.)
     * `audio/flac`
     * `audio/g729` (Use only with narrowband models.)
     * `audio/l16` (Specify the sampling rate (`rate`) and optionally the number of channels (`channels`) and endianness
     (`endianness`) of the audio.)
     * `audio/mp3`
     * `audio/mpeg`
     * `audio/mulaw` (Specify the sampling rate (`rate`) of the audio.)
     * `audio/ogg` (The service automatically detects the codec of the input audio.)
     * `audio/ogg;codecs=opus`
     * `audio/ogg;codecs=vorbis`
     * `audio/wav` (Provide audio with a maximum of nine channels.)
     * `audio/webm` (The service automatically detects the codec of the input audio.)
     * `audio/webm;codecs=opus`
     * `audio/webm;codecs=vorbis`
     The sampling rate of an audio file must match the sampling rate of the base model for the custom model: for
     broadband models, at least 16 kHz; for narrowband models, at least 8 kHz. If the sampling rate of the audio is
     higher than the minimum required rate, the service down-samples the audio to the appropriate rate. If the sampling
     rate of the audio is lower than the minimum required rate, the service labels the audio file as `invalid`.
      **See also:** [Audio formats](https://cloud.ibm.com/docs/services/speech-to-text/audio-formats.html).
     ### Content types for archive-type resources
      You can add an archive file (**.zip** or **.tar.gz** file) that contains audio files in any format that the
     service supports for speech recognition. For an archive-type resource, use the `Content-Type` parameter to specify
     the media type of the archive file:
     * `application/zip` for a **.zip** file
     * `application/gzip` for a **.tar.gz** file.
     When you add an archive-type resource, the `Contained-Content-Type` header is optional depending on the format of
     the files that you are adding:
     * For audio files of type `audio/alaw`, `audio/basic`, `audio/l16`, or `audio/mulaw`, you must use the
     `Contained-Content-Type` header to specify the format of the contained audio files. Include the `rate`, `channels`,
     and `endianness` parameters where necessary. In this case, all audio files contained in the archive file must have
     the same audio format.
     * For audio files of all other types, you can omit the `Contained-Content-Type` header. In this case, the audio
     files contained in the archive file can have any of the formats not listed in the previous bullet. The audio files
     do not need to have the same format.
     Do not use the `Contained-Content-Type` header when adding an audio-type resource.
     ### Naming restrictions for embedded audio files
      The name of an audio file that is embedded within an archive-type resource must meet the following restrictions:
     * Include a maximum of 128 characters in the file name; this includes the file extension.
     * Do not include spaces, slashes, or backslashes in the file name.
     * Do not use the name of an audio file that has already been added to the custom model as part of an archive-type
     resource.

     - parameter customizationID: The customization ID (GUID) of the custom acoustic model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter audioName: The name of the new audio resource for the custom acoustic model. Use a localized name
       that matches the language of the custom model and reflects the contents of the resource.
       * Include a maximum of 128 characters in the name.
       * Do not include spaces, slashes, or backslashes in the name.
       * Do not use the name of an audio resource that has already been added to the custom model.
     - parameter audioResource: The audio resource that is to be added to the custom acoustic model, an individual
       audio file or an archive file.
     - parameter containedContentType: **For an archive-type resource,** specify the format of the audio files that
       are contained in the archive file if they are of type `audio/alaw`, `audio/basic`, `audio/l16`, or `audio/mulaw`.
       Include the `rate`, `channels`, and `endianness` parameters where necessary. In this case, all audio files that
       are contained in the archive file must be of the indicated type.
       For all other audio formats, you can omit the header. In this case, the audio files can be of multiple types as
       long as they are not of the types listed in the previous paragraph.
       The parameter accepts all of the audio formats that are supported for use with speech recognition. For more
       information, see **Content types for audio-type resources** in the method description.
       **For an audio-type resource,** omit the header.
     - parameter allowOverwrite: If `true`, the specified audio resource overwrites an existing audio resource with
       the same name. If `false`, the request fails if an audio resource with the same name already exists. The
       parameter has no effect if an audio resource with the same name does not already exist.
     - parameter contentType: For an audio-type resource, the format (MIME type) of the audio. For more information,
       see **Content types for audio-type resources** in the method description.
       For an archive-type resource, the media type of the archive file. For more information, see **Content types for
       archive-type resources** in the method description.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func addAudio(
        customizationID: String,
        audioName: String,
        audioResource: Data,
        containedContentType: String? = nil,
        allowOverwrite: Bool? = nil,
        contentType: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct body
        let body = audioResource

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "addAudio")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let containedContentType = containedContentType {
            headerParameters["Contained-Content-Type"] = containedContentType
        }
        if let contentType = contentType {
            headerParameters["Content-Type"] = contentType
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let allowOverwrite = allowOverwrite {
            let queryParameter = URLQueryItem(name: "allow_overwrite", value: "\(allowOverwrite)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/acoustic_customizations/\(customizationID)/audio/\(audioName)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     Get an audio resource.

     Gets information about an audio resource from a custom acoustic model. The method returns an `AudioListing` object
     whose fields depend on the type of audio resource that you specify with the method's `audio_name` parameter:
     * **For an audio-type resource,** the object's fields match those of an `AudioResource` object: `duration`, `name`,
     `details`, and `status`.
     * **For an archive-type resource,** the object includes a `container` field whose fields match those of an
     `AudioResource` object. It also includes an `audio` field, which contains an array of `AudioResource` objects that
     provides information about the audio files that are contained in the archive.
     The information includes the status of the specified audio resource. The status is important for checking the
     service's analysis of a resource that you add to the custom model.
     * For an audio-type resource, the `status` field is located in the `AudioListing` object.
     * For an archive-type resource, the `status` field is located in the `AudioResource` object that is returned in the
     `container` field.
     You must use credentials for the instance of the service that owns a model to list its audio resources.
     **See also:** [Listing audio resources for a custom acoustic
     model](https://cloud.ibm.com/docs/services/speech-to-text/acoustic-audio.html#listAudio).

     - parameter customizationID: The customization ID (GUID) of the custom acoustic model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter audioName: The name of the audio resource for the custom acoustic model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getAudio(
        customizationID: String,
        audioName: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<AudioListing>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getAudio")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/acoustic_customizations/\(customizationID)/audio/\(audioName)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete an audio resource.

     Deletes an existing audio resource from a custom acoustic model. Deleting an archive-type audio resource removes
     the entire archive of files; the current interface does not allow deletion of individual files from an archive
     resource. Removing an audio resource does not affect the custom model until you train the model on its updated data
     by using the **Train a custom acoustic model** method. You must use credentials for the instance of the service
     that owns a model to delete its audio resources.
     **See also:** [Deleting an audio resource from a custom acoustic
     model](https://cloud.ibm.com/docs/services/speech-to-text/acoustic-audio.html#deleteAudio).

     - parameter customizationID: The customization ID (GUID) of the custom acoustic model that is to be used for the
       request. You must make the request with credentials for the instance of the service that owns the custom model.
     - parameter audioName: The name of the audio resource for the custom acoustic model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteAudio(
        customizationID: String,
        audioName: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteAudio")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/acoustic_customizations/\(customizationID)/audio/\(audioName)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
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
        request.response(completionHandler: completionHandler)
    }

    /**
     Delete labeled data.

     Deletes all data that is associated with a specified customer ID. The method deletes all data for the customer ID,
     regardless of the method by which the information was added. The method has no effect if no data is associated with
     the customer ID. You must issue the request with credentials for the same instance of the service that was used to
     associate the customer ID with the data.
     You associate a customer ID with data by passing the `X-Watson-Metadata` header with a request that passes the
     data.
     **See also:** [Information security](https://cloud.ibm.com/docs/services/speech-to-text/information-security.html).

     - parameter customerID: The customer ID for which all data is to be deleted.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteUserData(
        customerID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteUserData")
        headerParameters.merge(sdkHeaders) { (_, new) in new }

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
        request.response(completionHandler: completionHandler)
    }

}
