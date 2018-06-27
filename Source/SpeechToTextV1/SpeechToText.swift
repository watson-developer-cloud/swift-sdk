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
 The IBM&reg; Speech to Text service provides an API that uses IBM's speech-recognition capabilities to produce
 transcripts of spoken audio. The service can transcribe speech from various languages and audio formats. It addition to
 basic transcription, the service can produce detailed information about many aspects of the audio. For most languages,
 the service supports two sampling rates, broadband and narrowband. It returns all JSON response content in the UTF-8
 character set. For more information about the service, see the [IBM&reg; Cloud
 documentation](https://console.bluemix.net/docs/services/speech-to-text/index.html).
 ### API usage guidelines
 * **Audio formats:** The service accepts audio in many formats (MIME types). See [Audio
 formats](https://console.bluemix.net/docs/services/speech-to-text/audio-formats.html).
 * **HTTP interfaces:** The service provides three HTTP interfaces for speech recognition. The sessionless interface
 includes a single synchronous method. The session-based interface includes multiple synchronous methods for maintaining
 a long, multi-turn exchange with the service. And the asynchronous interface provides multiple methods that use
 registered callbacks and polling for non-blocking recognition. See [The HTTP REST
 interface](https://console.bluemix.net/docs/services/speech-to-text/http.html) and [The asynchronous HTTP
 interface](https://console.bluemix.net/docs/services/speech-to-text/async.html).
 * **WebSocket interface:** The service also offers a WebSocket interface for speech recognition. The WebSocket
 interface provides a full-duplex, low-latency communication channel. Clients send requests and audio to the service and
 receive results over a single connection in an asynchronous fashion. See [The WebSocket
 interface](https://console.bluemix.net/docs/services/speech-to-text/websockets.html).
 * **Customization:** Use language model customization to expand the vocabulary of a base model with domain-specific
 terminology. Use acoustic model customization to adapt a base model for the acoustic characteristics of your audio.
 Language model customization is generally available for production use by most supported languages; acoustic model
 customization is beta functionality that is available for all supported languages. See [The customization
 interface](https://console.bluemix.net/docs/services/speech-to-text/custom.html).
 * **Customization IDs:** Many methods accept a customization ID to identify a custom language or custom acoustic model.
 Customization IDs are Globally Unique Identifiers (GUIDs). They are hexadecimal strings that have the format
 `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.
 * **`X-Watson-Learning-Opt-Out`:** By default, all Watson services log requests and their results. Logging is done only
 to improve the services for future users. The logged data is not shared or made public. To prevent IBM from accessing
 your data for general service improvements, set the `X-Watson-Learning-Opt-Out` request header to `true` for all
 requests. You must set the header on each request that you do not want IBM to access for general service improvements.
   Methods of the customization interface do not log corpora, words, and audio resources that you use to build custom
 models. Your training data is never used to improve the service's base models. However, the service does log such data
 when a custom model is used with a recognition request. You must set the `X-Watson-Learning-Opt-Out` request header to
 `true` to prevent IBM from accessing the data to improve the service.
 * **`X-Watson-Metadata`**: This header allows you to associate a customer ID with data that is passed with a request.
 If necessary, you can use the **Delete labeled data** method to delete the data for a customer ID. See [Information
 security](https://console.bluemix.net/docs/services/speech-to-text/information-security.html).
 */
public class SpeechToText {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://stream.watsonplatform.net/speech-to-text/api"

    /// The URL that shall be used to obtain a token.
    public var tokenURL = "https://stream.watsonplatform.net/authorization/api/v1/token"

    /// The URL that shall be used to stream audio for transcription.
    public var websocketsURL = "wss://stream.watsonplatform.net/speech-to-text/api/v1/recognize"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    internal let session = URLSession(configuration: URLSessionConfiguration.default)
    internal var authMethod: AuthenticationMethod
    internal let domain = "com.ibm.watson.developer-cloud.SpeechToTextV1"

    /**
     Create a `SpeechToText` object.

     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     */
    public init(username: String, password: String) {
        self.authMethod = BasicAuthentication(username: username, password: password)
    }

    /**
     Create a `SpeechToText` object.

     - parameter apiKey: An API key for IAM that can be used to obtain access tokens for the service.
     - parameter iamUrl: The URL for the IAM service.
     */
    public init(version: String, apiKey: String, iamUrl: String? = nil) {
        self.authMethod = IAMAuthentication(apiKey: apiKey, url: iamUrl)
    }

    /**
     Create a `SpeechToText` object.

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
     If the response or data represents an error returned by the Speech to Text service,
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
                userInfo[NSLocalizedRecoverySuggestionErrorKey] = description
            }
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return NSError(domain: domain, code: code, userInfo: nil)
        }
    }

    /**
     List models.

     Lists all language models that are available for use with the service. The information includes the name of the
     model and its minimum sampling rate in Hertz, among other things.

     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listModels(
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SpeechModels) -> Void)
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
            url: serviceURL + "/v1/models",
            headerParameters: headerParameters
        )

        // execute REST request
        request.responseObject {
            (response: RestResponse<SpeechModels>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Get a model.

     Gets information for a single specified language model that is available for use with the service. The information
     includes the name of the model and its minimum sampling rate in Hertz, among other things.

     - parameter modelID: The identifier of the model in the form of its name from the output of the **Get models**
       method.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getModel(
        modelID: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SpeechModel) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/models/\(modelID)"
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
            (response: RestResponse<SpeechModel>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Recognize audio.

     Sends audio and returns transcription results for a sessionless recognition request. Returns only the final
     results; to enable interim results, use session-based requests or the WebSocket API. The service imposes a data
     size limit of 100 MB. It automatically detects the endianness of the incoming audio and, for audio that includes
     multiple channels, downmixes the audio to one-channel mono during transcoding. (For the `audio/l16` format, you can
     specify the endianness.)
     ### Streaming mode
      For requests to transcribe live audio as it becomes available, you must set the `Transfer-Encoding` header to
     `chunked` to use streaming mode. In streaming mode, the server closes the connection (status code 408) if the
     service receives no data chunk for 30 seconds and the service has no audio to transcribe for 30 seconds. The server
     also closes the connection (status code 400) if no speech is detected for `inactivity_timeout` seconds of audio
     (not processing time); use the `inactivity_timeout` parameter to change the default of 30 seconds.
     ### Audio formats (content types)
      Use the `Content-Type` header to specify the audio format (MIME type) of the audio. The service accepts the
     following formats:
     * `audio/basic` (Use only with narrowband models.)
     * `audio/flac`
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
     For information about the supported audio formats, including specifying the sampling rate, channels, and endianness
     for the indicated formats, see [Audio
     formats](https://console.bluemix.net/docs/services/speech-to-text/audio-formats.html).
     ### Multipart speech recognition
      The method also supports multipart recognition requests. With multipart requests, you pass all audio data as
     multipart form data. You specify some parameters as request headers and query parameters, but you pass JSON
     metadata as form data to control most aspects of the transcription.
     The multipart approach is intended for use with browsers for which JavaScript is disabled or when the parameters
     used with the request are greater than the 8 KB limit imposed by most HTTP servers and proxies. You can encounter
     this limit, for example, if you want to spot a very large number of keywords.
     For information about submitting a multipart request, see [Submitting multipart requests as form
     data](https://console.bluemix.net/docs/services/speech-to-text/http.html#HTTP-multi).

     - parameter audio: The audio to transcribe in the format specified by the `Content-Type` header.
     - parameter contentType: The type of the input.
     - parameter model: The identifier of the model that is to be used for the recognition request or, for the
       **Create a session** method, with the new session.
     - parameter customizationID: The customization ID (GUID) of a custom language model that is to be used with the
       recognition request or, for the **Create a session** method, with the new session. The base model of the
       specified custom language model must match the model specified with the `model` parameter. You must make the
       request with service credentials created for the instance of the service that owns the custom model. By default,
       no custom language model is used.
     - parameter acousticCustomizationID: The customization ID (GUID) of a custom acoustic model that is to be used
       with the recognition request or, for the **Create a session** method, with the new session. The base model of the
       specified custom acoustic model must match the model specified with the `model` parameter. You must make the
       request with service credentials created for the instance of the service that owns the custom model. By default,
       no custom acoustic model is used.
     - parameter baseModelVersion: The version of the specified base model that is to be used with recognition request
       or, for the **Create a session** method, with the new session. Multiple versions of a base model can exist when a
       model is updated for internal improvements. The parameter is intended primarily for use with custom models that
       have been upgraded for a new base model. The default value depends on whether the parameter is used with or
       without a custom model. For more information, see [Base model
       version](https://console.bluemix.net/docs/services/speech-to-text/input.html#version).
     - parameter customizationWeight: If you specify the customization ID (GUID) of a custom language model with the
       recognition request or, for sessions, with the **Create a session** method, the customization weight tells the
       service how much weight to give to words from the custom language model compared to those from the base model for
       the current request.
       Specify a value between 0.0 and 1.0. Unless a different customization weight was specified for the custom model
       when it was trained, the default value is 0.3. A customization weight that you specify overrides a weight that
       was specified when the custom model was trained.
       The default value yields the best performance in general. Assign a higher value if your audio makes frequent use
       of OOV words from the custom model. Use caution when setting the weight: a higher value can improve the accuracy
       of phrases from the custom model's domain, but it can negatively affect performance on non-domain phrases.
     - parameter inactivityTimeout: The time in seconds after which, if only silence (no speech) is detected in
       submitted audio, the connection is closed with a 400 error. The parameter is useful for stopping audio submission
       from a live microphone when a user simply walks away. Use `-1` for infinity.
     - parameter keywords: An array of keyword strings to spot in the audio. Each keyword string can include one or
       more tokens. Keywords are spotted only in the final results, not in interim hypotheses. If you specify any
       keywords, you must also specify a keywords threshold. You can spot a maximum of 1000 keywords. Omit the parameter
       or specify an empty array if you do not need to spot keywords.
     - parameter keywordsThreshold: A confidence value that is the lower bound for spotting a keyword. A word is
       considered to match a keyword if its confidence is greater than or equal to the threshold. Specify a probability
       between 0 and 1 inclusive. No keyword spotting is performed if you omit the parameter. If you specify a
       threshold, you must also specify one or more keywords.
     - parameter maxAlternatives: The maximum number of alternative transcripts to be returned. By default, a single
       transcription is returned.
     - parameter wordAlternativesThreshold: A confidence value that is the lower bound for identifying a hypothesis as
       a possible word alternative (also known as \"Confusion Networks\"). An alternative word is considered if its
       confidence is greater than or equal to the threshold. Specify a probability between 0 and 1 inclusive. No
       alternative words are computed if you omit the parameter.
     - parameter wordConfidence: If `true`, a confidence measure in the range of 0 to 1 is returned for each word. By
       default, no word confidence measures are returned.
     - parameter timestamps: If `true`, time alignment is returned for each word. By default, no timestamps are
       returned.
     - parameter profanityFilter: If `true` (the default), filters profanity from all output except for keyword
       results by replacing inappropriate words with a series of asterisks. Set the parameter to `false` to return
       results with no censoring. Applies to US English transcription only.
     - parameter smartFormatting: If `true`, converts dates, times, series of digits and numbers, phone numbers,
       currency values, and internet addresses into more readable, conventional representations in the final transcript
       of a recognition request. For US English, also converts certain keyword strings to punctuation symbols. By
       default, no smart formatting is performed. Applies to US English and Spanish transcription only.
     - parameter speakerLabels: If `true`, the response includes labels that identify which words were spoken by which
       participants in a multi-person exchange. By default, no speaker labels are returned. Setting `speaker_labels` to
       `true` forces the `timestamps` parameter to be `true`, regardless of whether you specify `false` for the
       parameter.
        To determine whether a language model supports speaker labels, use the **Get models** method and check that the
       attribute `speaker_labels` is set to `true`. You can also refer to [Speaker
       labels](https://console.bluemix.net/docs/services/speech-to-text/output.html#speaker_labels).
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func recognizeSessionless(
        model: String? = nil,
        customizationID: String? = nil,
        acousticCustomizationID: String? = nil,
        baseModelVersion: String? = nil,
        customizationWeight: Double? = nil,
        audio: Data? = nil,
        contentType: String? = nil,
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
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SpeechRecognitionResults) -> Void)
    {
        // construct body
        let body = audio

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let model = model {
            let queryParameter = URLQueryItem(name: "model", value: model)
            queryParameters.append(queryParameter)
        }
        if let customizationID = customizationID {
            let queryParameter = URLQueryItem(name: "customization_id", value: customizationID)
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
        request.responseObject {
            (response: RestResponse<SpeechRecognitionResults>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
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
     You can register a maximum of 20 callback URLS in a one-hour span of time. For more information, see [Registering a
     callback URL](https://console.bluemix.net/docs/services/speech-to-text/async.html#register).

     - parameter callbackUrl: An HTTP or HTTPS URL to which callback notifications are to be sent. To be white-listed,
       the URL must successfully echo the challenge string during URL verification. During verification, the client can
       also check the signature that the service sends in the `X-Callback-Signature` header to verify the origin of the
       request.
     - parameter userSecret: A user-specified string that the service uses to generate the HMAC-SHA1 signature that it
       sends via the `X-Callback-Signature` header. The service includes the header during URL verification and with
       every notification sent to the callback URL. It calculates the signature over the payload of the notification. If
       you omit the parameter, the service does not send the header.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func registerCallback(
        callbackUrl: String,
        userSecret: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (RegisterStatus) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "callback_url", value: callbackUrl))
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
        request.responseObject {
            (response: RestResponse<RegisterStatus>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Unregister a callback.

     Unregisters a callback URL that was previously white-listed with a **Register a callback** request for use with the
     asynchronous interface. Once unregistered, the URL can no longer be used with asynchronous recognition requests.

     - parameter callbackUrl: The callback URL that is to be unregistered.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func unregisterCallback(
        callbackUrl: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "callback_url", value: callbackUrl))

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
        request.responseVoid {
            (response: RestResponse) in
            switch response.result {
            case .success: success()
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Create a job.

     Creates a job for a new asynchronous recognition request. The job is owned by the user whose service credentials
     are used to create it. How you learn the status and results of a job depends on the parameters you include with the
     job creation request:
     * By callback notification: Include the `callback_url` parameter to specify a URL to which the service is to send
     callback notifications when the status of the job changes. Optionally, you can also include the `events` and
     `user_token` parameters to subscribe to specific events and to specify a string that is to be included with each
     notification for the job.
     * By polling the service: Omit the `callback_url`, `events`, and `user_token` parameters. You must then use the
     **Check jobs** or **Check a job** methods to check the status of the job, using the latter to retrieve the results
     when the job is complete.
     The two approaches are not mutually exclusive. You can poll the service for job status or obtain results from the
     service manually even if you include a callback URL. In both cases, you can include the `results_ttl` parameter to
     specify how long the results are to remain available after the job is complete. For detailed usage information
     about the two approaches, including callback notifications, see [Creating a
     job](https://console.bluemix.net/docs/services/speech-to-text/async.html#create). Using the HTTPS **Check a job**
     method to retrieve results is more secure than receiving them via callback notification over HTTP because it
     provides confidentiality in addition to authentication and data integrity.
     The method supports the same basic parameters as other HTTP and WebSocket recognition requests. It also supports
     the following parameters specific to the asynchronous interface:
     * `callback_url`
     * `events`
     * `user_token`
     * `results_ttl`
     The service imposes a data size limit of 100 MB. It automatically detects the endianness of the incoming audio and,
     for audio that includes multiple channels, downmixes the audio to one-channel mono during transcoding. (For the
     `audio/l16` format, you can specify the endianness.)
     ### Audio formats (content types)
      Use the `Content-Type` parameter to specify the audio format (MIME type) of the audio:
     * `audio/basic` (Use only with narrowband models.)
     * `audio/flac`
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
     For information about the supported audio formats, including specifying the sampling rate, channels, and endianness
     for the indicated formats, see [Audio
     formats](https://console.bluemix.net/docs/services/speech-to-text/audio-formats.html).

     - parameter audio: The audio to transcribe in the format specified by the `Content-Type` header.
     - parameter contentType: The type of the input.
     - parameter model: The identifier of the model that is to be used for the recognition request or, for the
       **Create a session** method, with the new session.
     - parameter callbackUrl: A URL to which callback notifications are to be sent. The URL must already be
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
       Omit the parameter to subscribe to the default events: `recognitions.started`, `recognitions.completed`, and
       `recognitions.failed`. The `recognitions.completed` and `recognitions.completed_with_results` events are
       incompatible; you can specify only of the two events. If the job does not include a callback URL, omit the
       parameter.
     - parameter userToken: If the job includes a callback URL, a user-specified string that the service is to include
       with each callback notification for the job; the token allows the user to maintain an internal mapping between
       jobs and notification events. If the job does not include a callback URL, omit the parameter.
     - parameter resultsTtl: The number of minutes for which the results are to be available after the job has
       finished. If not delivered via a callback, the results must be retrieved within this time. Omit the parameter to
       use a time to live of one week. The parameter is valid with or without a callback URL.
     - parameter customizationID: The customization ID (GUID) of a custom language model that is to be used with the
       recognition request or, for the **Create a session** method, with the new session. The base model of the
       specified custom language model must match the model specified with the `model` parameter. You must make the
       request with service credentials created for the instance of the service that owns the custom model. By default,
       no custom language model is used.
     - parameter acousticCustomizationID: The customization ID (GUID) of a custom acoustic model that is to be used
       with the recognition request or, for the **Create a session** method, with the new session. The base model of the
       specified custom acoustic model must match the model specified with the `model` parameter. You must make the
       request with service credentials created for the instance of the service that owns the custom model. By default,
       no custom acoustic model is used.
     - parameter baseModelVersion: The version of the specified base model that is to be used with recognition request
       or, for the **Create a session** method, with the new session. Multiple versions of a base model can exist when a
       model is updated for internal improvements. The parameter is intended primarily for use with custom models that
       have been upgraded for a new base model. The default value depends on whether the parameter is used with or
       without a custom model. For more information, see [Base model
       version](https://console.bluemix.net/docs/services/speech-to-text/input.html#version).
     - parameter customizationWeight: If you specify the customization ID (GUID) of a custom language model with the
       recognition request or, for sessions, with the **Create a session** method, the customization weight tells the
       service how much weight to give to words from the custom language model compared to those from the base model for
       the current request.
       Specify a value between 0.0 and 1.0. Unless a different customization weight was specified for the custom model
       when it was trained, the default value is 0.3. A customization weight that you specify overrides a weight that
       was specified when the custom model was trained.
       The default value yields the best performance in general. Assign a higher value if your audio makes frequent use
       of OOV words from the custom model. Use caution when setting the weight: a higher value can improve the accuracy
       of phrases from the custom model's domain, but it can negatively affect performance on non-domain phrases.
     - parameter inactivityTimeout: The time in seconds after which, if only silence (no speech) is detected in
       submitted audio, the connection is closed with a 400 error. The parameter is useful for stopping audio submission
       from a live microphone when a user simply walks away. Use `-1` for infinity.
     - parameter keywords: An array of keyword strings to spot in the audio. Each keyword string can include one or
       more tokens. Keywords are spotted only in the final results, not in interim hypotheses. If you specify any
       keywords, you must also specify a keywords threshold. You can spot a maximum of 1000 keywords. Omit the parameter
       or specify an empty array if you do not need to spot keywords.
     - parameter keywordsThreshold: A confidence value that is the lower bound for spotting a keyword. A word is
       considered to match a keyword if its confidence is greater than or equal to the threshold. Specify a probability
       between 0 and 1 inclusive. No keyword spotting is performed if you omit the parameter. If you specify a
       threshold, you must also specify one or more keywords.
     - parameter maxAlternatives: The maximum number of alternative transcripts to be returned. By default, a single
       transcription is returned.
     - parameter wordAlternativesThreshold: A confidence value that is the lower bound for identifying a hypothesis as
       a possible word alternative (also known as \"Confusion Networks\"). An alternative word is considered if its
       confidence is greater than or equal to the threshold. Specify a probability between 0 and 1 inclusive. No
       alternative words are computed if you omit the parameter.
     - parameter wordConfidence: If `true`, a confidence measure in the range of 0 to 1 is returned for each word. By
       default, no word confidence measures are returned.
     - parameter timestamps: If `true`, time alignment is returned for each word. By default, no timestamps are
       returned.
     - parameter profanityFilter: If `true` (the default), filters profanity from all output except for keyword
       results by replacing inappropriate words with a series of asterisks. Set the parameter to `false` to return
       results with no censoring. Applies to US English transcription only.
     - parameter smartFormatting: If `true`, converts dates, times, series of digits and numbers, phone numbers,
       currency values, and internet addresses into more readable, conventional representations in the final transcript
       of a recognition request. For US English, also converts certain keyword strings to punctuation symbols. By
       default, no smart formatting is performed. Applies to US English and Spanish transcription only.
     - parameter speakerLabels: If `true`, the response includes labels that identify which words were spoken by which
       participants in a multi-person exchange. By default, no speaker labels are returned. Setting `speaker_labels` to
       `true` forces the `timestamps` parameter to be `true`, regardless of whether you specify `false` for the
       parameter.
        To determine whether a language model supports speaker labels, use the **Get models** method and check that the
       attribute `speaker_labels` is set to `true`. You can also refer to [Speaker
       labels](https://console.bluemix.net/docs/services/speech-to-text/output.html#speaker_labels).
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func createJob(
        audio: Data,
        contentType: String,
        model: String? = nil,
        callbackUrl: String? = nil,
        events: String? = nil,
        userToken: String? = nil,
        resultsTtl: Int? = nil,
        customizationID: String? = nil,
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
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (RecognitionJob) -> Void)
    {
        // construct body
        let body = audio

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let model = model {
            let queryParameter = URLQueryItem(name: "model", value: model)
            queryParameters.append(queryParameter)
        }
        if let callbackUrl = callbackUrl {
            let queryParameter = URLQueryItem(name: "callback_url", value: callbackUrl)
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
        if let customizationID = customizationID {
            let queryParameter = URLQueryItem(name: "customization_id", value: customizationID)
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
        request.responseObject {
            (response: RestResponse<RecognitionJob>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Check jobs.

     Returns the ID and status of the latest 100 outstanding jobs associated with the service credentials with which it
     is called. The method also returns the creation and update times of each job, and, if a job was created with a
     callback URL and a user token, the user token for the job. To obtain the results for a job whose status is
     `completed` or not one of the latest 100 outstanding jobs, use the **Check a job** method. A job and its results
     remain available until you delete them with the **Delete a job** method or until the job's time to live expires,
     whichever comes first.

     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func checkJobs(
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (RecognitionJobs) -> Void)
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
            url: serviceURL + "/v1/recognitions",
            headerParameters: headerParameters
        )

        // execute REST request
        request.responseObject {
            (response: RestResponse<RecognitionJobs>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Check a job.

     Returns information about the specified job. The response always includes the status of the job and its creation
     and update times. If the status is `completed`, the response includes the results of the recognition request. You
     must submit the request with the service credentials of the user who created the job.
     You can use the method to retrieve the results of any job, regardless of whether it was submitted with a callback
     URL and the `recognitions.completed_with_results` event, and you can retrieve the results multiple times for as
     long as they remain available. Use the **Check jobs** method to request information about the most recent jobs
     associated with the calling user.

     - parameter id: The ID of the asynchronous job.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func checkJob(
        id: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (RecognitionJob) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/recognitions/\(id)"
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
            (response: RestResponse<RecognitionJob>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete a job.

     Deletes the specified job. You cannot delete a job that the service is actively processing. Once you delete a job,
     its results are no longer available. The service automatically deletes a job and its results when the time to live
     for the results expires. You must submit the request with the service credentials of the user who created the job.

     - parameter id: The ID of the asynchronous job.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func deleteJob(
        id: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/recognitions/\(id)"
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
     Create a custom language model.

     Creates a new custom language model for a specified base model. The custom language model can be used only with the
     base model for which it is created. The model is owned by the instance of the service whose credentials are used to
     create it.

     - parameter createLanguageModel: A `CreateLanguageModel` object that provides basic information about the new
       custom language model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func createLanguageModel(
        createLanguageModel: CreateLanguageModel,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (LanguageModel) -> Void)
    {
        // construct body
        guard let body = try? JSONEncoder().encode(createLanguageModel) else {
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
            (response: RestResponse<LanguageModel>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     List custom language models.

     Lists information about all custom language models that are owned by an instance of the service. Use the `language`
     parameter to see all custom language models for the specified language. Omit the parameter to see all custom
     language models for all languages. You must use credentials for the instance of the service that owns a model to
     list information about it.

     - parameter language: The identifier of the language for which custom language or custom acoustic models are to
       be returned (for example, `en-US`). Omit the parameter to see all custom language or custom acoustic models owned
       by the requesting service credentials.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listLanguageModels(
        language: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (LanguageModels) -> Void)
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
            (response: RestResponse<LanguageModels>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Get a custom language model.

     Gets information about a specified custom language model. You must use credentials for the instance of the service
     that owns a model to list information about it.

     - parameter customizationID: The customization ID (GUID) of the custom language model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getLanguageModel(
        customizationID: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (LanguageModel) -> Void)
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
            (response: RestResponse<LanguageModel>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete a custom language model.

     Deletes an existing custom language model. The custom model cannot be deleted if another request, such as adding a
     corpus to the model, is currently being processed. You must use credentials for the instance of the service that
     owns a model to delete it.

     - parameter customizationID: The customization ID (GUID) of the custom language model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func deleteLanguageModel(
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
     Train a custom language model.

     Initiates the training of a custom language model with new corpora, custom words, or both. After adding, modifying,
     or deleting corpora or words for a custom language model, use this method to begin the actual training of the model
     on the latest data. You can specify whether the custom language model is to be trained with all words from its
     words resource or only with words that were added or modified by the user. You must use credentials for the
     instance of the service that owns a model to train it.
     The training method is asynchronous. It can take on the order of minutes to complete depending on the amount of
     data on which the service is being trained and the current load on the service. The method returns an HTTP 200
     response code to indicate that the training process has begun.
     You can monitor the status of the training by using the **Get a custom language model** method to poll the model's
     status. Use a loop to check the status every 10 seconds. The method returns a `LanguageModel` object that includes
     `status` and `progress` fields. A status of `available` means that the custom model is trained and ready to use.
     The service cannot accept subsequent training requests, or requests to add new corpora or words, until the existing
     request completes.
     Training can fail to start for the following reasons:
     * The service is currently handling another request for the custom model, such as another training request or a
     request to add a corpus or words to the model.
     * No training data (corpora or words) have been added to the custom model.
     * One or more words that were added to the custom model have invalid sounds-like pronunciations that you must fix.

     - parameter customizationID: The customization ID (GUID) of the custom language model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter wordTypeToAdd: The type of words from the custom language model's words resource on which to train
       the model:
       * `all` (the default) trains the model on all new words, regardless of whether they were extracted from corpora
       or were added or modified by the user.
       * `user` trains the model only on new words that were added or modified by the user; the model is not trained on
       new words extracted from corpora.
     - parameter customizationWeight: Specifies a customization weight for the custom language model. The
       customization weight tells the service how much weight to give to words from the custom language model compared
       to those from the base model for speech recognition. Specify a value between 0.0 and 1.0; the default is 0.3.
       The default value yields the best performance in general. Assign a higher value if your audio makes frequent use
       of OOV words from the custom model. Use caution when setting the weight: a higher value can improve the accuracy
       of phrases from the custom model's domain, but it can negatively affect performance on non-domain phrases.
       The value that you assign is used for all recognition requests that use the model. You can override it for any
       recognition request by specifying a customization weight for that request.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func trainLanguageModel(
        customizationID: String,
        wordTypeToAdd: String? = nil,
        customizationWeight: Double? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
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

    /**
     Reset a custom language model.

     Resets a custom language model by removing all corpora and words from the model. Resetting a custom language model
     initializes the model to its state when it was first created. Metadata such as the name and language of the model
     are preserved, but the model's words resource is removed and must be re-created. You must use credentials for the
     instance of the service that owns a model to reset it.

     - parameter customizationID: The customization ID (GUID) of the custom language model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func resetLanguageModel(
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
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/reset"
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
     For more information, see [Upgrading custom
     models](https://console.bluemix.net/docs/services/speech-to-text/custom-upgrade.html).

     - parameter customizationID: The customization ID (GUID) of the custom language model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func upgradeLanguageModel(
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
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/upgrade_model"
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
     List corpora.

     Lists information about all corpora from a custom language model. The information includes the total number of
     words and out-of-vocabulary (OOV) words, name, and status of each corpus. You must use credentials for the instance
     of the service that owns a model to list its corpora.

     - parameter customizationID: The customization ID (GUID) of the custom language model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listCorpora(
        customizationID: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Corpora) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/corpora"
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
            (response: RestResponse<Corpora>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Add a corpus.

     Adds a single corpus text file of new training data to a custom language model. Use multiple requests to submit
     multiple corpus text files. You must use credentials for the instance of the service that owns a model to add a
     corpus to it. Adding a corpus does not affect the custom language model until you train the model for the new data
     by using the **Train a custom language model** method.
     Submit a plain text file that contains sample sentences from the domain of interest to enable the service to
     extract words in context. The more sentences you add that represent the context in which speakers use words from
     the domain, the better the service's recognition accuracy. For guidelines about adding a corpus text file and for
     information about how the service parses a corpus file, see [Preparing a corpus text
     file](https://console.bluemix.net/docs/services/speech-to-text/language-resource.html#prepareCorpus).
     The call returns an HTTP 201 response code if the corpus is valid. The service then asynchronously processes the
     contents of the corpus and automatically extracts new words that it finds. This can take on the order of a minute
     or two to complete depending on the total number of words and the number of new words in the corpus, as well as the
     current load on the service. You cannot submit requests to add additional corpora or words to the custom model, or
     to train the model, until the service's analysis of the corpus for the current request completes. Use the **List a
     corpus** method to check the status of the analysis.
     The service auto-populates the model's words resource with any word that is not found in its base vocabulary; these
     are referred to as out-of-vocabulary (OOV) words. You can use the **List custom words** method to examine the words
     resource, using other words method to eliminate typos and modify how words are pronounced as needed.
     To add a corpus file that has the same name as an existing corpus, set the `allow_overwrite` parameter to `true`;
     otherwise, the request fails. Overwriting an existing corpus causes the service to process the corpus text file and
     extract OOV words anew. Before doing so, it removes any OOV words associated with the existing corpus from the
     model's words resource unless they were also added by another corpus or they have been modified in some way with
     the **Add custom words** or **Add a custom word** method.
     The service limits the overall amount of data that you can add to a custom model to a maximum of 10 million total
     words from all corpora combined. Also, you can add no more than 30 thousand custom (OOV) words to a model; this
     includes words that the service extracts from corpora and words that you add directly.

     - parameter customizationID: The customization ID (GUID) of the custom language model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter corpusName: The name of the corpus for the custom language model. When adding a corpus, do not
       include spaces in the name; use a localized name that matches the language of the custom model; and do not use
       the name `user`, which is reserved by the service to denote custom words added or modified by the user.
     - parameter corpusFile: A plain text file that contains the training data for the corpus. Encode the file in
       UTF-8 if it contains non-ASCII characters; the service assumes UTF-8 encoding if it encounters non-ASCII
       characters. With cURL, use the `--data-binary` option to upload the file for the request.
     - parameter allowOverwrite: If `true`, the specified corpus or audio resource overwrites an existing corpus or
       audio resource with the same name. If `false` (the default), the request fails if a corpus or audio resource with
       the same name already exists. The parameter has no effect if a corpus or audio resource with the same name does
       not already exist.
     - parameter corpusFileContentType: The content type of corpusFile.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func addCorpus(
        customizationID: String,
        corpusName: String,
        corpusFile: URL,
        allowOverwrite: Bool? = nil,
        corpusFileContentType: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(corpusFile, withName: "corpus_file")
        guard let body = try? multipartFormData.toData() else {
            failure?(RestError.encodingError)
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
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
            queryItems: queryParameters,
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
     Get a corpus.

     Gets information about a corpus from a custom language model. The information includes the total number of words
     and out-of-vocabulary (OOV) words, name, and status of the corpus. You must use credentials for the instance of the
     service that owns a model to list its corpora.

     - parameter customizationID: The customization ID (GUID) of the custom language model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter corpusName: The name of the corpus for the custom language model. When adding a corpus, do not
       include spaces in the name; use a localized name that matches the language of the custom model; and do not use
       the name `user`, which is reserved by the service to denote custom words added or modified by the user.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getCorpus(
        customizationID: String,
        corpusName: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Corpus) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/corpora/\(corpusName)"
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
            (response: RestResponse<Corpus>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete a corpus.

     Deletes an existing corpus from a custom language model. The service removes any out-of-vocabulary (OOV) words
     associated with the corpus from the custom model's words resource unless they were also added by another corpus or
     they have been modified in some way with the **Add custom words** or **Add a custom word** method. Removing a
     corpus does not affect the custom model until you train the model with the **Train a custom language model**
     method. You must use credentials for the instance of the service that owns a model to delete its corpora.

     - parameter customizationID: The customization ID (GUID) of the custom language model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter corpusName: The name of the corpus for the custom language model. When adding a corpus, do not
       include spaces in the name; use a localized name that matches the language of the custom model; and do not use
       the name `user`, which is reserved by the service to denote custom words added or modified by the user.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func deleteCorpus(
        customizationID: String,
        corpusName: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/corpora/\(corpusName)"
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
     List custom words.

     Lists information about custom words from a custom language model. You can list all words from the custom model's
     words resource, only custom words that were added or modified by the user, or only out-of-vocabulary (OOV) words
     that were extracted from corpora. You can also indicate the order in which the service is to return words; by
     default, words are listed in ascending alphabetical order. You must use credentials for the instance of the service
     that owns a model to query information about its words.

     - parameter customizationID: The customization ID (GUID) of the custom language model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter wordType: The type of words to be listed from the custom language model's words resource:
       * `all` (the default) shows all words.
       * `user` shows only custom words that were added or modified by the user.
       * `corpora` shows only OOV that were extracted from corpora.
     - parameter sort: Indicates the order in which the words are to be listed, `alphabetical` or by `count`. You can
       prepend an optional `+` or `-` to an argument to indicate whether the results are to be sorted in ascending or
       descending order. By default, words are sorted in ascending alphabetical order. For alphabetical ordering, the
       lexicographical precedence is numeric values, uppercase letters, and lowercase letters. For count ordering,
       values with the same count are ordered alphabetically. With cURL, URL encode the `+` symbol as `%2B`.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listWords(
        customizationID: String,
        wordType: String? = nil,
        sort: String? = nil,
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
            (response: RestResponse<Words>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Add custom words.

     Adds one or more custom words to a custom language model. The service populates the words resource for a custom
     model with out-of-vocabulary (OOV) words found in each corpus added to the model. You can use this method to add
     additional words or to modify existing words in the words resource. The words resource for a model can contain a
     maximum of 30 thousand custom (OOV) words, including words that the service extracts from corpora and words that
     you add directly.
     You must use credentials for the instance of the service that owns a model to add or modify custom words for the
     model. Adding or modifying custom words does not affect the custom model until you train the model for the new data
     by using the **Train a custom language model** method.
     You add custom words by providing a `CustomWords` object, which is an array of `CustomWord` objects, one per word.
     You must use the object's `word` parameter to identify the word that is to be added. You can also provide one or
     both of the optional `sounds_like` and `display_as` fields for each word.
     * The `sounds_like` field provides an array of one or more pronunciations for the word. Use the parameter to
     specify how the word can be pronounced by users. Use the parameter for words that are difficult to pronounce,
     foreign words, acronyms, and so on. For example, you might specify that the word `IEEE` can sound like `i triple
     e`. You can specify a maximum of five sounds-like pronunciations for a word. For information about pronunciation
     rules, see [Using the sounds_like
     field](https://console.bluemix.net/docs/services/speech-to-text/language-resource.html#soundsLike).
     * The `display_as` field provides a different way of spelling the word in a transcript. Use the parameter when you
     want the word to appear different from its usual representation or from its spelling in corpora training data. For
     example, you might indicate that the word `IBM(trademark)` is to be displayed as `IBM&trade;`. For more
     information, see [Using the display_as
     field](https://console.bluemix.net/docs/services/speech-to-text/language-resource.html#displayAs).
     If you add a custom word that already exists in the words resource for the custom model, the new definition
     overwrites the existing data for the word. If the service encounters an error with the input data, it returns a
     failure code and does not add any of the words to the words resource.
     The call returns an HTTP 201 response code if the input data is valid. It then asynchronously processes the words
     to add them to the model's words resource. The time that it takes for the analysis to complete depends on the
     number of new words that you add but is generally faster than adding a corpus or training a model.
     You can monitor the status of the request by using the **List a custom language model** method to poll the model's
     status. Use a loop to check the status every 10 seconds. The method returns a `Customization` object that includes
     a `status` field. A status of `ready` means that the words have been added to the custom model. The service cannot
     accept requests to add new corpora or words or to train the model until the existing request completes.
     You can use the **List custom words** or **List a custom word** method to review the words that you add. Words with
     an invalid `sounds_like` field include an `error` field that describes the problem. You can use other words-related
     methods to correct errors, eliminate typos, and modify how words are pronounced as needed.

     - parameter customizationID: The customization ID (GUID) of the custom language model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter words: An array of objects that provides information about each custom word that is to be added to or
       updated in the custom language model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func addWords(
        customizationID: String,
        words: [CustomWord],
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct body
        let addWordsRequest = CustomWords(words: words)
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
     Add a custom word.

     Adds a custom word to a custom language model. The service populates the words resource for a custom model with
     out-of-vocabulary (OOV) words found in each corpus added to the model. You can use this method to add a word or to
     modify an existing word in the words resource. The words resource for a model can contain a maximum of 30 thousand
     custom (OOV) words, including words that the service extracts from corpora and words that you add directly.
     You must use credentials for the instance of the service that owns a model to add or modify a custom word for the
     model. Adding or modifying a custom word does not affect the custom model until you train the model for the new
     data by using the **Train a custom language model** method.
     Use the `word_name` parameter to specify the custom word that is to be added or modified. Use the `CustomWord`
     object to provide one or both of the optional `sounds_like` and `display_as` fields for the word.
     * The `sounds_like` field provides an array of one or more pronunciations for the word. Use the parameter to
     specify how the word can be pronounced by users. Use the parameter for words that are difficult to pronounce,
     foreign words, acronyms, and so on. For example, you might specify that the word `IEEE` can sound like `i triple
     e`. You can specify a maximum of five sounds-like pronunciations for a word. For information about pronunciation
     rules, see [Using the sounds_like
     field](https://console.bluemix.net/docs/services/speech-to-text/language-resource.html#soundsLike).
     * The `display_as` field provides a different way of spelling the word in a transcript. Use the parameter when you
     want the word to appear different from its usual representation or from its spelling in corpora training data. For
     example, you might indicate that the word `IBM(trademark)` is to be displayed as `IBM&trade;`. For more
     information, see [Using the display_as
     field](https://console.bluemix.net/docs/services/speech-to-text/language-resource.html#displayAs).
     If you add a custom word that already exists in the words resource for the custom model, the new definition
     overwrites the existing data for the word. If the service encounters an error, it does not add the word to the
     words resource. Use the **List a custom word** method to review the word that you add.

     - parameter customizationID: The customization ID (GUID) of the custom language model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter wordName: The custom word for the custom language model. When you add or update a custom word with
       the **Add a custom word** method, do not include spaces in the word. Use a `-` (dash) or `_` (underscore) to
       connect the tokens of compound words.
     - parameter word: For the **Add custom words** method, you must specify the custom word that is to be added to or
       updated in the custom model. Do not include spaces in the word. Use a `-` (dash) or `_` (underscore) to connect
       the tokens of compound words.
       Omit this field for the **Add a custom word** method.
     - parameter soundsLike: An array of sounds-like pronunciations for the custom word. Specify how words that are
       difficult to pronounce, foreign words, acronyms, and so on can be pronounced by users. For a word that is not in
       the service's base vocabulary, omit the parameter to have the service automatically generate a sounds-like
       pronunciation for the word. For a word that is in the service's base vocabulary, use the parameter to specify
       additional pronunciations for the word. You cannot override the default pronunciation of a word; pronunciations
       you add augment the pronunciation from the base vocabulary. A word can have at most five sounds-like
       pronunciations, and a pronunciation can include at most 40 characters not including spaces.
     - parameter displayAs: An alternative spelling for the custom word when it appears in a transcript. Use the
       parameter when you want the word to have a spelling that is different from its usual representation or from its
       spelling in corpora training data.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func addWord(
        customizationID: String,
        wordName: String,
        word: String? = nil,
        soundsLike: [String]? = nil,
        displayAs: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct body
        let addWordRequest = CustomWord(word: word, soundsLike: soundsLike, displayAs: displayAs)
        guard let body = try? JSONEncoder().encode(addWordRequest) else {
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
        let path = "/v1/customizations/\(customizationID)/words/\(wordName)"
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

     Gets information about a custom word from a custom language model. You must use credentials for the instance of the
     service that owns a model to query information about its words.

     - parameter customizationID: The customization ID (GUID) of the custom language model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter wordName: The custom word for the custom language model. When you add or update a custom word with
       the **Add a custom word** method, do not include spaces in the word. Use a `-` (dash) or `_` (underscore) to
       connect the tokens of compound words.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getWord(
        customizationID: String,
        wordName: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Word) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words/\(wordName)"
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
            (response: RestResponse<Word>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete a custom word.

     Deletes a custom word from a custom language model. You can remove any word that you added to the custom model's
     words resource via any means. However, if the word also exists in the service's base vocabulary, the service
     removes only the custom pronunciation for the word; the word remains in the base vocabulary. Removing a custom word
     does not affect the custom model until you train the model with the **Train a custom language model** method. You
     must use credentials for the instance of the service that owns a model to delete its words.

     - parameter customizationID: The customization ID (GUID) of the custom language model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter wordName: The custom word for the custom language model. When you add or update a custom word with
       the **Add a custom word** method, do not include spaces in the word. Use a `-` (dash) or `_` (underscore) to
       connect the tokens of compound words.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func deleteWord(
        customizationID: String,
        wordName: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/customizations/\(customizationID)/words/\(wordName)"
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
     Create a custom acoustic model.

     Creates a new custom acoustic model for a specified base model. The custom acoustic model can be used only with the
     base model for which it is created. The model is owned by the instance of the service whose credentials are used to
     create it.

     - parameter name: A user-defined name for the new custom acoustic model. Use a name that is unique among all
       custom acoustic models that you own. Use a localized name that matches the language of the custom model. Use a
       name that describes the acoustic environment of the custom model, such as `Mobile custom model` or `Noisy car
       custom model`.
     - parameter baseModelName: The name of the base language model that is to be customized by the new custom
       acoustic model. The new custom model can be used only with the base model that it customizes. To determine
       whether a base model supports acoustic model customization, refer to [Language support for
       customization](https://console.bluemix.net/docs/services/speech-to-text/custom.html#languageSupport).
     - parameter description: A description of the new custom acoustic model. Use a localized description that matches
       the language of the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func createAcousticModel(
        name: String,
        baseModelName: String,
        description: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (AcousticModel) -> Void)
    {
        // construct body
        let createAcousticModelRequest = CreateAcousticModel(name: name, baseModelName: baseModelName, description: description)
        guard let body = try? JSONEncoder().encode(createAcousticModelRequest) else {
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
            url: serviceURL + "/v1/acoustic_customizations",
            headerParameters: headerParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject {
            (response: RestResponse<AcousticModel>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     List custom acoustic models.

     Lists information about all custom acoustic models that are owned by an instance of the service. Use the `language`
     parameter to see all custom acoustic models for the specified language. Omit the parameter to see all custom
     acoustic models for all languages. You must use credentials for the instance of the service that owns a model to
     list information about it.

     - parameter language: The identifier of the language for which custom language or custom acoustic models are to
       be returned (for example, `en-US`). Omit the parameter to see all custom language or custom acoustic models owned
       by the requesting service credentials.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listAcousticModels(
        language: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (AcousticModels) -> Void)
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
            url: serviceURL + "/v1/acoustic_customizations",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject {
            (response: RestResponse<AcousticModels>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Get a custom acoustic model.

     Gets information about a specified custom acoustic model. You must use credentials for the instance of the service
     that owns a model to list information about it.

     - parameter customizationID: The customization ID (GUID) of the custom acoustic model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getAcousticModel(
        customizationID: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (AcousticModel) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/acoustic_customizations/\(customizationID)"
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
            (response: RestResponse<AcousticModel>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete a custom acoustic model.

     Deletes an existing custom acoustic model. The custom model cannot be deleted if another request, such as adding an
     audio resource to the model, is currently being processed. You must use credentials for the instance of the service
     that owns a model to delete it.

     - parameter customizationID: The customization ID (GUID) of the custom acoustic model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func deleteAcousticModel(
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
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/acoustic_customizations/\(customizationID)"
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
     language model that is to be used during training. Specify a custom language model if you have verbatim
     transcriptions of the audio files that you have added to the custom model or you have either corpora (text files)
     or a list of words that are relevant to the contents of the audio files. For information about creating a separate
     custom language model, see [Creating a custom language
     model](https://console.bluemix.net/docs/services/speech-to-text/language-create.html).
     Training can fail to start for the following reasons:
     * The service is currently handling another request for the custom model, such as another training request or a
     request to add audio resources to the model.
     * The custom model contains less than 10 minutes or more than 50 hours of audio data.
     * One or more of the custom model's audio resources is invalid.

     - parameter customizationID: The customization ID (GUID) of the custom acoustic model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter customLanguageModelID: The customization ID (GUID) of a custom language model that is to be used
       during training of the custom acoustic model. Specify a custom language model that has been trained with verbatim
       transcriptions of the audio resources or that contains words that are relevant to the contents of the audio
       resources.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func trainAcousticModel(
        customizationID: String,
        customLanguageModelID: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
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

    /**
     Reset a custom acoustic model.

     Resets a custom acoustic model by removing all audio resources from the model. Resetting a custom acoustic model
     initializes the model to its state when it was first created. Metadata such as the name and language of the model
     are preserved, but the model's audio resources are removed and must be re-created. You must use credentials for the
     instance of the service that owns a model to reset it.

     - parameter customizationID: The customization ID (GUID) of the custom acoustic model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func resetAcousticModel(
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
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/acoustic_customizations/\(customizationID)/reset"
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
     For more information, see [Upgrading custom
     models](https://console.bluemix.net/docs/services/speech-to-text/custom-upgrade.html).

     - parameter customizationID: The customization ID (GUID) of the custom acoustic model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter customLanguageModelID: If the custom acoustic model was trained with a custom language model, the
       customization ID (GUID) of that custom language model. The custom language model must be upgraded before the
       custom acoustic model can be upgraded.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func upgradeAcousticModel(
        customizationID: String,
        customLanguageModelID: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let customLanguageModelID = customLanguageModelID {
            let queryParameter = URLQueryItem(name: "custom_language_model_id", value: customLanguageModelID)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/acoustic_customizations/\(customizationID)/upgrade_model"
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

    /**
     List audio resources.

     Lists information about all audio resources from a custom acoustic model. The information includes the name of the
     resource and information about its audio data, such as its duration. It also includes the status of the audio
     resource, which is important for checking the service's analysis of the resource in response to a request to add it
     to the custom acoustic model. You must use credentials for the instance of the service that owns a model to list
     its audio resources.

     - parameter customizationID: The customization ID (GUID) of the custom acoustic model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listAudio(
        customizationID: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (AudioResources) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/acoustic_customizations/\(customizationID)/audio"
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
            (response: RestResponse<AudioResources>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
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
     You must add a minimum of 10 minutes and a maximum of 50 hours of audio that includes speech, not just silence, to
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
     ### Content types for audio-type resources
      You can add an individual audio file in any format that the service supports for speech recognition. For an
     audio-type resource, use the `Content-Type` parameter to specify the audio format (MIME type) of the audio file:
     * `audio/basic` (Use only with narrowband models.)
     * `audio/flac`
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
     For information about the supported audio formats, including specifying the sampling rate, channels, and endianness
     for the indicated formats, see [Audio
     formats](https://console.bluemix.net/docs/services/speech-to-text/audio-formats.html).
     **Note:** The sampling rate of an audio file must match the sampling rate of the base model for the custom model:
     for broadband models, at least 16 kHz; for narrowband models, at least 8 kHz. If the sampling rate of the audio is
     higher than the minimum required rate, the service down-samples the audio to the appropriate rate. If the sampling
     rate of the audio is lower than the minimum required rate, the service labels the audio file as `invalid`.
     ### Content types for archive-type resources
      You can add an archive file (**.zip** or **.tar.gz** file) that contains audio files in any format that the
     service supports for speech recognition. For an archive-type resource, use the `Content-Type` parameter to specify
     the media type of the archive file:
     * `application/zip` for a **.zip** file
     * `application/gzip` for a **.tar.gz** file.
     All audio files contained in the archive must have the same audio format. Use the `Contained-Content-Type`
     parameter to specify the format of the contained audio files. The parameter accepts all of the audio formats
     supported for use with speech recognition and with the `Content-Type` header, including the `rate`, `channels`, and
     `endianness` parameters that are used with some formats. The default contained audio format is `audio/wav`.

     - parameter customizationID: The customization ID (GUID) of the custom acoustic model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter audioName: The name of the audio resource for the custom acoustic model. When adding an audio
       resource, do not include spaces in the name; use a localized name that matches the language of the custom model.
     - parameter audioResource: The audio resource that is to be added to the custom acoustic model, an individual
       audio file or an archive file.
     - parameter contentType: The type of the input.
     - parameter containedContentType: For an archive-type resource, specifies the format of the audio files contained
       in the archive file. The parameter accepts all of the audio formats supported for use with speech recognition,
       including the `rate`, `channels`, and `endianness` parameters that are used with some formats. For a complete
       list of supported audio formats, see [Audio formats](/docs/services/speech-to-text/input.html#formats).
     - parameter allowOverwrite: If `true`, the specified corpus or audio resource overwrites an existing corpus or
       audio resource with the same name. If `false` (the default), the request fails if a corpus or audio resource with
       the same name already exists. The parameter has no effect if a corpus or audio resource with the same name does
       not already exist.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func addAudio(
        customizationID: String,
        audioName: String,
        audioResource: Data,
        contentType: String,
        containedContentType: String? = nil,
        allowOverwrite: Bool? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct body
        let body = audioResource

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = contentType
        if let containedContentType = containedContentType {
            headerParameters["Contained-Content-Type"] = containedContentType
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
            queryItems: queryParameters,
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

     - parameter customizationID: The customization ID (GUID) of the custom acoustic model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter audioName: The name of the audio resource for the custom acoustic model. When adding an audio
       resource, do not include spaces in the name; use a localized name that matches the language of the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getAudio(
        customizationID: String,
        audioName: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (AudioListing) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/acoustic_customizations/\(customizationID)/audio/\(audioName)"
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
            (response: RestResponse<AudioListing>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete an audio resource.

     Deletes an existing audio resource from a custom acoustic model. Deleting an archive-type audio resource removes
     the entire archive of files; the current interface does not allow deletion of individual files from an archive
     resource. Removing an audio resource does not affect the custom model until you train the model on its updated data
     by using the **Train a custom acoustic model** method. You must use credentials for the instance of the service
     that owns a model to delete its audio resources.

     - parameter customizationID: The customization ID (GUID) of the custom acoustic model. You must make the request
       with service credentials created for the instance of the service that owns the custom model.
     - parameter audioName: The name of the audio resource for the custom acoustic model. When adding an audio
       resource, do not include spaces in the name; use a localized name that matches the language of the custom model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func deleteAudio(
        customizationID: String,
        audioName: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/acoustic_customizations/\(customizationID)/audio/\(audioName)"
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
     security](https://console.bluemix.net/docs/services/speech-to-text/information-security.html).

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
        headerParameters["Accept"] = "application/json"

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
