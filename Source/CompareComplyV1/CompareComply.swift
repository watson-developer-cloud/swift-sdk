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

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    let session = URLSession(configuration: URLSessionConfiguration.default)
    var authMethod: AuthenticationMethod
    let domain = "com.ibm.watson.developer-cloud.CompareComplyV1"
    let version: String

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
        Shared.configureRestRequest()
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
        Shared.configureRestRequest()
    }

    public func accessToken(_ newToken: String) {
        if self.authMethod is IAMAccessToken {
            self.authMethod = IAMAccessToken(accessToken: newToken)
        }
    }

    /**
     If the response or data represents an error returned by the Compare and Comply service,
     then return NSError with information about the error that occured. Otherwise, return nil.

     - parameter data: Raw data returned from the service that may represent an error.
     - parameter response: the URL response returned from the service.
     */
    func errorResponseDecoder(data: Data, response: HTTPURLResponse) -> Error {

        let code = response.statusCode
        do {
            let json = try JSONDecoder().decode([String: JSON].self, from: data)
            var userInfo: [String: Any] = [:]
            if case let .some(.string(message)) = json["error"] {
                userInfo[NSLocalizedDescriptionKey] = message
            }
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return NSError(domain: domain, code: code, userInfo: nil)
        }
    }

    /**
     Convert file to HTML.

     Uploads an input file to the service instance, which returns an HTML version of the document.

     - parameter file: The input file to convert.
     - parameter modelID: The analysis model to be used by the service. For the `/v1/element_classification` and
       `/v1/comparison` methods, the default is `contracts`. For the `/v1/tables` method, the default is `tables`. These
       defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter fileContentType: The content type of file.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func convertToHtml(
        file: URL,
        modelID: String? = nil,
        fileContentType: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (HTMLReturn) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        do {
            try multipartFormData.append(file: file, withName: "file")
        } catch {
            failure?(error)
            return
        }
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
        request.responseObject {
            (response: RestResponse<HTMLReturn>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Classify the elements of a document.

     Uploads a file to the service instance, which returns an analysis of the document's structural and semantic
     elements.

     - parameter file: The input file to convert.
     - parameter modelID: The analysis model to be used by the service. For the `/v1/element_classification` and
       `/v1/comparison` methods, the default is `contracts`. For the `/v1/tables` method, the default is `tables`. These
       defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter fileContentType: The content type of file.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func classifyElements(
        file: URL,
        modelID: String? = nil,
        fileContentType: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ClassifyReturn) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        do {
            try multipartFormData.append(file: file, withName: "file")
        } catch {
            failure?(error)
            return
        }
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
        request.responseObject {
            (response: RestResponse<ClassifyReturn>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Extract a document's tables.

     Uploads a document file to the service instance, which extracts the contents of the document's tables.

     - parameter file: The input file on which to run table extraction.
     - parameter modelID: The analysis model to be used by the service. For the `/v1/element_classification` and
       `/v1/comparison` methods, the default is `contracts`. For the `/v1/tables` method, the default is `tables`. These
       defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter fileContentType: The content type of file.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func extractTables(
        file: URL,
        modelID: String? = nil,
        fileContentType: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (TableReturn) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        do {
            try multipartFormData.append(file: file, withName: "file")
        } catch {
            failure?(error)
            return
        }
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
        request.responseObject {
            (response: RestResponse<TableReturn>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Compare two documents.

     Uploads two input files to the service instance, which analyzes the content and returns parsed JSON comparing the
     two documents. Uploaded files must be in the same file format.

     - parameter file1: The first file to compare.
     - parameter file2: The second file to compare.
     - parameter file1Label: A text label for the first file. The label cannot exceed 64 characters in length. The
       default is `file_1`.
     - parameter file2Label: A text label for the second file. The label cannot exceed 64 characters in length. The
       default is `file_2`.
     - parameter modelID: The analysis model to be used by the service. For the `/v1/element_classification` and
       `/v1/comparison` methods, the default is `contracts`. For the `/v1/tables` method, the default is `tables`. These
       defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter file1ContentType: The content type of file1.
     - parameter file2ContentType: The content type of file2.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
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
        failure: ((Error) -> Void)? = nil,
        success: @escaping (CompareReturn) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        do {
            try multipartFormData.append(file: file1, withName: "file_1")
        } catch {
            failure?(error)
            return
        }
        do {
            try multipartFormData.append(file: file2, withName: "file_2")
        } catch {
            failure?(error)
            return
        }
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
        request.responseObject {
            (response: RestResponse<CompareReturn>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
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
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func addFeedback(
        feedbackData: FeedbackDataInput,
        userID: String? = nil,
        comment: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (FeedbackReturn) -> Void)
    {
        // construct body
        let addFeedbackRequest = FeedbackInput(feedbackData: feedbackData, userID: userID, comment: comment)
        guard let body = try? JSONEncoder().encode(addFeedbackRequest) else {
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
            url: serviceURL + "/v1/feedback",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject {
            (response: RestResponse<FeedbackReturn>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
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
       return. The default value is `10` and the maximum value is `100`.
     - parameter cursor: An optional string that returns the set of documents after the previous set. Use this
       parameter with the `page_limit` parameter.
     - parameter sort: An optional comma-separated list of fields in the document to sort on. You can optionally
       specify the sort direction by prefixing the value of the field with `-` for descending order or `+` for ascending
       order (the default). Currently permitted sorting fields are `created`, `user_id`, and `document_title`.
     - parameter includeTotal: An optional boolean value. If specified as `true`, the `pagination` object in the
       output includes a value called `total` that gives the total count of feedback created.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listFeedback(
        feedbackType: String? = nil,
        before: String? = nil,
        after: String? = nil,
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
        failure: ((Error) -> Void)? = nil,
        success: @escaping (FeedbackList) -> Void)
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
        if let feedbackType = feedbackType {
            let queryParameter = URLQueryItem(name: "feedback_type", value: feedbackType)
            queryParameters.append(queryParameter)
        }
        if let before = before {
            let queryParameter = URLQueryItem(name: "before", value: before)
            queryParameters.append(queryParameter)
        }
        if let after = after {
            let queryParameter = URLQueryItem(name: "after", value: after)
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
        request.responseObject {
            (response: RestResponse<FeedbackList>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     List a specified feedback entry.

     - parameter feedbackID: An string that specifies the feedback entry to be included in the output.
     - parameter modelID: The analysis model to be used by the service. For the `/v1/element_classification` and
       `/v1/comparison` methods, the default is `contracts`. For the `/v1/tables` method, the default is `tables`. These
       defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getFeedback(
        feedbackID: String,
        modelID: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (GetFeedback) -> Void)
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
        if let modelID = modelID {
            let queryParameter = URLQueryItem(name: "model_id", value: modelID)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/feedback/\(feedbackID)"
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
            (response: RestResponse<GetFeedback>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Deletes a specified feedback entry.

     - parameter feedbackID: An string that specifies the feedback entry to be deleted from the document.
     - parameter modelID: The analysis model to be used by the service. For the `/v1/element_classification` and
       `/v1/comparison` methods, the default is `contracts`. For the `/v1/tables` method, the default is `tables`. These
       defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func deleteFeedback(
        feedbackID: String,
        modelID: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (FeedbackDeleted) -> Void)
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
        if let modelID = modelID {
            let queryParameter = URLQueryItem(name: "model_id", value: modelID)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/feedback/\(feedbackID)"
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
            (response: RestResponse<FeedbackDeleted>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Submit a batch-processing request.

     Run Compare and Comply methods over a collection of input documents.
     **Important:** Batch processing requires the use of the [IBM Cloud Object Storage
     service](https://console.bluemix.net/docs/services/cloud-object-storage/about-cos.html#about-ibm-cloud-object-storage).
     The use of IBM Cloud Object Storage with Compare and Comply is discussed at [Using batch
     processing](https://console.bluemix.net/docs/services/compare-comply/batching.html#before-you-batch).

     - parameter function: The Compare and Comply method to run across the submitted input documents. Possible values
       are `html_conversion`, `element_classification`, and `tables`.
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
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
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
        failure: ((Error) -> Void)? = nil,
        success: @escaping (BatchStatus) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        do {
            try multipartFormData.append(file: inputCredentialsFile, withName: "input_credentials_file")
        } catch {
            failure?(error)
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
            failure?(error)
            return
        }
        if let outputBucketLocationData = outputBucketLocation.data(using: .utf8) {
            multipartFormData.append(outputBucketLocationData, withName: "output_bucket_location")
        }
        if let outputBucketNameData = outputBucketName.data(using: .utf8) {
            multipartFormData.append(outputBucketNameData, withName: "output_bucket_name")
        }
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
        request.responseObject {
            (response: RestResponse<BatchStatus>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Gets the list of submitted batch-processing jobs.

     Gets the list of batch-processing jobs submitted by users.

     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listBatches(
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Batches) -> Void)
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
            url: serviceURL + "/v1/batches",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject {
            (response: RestResponse<Batches>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Gets information about a specific batch-processing request.

     Gets information about a batch-processing request with a specified ID.

     - parameter batchID: The ID of the batch-processing request whose information you want to retrieve.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getBatch(
        batchID: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (BatchStatus) -> Void)
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
        let path = "/v1/batches/\(batchID)"
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
            (response: RestResponse<BatchStatus>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Updates a pending or active batch-processing request.

     Updates a pending or active batch-processing request. You can rescan the input bucket to check for new documents or
     cancel a request.

     - parameter batchID: The ID of the batch-processing request you want to update.
     - parameter action: The action you want to perform on the specified batch-processing request. Possible values are
       `rescan` and `cancel`.
     - parameter modelID: The analysis model to be used by the service. For the `/v1/element_classification` and
       `/v1/comparison` methods, the default is `contracts`. For the `/v1/tables` method, the default is `tables`. These
       defaults apply to the standalone methods as well as to the methods' use in batch-processing requests.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func updateBatch(
        batchID: String,
        action: String,
        modelID: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (BatchStatus) -> Void)
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
        queryParameters.append(URLQueryItem(name: "action", value: action))
        if let modelID = modelID {
            let queryParameter = URLQueryItem(name: "model_id", value: modelID)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v1/batches/\(batchID)"
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
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject {
            (response: RestResponse<BatchStatus>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

}
