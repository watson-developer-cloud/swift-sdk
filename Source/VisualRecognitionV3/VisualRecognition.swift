/**
 * (C) Copyright IBM Corp. 2016, 2020.
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
import IBMSwiftSDKCore

/**
 The IBM Watson&trade; Visual Recognition service uses deep learning algorithms to identify scenes and objects in images
 that you upload to the service. You can create and train a custom classifier to identify subjects that suit your needs.
 */
public class VisualRecognition {

    /// The base URL to use when contacting the service.
    public var serviceURL: String? = "https://gateway.watsonplatform.net/visual-recognition/api"

    /// Service identifiers
    internal let serviceName = "WatsonVisionCombined"
    internal let serviceVersion = "v3"
    internal let serviceSdkName = "visual_recognition"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    var session = URLSession(configuration: URLSessionConfiguration.default)
    public let authenticator: Authenticator
    let version: String

    #if os(Linux)
    /**
     Create a `VisualRecognition` object.

     This initializer will retrieve credentials from the environment or a local credentials file.
     The credentials file can be downloaded from your service instance on IBM Cloud as ibm-credentials.env.
     Make sure to add the credentials file to your project so that it can be loaded at runtime.

     If credentials are not available in the environment or a local credentials file, initialization will fail.
     In that case, try another initializer that directly passes in the credentials.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     */
    public init(version: String) throws {
        self.version = version

        let authenticator = try ConfigBasedAuthenticatorFactory.getAuthenticator(credentialPrefix: serviceSdkName)
        self.authenticator = authenticator

        if let serviceURL = CredentialUtils.getServiceURL(credentialPrefix: serviceSdkName) {
            self.serviceURL = serviceURL
        }

        RestRequest.userAgent = Shared.userAgent
    }
    #endif

    /**
     Create a `VisualRecognition` object.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     - parameter authenticator: The Authenticator object used to authenticate requests to the service
     */
    public init(version: String, authenticator: Authenticator) {
        self.version = version
        self.authenticator = authenticator
        RestRequest.userAgent = Shared.userAgent
    }

    #if !os(Linux)
    /**
     Allow network requests to a server without verification of the server certificate.
     **IMPORTANT**: This should ONLY be used if truly intended, as it is unsafe otherwise.
     */
    public func disableSSLVerification() {
        session = InsecureConnection.session()
    }
    #endif

    /**
     Use the HTTP response and data received by the Visual Recognition service to extract
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
                // ErrorAuthentication
            } else if case let .some(.string(message)) = json["statusInfo"] {
                errorMessage = message
                // ErrorInfo
            } else if case let .some(.object(errorObj)) = json["error"],    // 404
                case let .some(.string(message)) = errorObj["description"] {
                errorMessage = message
                // ErrorHTML
            } else if case let .some(.string(message)) = json["Error"] {   // 413
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
     Classify images.

     Classify images with built-in or custom classifiers.

     - parameter imagesFile: An image file (.gif, .jpg, .png, .tif) or .zip file with images. Maximum image size is 10
       MB. Include no more than 20 images and limit the .zip file to 100 MB. Encode the image and .zip file names in
       UTF-8 if they contain non-ASCII characters. The service assumes UTF-8 encoding if it encounters non-ASCII
       characters.
       You can also include an image with the **url** parameter.
     - parameter imagesFilename: The filename for imagesFile.
     - parameter imagesFileContentType: The content type of imagesFile.
     - parameter url: The URL of an image (.gif, .jpg, .png, .tif) to analyze. The minimum recommended pixel density
       is 32X32 pixels, but the service tends to perform better with images that are at least 224 x 224 pixels. The
       maximum image size is 10 MB.
       You can also include images with the **images_file** parameter.
     - parameter threshold: The minimum score a class must have to be displayed in the response. Set the threshold to
       `0.0` to return all identified classes.
     - parameter owners: The categories of classifiers to apply. The **classifier_ids** parameter overrides
       **owners**, so make sure that **classifier_ids** is empty.
       - Use `IBM` to classify against the `default` general classifier. You get the same result if both
       **classifier_ids** and **owners** parameters are empty.
       - Use `me` to classify against all your custom classifiers. However, for better performance use
       **classifier_ids** to specify the specific custom classifiers to apply.
       - Use both `IBM` and `me` to analyze the image against both classifier categories.
     - parameter classifierIDs: Which classifiers to apply. Overrides the **owners** parameter. You can specify both
       custom and built-in classifier IDs. The built-in `default` classifier is used if both **classifier_ids** and
       **owners** parameters are empty.
       The following built-in classifier IDs require no training:
       - `default`: Returns classes from thousands of general tags.
       - `food`: Enhances specificity and accuracy for images of food items.
       - `explicit`: Evaluates whether the image might be pornographic.
     - parameter acceptLanguage: The desired language of parts of the response. See the response for details.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func classify(
        imagesFile: Data? = nil,
        imagesFilename: String? = nil,
        imagesFileContentType: String? = nil,
        url: String? = nil,
        threshold: Double? = nil,
        owners: [String]? = nil,
        classifierIDs: [String]? = nil,
        acceptLanguage: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ClassifiedImages>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        if let imagesFile = imagesFile {
            multipartFormData.append(imagesFile, withName: "images_file", mimeType: imagesFileContentType, fileName: imagesFilename ?? "filename")
        }
        if let url = url {
            if let urlData = url.data(using: .utf8) {
                multipartFormData.append(urlData, withName: "url")
            }
        }
        if let threshold = threshold {
            if let thresholdData = "\(threshold)".data(using: .utf8) {
                multipartFormData.append(thresholdData, withName: "threshold")
            }
        }

        // HAND EDIT: concat owners into csv data
        if let csvOwners = owners?.joined(separator: ",").data(using: .utf8) {
            multipartFormData.append(csvOwners, withName: "owners")
        }

        // HAND EDIT: concat classifier IDs into csv data
        if let csvClassifierIDs = classifierIDs?.joined(separator: ",").data(using: .utf8) {
            multipartFormData.append(csvClassifierIDs, withName: "classifier_ids")
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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "classify")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType
        if let acceptLanguage = acceptLanguage {
            headerParameters["Accept-Language"] = acceptLanguage
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + "/v3/classify",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Create a classifier.

     Train a new multi-faceted classifier on the uploaded image data. Create your custom classifier with positive or
     negative example training images. Include at least two sets of examples, either two positive example files or one
     positive and one negative file. You can upload a maximum of 256 MB per call.
     **Tips when creating:**
     - If you set the **X-Watson-Learning-Opt-Out** header parameter to `true` when you create a classifier, the example
     training images are not stored. Save your training images locally. For more information, see [Data
     collection](#data-collection).
     - Encode all names in UTF-8 if they contain non-ASCII characters (.zip and image file names, and classifier and
     class names). The service assumes UTF-8 encoding if it encounters non-ASCII characters.

     - parameter name: The name of the new classifier. Encode special characters in UTF-8.
     - parameter positiveExamples: A dictionary that contains the value for each classname. The value is a .zip file
       of images that depict the visual subject of a class in the new classifier. You can include more than one positive
       example file in a call.
       Specify the parameter name by appending `_positive_examples` to the class name. For example,
       `goldenretriever_positive_examples` creates the class **goldenretriever**. The string cannot contain the
       following characters: ``$ * - { } \ | / ' " ` [ ]``.
       Include at least 10 images in .jpg or .png format. The minimum recommended image resolution is 32X32 pixels. The
       maximum number of images is 10,000 images or 100 MB per .zip file.
       Encode special characters in the file name in UTF-8.
     - parameter negativeExamples: A .zip file of images that do not depict the visual subject of any of the classes
       of the new classifier. Must contain a minimum of 10 images.
       Encode special characters in the file name in UTF-8.
     - parameter negativeExamplesFilename: The filename for negativeExamples.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createClassifier(
        name: String,
        positiveExamples: [String: Data],
        negativeExamples: Data? = nil,
        negativeExamplesFilename: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Classifier>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        if let nameData = name.data(using: .utf8) {
            multipartFormData.append(nameData, withName: "name")
        }
        positiveExamples.forEach { (classname, value) in
            let partName = "\(classname)_positive_examples"
            multipartFormData.append(value, withName: partName, fileName: "\(classname).zip")
        }
        if let negativeExamples = negativeExamples {
            multipartFormData.append(negativeExamples, withName: "negative_examples", fileName: negativeExamplesFilename ?? "filename.zip")
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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createClassifier")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + "/v3/classifiers",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Retrieve a list of classifiers.

     - parameter verbose: Specify `true` to return details about the classifiers. Omit this parameter to return a
       brief list of classifiers.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listClassifiers(
        verbose: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Classifiers>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listClassifiers")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let verbose = verbose {
            let queryParameter = URLQueryItem(name: "verbose", value: "\(verbose)")
            queryParameters.append(queryParameter)
        }

        // construct REST request

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + "/v3/classifiers",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Retrieve classifier details.

     Retrieve information about a custom classifier.

     - parameter classifierID: The ID of the classifier.
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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getClassifier")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v3/classifiers/\(classifierID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Update a classifier.

     Update a custom classifier by adding new positive or negative classes or by adding new images to existing classes.
     You must supply at least one set of positive or negative examples. For details, see [Updating custom
     classifiers](https://cloud.ibm.com/docs/services/visual-recognition?topic=visual-recognition-customizing#updating-custom-classifiers).
     Encode all names in UTF-8 if they contain non-ASCII characters (.zip and image file names, and classifier and class
     names). The service assumes UTF-8 encoding if it encounters non-ASCII characters.
     **Tips about retraining:**
     - You can't update the classifier if the **X-Watson-Learning-Opt-Out** header parameter was set to `true` when the
     classifier was created. Training images are not stored in that case. Instead, create another classifier. For more
     information, see [Data collection](#data-collection).
     - Don't make retraining calls on a classifier until the status is ready. When you submit retraining requests in
     parallel, the last request overwrites the previous requests. The `retrained` property shows the last time the
     classifier retraining finished.

     - parameter classifierID: The ID of the classifier.
     - parameter positiveExamples: A dictionary that contains the value for each classname. The value is a .zip file
       of images that depict the visual subject of a class in the classifier. The positive examples create or update
       classes in the classifier. You can include more than one positive example file in a call.
       Specify the parameter name by appending `_positive_examples` to the class name. For example,
       `goldenretriever_positive_examples` creates the class `goldenretriever`. The string cannot contain the following
       characters: ``$ * - { } \ | / ' " ` [ ]``.
       Include at least 10 images in .jpg or .png format. The minimum recommended image resolution is 32X32 pixels. The
       maximum number of images is 10,000 images or 100 MB per .zip file.
       Encode special characters in the file name in UTF-8.
     - parameter negativeExamples: A .zip file of images that do not depict the visual subject of any of the classes
       of the new classifier. Must contain a minimum of 10 images.
       Encode special characters in the file name in UTF-8.
     - parameter negativeExamplesFilename: The filename for negativeExamples.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateClassifier(
        classifierID: String,
        positiveExamples: [String: Data]? = nil,
        negativeExamples: Data? = nil,
        negativeExamplesFilename: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Classifier>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        if let positiveExamples = positiveExamples {
            positiveExamples.forEach { (classname, value) in
                let partName = "\(classname)_positive_examples"
                multipartFormData.append(value, withName: partName, fileName: "\(classname).zip")
            }
        }
        if let negativeExamples = negativeExamples {
            multipartFormData.append(negativeExamples, withName: "negative_examples", fileName: negativeExamplesFilename ?? "filename.zip")
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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateClassifier")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v3/classifiers/\(classifierID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete a classifier.

     - parameter classifierID: The ID of the classifier.
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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteClassifier")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v3/classifiers/\(classifierID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     Retrieve a Core ML model of a classifier.

     Download a Core ML model file (.mlmodel) of a custom classifier that returns <tt>"core_ml_enabled": true</tt> in
     the classifier details.

     - parameter classifierID: The ID of the classifier.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getCoreMLModel(
        classifierID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Data>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getCoreMLModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/octet-stream"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v3/classifiers/\(classifierID)/core_ml_model"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

    /**
     Delete labeled data.

     Deletes all data associated with a specified customer ID. The method has no effect if no data is associated with
     the customer ID.
     You associate a customer ID with data by passing the `X-Watson-Metadata` header with a request that passes data.
     For more information about personal data and customer IDs, see [Information
     security](https://cloud.ibm.com/docs/services/visual-recognition?topic=visual-recognition-information-security).

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
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        queryParameters.append(URLQueryItem(name: "customer_id", value: customerID))

        // construct REST request

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceEndpoint + "/v3/user_data",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

}
