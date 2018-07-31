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
 Analyze various features of text content at scale. Provide text, raw HTML, or a public URL, and IBM Watson Natural
 Language Understanding will give you results for the features you request. The service cleans HTML content before
 analysis by default, so the results can ignore most advertisements and other unwanted content.
 You can create <a target="_blank"
 href="https://www.ibm.com/watson/developercloud/doc/natural-language-understanding/customizing.html">custom models</a>
 with Watson Knowledge Studio that can be used to detect custom entities and relations in Natural Language
 Understanding.
 */
public class NaturalLanguageUnderstanding {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/natural-language-understanding/api"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    private let session = URLSession(configuration: URLSessionConfiguration.default)
    private var authMethod: AuthenticationMethod
    private let domain = "com.ibm.watson.developer-cloud.NaturalLanguageUnderstandingV1"
    private let version: String

    /**
     Create a `NaturalLanguageUnderstanding` object.

     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     */
    public init(username: String, password: String, version: String) {
        self.authMethod = BasicAuthentication(username: username, password: password)
        self.version = version
    }

    /**
     Create a `NaturalLanguageUnderstanding` object.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     - parameter apiKey: An API key for IAM that can be used to obtain access tokens for the service.
     - parameter iamUrl: The URL for the IAM service.
     */
    public init(version: String, apiKey: String, iamUrl: String? = nil) {
        self.version = version
        self.authMethod = IAMAuthentication(apiKey: apiKey, url: iamUrl)
    }

    /**
     Create a `NaturalLanguageUnderstanding` object.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     - parameter accessToken: An access token for the service.
     */
    public init(version: String, accessToken: String) {
        self.version = version
        self.authMethod = IAMAccessToken(accessToken: accessToken)
    }

    public func accessToken(_ newToken: String) {
        if self.authMethod is IAMAccessToken {
            self.authMethod = IAMAccessToken(accessToken: newToken)
        }
    }

    /**
     If the response or data represents an error returned by the Natural Language Understanding service,
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
            if case let .some(.string(description)) = json["description"] {
                userInfo[NSLocalizedRecoverySuggestionErrorKey] = description
            }
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return NSError(domain: domain, code: code, userInfo: nil)
        }
    }

    /**
     Analyze text, HTML, or a public webpage.

     Analyzes text, HTML, or a public webpage with one or more text analysis features.
     ### Concepts
     Identify general concepts that are referenced or alluded to in your content. Concepts that are detected typically
     have an associated link to a DBpedia resource.
     ### Emotion
     Detect anger, disgust, fear, joy, or sadness that is conveyed by your content. Emotion information can be returned
     for detected entities, keywords, or user-specified target phrases found in the text.
     ### Entities
     Detect important people, places, geopolitical entities and other types of entities in your content. Entity
     detection recognizes consecutive coreferences of each entity. For example, analysis of the following text would
     count \"Barack Obama\" and \"He\" as the same entity:
     \"Barack Obama was the 44th President of the United States. He took office in January 2009.\"
     ### Keywords
     Determine the most important keywords in your content. Keyword phrases are organized by relevance in the results.
     ### Metadata
     Get author information, publication date, and the title of your text/HTML content.
     ### Relations
     Recognize when two entities are related, and identify the type of relation.  For example, you can identify an
     \"awardedTo\" relation between an award and its recipient.
     ### Semantic Roles
     Parse sentences into subject-action-object form, and identify entities and keywords that are subjects or objects of
     an action.
     ### Sentiment
     Determine whether your content conveys postive or negative sentiment. Sentiment information can be returned for
     detected entities, keywords, or user-specified target phrases found in the text.
     ### Categories
     Categorize your content into a hierarchical 5-level taxonomy. For example, \"Leonardo DiCaprio won an Oscar\"
     returns \"/art and entertainment/movies and tv/movies\" as the most confident classification.

     - parameter parameters: An object containing request parameters. The `features` object and one of the `text`,
       `html`, or `url` attributes are required.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func analyze(
        parameters: Parameters,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (AnalysisResults) -> Void)
    {
        // construct body
        guard let body = try? JSONEncoder().encode(parameters) else {
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

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v1/analyze",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject {
            (response: RestResponse<AnalysisResults>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     List models.

     Lists available models for Relations and Entities features, including Watson Knowledge Studio custom models that
     you have created and linked to your Natural Language Understanding service.

     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listModels(
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ListModelsResults) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + "/v1/models",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject {
            (response: RestResponse<ListModelsResults>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete model.

     Deletes a custom model.

     - parameter modelID: model_id of the model to delete.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func deleteModel(
        modelID: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DeleteModelResults) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

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
            method: "DELETE",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject {
            (response: RestResponse<DeleteModelResults>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

}
