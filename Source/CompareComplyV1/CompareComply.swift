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
 IBM Watson&trade; Compare and Comply analyzes governing documents to provide details about critical aspects of the
 documents.
 */
public class CompareComply {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/compare-comply/api"
    internal let serviceName = "CompareComply"
    internal let serviceVersion = "v1"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    var session = URLSession(configuration: URLSessionConfiguration.default)
    var authMethod: AuthenticationMethod
    let version: String

    /**
     Create a `CompareComply` object.

     Use this initializer to automatically pull service credentials from your credentials file.
     This file is downloaded from your service instance on IBM Cloud as ibm-credentials.env.
     Make sure to add the credentials file to your project so that it can be loaded at runtime.

     If the credentials cannot be loaded from the file, or the file is not found, initialization will fail.
     In that case, try another initializer that directly passes in the credentials.

     - parameter credentialsFile: The URL of the credentials file.
     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     */
    public init?(credentialsFile: URL, version: String) {
        guard let credentials = Shared.extractCredentials(from: credentialsFile, serviceName: "compare_comply") else {
            return nil
        }
        guard let authMethod = Shared.getAuthMethod(from: credentials) else {
            return nil
        }
        if let serviceURL = Shared.getServiceURL(from: credentials) {
            self.serviceURL = serviceURL
        }
        self.authMethod = authMethod
        self.version = version
    }

    /**
     Create a `CompareComply` object.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     - parameter apiKey: An API key for IAM that can be used to obtain access tokens for the service.
     - parameter iamUrl: The URL for the IAM service.
     */
    public init(version: String, apiKey: String, iamUrl: String? = nil) {
        self.authMethod = Shared.getAuthMethod(apiKey: apiKey, iamURL: iamUrl)
        self.version = version
    }

    /**
     Create a `CompareComply` object.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     - parameter accessToken: An access token for the service.
     */
    public init(version: String, accessToken: String) {
        self.authMethod = IAMAccessToken(accessToken: accessToken)
        self.version = version
    }

    public func accessToken(_ newToken: String) {
        if self.authMethod is IAMAccessToken {
            self.authMethod = IAMAccessToken(accessToken: newToken)
        }
    }

    /**
     Use the HTTP response and data received by the Compare and Comply service to extract
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
            // If metadata is empty, it should show up as nil in the WatsonError
            return WatsonError.http(statusCode: statusCode, message: errorMessage, metadata: !metadata.isEmpty ? metadata : nil)
        } catch {
            return WatsonError.http(statusCode: statusCode, message: nil, metadata: nil)
        }
    }

    /**
     Convert file to HTML.

     Convert an uploaded file to HTML.

     - parameter file: The file to convert.
     - parameter modelID: The analysis model to be used by the service. For the `/v1/element_classification` and
       `/v1/comparison` methods, the default is `contracts`. For the `/v1/tables` method, the default is `tables`. These
       defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter fileContentType: The content type of file.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func convertToHTML(
        file: URL,
        modelID: String? = nil,
        fileContentType: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<HTMLReturn>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        do {
            try multipartFormData.append(file: file, withName: "file")
        } catch {
            completionHandler(nil, WatsonError.serialization(values: "file \(file.path)"))
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
        let metadataHeaders = Shared.getMetadataHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "convertToHTML")
        headerParameters.merge(metadataHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let modelID = modelID {
            let queryParameter = URLQueryItem(name: "model_id", value: modelID)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v1/html_conversion",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Classify the elements of a document.

     Analyze an uploaded file's structural and semantic elements.

     - parameter file: The file to classify.
     - parameter modelID: The analysis model to be used by the service. For the `/v1/element_classification` and
       `/v1/comparison` methods, the default is `contracts`. For the `/v1/tables` method, the default is `tables`. These
       defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter fileContentType: The content type of file.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func classifyElements(
        file: URL,
        modelID: String? = nil,
        fileContentType: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ClassifyReturn>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        do {
            try multipartFormData.append(file: file, withName: "file")
        } catch {
            completionHandler(nil, WatsonError.serialization(values: "file \(file.path)"))
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
        let metadataHeaders = Shared.getMetadataHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "classifyElements")
        headerParameters.merge(metadataHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let modelID = modelID {
            let queryParameter = URLQueryItem(name: "model_id", value: modelID)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v1/element_classification",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Extract a document's tables.

     Extract and analyze an uploaded file's tables.

     - parameter file: The file on which to run table extraction.
     - parameter modelID: The analysis model to be used by the service. For the `/v1/element_classification` and
       `/v1/comparison` methods, the default is `contracts`. For the `/v1/tables` method, the default is `tables`. These
       defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter fileContentType: The content type of file.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func extractTables(
        file: URL,
        modelID: String? = nil,
        fileContentType: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TableReturn>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        do {
            try multipartFormData.append(file: file, withName: "file")
        } catch {
            completionHandler(nil, WatsonError.serialization(values: "file \(file.path)"))
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
        let metadataHeaders = Shared.getMetadataHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "extractTables")
        headerParameters.merge(metadataHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let modelID = modelID {
            let queryParameter = URLQueryItem(name: "model_id", value: modelID)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v1/tables",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Compare two documents.

     Compare two uploaded input files. Uploaded files must be in the same file format.

     - parameter file1: The first file to compare.
     - parameter file2: The second file to compare.
     - parameter file1Label: A text label for the first file.
     - parameter file2Label: A text label for the second file.
     - parameter modelID: The analysis model to be used by the service. For the `/v1/element_classification` and
       `/v1/comparison` methods, the default is `contracts`. For the `/v1/tables` method, the default is `tables`. These
       defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter file1ContentType: The content type of file1.
     - parameter file2ContentType: The content type of file2.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func compareDocuments(
        file1: URL,
        file2: URL,
        file1Label: String? = nil,
        file2Label: String? = nil,
        modelID: String? = nil,
        file1ContentType: String? = nil,
        file2ContentType: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<CompareReturn>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        do {
            try multipartFormData.append(file: file1, withName: "file_1")
        } catch {
            completionHandler(nil, WatsonError.serialization(values: "file \(file1.path)"))
            return
        }
        do {
            try multipartFormData.append(file: file2, withName: "file_2")
        } catch {
            completionHandler(nil, WatsonError.serialization(values: "file \(file2.path)"))
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
        let metadataHeaders = Shared.getMetadataHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "compareDocuments")
        headerParameters.merge(metadataHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let file1Label = file1Label {
            let queryParameter = URLQueryItem(name: "file_1_label", value: file1Label)
            queryParameters.append(queryParameter)
        }
        if let file2Label = file2Label {
            let queryParameter = URLQueryItem(name: "file_2_label", value: file2Label)
            queryParameters.append(queryParameter)
        }
        if let modelID = modelID {
            let queryParameter = URLQueryItem(name: "model_id", value: modelID)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v1/comparison",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Add feedback.

     Adds feedback in the form of _labels_ from a subject-matter expert (SME) to a governing document.
     **Important:** Feedback is not immediately incorporated into the training model, nor is it guaranteed to be
     incorporated at a later date. Instead, submitted feedback is used to suggest future updates to the training model.

     - parameter feedbackData: Feedback data for submission.
     - parameter userID: An optional string identifying the user.
     - parameter comment: An optional comment on or description of the feedback.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func addFeedback(
        feedbackData: FeedbackDataInput,
        userID: String? = nil,
        comment: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<FeedbackReturn>?, WatsonError?) -> Void)
    {
        // construct body
        let addFeedbackRequest = FeedbackInput(
            feedbackData: feedbackData,
            userID: userID,
            comment: comment)
        guard let body = try? JSONEncoder().encode(addFeedbackRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let metadataHeaders = Shared.getMetadataHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "addFeedback")
        headerParameters.merge(metadataHeaders) { (_, new) in new }
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
            url: serviceURL + "/v1/feedback",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List the feedback in documents.

     - parameter feedbackType: An optional string that filters the output to include only feedback with the specified
       feedback type. The only permitted value is `element_classification`.
     - parameter before: An optional string in the format `YYYY-MM-DD` that filters the output to include only
       feedback that was added before the specified date.
     - parameter after: An optional string in the format `YYYY-MM-DD` that filters the output to include only feedback
       that was added after the specified date.
     - parameter documentTitle: An optional string that filters the output to include only feedback from the document
       with the specified `document_title`.
     - parameter modelID: An optional string that filters the output to include only feedback with the specified
       `model_id`. The only permitted value is `contracts`.
     - parameter modelVersion: An optional string that filters the output to include only feedback with the specified
       `model_version`.
     - parameter categoryRemoved: An optional string in the form of a comma-separated list of categories. If this is
       specified, the service filters the output to include only feedback that has at least one category from the list
       removed.
     - parameter categoryAdded: An optional string in the form of a comma-separated list of categories. If this is
       specified, the service filters the output to include only feedback that has at least one category from the list
       added.
     - parameter categoryNotChanged: An optional string in the form of a comma-separated list of categories. If this
       is specified, the service filters the output to include only feedback that has at least one category from the
       list unchanged.
     - parameter typeRemoved: An optional string of comma-separated `nature`:`party` pairs. If this is specified, the
       service filters the output to include only feedback that has at least one `nature`:`party` pair from the list
       removed.
     - parameter typeAdded: An optional string of comma-separated `nature`:`party` pairs. If this is specified, the
       service filters the output to include only feedback that has at least one `nature`:`party` pair from the list
       removed.
     - parameter typeNotChanged: An optional string of comma-separated `nature`:`party` pairs. If this is specified,
       the service filters the output to include only feedback that has at least one `nature`:`party` pair from the list
       unchanged.
     - parameter pageLimit: An optional integer specifying the number of documents that you want the service to
       return.
     - parameter cursor: An optional string that returns the set of documents after the previous set. Use this
       parameter with the `page_limit` parameter.
     - parameter sort: An optional comma-separated list of fields in the document to sort on. You can optionally
       specify the sort direction by prefixing the value of the field with `-` for descending order or `+` for ascending
       order (the default). Currently permitted sorting fields are `created`, `user_id`, and `document_title`.
     - parameter includeTotal: An optional boolean value. If specified as `true`, the `pagination` object in the
       output includes a value called `total` that gives the total count of feedback created.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listFeedback(
        feedbackType: String? = nil,
        before: Date? = nil,
        after: Date? = nil,
        documentTitle: String? = nil,
        modelID: String? = nil,
        modelVersion: String? = nil,
        categoryRemoved: String? = nil,
        categoryAdded: String? = nil,
        categoryNotChanged: String? = nil,
        typeRemoved: String? = nil,
        typeAdded: String? = nil,
        typeNotChanged: String? = nil,
        pageLimit: Int? = nil,
        cursor: String? = nil,
        sort: String? = nil,
        includeTotal: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<FeedbackList>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let metadataHeaders = Shared.getMetadataHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listFeedback")
        headerParameters.merge(metadataHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let feedbackType = feedbackType {
            let queryParameter = URLQueryItem(name: "feedback_type", value: feedbackType)
            queryParameters.append(queryParameter)
        }
        if let before = before {
            let queryParameter = URLQueryItem(name: "before", value: "\(before)")
            queryParameters.append(queryParameter)
        }
        if let after = after {
            let queryParameter = URLQueryItem(name: "after", value: "\(after)")
            queryParameters.append(queryParameter)
        }
        if let documentTitle = documentTitle {
            let queryParameter = URLQueryItem(name: "document_title", value: documentTitle)
            queryParameters.append(queryParameter)
        }
        if let modelID = modelID {
            let queryParameter = URLQueryItem(name: "model_id", value: modelID)
            queryParameters.append(queryParameter)
        }
        if let modelVersion = modelVersion {
            let queryParameter = URLQueryItem(name: "model_version", value: modelVersion)
            queryParameters.append(queryParameter)
        }
        if let categoryRemoved = categoryRemoved {
            let queryParameter = URLQueryItem(name: "category_removed", value: categoryRemoved)
            queryParameters.append(queryParameter)
        }
        if let categoryAdded = categoryAdded {
            let queryParameter = URLQueryItem(name: "category_added", value: categoryAdded)
            queryParameters.append(queryParameter)
        }
        if let categoryNotChanged = categoryNotChanged {
            let queryParameter = URLQueryItem(name: "category_not_changed", value: categoryNotChanged)
            queryParameters.append(queryParameter)
        }
        if let typeRemoved = typeRemoved {
            let queryParameter = URLQueryItem(name: "type_removed", value: typeRemoved)
            queryParameters.append(queryParameter)
        }
        if let typeAdded = typeAdded {
            let queryParameter = URLQueryItem(name: "type_added", value: typeAdded)
            queryParameters.append(queryParameter)
        }
        if let typeNotChanged = typeNotChanged {
            let queryParameter = URLQueryItem(name: "type_not_changed", value: typeNotChanged)
            queryParameters.append(queryParameter)
        }
        if let pageLimit = pageLimit {
            let queryParameter = URLQueryItem(name: "page_limit", value: "\(pageLimit)")
            queryParameters.append(queryParameter)
        }
        if let cursor = cursor {
            let queryParameter = URLQueryItem(name: "cursor", value: cursor)
            queryParameters.append(queryParameter)
        }
        if let sort = sort {
            let queryParameter = URLQueryItem(name: "sort", value: sort)
            queryParameters.append(queryParameter)
        }
        if let includeTotal = includeTotal {
            let queryParameter = URLQueryItem(name: "include_total", value: "\(includeTotal)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + "/v1/feedback",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List a specified feedback entry.

     - parameter feedbackID: A string that specifies the feedback entry to be included in the output.
     - parameter modelID: The analysis model to be used by the service. For the `/v1/element_classification` and
       `/v1/comparison` methods, the default is `contracts`. For the `/v1/tables` method, the default is `tables`. These
       defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getFeedback(
        feedbackID: String,
        modelID: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<GetFeedback>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let metadataHeaders = Shared.getMetadataHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getFeedback")
        headerParameters.merge(metadataHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let modelID = modelID {
            let queryParameter = URLQueryItem(name: "model_id", value: modelID)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/feedback/\(feedbackID)"
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
     Deletes a specified feedback entry.

     - parameter feedbackID: A string that specifies the feedback entry to be deleted from the document.
     - parameter modelID: The analysis model to be used by the service. For the `/v1/element_classification` and
       `/v1/comparison` methods, the default is `contracts`. For the `/v1/tables` method, the default is `tables`. These
       defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteFeedback(
        feedbackID: String,
        modelID: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<FeedbackDeleted>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let metadataHeaders = Shared.getMetadataHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteFeedback")
        headerParameters.merge(metadataHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let modelID = modelID {
            let queryParameter = URLQueryItem(name: "model_id", value: modelID)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/feedback/\(feedbackID)"
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
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Submit a batch-processing request.

     Run Compare and Comply methods over a collection of input documents.
     **Important:** Batch processing requires the use of the [IBM Cloud Object Storage
     service](https://cloud.ibm.com/docs/services/cloud-object-storage/about-cos.html#about-ibm-cloud-object-storage).
     The use of IBM Cloud Object Storage with Compare and Comply is discussed at [Using batch
     processing](https://cloud.ibm.com/docs/services/compare-comply/batching.html#before-you-batch).

     - parameter function: The Compare and Comply method to run across the submitted input documents.
     - parameter inputCredentialsFile: A JSON file containing the input Cloud Object Storage credentials. At a
       minimum, the credentials must enable `READ` permissions on the bucket defined by the `input_bucket_name`
       parameter.
     - parameter inputBucketLocation: The geographical location of the Cloud Object Storage input bucket as listed on
       the **Endpoint** tab of your Cloud Object Storage instance; for example, `us-geo`, `eu-geo`, or `ap-geo`.
     - parameter inputBucketName: The name of the Cloud Object Storage input bucket.
     - parameter outputCredentialsFile: A JSON file that lists the Cloud Object Storage output credentials. At a
       minimum, the credentials must enable `READ` and `WRITE` permissions on the bucket defined by the
       `output_bucket_name` parameter.
     - parameter outputBucketLocation: The geographical location of the Cloud Object Storage output bucket as listed
       on the **Endpoint** tab of your Cloud Object Storage instance; for example, `us-geo`, `eu-geo`, or `ap-geo`.
     - parameter outputBucketName: The name of the Cloud Object Storage output bucket.
     - parameter modelID: The analysis model to be used by the service. For the `/v1/element_classification` and
       `/v1/comparison` methods, the default is `contracts`. For the `/v1/tables` method, the default is `tables`. These
       defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createBatch(
        function: String,
        inputCredentialsFile: URL,
        inputBucketLocation: String,
        inputBucketName: String,
        outputCredentialsFile: URL,
        outputBucketLocation: String,
        outputBucketName: String,
        modelID: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<BatchStatus>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        do {
            try multipartFormData.append(file: inputCredentialsFile, withName: "input_credentials_file")
        } catch {
            completionHandler(nil, WatsonError.serialization(values: "file \(inputCredentialsFile.path)"))
            return
        }
        if let inputBucketLocationData = inputBucketLocation.data(using: .utf8) {
            multipartFormData.append(inputBucketLocationData, withName: "input_bucket_location")
        }
        if let inputBucketNameData = inputBucketName.data(using: .utf8) {
            multipartFormData.append(inputBucketNameData, withName: "input_bucket_name")
        }
        do {
            try multipartFormData.append(file: outputCredentialsFile, withName: "output_credentials_file")
        } catch {
            completionHandler(nil, WatsonError.serialization(values: "file \(outputCredentialsFile.path)"))
            return
        }
        if let outputBucketLocationData = outputBucketLocation.data(using: .utf8) {
            multipartFormData.append(outputBucketLocationData, withName: "output_bucket_location")
        }
        if let outputBucketNameData = outputBucketName.data(using: .utf8) {
            multipartFormData.append(outputBucketNameData, withName: "output_bucket_name")
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
        let metadataHeaders = Shared.getMetadataHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createBatch")
        headerParameters.merge(metadataHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        queryParameters.append(URLQueryItem(name: "function", value: function))
        if let modelID = modelID {
            let queryParameter = URLQueryItem(name: "model_id", value: modelID)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v1/batches",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List submitted batch-processing jobs.

     List the batch-processing jobs submitted by users.

     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listBatches(
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Batches>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let metadataHeaders = Shared.getMetadataHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listBatches")
        headerParameters.merge(metadataHeaders) { (_, new) in new }
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
            url: serviceURL + "/v1/batches",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Get information about a specific batch-processing request.

     Get information about a batch-processing request with a specified ID.

     - parameter batchID: The ID of the batch-processing request whose information you want to retrieve.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getBatch(
        batchID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<BatchStatus>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let metadataHeaders = Shared.getMetadataHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getBatch")
        headerParameters.merge(metadataHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/batches/\(batchID)"
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
     Update a pending or active batch-processing request.

     Update a pending or active batch-processing request. You can rescan the input bucket to check for new documents or
     cancel a request.

     - parameter batchID: The ID of the batch-processing request you want to update.
     - parameter action: The action you want to perform on the specified batch-processing request.
     - parameter modelID: The analysis model to be used by the service. For the `/v1/element_classification` and
       `/v1/comparison` methods, the default is `contracts`. For the `/v1/tables` method, the default is `tables`. These
       defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateBatch(
        batchID: String,
        action: String,
        modelID: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<BatchStatus>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let metadataHeaders = Shared.getMetadataHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateBatch")
        headerParameters.merge(metadataHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        queryParameters.append(URLQueryItem(name: "action", value: action))
        if let modelID = modelID {
            let queryParameter = URLQueryItem(name: "model_id", value: modelID)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/batches/\(batchID)"
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
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

}
