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
   IBM Watson Natural Language Classifier uses machine learning algorithms to return the top matching
  predefined classes for short text input. You create and train a classifier to connect predefined
  classes to example texts so that the service can apply those classes to new inputs.
 */
public class NaturalLanguageClassifier {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/natural-language-classifier/api"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    private let credentials: Credentials
    private let domain = "com.ibm.watson.developer-cloud.NaturalLanguageClassifierV1"

    /**
     Create a `NaturalLanguageClassifier` object.

     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     */
    public init(username: String, password: String) {
        self.credentials = .basicAuthentication(username: username, password: password)
    }

    /**
     If the response or data represents an error returned by the Natural Language Classifier service,
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
            let error = try? json.getString(at: "error")
            let description = try? json.getString(at: "description")
            let userInfo = [NSLocalizedDescriptionKey: error ?? "", NSLocalizedFailureReasonErrorKey: description ?? ""]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }

    /**
     Classify.

     Returns label information for the input. The status must be `Available` before you can use the classifier to classify text. Use `Get information about a classifier` to retrieve the status.

     - parameter classifierID: Classifier ID to use.
     - parameter text: The submitted phrase.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func classify(
        classifierID: String,
        text: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Classification) -> Void)
    {
        // construct body
        let classifyRequest = ClassifyInput(text: text)
        guard let body = try? JSONEncoder().encode(classifyRequest) else {
            failure?(RestError.serializationError)
            return
        }

        // construct REST request
        let path = "/v1/classifiers/\(classifierID)/classify"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: nil,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Classification>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Create classifier.

     Sends data to create and train a classifier and returns information about the new classifier.

     - parameter metadata: Metadata in JSON format. The metadata identifies the language of the data, and an optional name to identify the classifier. For details, see the [API reference](https://www.ibm.com/watson/developercloud/natural-language-classifier/api/v1/#create_classifier).
     - parameter trainingData: Training data in CSV format. Each text value must have at least one class. The data can include up to 15,000 records. For details, see [Using your own data](https://www.ibm.com/watson/developercloud/doc/natural-language-classifier/using-your-data.html).
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func createClassifier(
        metadata: URL,
        trainingData: URL,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Classifier) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(metadata, withName: "training_metadata")
        multipartFormData.append(trainingData, withName: "training_data")
        guard let body = try? multipartFormData.toData() else {
            failure?(RestError.encodingError)
            return
        }

        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/classifiers",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: multipartFormData.contentType,
            queryItems: nil,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Classifier>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Delete classifier.

     - parameter classifierID: Classifier ID to delete.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func deleteClassifier(
        classifierID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping () -> Void)
    {
        // construct REST request
        let path = "/v1/classifiers/\(classifierID)"
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
     Get information about a classifier.

     Returns status and other information about a classifier.

     - parameter classifierID: Classifier ID to query.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func getClassifier(
        classifierID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Classifier) -> Void)
    {
        // construct REST request
        let path = "/v1/classifiers/\(classifierID)"
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
            contentType: nil,
            queryItems: nil,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Classifier>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     List classifiers.

     Returns an empty array if no classifiers are available.

     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func listClassifiers(
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ClassifierList) -> Void)
    {
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/classifiers",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: nil,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<ClassifierList>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

}
