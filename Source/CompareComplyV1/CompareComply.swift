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

    #if os(Linux)
    /**
     Create a `CompareComply` object.

     This initializer will retrieve credentials from the environment or a local credentials file.
     The credentials file can be downloaded from your service instance on IBM Cloud as ibm-credentials.env.
     Make sure to add the credentials file to your project so that it can be loaded at runtime.

     If credentials are not available in the environment or a local credentials file, initialization will fail.
     In that case, try another initializer that directly passes in the credentials.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     */
    public init?(version: String) {
        self.version = version
        guard let credentials = Shared.extractCredentials(serviceName: "compare_comply") else {
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
     Create a `CompareComply` object.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     - parameter apiKey: An API key for IAM that can be used to obtain access tokens for the service.
     - parameter iamUrl: The URL for the IAM service.
     */
    public init(version: String, apiKey: String, iamUrl: String? = nil) {
        self.authMethod = Shared.getAuthMethod(apiKey: apiKey, iamURL: iamUrl)
        self.version = version
        RestRequest.userAgent = Shared.userAgent
    }

    /**
     Create a `CompareComply` object.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     - parameter accessToken: An access token for the service.
     */
    public init(version: String, accessToken: String) {
        self.version = version
        self.authMethod = IAMAccessToken(accessToken: accessToken)
        RestRequest.userAgent = Shared.userAgent
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
     Convert document to HTML.

     Converts a document to HTML.

     - parameter file: The document to convert.
     - parameter filename: The filename for file.
     - parameter fileContentType: The content type of file.
     - parameter model: The analysis model to be used by the service. For the **Element classification** and **Compare
       two documents** methods, the default is `contracts`. For the **Extract tables** method, the default is `tables`.
       These defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func convertToHTML(
        file: Data,
        filename: String,
        fileContentType: String? = nil,
        model: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<HTMLReturn>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(file, withName: "file", mimeType: fileContentType, fileName: filename)
        guard let body = try? multipartFormData.toData() else {
            completionHandler(nil, WatsonError.serialization(values: "request multipart form data"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "convertToHTML")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let model = model {
            let queryParameter = URLQueryItem(name: "model", value: model)
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

     Analyzes the structural and semantic elements of a document.

     - parameter file: The document to classify.
     - parameter fileContentType: The content type of file.
     - parameter model: The analysis model to be used by the service. For the **Element classification** and **Compare
       two documents** methods, the default is `contracts`. For the **Extract tables** method, the default is `tables`.
       These defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func classifyElements(
        file: Data,
        fileContentType: String? = nil,
        model: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ClassifyReturn>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(file, withName: "file", mimeType: fileContentType, fileName: "filename")
        guard let body = try? multipartFormData.toData() else {
            completionHandler(nil, WatsonError.serialization(values: "request multipart form data"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "classifyElements")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let model = model {
            let queryParameter = URLQueryItem(name: "model", value: model)
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

     Analyzes the tables in a document.

     - parameter file: The document on which to run table extraction.
     - parameter fileContentType: The content type of file.
     - parameter model: The analysis model to be used by the service. For the **Element classification** and **Compare
       two documents** methods, the default is `contracts`. For the **Extract tables** method, the default is `tables`.
       These defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func extractTables(
        file: Data,
        fileContentType: String? = nil,
        model: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TableReturn>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(file, withName: "file", mimeType: fileContentType, fileName: "filename")
        guard let body = try? multipartFormData.toData() else {
            completionHandler(nil, WatsonError.serialization(values: "request multipart form data"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "extractTables")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let model = model {
            let queryParameter = URLQueryItem(name: "model", value: model)
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

     Compares two input documents. Documents must be in the same format.

     - parameter file1: The first document to compare.
     - parameter file2: The second document to compare.
     - parameter file1ContentType: The content type of file1.
     - parameter file2ContentType: The content type of file2.
     - parameter file1Label: A text label for the first document.
     - parameter file2Label: A text label for the second document.
     - parameter model: The analysis model to be used by the service. For the **Element classification** and **Compare
       two documents** methods, the default is `contracts`. For the **Extract tables** method, the default is `tables`.
       These defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func compareDocuments(
        file1: Data,
        file2: Data,
        file1ContentType: String? = nil,
        file2ContentType: String? = nil,
        file1Label: String? = nil,
        file2Label: String? = nil,
        model: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<CompareReturn>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(file1, withName: "file_1", mimeType: file1ContentType, fileName: "filename")
        multipartFormData.append(file2, withName: "file_2", mimeType: file2ContentType, fileName: "filename")
        guard let body = try? multipartFormData.toData() else {
            completionHandler(nil, WatsonError.serialization(values: "request multipart form data"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "compareDocuments")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
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
        if let model = model {
            let queryParameter = URLQueryItem(name: "model", value: model)
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
        guard let body = try? JSON.encoder.encode(addFeedbackRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "addFeedback")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
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
     List the feedback in a document.

     Lists the feedback in a document.

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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listFeedback")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
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

     Lists a feedback entry with a specified `feedback_id`.

     - parameter feedbackID: A string that specifies the feedback entry to be included in the output.
     - parameter model: The analysis model to be used by the service. For the **Element classification** and **Compare
       two documents** methods, the default is `contracts`. For the **Extract tables** method, the default is `tables`.
       These defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getFeedback(
        feedbackID: String,
        model: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<GetFeedback>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getFeedback")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let model = model {
            let queryParameter = URLQueryItem(name: "model", value: model)
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
     Delete a specified feedback entry.

     Deletes a feedback entry with a specified `feedback_id`.

     - parameter feedbackID: A string that specifies the feedback entry to be deleted from the document.
     - parameter model: The analysis model to be used by the service. For the **Element classification** and **Compare
       two documents** methods, the default is `contracts`. For the **Extract tables** method, the default is `tables`.
       These defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteFeedback(
        feedbackID: String,
        model: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<FeedbackDeleted>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteFeedback")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let model = model {
            let queryParameter = URLQueryItem(name: "model", value: model)
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
     - parameter model: The analysis model to be used by the service. For the **Element classification** and **Compare
       two documents** methods, the default is `contracts`. For the **Extract tables** method, the default is `tables`.
       These defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createBatch(
        function: String,
        inputCredentialsFile: Data,
        inputBucketLocation: String,
        inputBucketName: String,
        outputCredentialsFile: Data,
        outputBucketLocation: String,
        outputBucketName: String,
        model: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<BatchStatus>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(inputCredentialsFile, withName: "input_credentials_file", fileName: "filename")
        if let inputBucketLocationData = inputBucketLocation.data(using: .utf8) {
            multipartFormData.append(inputBucketLocationData, withName: "input_bucket_location")
        }
        if let inputBucketNameData = inputBucketName.data(using: .utf8) {
            multipartFormData.append(inputBucketNameData, withName: "input_bucket_name")
        }
        multipartFormData.append(outputCredentialsFile, withName: "output_credentials_file", fileName: "filename")
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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createBatch")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        queryParameters.append(URLQueryItem(name: "function", value: function))
        if let model = model {
            let queryParameter = URLQueryItem(name: "model", value: model)
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

     Lists batch-processing jobs submitted by users.

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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listBatches")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
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
     Get information about a specific batch-processing job.

     Gets information about a batch-processing job with a specified ID.

     - parameter batchID: The ID of the batch-processing job whose information you want to retrieve.
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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getBatch")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
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
     Update a pending or active batch-processing job.

     Updates a pending or active batch-processing job. You can rescan the input bucket to check for new documents or
     cancel a job.

     - parameter batchID: The ID of the batch-processing job you want to update.
     - parameter action: The action you want to perform on the specified batch-processing job.
     - parameter model: The analysis model to be used by the service. For the **Element classification** and **Compare
       two documents** methods, the default is `contracts`. For the **Extract tables** method, the default is `tables`.
       These defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateBatch(
        batchID: String,
        action: String,
        model: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<BatchStatus>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateBatch")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        queryParameters.append(URLQueryItem(name: "action", value: action))
        if let model = model {
            let queryParameter = URLQueryItem(name: "model", value: model)
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
