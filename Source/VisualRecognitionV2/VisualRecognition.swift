/**
 * Copyright IBM Corporation 2015
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

/**
 The IBM Watson Visual Recognition service uses deep learning algorithms to analyze images,
 identify scenes, objects, faces, text, and other content, and return keywords that provide
 information about that content.
 */
public class VisualRecognition {
    
    private let apiKey: String
    private let version: String
    private let domain = "com.ibm.watson.developer-cloud.WatsonDeveloperCloud"
    private let serviceURL = "https://gateway.watsonplatform.net/visual-recognition/api/v2"
    
    public init(apiKey: String, version: String) {
        self.apiKey = apiKey
        self.version = version
    }
    
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
    
    public func getClassifiers(
        verbose: Bool? = nil,
        failure: (NSError -> Void)? = nil,
        success: ClassifierBrief -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "version", value: version))
        if let verbose = verbose {
            queryParameters.append(NSURLQueryItem(name: "true", value: "\(verbose)"))
        }
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/classifiers",
            acceptType: "application/json",
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<ClassifierBrief, NSError>) in
                switch response.result {
                case .Success(let classifierBrief): success(classifierBrief)
                case .Failure(let error): failure?(error)
                }
        }
    }
    
    public func createClassifier(
        name: String,
        positiveExamples: [PositiveExamples],
        negativeExamples: NSURL? = nil,
        failure: (NSError -> Void)? = nil,
        success: ClassifierVerbose -> Void)
    {
        // ensure requisite examples were provided
        let twoOrMoreClasses = (positiveExamples.count >= 2)
        let positiveAndNegative = (positiveExamples.count >= 1 && negativeExamples != nil)
        guard twoOrMoreClasses || positiveAndNegative else {
            let failureReason = "To create a classifier, you must supply at least 2 zip files" +
                                "—either two positive example sets or 1 positive and 1 negative" +
                                "set."
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
            url: serviceURL + "/classifiers",
            acceptType: "application/json",
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.upload(request,
            multipartFormData: { multipartFormData in
                for positiveExample in positiveExamples {
                    let examples = positiveExample.examples
                    let name = positiveExample.name + "_positive_examples"
                    multipartFormData.appendBodyPart(fileURL: examples, name: name)
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
                        (response: Response<ClassifierVerbose, NSError>) in
                        switch response.result {
                        case .Success(let classifierVerbose): success(classifierVerbose)
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
            url: "/classifiers/\(classifierID)",
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
    
    public func getClassifier(
        classifierID: String,
        failure: (NSError -> Void)? = nil,
        success: ClassifierVerbose -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: "/classifiers/\(classifierID)",
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<ClassifierVerbose, NSError>) in
                switch response.result {
                case .Success(let classifierVerbose): success(classifierVerbose)
                case .Failure(let error): failure?(error)
                }
            }
    }
    
    public func classify(
        url url: String,
        owners: [String]? = nil,
        classifierIDs: [String]? = nil,
        showLowConfidence: Bool? = nil,
        outputLanguage: String? = nil,
        failure: (NSError -> Void)? = nil,
        success: ClassifiedImages -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "version", value: version))
        queryParameters.append(NSURLQueryItem(name: "url", value: url))
        if let owners = owners {
            let value = owners.joinWithSeparator(",")
            queryParameters.append(NSURLQueryItem(name: "owners", value: value))
        }
        if let classifierIDs = classifierIDs {
            let value = classifierIDs.joinWithSeparator(",")
            queryParameters.append(NSURLQueryItem(name: "classifier_ids", value: value))
        }
        if let showLowConfidence = showLowConfidence {
            let value = "\(showLowConfidence)"
            queryParameters.append(NSURLQueryItem(name: "show_low_confidence", value: value))
        }
        
        // construct header parameters
        var headerParameters = [String: String]()
        if let outputLanguage = outputLanguage {
            headerParameters["Accept-Language"] = outputLanguage
        }
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: "/classify",
            acceptType: "application/json",
            queryParameters: queryParameters,
            headerParameters: headerParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<ClassifiedImages, NSError>) in
                switch response.result {
                case .Success(let classifiedImages): success(classifiedImages)
                case .Failure(let error): failure?(error)
                }
            }
    }
    
    // TODO: add convenience function that writes parameters as JSON file then calls classify?
    // TODO: maybe also write a convenicne function that writes a JSON file?
    
    public func classify(
        images images: NSURL,
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
            url: "/classify",
            acceptType: "application/json",
            queryParameters: queryParameters,
            headerParameters: headerParameters
        )
        
        // execute REST request
        Alamofire.upload(request,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: images, name: "images_file")
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
    
    public func detectFaces(
        url url: String,
        failure: (NSError -> Void)? = nil,
        success: FaceImages -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "version", value: version))
        queryParameters.append(NSURLQueryItem(name: "url", value: url))
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: "/detect_faces",
            acceptType: "application/json",
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<FaceImages, NSError>) in
                switch response.result {
                case .Success(let faceImages): success(faceImages)
                case .Failure(let error): failure?(error)
                }
            }
    }
    
    // TODO: add convenience function that writes parameters as JSON file then calls classify?
    
    public func detectFaces(
        images images: NSURL,
        parameters: NSURL? = nil,
        failure: (NSError -> Void)? = nil,
        success: FaceImages -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: "/detect_faces",
            acceptType: "application/json",
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.upload(request,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: images, name: "images_file")
                if let parameters = parameters {
                    multipartFormData.appendBodyPart(fileURL: parameters, name: "parameters")
                }
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseObject(dataToError: self.dataToError) {
                        (response: Response<FaceImages, NSError>) in
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
    
    public func recognizeText(
        url url: String,
        failure: (NSError -> Void)? = nil,
        success: WordImages -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "version", value: version))
        queryParameters.append(NSURLQueryItem(name: "url", value: url))
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: "/recognize_text",
            acceptType: "application/json",
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) {
                (response: Response<WordImages, NSError>) in
                switch response.result {
                case .Success(let wordImages): success(wordImages)
                case .Failure(let error): failure?(error)
                }
        }
    }
    
    // TODO: add convenience function that writes parameters as JSON file then calls classify?
    
    public func detectFaces(
        images images: NSURL,
        parameters: NSURL? = nil,
        failure: (NSError -> Void)? = nil,
        success: WordImages -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "version", value: version))
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: "/recognize_text",
            acceptType: "application/json",
            queryParameters: queryParameters
        )
        
        // execute REST request
        Alamofire.upload(request,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: images, name: "images_file")
                if let parameters = parameters {
                    multipartFormData.appendBodyPart(fileURL: parameters, name: "parameters")
                }
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseObject(dataToError: self.dataToError) {
                        (response: Response<WordImages, NSError>) in
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
}
