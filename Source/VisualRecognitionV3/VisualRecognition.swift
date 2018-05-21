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
 The IBM Watson Visual Recognition service uses deep learning algorithms to identify scenes, objects, and faces  in
 images you upload to the service. You can create and train a custom classifier to identify subjects that suit your
 needs.
 */
public class VisualRecognition {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway-a.watsonplatform.net/visual-recognition/api"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    internal let credentials: Credentials
    internal let domain = "com.ibm.watson.developer-cloud.VisualRecognitionV3"
    internal let version: String

    /**
     Create a `VisualRecognition` object.

     - parameter apiKey: The API key used to authenticate with the service.
     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     */
    public init(apiKey: String, version: String) {
        self.credentials = .apiKey(name: "api_key", key: apiKey, in: .query)
        self.version = version
    }

    /**
     If the response or data represents an error returned by the Visual Recognition service,
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

        let code = response?.statusCode ?? 400
        do {
            let json = try JSONWrapper(data: data)
            let errorID = (try? json.getString(at: "error_id")) ?? (try? json.getString(at: "error", "error_id"))
            let error = try? json.getString(at: "error")
            let status = try? json.getString(at: "status")
            let html = try? json.getString(at: "Error")
            let message = errorID ?? error ?? status ?? html ?? "Unknown error."
            let description = (try? json.getString(at: "description")) ?? (try? json.getString(at: "error", "description"))
            let statusInfo = try? json.getString(at: "statusInfo")
            let reason = description ?? statusInfo ?? "Please use the status code to refer to the documentation."
            let userInfo = [
                NSLocalizedDescriptionKey: message,
                NSLocalizedFailureReasonErrorKey: reason,
            ]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return NSError(domain: domain, code: code, userInfo: nil)
        }
    }

    /**
     Classify images.

     Classify images with built-in or custom classifiers.

     - parameter imagesFile: An image file (.jpg, .png) or .zip file with images. Maximum image size is 10 MB. Include no more than 20 images
     and limit the .zip file to 100 MB. Encode the image and .zip file names in UTF-8 if they contain non-ASCII
     characters. The service assumes UTF-8 encoding if it encounters non-ASCII characters.  You can also include an
     image with the **url** parameter.
     - parameter acceptLanguage: The language of the output class names. The full set of languages is supported only for the built-in `default`
     classifier ID. The class names of custom classifiers are not translated.  The response might not be in the
     specified language when the requested language is not supported or when there is no translation for the class name.
     - parameter url: The URL of an image to analyze. Must be in .jpg, or .png format. The minimum recommended pixel density is 32X32
     pixels per inch, and the maximum image size is 10 MB.  You can also include images with the **images_file**
     parameter.
     - parameter threshold: The minimum score a class must have to be displayed in the response. Set the threshold to `0.0` to ignore the
     classification score and return all values.
     - parameter owners: The categories of classifiers to apply. Use `IBM` to classify against the `default` general classifier, and use
     `me` to classify against your custom classifiers. To analyze the image against both classifier categories, set the
     value to both `IBM` and `me`.   The built-in `default` classifier is used if both **classifier_ids** and **owners**
     parameters are empty.  The **classifier_ids** parameter overrides **owners**, so make sure that **classifier_ids**
     is empty.
     - parameter classifierIDs: Which classifiers to apply. Overrides the **owners** parameter. You can specify both custom and built-in classifier
     IDs. The built-in `default` classifier is used if both **classifier_ids** and **owners** parameters are empty.  The
     following built-in classifier IDs require no training: - `default`: Returns classes from thousands of general tags.
     - `food`: (Beta) Enhances specificity and accuracy for images of food items. - `explicit`: (Beta) Evaluates whether
     the image might be pornographic.
     - parameter imagesFileContentType: The content type of imagesFile.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func classify(
        imagesFile: URL? = nil,
        url: String? = nil,
        threshold: Double? = nil,
        owners: [String]? = nil,
        classifierIDs: [String]? = nil,
        acceptLanguage: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ClassifiedImages) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        if let imagesFile = imagesFile {
            multipartFormData.append(imagesFile, withName: "images_file")
        }
        if let url = url {
            guard let urlData = url.data(using: .utf8) else {
                failure?(RestError.serializationError)
                return
            }
            multipartFormData.append(urlData, withName: "url")
        }
        if let threshold = threshold {
            guard let thresholdData = "\(threshold)".data(using: .utf8) else {
                failure?(RestError.serializationError)
                return
            }
            multipartFormData.append(thresholdData, withName: "threshold")
        }
        if let owners = owners {
            guard let ownersData = owners.joined(separator: ",").data(using: .utf8) else {
                failure?(RestError.serializationError)
                return
            }
            multipartFormData.append(ownersData, withName: "owners")
        }
        if let classifierIDs = classifierIDs {
            guard let classifierIDsData = classifierIDs.joined(separator: ",").data(using: .utf8) else {
                failure?(RestError.serializationError)
                return
            }
            multipartFormData.append(classifierIDsData, withName: "classifier_ids")
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
        if let acceptLanguage = acceptLanguage {
            headerParameters["Accept-Language"] = acceptLanguage
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v3/classify",
            credentials: credentials,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<ClassifiedImages>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Detect faces in images.

     **Important:** On April 2, 2018, the identity information in the response to calls to the Face model was removed.
     The identity information refers to the `name` of the person, `score`, and `type_hierarchy` knowledge graph. For
     details about the enhanced Face model, see the [Release
     notes](https://console.bluemix.net/docs/services/visual-recognition/release-notes.html#2april2018).  Analyze and
     get data about faces in images. Responses can include estimated age and gender. This feature uses a built-in model,
     so no training is necessary. The Detect faces method does not support general biometric facial recognition.
     Supported image formats include .gif, .jpg, .png, and .tif. The maximum image size is 10 MB. The minimum
     recommended pixel density is 32X32 pixels per inch.

     - parameter imagesFile: An image file (gif, .jpg, .png, .tif.) or .zip file with images. Limit the .zip file to 100 MB. You can include a
     maximum of 15 images in a request.  Encode the image and .zip file names in UTF-8 if they contain non-ASCII
     characters. The service assumes UTF-8 encoding if it encounters non-ASCII characters.  You can also include an
     image with the **url** parameter.
     - parameter url: The URL of an image to analyze. Must be in .gif, .jpg, .png, or .tif format. The minimum recommended pixel density
     is 32X32 pixels per inch, and the maximum image size is 10 MB. Redirects are followed, so you can use a shortened
     URL.  You can also include images with the **images_file** parameter.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func detectFaces(
        imagesFile: URL? = nil,
        url: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DetectedFaces) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        if let imagesFile = imagesFile {
            multipartFormData.append(imagesFile, withName: "images_file", mimeType: "application/octet-stream")
        }
        if let url = url {
            guard let urlData = url.data(using: .utf8) else {
                failure?(RestError.serializationError)
                return
            }
            multipartFormData.append(urlData, withName: "url")
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

        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v3/detect_faces",
            credentials: credentials,
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<DetectedFaces>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Create a classifier.

     Train a new multi-faceted classifier on the uploaded image data. Create your custom classifier with positive or
     negative examples. Include at least two sets of examples, either two positive example files or one positive and one
     negative file. You can upload a maximum of 256 MB per call.  Encode all names in UTF-8 if they contain non-ASCII
     characters (.zip and image file names, and classifier and class names). The service assumes UTF-8 encoding if it
     encounters non-ASCII characters.

     - parameter name: The name of the new classifier. Encode special characters in UTF-8.
     - parameter positiveExamples: An array of positive examples, each with a name and a compressed
        (.zip) file of images that depict the visual subject for a class within the new classifier. Include at least
        10 images in .jpg or .png format. The minimum recommended image resolution is 32X32 pixels. The maximum number
        of images is 10,000 images or 100 MB per .zip file.
     - parameter negativeExamples: A .zip file of images that do not depict the visual subject of any of the classes of the new classifier. Must
     contain a minimum of 10 images.  Encode special characters in the file name in UTF-8.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func createClassifier(
        name: String,
        positiveExamples: [PositiveExample],
        negativeExamples: URL? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Classifier) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        guard let nameData = name.data(using: .utf8) else {
            failure?(RestError.serializationError)
            return
        }
        multipartFormData.append(nameData, withName: "name")
        positiveExamples.forEach { example in
            multipartFormData.append(example.examples, withName: example.name + "_positive_examples")
        }
        if let negativeExamples = negativeExamples {
            multipartFormData.append(negativeExamples, withName: "negative_examples")
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

        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v3/classifiers",
            credentials: credentials,
            headerParameters: headerParameters,
            queryItems: queryParameters,
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
     Retrieve a list of classifiers.

     - parameter owners: Unused. This parameter will be removed in a future release.
     - parameter verbose: Specify `true` to return details about the classifiers. Omit this parameter to return a brief list of classifiers.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func listClassifiers(
        owners: [String]? = nil,
        verbose: Bool? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Classifiers) -> Void)
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
        if let verbose = verbose {
            let queryParameter = URLQueryItem(name: "verbose", value: "\(verbose)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v3/classifiers",
            credentials: credentials,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Classifiers>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Retrieve classifier details.

     Retrieve information about a custom classifier.

     - parameter classifierID: The ID of the classifier.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getClassifier(
        classifierID: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Classifier) -> Void)
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
        let path = "/v3/classifiers/\(classifierID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headerParameters,
            queryItems: queryParameters
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
     Update a classifier.

     Update a custom classifier by adding new positive or negative classes (examples) or by adding new images to
     existing classes. You must supply at least one set of positive or negative examples. For details, see [Updating
     custom
     classifiers](https://console.bluemix.net/docs/services/visual-recognition/customizing.html#updating-custom-classifiers).
      Encode all names in UTF-8 if they contain non-ASCII characters (.zip and image file names, and classifier and
     class names). The service assumes UTF-8 encoding if it encounters non-ASCII characters.  **Tip:** Don't make
     retraining calls on a classifier until the status is ready. When you submit retraining requests in parallel, the
     last request overwrites the previous requests. The retrained property shows the last time the classifier retraining
     finished.

     - parameter classifierID: The ID of the classifier.
     - parameter positiveExamples: An array of positive examples, each with a name and a compressed
     (.zip) file of images that depict the visual subject for a class within the new classifier. Include at least
     10 images in .jpg or .png format. The minimum recommended image resolution is 32X32 pixels. The maximum number
     of images is 10,000 images or 100 MB per .zip file.
     - parameter negativeExamples: A .zip file of images that do not depict the visual subject of any of the classes of the new classifier. Must
     contain a minimum of 10 images.  Encode special characters in the file name in UTF-8.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func updateClassifier(
        classifierID: String,
        positiveExamples: [PositiveExample]? = nil,
        negativeExamples: URL? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Classifier) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        if let positiveExamples = positiveExamples {
            positiveExamples.forEach { example in
                multipartFormData.append(example.examples, withName: example.name + "_positive_examples")
            }
        }
        if let negativeExamples = negativeExamples {
            multipartFormData.append(negativeExamples, withName: "negative_examples")
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

        // construct REST request
        let path = "/v3/classifiers/\(classifierID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "POST",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headerParameters,
            queryItems: queryParameters,
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
     Delete a classifier.

     - parameter classifierID: The ID of the classifier.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func deleteClassifier(
        classifierID: String,
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
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v3/classifiers/\(classifierID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headerParameters,
            queryItems: queryParameters
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
     Retrieve a Core ML model of a classifier.

     Download a Core ML model file (.mlmodel) of a custom classifier that returns <tt>\"core_ml_enabled\": true</tt> in
     the classifier details.

     - parameter classifierID: The ID of the classifier.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func getCoreMlModel(
        classifierID: String,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (URL) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/octet-stream"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v3/classifiers/\(classifierID)/core_ml_model"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<URL>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

}
