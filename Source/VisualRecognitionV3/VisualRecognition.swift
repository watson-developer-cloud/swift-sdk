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
import Alamofire
import Freddy
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
            let imagesProcessed = try json.getInt(at: "images_processed")
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
    
    /**
     Retrieve a list of user-trained classifiers.
 
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
            method: .get,
            url: serviceURL + "/v3/classifiers",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .responseArray(path: ["classifiers"]) { (response: DataResponse<[Classifier]>) in
                switch response.result {
                case .success(let classifiers): success(classifiers)
                case .failure(let error): failure?(error)
                }
        }
    }
    
    /**
     Train a new classifier on uploaded image data.
 
     To create a classifier, you must specify at least two classes—either two positive example sets,
     or one positive example set and one negative example set.
 
     - parameter name: The name of the new classifier.
     - parameter positiveExamples: An array of classes, each with a name and a zip archive file of
            images that prominently depict the visual subject of the class. Each class requires a
            minimum of 10 images. If you specify multiple classes, the system will learn to classify
            each category.
     - parameter negativeExamples: A zip archive file of images that *do not* prominently depict the
            visual subject of *any* of the classes being trained. Must contain a minimum of 10
            images.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the created classifier.
     */
    public func createClassifier(
        name: String,
        positiveExamples: [Class],
        negativeExamples: URL? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Classifier) -> Void)
    {
        // ensure at least two classes were specified
        let twoOrMoreClasses = (positiveExamples.count >= 2)
        let positiveAndNegative = (positiveExamples.count >= 1 && negativeExamples != nil)
        guard twoOrMoreClasses || positiveAndNegative else {
            let failureReason = "To create a classifier, you must specify at least two classes" +
                                "—either two positive example sets, or one positive example set " +
                                "and one negative example set."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: .post,
            url: serviceURL + "/v3/classifiers",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for positiveExample in positiveExamples {
                    let name = positiveExample.name + "_positive_examples"
                    if let examples = positiveExample.examples {
                        multipartFormData.append(examples, withName: name)
                    }
                }
                if let negativeExamples = negativeExamples {
                    let examples = negativeExamples
                    let name = "negative_examples"
                    multipartFormData.append(examples, withName: name)
                }
                if let name = name.data(using: String.Encoding.utf8) {
                    multipartFormData.append(name, withName: "name")
                }
            },
            with: request,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseObject() { (response: DataResponse<Classifier>) in
                        switch response.result {
                        case .success(let classifier): success(classifier)
                        case .failure(let error): failure?(error)
                        }
                    }
                case .failure:
                    let failureReason = "Provided file(s) could not be encoded as form data."
                    let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }
            }
        )
    }
    
    /**
     Delete a custom classifier with the given classifier id.
 
     - parameter classifierID: The id of the classifier to delete.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed after the classifier has been successfully deleted.
     */
    public func deleteClassifier(
        classifierID: String,
        failure: ((Error) -> Void)? = nil,
        success: ((Void) -> Void)? = nil)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: .delete,
            url: serviceURL + "/v3/classifiers/\(classifierID)",
            headerParameters: defaultHeaders,
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .responseData { response in
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
     Retrieve information about a specific classifier. Only user-trained classifiers may be
     addressed.
 
     - parameter classifierID: The id of the classifier to retrieve information about.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the retrieved information about the given
            classifier.
     */
    public func getClassifier(
        classifierID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Classifier) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: .get,
            url: serviceURL + "/v3/classifiers/\(classifierID)",
            headerParameters: defaultHeaders,
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .responseObject() { (response: DataResponse<Classifier>) in
                switch response.result {
                case .success(let classifier): success(classifier)
                case .failure(let error): failure?(error)
                }
            }
    }
    
    /**
     Update an existing classifier by adding new classes or by adding new images to existing 
     classes. At least one compressed file must be passed in.
     
     - parameter classifierID: The ID of the classifier you want to update.
     - parameter positiveExamples: An array of classes, each with a name and a zip archive file of
        images that prominently depict the visual subject of the class. Each class requires a
        minimum of 10 images. If you specify multiple classes, the system will learn to classify
        each category.
     - parameter negativeExamples: A zip archive file of images that *do not* prominently depict the
        visual subject of *any* of the classes being trained. Must contain a minimum of 10
        images.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the updated classifier.
     */
    public func updateClassifier(
        classifierID: String,
        positiveExamples: [Class]? = nil,
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
        
        // construct REST request
        let request = RestRequest(
            method: .post,
            url: serviceURL + "/v3/classifiers/\(classifierID)",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if let positiveExamples = positiveExamples {
                    for positiveExample in positiveExamples {
                        let name = positiveExample.name + "_positive_examples"
                        if let examples = positiveExample.examples {
                            multipartFormData.append(examples, withName: name)
                        }
                    }                    
                }
                if let negativeExamples = negativeExamples {
                    let examples = negativeExamples
                    let name = "negative_examples"
                    multipartFormData.append(examples, withName: name)
                }
            },
            with: request,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseObject() { (response: DataResponse<Classifier>) in
                        switch response.result {
                        case .success(let classifier): success(classifier)
                        case .failure(let error): failure?(error)
                        }
                    }
                case .failure:
                    let failureReason = "Provided file(s) could not be encoded as form data."
                    let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }
            }
        )
    }
    
    /**
     Classify images by URL. The supported image formats include .jpg, .png, and .gif.
 
     - parameter url: The URL of the image (.jpg, .png, or .gif). Redirects are followed, so it
            is safe to use with URL shorteners. The resolved URL is returned in the response.
     - parameter owners: A list with IBM and/or "me" to specify which classifiers to run.
     - parameter classifierIDs: A list of the ids for the classifiers to use. "default" is the id
            of the built-in classifier.
     - parameter showLowConfidence: If true, then the results will include lower-confidence classes.
     - parameter outputLanguage: The language of the output classifier (i.e. tag names). Can be
            "en" (English), "es" (Spanish), "ar" (Arabic), or "ja" (Japanese). Tags for which
            translations are not available are omitted.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the image classifications.
     */
    public func classify(
        url: String,
        owners: [String]? = nil,
        classifierIDs: [String]? = nil,
        showLowConfidence: Bool? = nil,
        outputLanguage: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ClassifiedImages) -> Void)
    {
        // write parameters to JSON file
        let parameters = writeParameters(
            url: url,
            classifierIDs: classifierIDs,
            owners: owners,
            showLowConfidence: showLowConfidence
        )
        
        // classify images
        classify(
            parameters: parameters,
            outputLanguage: outputLanguage,
            failure: failure,
            success: success
        )
    }
    
    /**
     Classify uploaded images. You can upload a single image or a compressed file (.zip) with
     multiple images to be classified. The supported image formats include .jpg, .png, and .gif.
     
     - parameter image: The image file (.jpg, .png, or .gif) or compressed (.zip) file of images
            to classify. The total number of images is limited to 100.
     - parameter owners: A list with IBM and/or "me" to specify which classifiers to run.
     - parameter classifierIDs: A list of the ids for the classifiers to use. "default" is the id
            of the built-in classifier.
     - parameter showLowConfidence: If true, then the results will include lower-confidence classes.
     - parameter outputLanguage: The language of the output classifier (i.e. tag names). Can be
            "en" (English), "es" (Spanish), "ar" (Arabic), or "ja" (Japanese). Tags for which
            translations are not available are omitted.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the image classifications.
     */
    public func classify(
        image: URL,
        owners: [String]? = nil,
        classifierIDs: [String]? = nil,
        showLowConfidence: Bool? = nil,
        outputLanguage: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ClassifiedImages) -> Void)
    {
        // write parameters to JSON file
        let parameters = writeParameters(
            classifierIDs: classifierIDs,
            owners: owners,
            showLowConfidence: showLowConfidence
        )
        
        // classify images
        classify(
            image: image,
            parameters: parameters,
            outputLanguage: outputLanguage,
            failure: failure,
            success: success
        )
    }
    
    /**
     Classify images by uploading an image file and/or specifying image URLs.

     The supported image formats include .jpg, .png, and .gif. You can upload a single image or a
     compressed file (.zip) with multiple images to be classified. You can also specify one or more
     URLs of images to classify.
     
     - parameter image: The image file (.jpg, .png, or .gif) or compressed (.zip) file of images
            to classify. The total number of images is limited to 100.
     - parameter parameters: A JSON file containing optional input parameters. See the service
            documentation for more information on the supported parameters and their formatting.
     - parameter outputLanguage: The language of the output classifier (i.e. tag names). Can be
            "en" (English), "es" (Spanish), "ar" (Arabic), or "ja" (Japanese). Tags for which
            translations are not available are omitted.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the image classifications.
    */
    public func classify(
        image: URL? = nil,
        parameters: URL? = nil,
        outputLanguage: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ClassifiedImages) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct header parameters
        var headerParameters = defaultHeaders
        if let outputLanguage = outputLanguage {
            headerParameters["Accept-Language"] = outputLanguage
        }
        
        // construct REST request
        let request = RestRequest(
            method: .post,
            url: serviceURL + "/v3/classify",
            headerParameters: headerParameters,
            acceptType: "application/json",
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if let image = image {
                    multipartFormData.append(image, withName: "images_file")
                }
                if let parameters = parameters {
                    multipartFormData.append(parameters, withName: "parameters")
                }
            },
            with: request,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseObject() { (response: DataResponse<ClassifiedImages>) in
                        switch response.result {
                        case .success(let classifiedImages): success(classifiedImages)
                        case .failure(let error): failure?(error)
                        }
                    }
                case .failure:
                    let failureReason = "File(s) could not be encoded as form data."
                    let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }
            }
        )
    }
    
    /**
     Detect faces in images by URL. The supported image formats include .jpg, .png, and .gif.
 
     - parameter url: The URL of the image (.jpg, .png, or .gif). Redirects are followed, so it
            is safe to use with URL shorteners. The resolved URL is returned in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the detected faces.
     */
    public func detectFaces(
        url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ImagesWithFaces) -> Void)
    {
        let parameters = writeParameters(url: url)
        detectFaces(parameters: parameters, failure: failure, success: success)
    }

    /**
     Detect faces in the provided image(s), along with information about each face such as
     estimated age and gender.
     
     Images can be uploaded and/or specified by URL in a parameters file. If uploading images, you
     can upload a single image or a compressed file (.zip) with multiple images to be processed.
     The supported image formats include .jpg, .png, and .gif.
 
     - parameter image: The image file (.jpg, .png, or .gif) or compressed (.zip) file of images
            in which to detect faces. The total number of images is limited to 100.
     - parameter parameters: A JSON file containing optional input parameters. See the service
            documentation for more information on the supported parameters and their formatting.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the detected faces.
     */
    public func detectFaces(
        image: URL? = nil,
        parameters: URL? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ImagesWithFaces) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: .post,
            url: serviceURL + "/v3/detect_faces",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if let image = image {
                    multipartFormData.append(image, withName: "images_file")
                }
                if let parameters = parameters {
                    multipartFormData.append(parameters, withName: "parameters")
                }
            },
            with: request,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseObject() { (response: DataResponse<ImagesWithFaces>) in
                        switch response.result {
                        case .success(let faceImages): success(faceImages)
                        case .failure(let error): failure?(error)
                        }
                    }
                case .failure:
                    let failureReason = "File(s) could not be encoded as form data."
                    let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }
            }
        )
    }
    
    /**
     Recognize text in images by URL. The supported image formats include .jpg, .png, and .gif.
     
     - parameter url: The URL of the image (.jpg, .png, or .gif). Redirects are followed, so it
            is safe to use with URL shorteners. The resolved URL is returned in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the detected words.
     */
    public func recognizeText(
        url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ImagesWithWords) -> Void)
    {
        let parameters = writeParameters(url: url)
        recognizeText(parameters: parameters, failure: failure, success: success)
    }
    
    /**
     Recognize text in the provided image(s).
     
     Images can be uploaded and/or specified by URL in a parameters file. If uploading images, you
     can upload a single image or a compressed file (.zip) with multiple images to be processed.
     The supported image formats include .jpg, .png, and .gif.
     
     - parameter image: The image file (.jpg, .png, or .gif) or compressed (.zip) file of images
            in which to recognize text. The total number of images is limited to 100.
     - parameter parameters: A JSON file containing optional input parameters. See the service
            documentation for more information on the supported parameters and their formatting.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the detected words.
     */
    public func recognizeText(
        image: URL? = nil,
        parameters: URL? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ImagesWithWords) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: .post,
            url: serviceURL + "/v3/recognize_text",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if let image = image {
                    multipartFormData.append(image, withName: "images_file")
                }
                if let parameters = parameters {
                    multipartFormData.append(parameters, withName: "parameters")
                }
            },
            with: request,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseObject() { (response: DataResponse<ImagesWithWords>) in
                        switch response.result {
                        case .success(let wordImages): success(wordImages)
                        case .failure(let error): failure?(error)
                        }
                    }
                case .failure:
                    let failureReason = "File(s) could not be encoded as form data."
                    let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }
            }
        )
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
        showLowConfidence: Bool? = nil)
        -> URL
    {
        // construct JSON dictionary
        var json = [String: JSON]()
        if let url = url {
            json["url"] = JSON.string(url)
        }
        if let classifierIDs = classifierIDs {
            let ids_json = classifierIDs.map { id in JSON.string(id) }
            json["classifier_ids"] = JSON.array(ids_json)
        }
        if let owners = owners {
            let owners_json = owners.map { owner in JSON.string(owner) }
            json["owners"] = JSON.array(owners_json)
        }
        if let showLowConfidence = showLowConfidence {
            json["show_low_confidence"] = JSON.bool(showLowConfidence)
        }
        
        // create a globally unique file name in a temporary directory
        let suffix = "VisualRecognitionParameters.json"
        let fileName = String(format: "%@_%@", UUID().uuidString, suffix)
        let directoryURL = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let fileURL = directoryURL.appendingPathComponent(fileName)!
        
        // save JSON dictionary to file
        do {
            let data = try JSON.dictionary(json).serialize()
            try data.write(to: fileURL, options: .atomicWrite)
        } catch {
            // TODO: how to catch this?
        }
        
        return fileURL
    }
}
