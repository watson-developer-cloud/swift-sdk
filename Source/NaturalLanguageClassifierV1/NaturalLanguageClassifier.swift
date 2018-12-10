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
import RestKit

/**
 IBM Watson&trade; Natural Language Classifier uses machine learning algorithms to return the top matching predefined
 classes for short text input. You create and train a classifier to connect predefined classes to example texts so that
 the service can apply those classes to new inputs.
 */
public class NaturalLanguageClassifier {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/natural-language-classifier/api"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    var session = URLSession(configuration: URLSessionConfiguration.default)
    var authMethod: AuthenticationMethod

    /**
     Create a `NaturalLanguageClassifier` object.

     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     */
    public init(username: String, password: String) {
        self.authMethod = Shared.getAuthMethod(username: username, password: password)
        Shared.configureRestRequest()
    }

    /**
     Create a `NaturalLanguageClassifier` object.

     - parameter apiKey: An API key for IAM that can be used to obtain access tokens for the service.
     - parameter iamUrl: The URL for the IAM service.
     */
    public init(apiKey: String, iamUrl: String? = nil) {
        self.authMethod = Shared.getAuthMethod(apiKey: apiKey, iamURL: iamUrl)
        Shared.configureRestRequest()
    }

    /**
     Create a `NaturalLanguageClassifier` object.

     - parameter accessToken: An access token for the service.
     */
    public init(accessToken: String) {
        self.authMethod = IAMAccessToken(accessToken: accessToken)
        Shared.configureRestRequest()
    }

    public func accessToken(_ newToken: String) {
        if self.authMethod is IAMAccessToken {
            self.authMethod = IAMAccessToken(accessToken: newToken)
        }
    }

    /**
     Use the HTTP response and data received by the Natural Language Classifier service to extract
     information about the error that occurred.

     - parameter data: Raw data returned by the service that may represent an error.
     - parameter response: the URL response returned by the service.
     */
    func errorResponseDecoder(data: Data, response: HTTPURLResponse) -> WatsonError {

        let statusCode = response.statusCode
        var errorMessage: String?
        var metadata = [String: Any]()

        do {
            let json = try JSONDecoder().decode([String: JSON].self, from: data)
            metadata = [:]
            if case let .some(.string(message)) = json["error"] {
                errorMessage = message
            }
            if case let .some(.string(description)) = json["description"] {
                metadata["description"] = description
            }
            // If metadata is empty, it should show up as nil in the WatsonError
            return WatsonError.http(statusCode: statusCode, message: errorMessage, metadata: !metadata.isEmpty ? metadata : nil)
        } catch {
            return WatsonError.http(statusCode: statusCode, message: nil, metadata: nil)
        }
    }

    /**
     Classify a phrase.

     Returns label information for the input. The status must be `Available` before you can use the classifier to
     classify text.

     - parameter classifierID: Classifier ID to use.
     - parameter text: The submitted phrase. The maximum length is 2048 characters.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func classify(
        classifierID: String,
        text: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Classification>?, WatsonError?) -> Void)
    {
        // construct body
        let classifyRequest = ClassifyInput(
            text: text)
        guard let body = try? JSONEncoder().encode(classifyRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
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
        let path = "/v1/classifiers/\(classifierID)/classify"
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
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Classify multiple phrases.

     Returns label information for multiple phrases. The status must be `Available` before you can use the classifier to
     classify text.
     Note that classifying Japanese texts is a beta feature.

     - parameter classifierID: Classifier ID to use.
     - parameter collection: The submitted phrases.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func classifyCollection(
        classifierID: String,
        collection: [ClassifyInput],
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ClassificationCollection>?, WatsonError?) -> Void)
    {
        // construct body
        let classifyCollectionRequest = ClassifyCollectionInput(
            collection: collection)
        guard let body = try? JSONEncoder().encode(classifyCollectionRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
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
        let path = "/v1/classifiers/\(classifierID)/classify_collection"
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
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Create classifier.

     Sends data to create and train a classifier and returns information about the new classifier.

     - parameter metadata: Metadata in JSON format. The metadata identifies the language of the data, and an optional
       name to identify the classifier. Specify the language with the 2-letter primary language code as assigned in ISO
       standard 639.
       Supported languages are English (`en`), Arabic (`ar`), French (`fr`), German, (`de`), Italian (`it`), Japanese
       (`ja`), Korean (`ko`), Brazilian Portuguese (`pt`), and Spanish (`es`).
     - parameter trainingData: Training data in CSV format. Each text value must have at least one class. The data can
       include up to 3,000 classes and 20,000 records. For details, see [Data
       preparation](https://cloud.ibm.com/docs/services/natural-language-classifier/using-your-data.html).
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createClassifier(
        metadata: URL,
        trainingData: URL,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Classifier>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        do {
            try multipartFormData.append(file: metadata, withName: "training_metadata")
        } catch {
            completionHandler(nil, WatsonError.serialization(values: "file \(metadata.path)"))
            return
        }
        do {
            try multipartFormData.append(file: trainingData, withName: "training_data")
        } catch {
            completionHandler(nil, WatsonError.serialization(values: "file \(trainingData.path)"))
            return
        }
        guard let body = try? multipartFormData.toData() else {
            completionHandler(nil, WatsonError.serialization(values: "request multipart form data"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v1/classifiers",
            headerParameters: headerParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List classifiers.

     Returns an empty array if no classifiers are available.

     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listClassifiers(
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ClassifierList>?, WatsonError?) -> Void)
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
            url: serviceURL + "/v1/classifiers",
            headerParameters: headerParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Get information about a classifier.

     Returns status and other information about a classifier.

     - parameter classifierID: Classifier ID to query.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getClassifier(
        classifierID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Classifier>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/classifiers/\(classifierID)"
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
     Delete classifier.

     - parameter classifierID: Classifier ID to delete.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteClassifier(
        classifierID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"

        // construct REST request
        let path = "/v1/classifiers/\(classifierID)"
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

}
