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
 AlchemyVision is an API that can analyze an image and return the objects, people, and text
 found within the image. AlchemyVision can enhance the way businesses make decisions by
 integrating image cognition.
 */
@available(*, deprecated, message="Its functionality became a part of the IBM Watson Visual Recognition service.")
public class AlchemyVision {
    
    private let apiKey: String
    private let serviceURL: String
    private let userAgent = buildUserAgent("watson-apis-ios-sdk/0.6.0 AlchemyVisionV1")
    private let domain = "com.ibm.watson.developer-cloud.AlchemyVisionV1"
    private let unreservedCharacters = NSCharacterSet(charactersInString:
        "abcdefghijklmnopqrstuvwxyz" + "ABCDEFGHIJKLMNOPQRSTUVWXYZ" + "1234567890-._~")

    /**
     Create an `AlchemyVision` object.

     - parameter apiKey: The API key credential to use when authenticating with the service.
     - parameter serviceURL: The base URL to use when contacting the service.
     */
    public init(
        apiKey: String,
        serviceURL: String = "http://gateway-a.watsonplatform.net/calls")
    {
        self.apiKey = apiKey
        self.serviceURL = serviceURL
    }
    
    /**
     If the given data represents an error returned by the Alchemy Vision service, then return
     an NSError with information about the error that occured. Otherwise, return nil.
     
     - parameter data: Raw data returned from the service that may represent an error.
     */
    
    private func dataToError(data: NSData) -> NSError? {
        do {
            let json = try JSON(data: data)
            let status = try json.string("status")
            let statusInfo = try json.string("statusInfo")
            if status == "OK" {
                return nil
            } else {
                let userInfo = [
                    NSLocalizedFailureReasonErrorKey: status,
                    NSLocalizedDescriptionKey: statusInfo
                ]
                return NSError(domain: domain, code: 400, userInfo: userInfo)
            }
        } catch {
            return nil
        }
    }

    /**
     Perform face recognition on an uploaded image. For each face detected, the service returns
     the estimated bounding box, gender, age, and name (if a celebrity is detected).
 
     - parameter image: The data representation of the image file on which to perform face recognition.
     - parameter knowledgeGraph: Should additional metadata be provided for detected celebrities?
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the detected faces.
     */
    public func getRankedImageFaceTags(
        image imageData: NSData,
        knowledgeGraph: Bool? = nil,
        failure: (NSError -> Void)? = nil,
        success: FaceTags -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "outputMode", value: "json"))
        queryParameters.append(NSURLQueryItem(name: "imagePostMode", value: "raw"))
        if let knowledgeGraph = knowledgeGraph {
            if knowledgeGraph {
                queryParameters.append(NSURLQueryItem(name: "knowledgeGraph", value: "1"))
            } else {
                queryParameters.append(NSURLQueryItem(name: "knowledgeGraph", value: "0"))
            }
        }
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/image/ImageGetRankedImageFaceTags",
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParameters,
            messageBody: imageData
        )
        
        // execute REST request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) { (response: Response<FaceTags, NSError>) in
                switch response.result {
                case .Success(let faceTags): success(faceTags)
                case .Failure(let error): failure?(error)
                }
            }
    }

    /**
     Perform face recognition on the primary image at a given URL. For each face detected,
     the service returns the estimated bounding box, gender, age, and name (if a celebrity
     is detected).

     - parameter url: The URL at which to perform face recognition.
     - parameter knowledgeGraph: Should additional metadata be provided for detected celebrities?
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the detected faces.
     */
    public func getRankedImageFaceTags(
        url url: String,
        knowledgeGraph: Bool? = nil,
        failure: (NSError -> Void)? = nil,
        success: FaceTags -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "outputMode", value: "json"))
        queryParameters.append(NSURLQueryItem(name: "url", value: url))
        if let knowledgeGraph = knowledgeGraph {
            if knowledgeGraph {
                queryParameters.append(NSURLQueryItem(name: "knowledgeGraph", value: "1"))
            } else {
                queryParameters.append(NSURLQueryItem(name: "knowledgeGraph", value: "0"))
            }
        }

        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/url/URLGetRankedImageFaceTags",
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParameters
        )

        // execute REST request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) { (response: Response<FaceTags, NSError>) in
                switch response.result {
                case .Success(let faceTags): success(faceTags)
                case .Failure(let error): failure?(error)
                }
            }
    }

    /**
     Identify the primary image in an HTML file.
     
     - parameter html: The HTML file that shall be analyzed to identify the primary image.
     - parameter url: The HTML file's URL, for response-tracking purposes.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the identified primary image.
     */
    public func getImage(
        html html: NSURL,
        url: String? = nil,
        failure: (NSError -> Void)? = nil,
        success: ImageLink -> Void)
    {
        guard let html = try? String(contentsOfURL: html) else {
            let failureReason = "Failed to read the HTML file."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        getImage(html: html, url: url, failure: failure, success: success)
    }
    
    /**
     Identify the primary image in an HTML document.

     - parameter html: The HTML document that shall be analyzed to identify the primary image.
     - parameter url: The HTML document's URL, for response-tracking purposes.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the identified primary image.
     */
    public func getImage(
        html html: String,
        url: String? = nil,
        failure: (NSError -> Void)? = nil,
        success: ImageLink -> Void)
    {
        // encode html document
        guard let htmlEncoded = html.stringByAddingPercentEncodingWithAllowedCharacters(unreservedCharacters) else {
            let failureReason = "Failed to percent encode HTML document."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct body
        guard let body = "html=\(htmlEncoded)".dataUsingEncoding(NSUTF8StringEncoding) else {
            let failureReason = "Failed to construct body with HTML document."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "outputMode", value: "json"))
        if let url = url {
            queryParameters.append(NSURLQueryItem(name: "url", value: url))
        }

        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/html/HTMLGetImage",
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParameters,
            messageBody: body
        )

        // execute REST request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) { (response: Response<ImageLink, NSError>) in
                switch response.result {
                case.Success(let imageLinks): success(imageLinks)
                case .Failure(let error): failure?(error)
                }
            }
    }

    /**
     Identify the primary image at a given URL.

     - parameter url: The URL of a webpage on which the primary image shall be identified.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the identified primary image.
     */
    public func getImage(
        url url: String,
        failure: (NSError -> Void)? = nil,
        success: ImageLink -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "outputMode", value: "json"))
        queryParameters.append(NSURLQueryItem(name: "url", value: url))

        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/url/URLGetImage",
            acceptType: "application/json",
            userAgent: userAgent,
            queryParameters: queryParameters
        )

        // execute REST request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) { (response: Response<ImageLink, NSError>) in
                switch response.result {
                case .Success(let imageLinks): success(imageLinks)
                case .Failure(let error): failure?(error)
                }
            }
    }
    
    /**
     Perform image tagging on an uploaded image.
 
     - parameter image: The data representation of the image file on which to perform face recognition.
     - parameter forceShowAll: Should lower confidence tags be included in the response?
     - parameter knowledgeGraph: Should hierarchical metadata be provided for each tag?
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the identified tags.
     */
    public func getRankedImageKeywords(
        image imageData: NSData,
        forceShowAll: Bool? = nil,
        knowledgeGraph: Bool? = nil,
        failure: (NSError -> Void)? = nil,
        success: ImageKeywords -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "outputMode", value: "json"))
        queryParameters.append(NSURLQueryItem(name: "imagePostMode", value: "raw"))
        if let forceShowAll = forceShowAll {
            if forceShowAll {
                queryParameters.append(NSURLQueryItem(name: "forceShowAll", value: "1"))
            } else {
                queryParameters.append(NSURLQueryItem(name: "forceShowAll", value: "0"))
            }
        }
        if let knowledgeGraph = knowledgeGraph {
            if knowledgeGraph {
                queryParameters.append(NSURLQueryItem(name: "knowledgeGraph", value: "1"))
            } else {
                queryParameters.append(NSURLQueryItem(name: "knowledgeGraph", value: "0"))
            }
        }
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/image/ImageGetRankedImageKeywords",
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParameters,
            messageBody: imageData
        )
        
        // execute REST request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) { (response: Response<ImageKeywords, NSError>) in
                switch response.result {
                case .Success(let imageKeywords): success(imageKeywords)
                case .Failure(let error): failure?(error)
                }
        }
    }

    /**
     Perform image tagging on the primary image at a given URL.

     - parameter url: The URL at which to perform image tagging.
     - parameter forceShowAll: Should lower confidence tags be included in the response?
     - parameter knowledgeGraph: Should hierarchical metadata be provided for each tag?
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the identified tags.
     */
    public func getRankedImageKeywords(
        url url: String,
        forceShowAll: Bool? = nil,
        knowledgeGraph: Bool? = nil,
        failure: (NSError -> Void)? = nil,
        success: ImageKeywords -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "outputMode", value: "json"))
        queryParameters.append(NSURLQueryItem(name: "url", value: url))
        if let forceShowAll = forceShowAll {
            if forceShowAll {
                queryParameters.append(NSURLQueryItem(name: "forceShowAll", value: "1"))
            } else {
                queryParameters.append(NSURLQueryItem(name: "forceShowAll", value: "0"))
            }
        }
        if let knowledgeGraph = knowledgeGraph {
            if knowledgeGraph {
                queryParameters.append(NSURLQueryItem(name: "knowledgeGraph", value: "1"))
            } else {
                queryParameters.append(NSURLQueryItem(name: "knowledgeGraph", value: "0"))
            }
        }

        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/url/URLGetRankedImageKeywords",
            acceptType: "application/json",
            userAgent: userAgent,
            queryParameters: queryParameters
        )

        // execute REST request
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) { (response: Response<ImageKeywords, NSError>) in
                switch response.result {
                case .Success(let imageKeywords): success(imageKeywords)
                case .Failure(let error): failure?(error)
                }
            }
    }
    
    /**
     Identify text in an uploaded image.
 
     - parameter image: The data representation of the image file on which to perform text detection.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the detected text.
     */
    public func getRankedImageSceneText(
        image imageData: NSData,
        failure: (NSError -> Void)? = nil,
        success: SceneText -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "outputMode", value: "json"))
        queryParameters.append(NSURLQueryItem(name: "imagePostMode", value: "raw"))

        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/url/URLGetRankedImageSceneText",
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            userAgent: userAgent,
            queryParameters: queryParameters,
            messageBody: imageData
        )
        
        // execute REST requeset
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) { (response: Response<SceneText, NSError>) in
                switch response.result {
                case .Success(let sceneTexts): success(sceneTexts)
                case .Failure(let error): failure?(error)
                }
        }
    }

    /**
     Identify text in the primary image at a given URL.

     - parameter url: The URL at which to perform text detection.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the detected text.
     */
    public func getRankedImageSceneText(
        url url: String,
        failure: (NSError -> Void)? = nil,
        success: SceneText -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "apikey", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "outputMode", value: "json"))
        queryParameters.append(NSURLQueryItem(name: "url", value: url))

        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/url/URLGetRankedImageSceneText",
            acceptType: "application/json",
            userAgent: userAgent,
            queryParameters: queryParameters
        )

        // execute REST requeset
        Alamofire.request(request)
            .responseObject(dataToError: dataToError) { (response: Response<SceneText, NSError>) in
                switch response.result {
                case .Success(let sceneTexts): success(sceneTexts)
                case .Failure(let error): failure?(error)
                }
            }
    }
}
