/**
 * Copyright IBM Corporation 2016-2017
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
import RestKit

/**
 The IBM Watson Visual Recognition service uses deep learning algorithms to analyze images,
 identify scenes, objects, faces, text, and other content, and return keywords that provide
 information about that content.
 */
public class VisualRecognition {
    
    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway-a.watsonplatform.net/visual-recognition/api"
    
    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()
    
    private let apiKey: String
    private let version: String
    private let domain = "com.ibm.watson.developer-cloud.VisualRecognitionV3"
    
    /**
     Create a `VisualRecognition` object.
 
     - parameter apiKey: The API key used to authenticate with the service.
     - parameter version: The release date of the version of the API to use. Specify the date in
        "YYYY-MM-DD" format.
     */
    public init(apiKey: String, version: String) {
        self.apiKey = apiKey
        self.version = version
    }
    
    /**
     If the response or data represents an error returned by the Visual Recognition service,
     then return NSError with information about the error that occured. Otherwise, return nil.
     
     - parameter response: the URL response returned from the service.
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func responseToError(response: HTTPURLResponse?, data: Data?) -> NSError? {
        
        // Typically, we would check the http status code in the response object here, and return
        // `nil` if the status code is successful (200 <= statusCode < 300). However, there are 
        // specific endpoints, like the `classify` endpoint, where the service returns a status
        // code of 200 if you are able to successfully contact the service, without regards to
        // whether the response itself was a success or a failure.
        
        // ensure data is not nil
        guard let data = data else {
            if let code = response?.statusCode {
                return NSError(domain: domain, code: code, userInfo: nil)
            }
            return nil  // RestKit will generate error for this case
        }
        
        do {
            let json = try JSON(data: data)
            var code = response?.statusCode ?? 400
            let userInfo: [String: String]
            if let status = try? json.getString(at: "status") {
                let statusInfo = try json.getString(at: "statusInfo")
                userInfo = [
                    NSLocalizedFailureReasonErrorKey: status,
                    NSLocalizedDescriptionKey: statusInfo
                ]
            } else if let message = try? json.getString(at: "error") {
                userInfo = [
                    NSLocalizedDescriptionKey: message
                ]
            } else {
                let message = try json.getString(at: "images", 0, "error", "error_id")
                let description = try json.getString(at: "images", 0, "error", "description")
                let imagesProcessed = try json.getInt(at: "images_processed")
                code = 400
                userInfo = [
                    NSLocalizedFailureReasonErrorKey: message,
                    NSLocalizedDescriptionKey: description + " -- Images Processed: \(imagesProcessed)"
                ]
            }
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }
    
    // MARK: - Methods
    
    /**
     Classify an image at the given URL.
     
     - parameter image: The URL of the image (.jpg or .png). Redirects are followed, so you can use
        shortened URLs. The resolved URL is returned in the response. Maximum image size is 2 MB.
     - parameter owners: A list of the classifiers to run. Acceptable values are "IBM" and "me".
     - parameter classifierIDs: A list of the classifier ids to use. "default" is the id of the
        built-in classifier.
     - parameter threshold: The minimum score a class must have to be displayed in the response.
     - parameter language: The language of the output class names. Can be "en" (English), "es"
        (Spanish), "ar" (Arabic), or "ja" (Japanese). Classes for which no translation is available
        are omitted.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the image classifications.
     */
    public func classify(
        image url: String,
        owners: [String]? = nil,
        classifierIDs: [String]? = nil,
        threshold: Double? = nil,
        language: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ClassifiedImages) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        queryParameters.append(URLQueryItem(name: "url", value: url))
        if let owners = owners {
            let list = owners.joined(separator: ",")
            queryParameters.append(URLQueryItem(name: "owners", value: list))
        }
        if let classifierIDs = classifierIDs {
            let list = classifierIDs.joined(separator: ",")
            queryParameters.append(URLQueryItem(name: "classifier_ids", value: list))
        }
        if let threshold = threshold {
            queryParameters.append(URLQueryItem(name: "threshold", value: "\(threshold)"))
        }
        
        // construct header parameters
        var headerParameters = defaultHeaders
        if let language = language {
            headerParameters["Accept-Language"] = language
        }
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v3/classify",
            credentials: .apiKey,
            headerParameters: headerParameters,
            acceptType: "application/json",
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<ClassifiedImages>) in
            switch response.result {
            case .success(let classifiedImages): success(classifiedImages)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Upload and classify an image or multiple images in a compressed (.zip) file.
     
     - parameter imageFile: The image file (.jpg or .png) or compressed (.zip) file of images. The
        total number of images is limited to 20, with a max .zip size of 5 MB.
     - parameter owners: A list of the classifiers to run. Acceptable values are "IBM" and "me".
     - parameter classifierIDs: A list of the classifier ids to use. "default" is the id of the
        built-in classifier.
     - parameter threshold: The minimum score a class must have to be displayed in the response.
     - parameter language: The language of the output class names. Can be "en" (English), "es"
        (Spanish), "ar" (Arabic), or "ja" (Japanese). Classes for which no translation is available
        are omitted.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the image classifications.
     */
    public func classify(
        imageFile image: URL,
        owners: [String]? = nil,
        classifierIDs: [String]? = nil,
        threshold: Double? = nil,
        language: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ClassifiedImages) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct header parameters
        var headerParameters = defaultHeaders
        if let language = language {
            headerParameters["Accept-Language"] = language
        }
        
        // construct visual recognition parameters
        var parameters = [String: Any]()
        if let owners = owners {
            parameters["owners"] = owners
        }
        if let classifierIDs = classifierIDs {
            parameters["classifier_ids"] = classifierIDs
        }
        if let threshold = threshold {
            parameters["threshold"] = threshold
        }
        guard let json = try? JSON(dictionary: parameters).serialize() else {
            failure?(RestError.encodingError)
            return
        }
        
        // construct body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(image, withName: "image_file", mimeType: "application/octet-stream")
        multipartFormData.append(json, withName: "parameters", mimeType: "application/octet-stream", fileName: "parameters.json")
        guard let body = try? multipartFormData.toData() else {
            failure?(RestError.encodingError)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v3/classify",
            credentials: .apiKey,
            headerParameters: headerParameters,
            acceptType: "application/json",
            contentType: multipartFormData.contentType,
            queryItems: queryParameters,
            messageBody: body
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<ClassifiedImages>) in
            switch response.result {
            case .success(let classifiedImages): success(classifiedImages)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Detect faces in an image at the given URL. Each face is analyzed to estimate age, gender,
     celebrity name, and more.
     
     - parameter inImage: The URL of the image (.jpg or .png). Redirects are followed, so you
        can use shortened URLs. The resolved URL is returned in the response. Maximum image size is
        2 MB.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the detected faces.
     */
    public func detectFaces(
        inImage url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ImagesWithFaces) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        queryParameters.append(URLQueryItem(name: "url", value: url))

        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v3/detect_faces",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<ImagesWithFaces>) in
            switch response.result {
            case .success(let classifiedImages): success(classifiedImages)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Upload and detect faces in an image or multiple images in a compressed (.zip) file. Each face
     is analyzed to estimate age, gender, celebrity name, and more.
     
     - parameter inImageFile: The image file (.jpg or .png) or compressed (.zip) file of images. The
        total number of images is limited to 20, with a max .zip size of 5 MB.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the image classifications.
     */
    public func detectFaces(
        inImageFile image: URL,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ImagesWithFaces) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(image, withName: "image_file", mimeType: "application/octet-stream")
        guard let body = try? multipartFormData.toData() else {
            failure?(RestError.encodingError)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v3/detect_faces",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: multipartFormData.contentType,
            queryItems: queryParameters,
            messageBody: body
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<ImagesWithFaces>) in
            switch response.result {
            case .success(let classifiedImages): success(classifiedImages)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    // MARK: - Custom Classifiers

    /**
     Retrieve a list of custom classifiers.
 
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the list of classifiers.
     */
    public func getClassifiers(
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([Classifier]) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        queryParameters.append(URLQueryItem(name: "verbose", value: "true"))
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v3/classifiers",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseArray(responseToError: responseToError, path: ["classifiers"]) {
            (response: RestResponse<[Classifier]>) in
            switch response.result {
            case .success(let classifiers): success(classifiers)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Create and train a classifier with uploaded image data. You must supply at least two compressed
     (.zip) files of images, either two positive example files or one positive and one negative
     example file.
     
     Compressed files containing positive examples are used to create classes that define what the
     new classifier is. There is no limit to the number of positive example files that can be
     uploaded in a single call.
     
     The compressed file containing negative examples is not used to create a class within the
     trained classifier, but does define what the new classifier is not. Negative example files
     should contain images that do not depict the subject of any of the positive examples. You can
     only specify one negative example file in a single call.
 
     - parameter withName: The name of the new classifier.
     - parameter positiveExamples: An array of positive examples, each with a name and a compressed
        (.zip) file of images that depict the visual subject for a class within the new classifier.
        Must contain a minimum of 10 images.
     - parameter negativeExamples: A compressed (.zip) file of images that do not depict the visual
        subject of any of the classes of the new classifier. Must contain a minimum of 10 images.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the created classifier.
     */
    public func createClassifier(
        withName name: String,
        positiveExamples: [PositiveExample],
        negativeExamples: URL? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Classifier) -> Void)
    {
        // ensure at least two classes were specified
        let twoOrMoreClasses = (positiveExamples.count >= 2)
        let positiveAndNegative = (positiveExamples.count >= 1 && negativeExamples != nil)
        guard twoOrMoreClasses || positiveAndNegative else {
            let failureReason = "You must supply at least two compressed (.zip) files of images, " +
                                "either two positive example files or one positive and one " +
                                "negative example file."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // encode name as data
        guard let name = name.data(using: .utf8) else {
            failure?(RestError.encodingError)
            return
        }
        
        // construct body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(name, withName: "name")
        for positiveExample in positiveExamples {
            let name = positiveExample.name + "_positive_examples"
            let examples = positiveExample.examples
            multipartFormData.append(examples, withName: name)
        }
        if let negativeExamples = negativeExamples {
            multipartFormData.append(negativeExamples, withName: "negative_examples")
        }
        guard let body = try? multipartFormData.toData() else {
            failure?(RestError.encodingError)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v3/classifiers",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: multipartFormData.contentType,
            queryItems: queryParameters,
            messageBody: body
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Classifier>) in
            switch response.result {
            case .success(let classifier): success(classifier)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Delete a custom classifier.
     
     - parameter withID: The id of the classifier to delete.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed after the classifier has been successfully deleted.
     */
    public func deleteClassifier(
        withID classifierID: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + "/v3/classifiers/\(classifierID)",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    /**
     Retrieve information about a custom classifier.
 
     - parameter withID: The id of the classifier to retrieve information about.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the retrieved information about the given
            classifier.
     */
    public func getClassifier(
        withID classifierID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Classifier) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v3/classifiers/\(classifierID)",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Classifier>) in
            switch response.result {
            case .success(let classifier): success(classifier)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Update a custom classifier by adding new classes or images.
     
     - parameter withID: The id of the classifier to update.
     - parameter positiveExamples: An array of positive examples, each with a name and a compressed
        (.zip) file of images that depict the visual subject for a class within the new classifier.
        Must contain a minimum of 10 images.
     - parameter negativeExamples: A compressed (.zip) file of images that do not depict the visual
        subject of any of the classes of the new classifier. Must contain a minimum of 10 images.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the created classifier.
     */
    public func updateClassifier(
        withID classifierID: String,
        positiveExamples: [PositiveExample]? = nil,
        negativeExamples: URL? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Classifier) -> Void)
    {
        // ensure there is at least one compressed file
        guard (positiveExamples != nil) || (negativeExamples != nil) else {
            let failureReason = "To update a classifier, you must provide at least one " +
                                "compressed file of either positive or negative examples."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct body
        let multipartFormData = MultipartFormData()
        if let positiveExamples = positiveExamples {
            for positiveExample in positiveExamples {
                let name = positiveExample.name + "_positive_examples"
                let examples = positiveExample.examples
                multipartFormData.append(examples, withName: name)
            }
        }
        if let negativeExamples = negativeExamples {
            multipartFormData.append(negativeExamples, withName: "negative_examples")
        }
        guard let body = try? multipartFormData.toData() else {
            failure?(RestError.encodingError)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v3/classifiers/\(classifierID)",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: multipartFormData.contentType,
            queryItems: queryParameters,
            messageBody: body
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Classifier>) in
            switch response.result {
            case .success(let classifier): success(classifier)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    // MARK: - Custom Collections
    
    /** 
     Create a new collection. A maximum of five collections can be created.
     
     - parameter name:  The name of the new collection. The name can be a maximum of 128 UTF-8
        characters. The name cannot contain any spaces.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the newly created collection.
    */
    public func createCollection (
        withName name: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Collection) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        //construct body
        let multipartFormData = MultipartFormData()
        let nameData = name.data(using: String.Encoding.utf8)!
        multipartFormData.append(nameData, withName: "name")
        guard let body = try? multipartFormData.toData() else {
            failure?(RestError.encodingError)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v3/collections",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: multipartFormData.contentType,
            queryItems: queryParameters,
            messageBody: body
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Collection>) in
            switch response.result {
            case .success(let collection): success(collection)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
    List all collections created.
 
    - parameter failure: A function executed if an error occurs.
    - parameter success: A function executed with the list of classifiers.
    */
    public func getCollections(
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([Collection]) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v3/collections",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseArray(responseToError: responseToError, path: ["collections"]) {
            (response: RestResponse<[Collection]>) in
            switch response.result {
            case .success(let collections): success(collections)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Retrieve the information of a specified collection.
     
     - parameter withID: The ID of the collection to retrieve.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the collection retrieved.
     */
    public func retrieveCollectionDetails(
        withID collectionID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Collection) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v3/collections/\(collectionID)",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Collection>) in
            switch response.result {
            case .success(let collection): success(collection)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Delete a collection.
     
     - parameter withID: The ID of the collection to delete.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed after the collection has been successfully deleted.
    */
    public func deleteCollection(
        withID collectionID: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + "/v3/collections/\(collectionID)",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    /**
     Add images to a collection. Each collection can hold 1000000 images. Each image takes
     one second to upload.
     
     - parameter withID: The ID of the collection images will be added to.
     - parameter imageFile: The image file (.jpg or .png) of the image to add to the
        collection. The maximum file size to upload an image is 2 MB. If the images do not
        require a specific resolution, shrink the image to make the request faster.
        Concurrent requests of uploading photos is not supported. Uploading more than one
        image (.zip or folder of images) is not supported too. Uploading one image takes
        approximately one second.
     - parameter metadata: The JSON file that adds metadata to the image. The maximum
        file size for each image is 2 KB. Metadata can be used to identify images.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the image added to the
        collection.
     */
    public func addImageToCollection(
        withID collectionID: String,
        imageFile image: URL,
        metadata: URL? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (CollectionImages) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        //construct body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(image, withName: "image_file")
        if let metadata = metadata {
            multipartFormData.append(metadata, withName: "metadata")
        }
        guard let body = try? multipartFormData.toData() else {
            failure?(RestError.encodingError)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v3/collections/\(collectionID)/images",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: multipartFormData.contentType,
            queryItems: queryParameters,
            messageBody: body
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<CollectionImages>) in
            switch response.result {
            case .success(let images): success(images)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     List an arbitrary selection of 100 images in a selected collection. Each
     collection can contain 1000000 images.
     
     - parameter withID: The ID of the collection to list the images from.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the list of images in the collection.
     */
    public func getImagesInCollection(
        withID collectionID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([CollectionImage]) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v3/collections/\(collectionID)/images",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseArray(responseToError: responseToError, path: ["images"]) {
            (response: RestResponse<[CollectionImage]>) in
            switch response.result {
            case .success(let images): success(images)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     List the details of an image within a collection.
     
     - parameter withID: The ID of the collection the image is in.
     - parameter imageID: The ID of the image to get details from.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the image's details.
     */
    public func listImageDetailsInCollection(
        withID collectionID: String,
        imageID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (CollectionImage) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v3/collections/\(collectionID)/images/\(imageID)",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<CollectionImage>) in
            switch response.result {
            case .success(let image): success(image)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Delete an image from a collection.
 
     - parameter withID: The ID of the collection to delete the image from.
     - parameter imageID: The ID of the image to delete.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed when the image is deleted successfully.
    */
    public func deleteImageFromCollection(
        withID collectionID: String,
        imageID: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + "/v3/collections/\(collectionID)/images/\(imageID)",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }
 
    /**
     Delete an image's metadata from a collection.
     
     - parameter forImageID: The ID of the image containing the metadata to delete.
     - parameter inCollectionID: The ID of the collection to delete the image's metadata from.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed when the image metadata is deleted successfully.
    */
    public func deleteImageMetadata(
        forImageID imageID: String,
        inCollectionID collectionID: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + "/v3/collections/\(collectionID)/images/\(imageID)/metadata",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    /**
     List an image's metadata from a collection. 
     
     - parameter forImageID: The ID of the image to list metadata from.
     - parameter inCollectionID: The ID of the collection to list the image's metadata from.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed when the image metadata is listed successfully.
     */
    public func listImageMetadata(
        forImageID imageID: String,
        inCollectionID collectionID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Metadata) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v3/collections/\(collectionID)/images/\(imageID)/metadata",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Metadata>) in
            switch response.result {
            case .success(let metadata): success(metadata)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Update an image's metadata from a collection. 
     
     - parameter forImageID: The ID of the image to update.
     - parameter inCollectionID: The ID of the collection to update the image's metadata.
     - parameter metadata: The JSON file that adds metadata to the image. The maximum
        file size for each image is 2 KB. Metadata can be used to identify images.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed when the image metadata is updated successfully.
    */
    public func updateImageMetadata(
        forImageID imageID: String,
        inCollectionID collectionID: String,
        metadata: URL,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Metadata) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        //construct body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(metadata, withName: "metadata")
        guard let body = try? multipartFormData.toData() else {
            failure?(RestError.encodingError)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "PUT",
            url: serviceURL + "/v3/collections/\(collectionID)/images/\(imageID)/metadata",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: multipartFormData.contentType,
            queryItems: queryParameters,
            messageBody: body
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Metadata>) in
            switch response.result {
            case .success(let metadata): success(metadata)
            case .failure(let error): failure?(error)
            }
        }
    }
 
    /**
     Find similar images to an uploaded image within a collection.
     
     - parameter toImageFile: The image file (.jpg or .png) of the image to search against the
        collection.
     - parameter inCollectionID: The ID of the collection to find similar images in.
     - parameter limit: The number of similar results you want returned. Default is 10 with
         a max of 100 results.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the list of similar images.
    */
    public func findSimilarImages(
        toImageFile image: URL,
        inCollectionID collectionID: String,
        limit: Int? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SimilarImages) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        //construct body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(image, withName: "image_file")
        guard let body = try? multipartFormData.toData() else {
            failure?(RestError.encodingError)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v3/collections/\(collectionID)/find_similar",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: multipartFormData.contentType,
            queryItems: queryParameters,
            messageBody: body
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<SimilarImages>) in
            switch response.result {
            case .success(let similarImages): success(similarImages)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Write service input parameters to a temporary JSON file that can be uploaded.
     
     - parameter url: An array of image URLs to use.
     - parameter classifierIDs: An array of classifier ids. "default" is the id of the built-in
            classifier.
     - parameter owners: An array of owners. Must be "IBM", "me", or a combination of the two.
     - parameter showLowConfidence: If true, then the results will include lower-confidence classes.
     
     - returns: The URL of a JSON file that includes the given parameters.
     */
    private func writeParameters(
        url: String? = nil,
        classifierIDs: [String]? = nil,
        owners: [String]? = nil,
        showLowConfidence: Bool? = nil) throws
        -> URL
    {
        // construct JSON dictionary
        var json = [String: Any]()
        if let url = url {
            json["url"] = url
        }
        if let classifierIDs = classifierIDs {
            json["classifier_ids"] = classifierIDs
        }
        if let owners = owners {
            json["owners"] = owners
        }
        if let showLowConfidence = showLowConfidence {
            json["show_low_confidence"] = showLowConfidence
        }
        
        // create a globally unique file name in a temporary directory
        let suffix = "VisualRecognitionParameters.json"
        
        let uuid = UUID().uuidString
        let fileName = "\(uuid)_\(suffix)"
        let directoryURL = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let fileURL = directoryURL.appendingPathComponent(fileName)!
        
        // save JSON dictionary to file
        let data = try JSON(dictionary: json).serialize()
        try data.write(to: fileURL, options: .atomic)
        
        return fileURL
    }
}
