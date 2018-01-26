/**
 * Copyright IBM Corporation 2017
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
   Analyze various features of text content at scale. Provide text, raw HTML, or a public URL, and
  IBM Watson Natural Language Understanding will give you results for the features you request. The
  service cleans HTML content before analysis by default, so the results can ignore most
  advertisements and other unwanted content.

  ### Concepts
  Identify general concepts that are referenced or alluded to in your content. Concepts that are
  detected typically have an associated link to a DBpedia resource.

  ### Entities
  Detect important people, places, geopolitical entities and other types of entities in your
  content. Entity detection recognizes consecutive coreferences of each entity. For example,
  analysis of the following text would count "Barack Obama" and "He" as the same entity:

  "Barack Obama was the 44th President of the United States. He took office in January 2009."

  ### Keywords
  Determine the most important keywords in your content. Keyword phrases are organized by relevance
  in the results.

  ### Categories
  Categorize your content into a hierarchical 5-level taxonomy. For example, "Leonardo DiCaprio won
  an Oscar" returns "/art and entertainment/movies and tv/movies" as the most confident
  classification.

  ### Sentiment
  Determine whether your content conveys postive or negative sentiment. Sentiment information can be
  returned for detected entities, keywords, or user-specified target phrases found in the text.

  ### Emotion
  Detect anger, disgust, fear, joy, or sadness that is conveyed by your content. Emotion information
  can be returned for detected entities, keywords, or user-specified target phrases found in the
  text.

  ### Relations
  Recognize when two entities are related, and identify the type of relation.  For example, you can
  identify an "awardedTo" relation between an award and its recipient.

  ### Semantic Roles
  Parse sentences into subject-action-object form, and identify entities and keywords that are
  subjects or objects of an action.

  ### Metadata
  Get author information, publication date, and the title of your text/HTML content.
 */
public class NaturalLanguageUnderstanding {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/natural-language-understanding/api"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    private let credentials: Credentials
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
        self.credentials = .basicAuthentication(username: username, password: password)
        self.version = version
    }

    /**
     If the response or data represents an error returned by the Natural Language Understanding service,
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
            let message = try json.getString(at: "error")
            var userInfo = [NSLocalizedDescriptionKey: message]
            if let description = try? json.getString(at: "description") {
                userInfo[NSLocalizedRecoverySuggestionErrorKey] = description
            }
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }

    /**
     Analyze text, HTML, or a public webpage.

     Analyzes text, HTML, or a public webpage with one or more text analysis features.

     - parameter parameters: An object containing request parameters. The `features` object and one of the `text`, `html`, or `url` attributes are required.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func analyze(
        parameters: Parameters,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (AnalysisResults) -> Void)
    {
        // construct body
        guard let body = try? JSONEncoder().encode(parameters) else {
            failure?(RestError.serializationError)
            return
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/analyze",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<AnalysisResults>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete model.

     Deletes a custom model.

     - parameter modelID: modelID of the model to delete.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func deleteModel(
        modelID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
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
            method: "DELETE",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
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
     List models.

     Lists available models for Relations and Entities features, including Watson Knowledge Studio custom models that you have created and linked to your Natural Language Understanding service.

     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func listModels(
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ListModelsResults) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/models",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<ListModelsResults>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

}
