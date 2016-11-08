/**
 * Copyright IBM Corporation 2016
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
     If the given data represents an error returned by the Visual Recognition service, then return
     an NSError with information about the error that occured. Otherwise, return nil.

     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func dataToError(data: Data) -> NSError? {
        do {
            let json = try JSON(data: data)
            let imagesProcessed = try json.getInt(at: "images_processed") // TODO: may not be present?
            let code = try json.getInt(at: "error", "code")
            let error = try json.getString(at: "error", "error_id")
            let description = try json.getString(at: "error", "description")
            let userInfo = [
                NSLocalizedFailureReasonErrorKey: error,
                NSLocalizedDescriptionKey: description + " -- Images Processed: \(imagesProcessed)"
            ]
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
        request.responseObject(dataToError: dataToError) {
            (response: RestResponse<ClassifiedImages>) in
            switch response.result {
            case .success(let classifiedImages): success(classifiedImages)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    // TODO: The following classify function uploads images to be classified.
    // Unfortunately, we are seeing an undefined error from the service.
    // Most likely, there is an issue with the multipart/form data payload.
    // We will be investigating this issue further and issuing updates soon.
    
//    /**
//     Upload and classify an image or multiple images in a compressed (.zip) file.
//     
//     - parameter imageFile: The image file (.jpg or .png) or compressed (.zip) file of images. The
//        total number of images is limited to 20, with a max .zip size of 5 MB.
//     - parameter owners: A list of the classifiers to run. Acceptable values are "IBM" and "me".
//     - parameter classifierIDs: A list of the classifier ids to use. "default" is the id of the
//        built-in classifier.
//     - parameter threshold: The minimum score a class must have to be displayed in the response.
//     - parameter language: The language of the output class names. Can be "en" (English), "es"
//        (Spanish), "ar" (Arabic), or "ja" (Japanese). Classes for which no translation is available
//        are omitted.
//     - parameter failure: A function executed if an error occurs.
//     - parameter success: A function executed with the image classifications.
//     */
//    public func classify(
//        imageFile image: URL,
//        owners: [String]? = nil,
//        classifierIDs: [String]? = nil,
//        threshold: Double? = nil,
//        language: String? = nil,
//        failure: ((Error) -> Void)? = nil,
//        success: @escaping (ClassifiedImages) -> Void)
//    {
//        // construct query parameters
//        var queryParameters = [URLQueryItem]()
//        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
//        queryParameters.append(URLQueryItem(name: "version", value: version))
//        
//        // construct header parameters
//        var headerParameters = defaultHeaders
//        if let language = language {
//            headerParameters["Accept-Language"] = language
//        }
//        
//        // construct visual recognition parameters
//        var parameters = [String: Any]()
//        if let owners = owners {
//            parameters["owners"] = owners
//        }
//        if let classifierIDs = classifierIDs {
//            parameters["classifier_ids"] = classifierIDs
//        }
//        if let threshold = threshold {
//            parameters["threshold"] = threshold
//        }
//        guard let json = try? JSON(dictionary: parameters).serialize() else {
//            failure?(RestError.encodingError)
//            return
//        }
//        
//        // construct body
//        let multipartFormData = MultipartFormData()
//        multipartFormData.append(image, withName: "image_file", mimeType: "application/octet-stream")
//        // multipartFormData.append(json, withName: "parameters", mimeType: "application/octet-stream", fileName: "parameters.json")
//        guard let body = try? multipartFormData.toData() else {
//            failure?(RestError.encodingError)
//            return
//        }
//        
//        // construct REST request
//        let request = RestRequest(
//            method: "POST",
//            url: serviceURL + "/v3/classify",
//            credentials: .apiKey,
//            headerParameters: headerParameters,
//            acceptType: "application/json",
//            contentType: multipartFormData.contentType,
//            queryItems: queryParameters,
//            messageBody: body
//        )
//        
//        // execute REST request
//        request.responseObject(dataToError: dataToError) {
//            (response: RestResponse<ClassifiedImages>) in
//            switch response.result {
//            case .success(let classifiedImages): success(classifiedImages)
//            case .failure(let error): failure?(error)
//            }
//        }
//    }
    
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
        request.responseObject(dataToError: dataToError) {
            (response: RestResponse<ImagesWithFaces>) in
            switch response.result {
            case .success(let classifiedImages): success(classifiedImages)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    // TODO: The following classify function uploads images to be classified.
    // Unfortunately, we are seeing an undefined error from the service.
    // Most likely, there is an issue with the multipart/form data payload.
    // We will be investigating this issue further and issuing updates soon.
    
//    /**
//     Upload and detect faces in an image or multiple images in a compressed (.zip) file. Each face
//     is analyzed to estimate age, gender, celebrity name, and more.
//     
//     - parameter inImageFile: The image file (.jpg or .png) or compressed (.zip) file of images. The
//        total number of images is limited to 20, with a max .zip size of 5 MB.
//     - parameter failure: A function executed if an error occurs.
//     - parameter success: A function executed with the image classifications.
//     */
//    public func detectFaces(
//        inImageFile image: URL,
//        failure: ((Error) -> Void)? = nil,
//        success: @escaping (ImagesWithFaces) -> Void)
//    {
//        // construct query parameters
//        var queryParameters = [URLQueryItem]()
//        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
//        queryParameters.append(URLQueryItem(name: "version", value: version))
//
//        // construct body
//        let multipartFormData = MultipartFormData()
//        multipartFormData.append(image, withName: "image_file")
//        guard let body = try? multipartFormData.toData() else {
//            failure?(RestError.encodingError)
//            return
//        }
//        
//        // construct REST request
//        let request = RestRequest(
//            method: "POST",
//            url: serviceURL + "/v3/detect_faces",
//            credentials: .apiKey,
//            headerParameters: defaultHeaders,
//            acceptType: "application/json",
//            contentType: multipartFormData.contentType,
//            queryItems: queryParameters,
//            messageBody: body
//        )
//        
//        // execute REST request
//        request.responseObject(dataToError: dataToError) {
//            (response: RestResponse<ImagesWithFaces>) in
//            switch response.result {
//            case .success(let classifiedImages): success(classifiedImages)
//            case .failure(let error): failure?(error)
//            }
//        }
//    }
    
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
        request.responseArray(dataToError: dataToError, path: ["classifiers"]) {
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
        request.responseObject(dataToError: dataToError) {
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
        success: ((Void) -> Void)? = nil)
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
                switch self.dataToError(data: data) {
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
        request.responseObject(dataToError: dataToError) {
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
        request.responseObject(dataToError: dataToError) {
            (response: RestResponse<Classifier>) in
            switch response.result {
            case .success(let classifier): success(classifier)
            case .failure(let error): failure?(error)
            }
        }
        
    }
}



// TODO: remove the following unnecessary function, if all tests pass!
// The classify function requires a file. We used to use this function to actually create
// a file in the file-system with the given parameters, then pass that file to Alamofire
// to be encoded in the multipart/form data payload. It's possible that we can avoid creating
// the file by constructing the multipart/form data payload manually. If it works, then we can
// remove the code below.

//    /**
//     Write service input parameters to a temporary JSON file that can be uploaded.
//     
//     - parameter url: An array of image URLs to use.
//     - parameter classifierIDs: An array of classifier ids. "default" is the id of the built-in
//            classifier.
//     - parameter owners: An array of owners. Must be "IBM", "me", or a combination of the two.
//     - parameter showLowConfidence: If true, then the results will include lower-confidence classes.
//     
//     - returns: The URL of a JSON file that includes the given parameters.
//     */
//    private func writeParameters(
//        url: String? = nil,
//        classifierIDs: [String]? = nil,
//        owners: [String]? = nil,
//        showLowConfidence: Bool? = nil) throws
//        -> URL
//    {
//        // construct JSON dictionary
//        var json = [String: Any]()
//        if let url = url {
//            json["url"] = url
//        }
//        if let classifierIDs = classifierIDs {
//            json["classifier_ids"] = classifierIDs
//        }
//        if let owners = owners {
//            json["owners"] = owners
//        }
//        if let showLowConfidence = showLowConfidence {
//            json["show_low_confidence"] = showLowConfidence
//        }
//        
//        // create a globally unique file name in a temporary directory
//        let suffix = "VisualRecognitionParameters.json"
//        let fileName = String(format: "%@_%@", UUID().uuidString, suffix)
//        let directoryURL = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
//        let fileURL = directoryURL.appendingPathComponent(fileName)!
//        
//        // save JSON dictionary to file
//        let data = try JSON(dictionary: json).serialize()
//        try data.write(to: fileURL, options: .atomicWrite)
//        
//        return fileURL
//    }
