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
 AlchemyVision is an API that can analyze an image and return the objects, people, and text
 found within the image. AlchemyVision can enhance the way businesses make decisions by
 integrating image cognition.
 */
public class AlchemyVision {
    
    private let apiKey: String
    private let domain = "com.ibm.watson.developer-cloud.WatsonDeveloperCloud"
    private let serviceURL = "http://gateway-a.watsonplatform.net/calls"

    /**
     Create an `AlchemyVision` object.

     - parameter apiKey: The API key credential to use when authenticating with the service.
     */
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // TODO: dataToError

    // TODO: POST /image/ImageGetRankedImageFaceTags

    /**
     Perform face recognition on the primary image at a given URL. For each face detected,
     the service returns the estimated bounding box, gender, age, and name (if a celebrity
     is detected).

     - parameter url: The URL at which to perform face recognition.
     - knowledgeGraph: Should additional metadata be provided for detected celebrities?
     - failure: A function executed if an error occurs.
     - success: A function executed with information about the detected faces.
     */
    public func getRankedImageFaceTags(
        url: String,
        knowledgeGraph: Bool? = nil,
        failure: (NSError -> Void)? = nil,
        success: [FaceTags] -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "url", value: url))
        queryParameters.append(NSURLQueryItem(name: "apiKey", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "outputMode", value: "json"))
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
            queryParameters: queryParameters
        )

        // execute REST request
        Alamofire.request(request)
            .responseArray { (response: Response<[FaceTags], NSError>) in
                switch response.result {
                case .Success(let faceTags): success(faceTags)
                case .Failure(let error): failure?(error)
                }
            }
    }

    /**
     Identify the primary image in an HTML document.

     - parameter html: The HTML document that shall be analyzed to identify the primary image.
     - parameter url: The HTML document's URL, for response-tracking purposes.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the identified primary image.
     */
    public func getImage(
        html: String,
        url: String,
        failure: (NSError -> Void)? = nil,
        success: [ImageLink] -> Void)
    {
        // TODO: convert this function to use POST /html/HTMLGetImage instead.

        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "html", value: html))
        queryParameters.append(NSURLQueryItem(name: "url", value: url))
        queryParameters.append(NSURLQueryItem(name: "apiKey", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "outputMode", value: "json"))

        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/html/HTMLGetImage",
            acceptType: "application/json",
            queryParameters: queryParameters
        )

        // execute REST request
        Alamofire.request(request)
            .responseArray { (response: Response<[ImageLink], NSError>) in
                switch response.result {
                case .Success(let imageLinks): success(imageLinks)
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
        url: String,
        failure: (NSError -> Void)? = nil,
        success: [ImageLink] -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "url", value: url))
        queryParameters.append(NSURLQueryItem(name: "apiKey", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "outputMode", value: "json"))

        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/url/URLGetImage",
            acceptType: "application/json",
            queryParameters: queryParameters
        )

        // execute REST request
        Alamofire.request(request)
            .responseArray { (response: Response<[ImageLink], NSError>) in
                switch response.result {
                case .Success(let imageLinks): success(imageLinks)
                case .Failure(let error): failure?(error)
                }
            }
    }

    // TODO: POST /image/ImageGetRankedImageKeywords

    /**
     Tag the primary image at a given URL.

     - parameter url: The URL at which to perform image tagging.
     - parameter forceShowAll: Should lower confidence tags be included in the response?
     - parameter knowledgeGraph: Should additional metadata be provided for detected celebrities?
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the identified tags.
     */
    public func getRankedImageKeywords(
        url: String,
        forceShowAll: Bool? = nil,
        knowledgeGraph: Bool? = nil,
        failure: (NSError -> Void)? = nil,
        success: ImageKeywords -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "url", value: url))
        queryParameters.append(NSURLQueryItem(name: "apiKey", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "outputMode", value: "json"))
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
            queryParameters: queryParameters
        )

        // execute REST request
        Alamofire.request(request)
            .responseObject { (response: Response<ImageKeywords, NSError>) in
                switch response.result {
                case .Success(let imageKeywords): success(imageKeywords)
                case .Failure(let error): failure?(error)
                }
            }
    }

    // TODO: POST /image/ImageGetRankedImageSceneText

    /**
     Identify text in the primary image at a given URL.

     - parameter url: The URL at which to perform text detection.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the detected text.
     */
    public func getRankedImageSceneText(
        url: String,
        failure: (NSError -> Void)? = nil,
        success: [SceneText] -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        queryParameters.append(NSURLQueryItem(name: "url", value: url))
        queryParameters.append(NSURLQueryItem(name: "apiKey", value: apiKey))
        queryParameters.append(NSURLQueryItem(name: "outputMode", value: "json"))

        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/url/URLGetRankedImageKeywords",
            acceptType: "application/json",
            queryParameters: queryParameters
        )

        // execute REST requeset
        Alamofire.request(request)
            .responseArray { (response: Response<[SceneText], NSError>) in
                switch response.result {
                case .Success(let sceneTexts): success(sceneTexts)
                case .Failure(let error): failure?(error)
                }
            }
    }
}
