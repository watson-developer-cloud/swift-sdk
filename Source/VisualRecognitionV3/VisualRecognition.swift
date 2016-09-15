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
    
    private let apiKey: String
    private let version: String
    private let serviceURL: String
    private let userAgent = buildUserAgent("watson-apis-ios-sdk/0.8.0 VisualRecognitionV3")
    private let domain = "com.ibm.watson.developer-cloud.VisualRecognitionV3"
    
    /**
     Create a `VisualRecognition` object.
 
     - parameter apiKey: The API key used to authenticate with the service.
     - parameter version: The release date of the version of the API to use. Specify the date in
        "YYYY-MM-DD" format.
     - parameter serviceURL: The base URL to use when contacting the service.
     */
    public init(
        apiKey: String,
        version: String,
        serviceURL: String = "https://gateway-a.watsonplatform.net/visual-recognition/api")
    {
        self.apiKey = apiKey
        self.version = version
        self.serviceURL = serviceURL
    }
    
    /**
     If the given data represents an error returned by the Visual Recognition service, then return
     an NSError with information about the error that occured. Otherwise, return nil.

     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func dataToError(data: NSData) -> NSError? {
        do {
            let json = try JSON(data: data)
            let imagesProcessed = try json.int("images_processed")
            let code = try json.int("error", "code")
            let error = try json.string("error", "error_id")
            let description = try json.string("error", "description")
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
        failure: (NSError -> Void)? = nil,
        success: [Classifier] -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "version", value: version))
        queryParameters.append(NSURLQueryItem(name: "verbose", value: "true"))
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v3/classifiers",
            acceptType: "application/json",
            userAgent: userAgent,
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .responseArray(dataToError: dataToError, path: ["classifiers"]) {
                (response: Response<[Classifier], NSError>) in
                switch response.result {
                case .Success(let classifiers): success(classifiers)
                case .Failure(let error): failure?(error)
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
        negativeExamples: NSURL? = nil,
        failure: (NSError -> Void)? = nil,
        success: Classifier -> Void)
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
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v3/classifiers",
            acceptType: "application/json",
            userAgent: userAgent,
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.upload(request,
            multipartFormData: { multipartFormData in
                for positiveExample in positiveExamples {
                    let name = positiveExample.name + "_positive_examples"
                    if let examples = positiveExample.examples {
                        multipartFormData.appendBodyPart(fileURL: examples, name: name)
                    }
                }
                if let negativeExamples = negativeExamples {
                    let examples = negativeExamples
                    let name = "negative_examples"
                    multipartFormData.appendBodyPart(fileURL: examples, name: name)
                }
                if let name = name.dataUsingEncoding(NSUTF8StringEncoding) {
                    multipartFormData.appendBodyPart(data: name, name: "name")
                }
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseObject(dataToError: self.dataToError) {
                        (response: Response<Classifier, NSError>) in
                        switch response.result {
                        case .Success(let classifier): success(classifier)
                        case .Failure(let error): failure?(error)
                        }
                    }
                case .Failure:
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
        failure: (NSError -> Void)? = nil,
        success: (Void -> Void)? = nil)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: .DELETE,
            url: serviceURL + "/v3/classifiers/\(classifierID)",
            userAgent: userAgent,
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .responseData { response in
                switch response.result {
                case .Success(let data):
                    switch self.dataToError(data) {
                    case .Some(let error): failure?(error)
                    case .None: success?()
                    }
                case .Failure(let error):
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
        failure: (NSError -> Void)? = nil,
        success: Classifier -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v3/classifiers/\(classifierID)",
            userAgent: userAgent,
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<Classifier, NSError>) in
                switch response.result {
                case .Success(let classifier): success(classifier)
                case .Failure(let error): failure?(error)
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
        negativeExamples: NSURL? = nil,
        failure: (NSError -> Void)? = nil,
        success: Classifier -> Void)
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
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v3/classifiers/\(classifierID)",
            acceptType: "application/json",
            userAgent: userAgent,
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.upload(request,
            multipartFormData: { multipartFormData in
                if let positiveExamples = positiveExamples {
                    for positiveExample in positiveExamples {
                        let name = positiveExample.name + "_positive_examples"
                        if let examples = positiveExample.examples {
                            multipartFormData.appendBodyPart(fileURL: examples, name: name)
                        }
                    }                    
                }
                if let negativeExamples = negativeExamples {
                    let examples = negativeExamples
                    let name = "negative_examples"
                    multipartFormData.appendBodyPart(fileURL: examples, name: name)
                }
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseObject(dataToError: self.dataToError) {
                        (response: Response<Classifier, NSError>) in
                        switch response.result {
                        case .Success(let classifier): success(classifier)
                        case .Failure(let error): failure?(error)
                        }
                    }
                case .Failure:
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
        failure: (NSError -> Void)? = nil,
        success: ClassifiedImages -> Void)
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
        image: NSURL,
        owners: [String]? = nil,
        classifierIDs: [String]? = nil,
        showLowConfidence: Bool? = nil,
        outputLanguage: String? = nil,
        failure: (NSError -> Void)? = nil,
        success: ClassifiedImages -> Void)
    {
        // write parameters to JSON file
        let parameters = writeParameters(
            classifierIDs: classifierIDs,
            owners: owners,
            showLowConfidence: showLowConfidence
        )
        
        // classify images
        classify(
            image,
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
        image: NSURL? = nil,
        parameters: NSURL? = nil,
        outputLanguage: String? = nil,
        failure: (NSError -> Void)? = nil,
        success: ClassifiedImages -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "version", value: version))
        
        // construct header parameters
        var headerParameters = [String: String]()
        if let outputLanguage = outputLanguage {
            headerParameters["Accept-Language"] = outputLanguage
        }
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v3/classify",
            acceptType: "application/json",
            userAgent: userAgent,
            queryParameters: queryParameters,
            headerParameters: headerParameters
        )
        
        // execute REST request
        Alamofire.upload(request,
            multipartFormData: { multipartFormData in
                if let image = image {
                    multipartFormData.appendBodyPart(fileURL: image, name: "images_file")
                }
                if let parameters = parameters {
                    multipartFormData.appendBodyPart(fileURL: parameters, name: "parameters")
                }
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseObject(dataToError: self.dataToError) {
                        (response: Response<ClassifiedImages, NSError>) in
                        switch response.result {
                        case .Success(let classifiedImages): success(classifiedImages)
                        case .Failure(let error): failure?(error)
                        }
                    }
                case .Failure:
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
        failure: (NSError -> Void)? = nil,
        success: ImagesWithFaces -> Void)
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
        image: NSURL? = nil,
        parameters: NSURL? = nil,
        failure: (NSError -> Void)? = nil,
        success: ImagesWithFaces -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v3/detect_faces",
            acceptType: "application/json",
            userAgent: userAgent,
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.upload(request,
            multipartFormData: { multipartFormData in
                if let image = image {
                    multipartFormData.appendBodyPart(fileURL: image, name: "images_file")
                }
                if let parameters = parameters {
                    multipartFormData.appendBodyPart(fileURL: parameters, name: "parameters")
                }
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseObject(dataToError: self.dataToError) {
                        (response: Response<ImagesWithFaces, NSError>) in
                        switch response.result {
                        case .Success(let faceImages): success(faceImages)
                        case .Failure(let error): failure?(error)
                        }
                    }
                case .Failure:
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
        failure: (NSError -> Void)? = nil,
        success: ImagesWithWords -> Void)
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
        image: NSURL? = nil,
        parameters: NSURL? = nil,
        failure: (NSError -> Void)? = nil,
        success: ImagesWithWords -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v3/recognize_text",
            acceptType: "application/json",
            userAgent: userAgent,
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.upload(request,
            multipartFormData: { multipartFormData in
                if let image = image {
                    multipartFormData.appendBodyPart(fileURL: image, name: "images_file")
                }
                if let parameters = parameters {
                    multipartFormData.appendBodyPart(fileURL: parameters, name: "parameters")
                }
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseObject(dataToError: self.dataToError) {
                        (response: Response<ImagesWithWords, NSError>) in
                        switch response.result {
                        case .Success(let wordImages): success(wordImages)
                        case .Failure(let error): failure?(error)
                        }
                    }
                case .Failure:
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
        url url: String? = nil,
        classifierIDs: [String]? = nil,
        owners: [String]? = nil,
        showLowConfidence: Bool? = nil)
        -> NSURL
    {
        // construct JSON dictionary
        var json = [String: JSON]()
        if let url = url {
            json["url"] = JSON.String(url)
        }
        if let classifierIDs = classifierIDs {
            let ids_json = classifierIDs.map { id in JSON.String(id) }
            json["classifier_ids"] = JSON.Array(ids_json)
        }
        if let owners = owners {
            let owners_json = owners.map { owner in JSON.String(owner) }
            json["owners"] = JSON.Array(owners_json)
        }
        if let showLowConfidence = showLowConfidence {
            json["show_low_confidence"] = JSON.Bool(showLowConfidence)
        }
        
        // create a globally unique file name in a temporary directory
        let suffix = "VisualRecognitionParameters.json"
        let fileName = String(format: "%@_%@", NSUUID().UUIDString, suffix)
        let directoryURL = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let fileURL = directoryURL.URLByAppendingPathComponent(fileName)!
        
        // save JSON dictionary to file
        do {
            let data = try JSON.Dictionary(json).serialize()
            try data.writeToURL(fileURL, options: .AtomicWrite)
        } catch {
            // TODO: how to catch this?
        }
        
        return fileURL
    }
}
