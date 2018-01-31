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

/**
 AlchemyVision is an API that can analyze an image and return the objects, people, and text
 found within the image. AlchemyVision can enhance the way businesses make decisions by
 integrating image cognition.
 */
@available(*, deprecated, message: "Its functionality became a part of the IBM Watson Visual Recognition service.")
public class AlchemyVision {

    /// The base URL to use when contacting the service.
    public var serviceURL = "http://gateway-a.watsonplatform.net/calls"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    /// The API key credential to use when authenticating with the service.
    private let apiKey: String

    private let domain = "com.ibm.watson.developer-cloud.AlchemyVisionV1"
    private let unreservedCharacters = CharacterSet(charactersIn:
        "abcdefghijklmnopqrstuvwxyz" + "ABCDEFGHIJKLMNOPQRSTUVWXYZ" + "1234567890-._~")

    /**
     Create an `AlchemyVision` object.

     - parameter apiKey: The API key credential to use when authenticating with the service.
     */
    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    /**
     If the response or data represents an error returned by the AlchemyVision service,
     then return NSError with information about the error that occured. Otherwise, return nil.

     - parameter response: the URL response returned from the service.
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func responseToError(response: HTTPURLResponse?, data: Data?) -> NSError? {

        // Typically, we would check the http status code in the response object here, and return
        // `nil` if the status code is successful (200 <= statusCode < 300). However, the Alchemy
        // services return a status code of 200 if you are able to successfully contact the
        // service, without regards to whether the response itself was a success or a failure.

        // ensure data is not nil
        guard let data = data else {
            if let code = response?.statusCode {
                return NSError(domain: domain, code: code, userInfo: nil)
            }
            return nil  // RestKit will generate error for this case
        }

        do {
            let json = try JSONWrapper(data: data)
            let code = 400
            let status = try json.getString(at: "status")
            let statusInfo = try json.getString(at: "statusInfo")
            let userInfo = [
                NSLocalizedFailureReasonErrorKey: status,
                NSLocalizedDescriptionKey: statusInfo
            ]
            return NSError(domain: domain, code: code, userInfo: userInfo)
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
        fromImage imageData: Data,
        knowledgeGraph: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (FaceTags) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParameters.append(URLQueryItem(name: "outputMode", value: "json"))
        queryParameters.append(URLQueryItem(name: "imagePostMode", value: "raw"))
        if let knowledgeGraph = knowledgeGraph {
            if knowledgeGraph {
                queryParameters.append(URLQueryItem(name: "knowledgeGraph", value: "1"))
            } else {
                queryParameters.append(URLQueryItem(name: "knowledgeGraph", value: "0"))
            }
        }

        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/image/ImageGetRankedImageFaceTags",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParameters,
            messageBody: imageData
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<FaceTags>) in
            switch response.result {
            case .success(let faceTags): success(faceTags)
            case .failure(let error): failure?(error)
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
        fromImageAtURL url: String,
        knowledgeGraph: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (FaceTags) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParameters.append(URLQueryItem(name: "outputMode", value: "json"))
        queryParameters.append(URLQueryItem(name: "url", value: url))
        if let knowledgeGraph = knowledgeGraph {
            if knowledgeGraph {
                queryParameters.append(URLQueryItem(name: "knowledgeGraph", value: "1"))
            } else {
                queryParameters.append(URLQueryItem(name: "knowledgeGraph", value: "0"))
            }
        }

        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/url/URLGetRankedImageFaceTags",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<FaceTags>) in
            switch response.result {
            case .success(let faceTags): success(faceTags)
            case .failure(let error): failure?(error)
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
        fromHTMLFile html: URL,
        withURL url: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ImageLink) -> Void)
    {
        guard let html = try? String(contentsOf: html) else {
            let failureReason = "Failed to read the HTML file."
            let userInfo = [NSLocalizedDescriptionKey: failureReason]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        getImage(fromHTML: html, withURL: url, failure: failure, success: success)
    }

    /**
     Identify the primary image in an HTML document.

     - parameter html: The HTML document that shall be analyzed to identify the primary image.
     - parameter url: The HTML document's URL, for response-tracking purposes.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the identified primary image.
     */
    public func getImage(
        fromHTML html: String,
        withURL url: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ImageLink) -> Void)
    {
        // encode html document
        guard let htmlEncoded = html.addingPercentEncoding(withAllowedCharacters: unreservedCharacters) else {
            let failureReason = "Failed to percent encode HTML document."
            let userInfo = [NSLocalizedDescriptionKey: failureReason]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        // construct body
        guard let body = "html=\(htmlEncoded)".data(using: String.Encoding.utf8) else {
            let failureReason = "Failed to construct body with HTML document."
            let userInfo = [NSLocalizedDescriptionKey: failureReason]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParameters.append(URLQueryItem(name: "outputMode", value: "json"))
        if let url = url {
            queryParameters.append(URLQueryItem(name: "url", value: url))
        }

        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/html/HTMLGetImage",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<ImageLink>) in
            switch response.result {
            case .success(let imageLinks): success(imageLinks)
            case .failure(let error): failure?(error)
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
        fromURL url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ImageLink) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParameters.append(URLQueryItem(name: "outputMode", value: "json"))
        queryParameters.append(URLQueryItem(name: "url", value: url))

        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/url/URLGetImage",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<ImageLink>) in
            switch response.result {
            case .success(let imageLinks): success(imageLinks)
            case .failure(let error): failure?(error)
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
        fromImage imageData: Data,
        forceShowAll: Bool? = nil,
        knowledgeGraph: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ImageKeywords) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParameters.append(URLQueryItem(name: "outputMode", value: "json"))
        queryParameters.append(URLQueryItem(name: "imagePostMode", value: "raw"))
        if let forceShowAll = forceShowAll {
            if forceShowAll {
                queryParameters.append(URLQueryItem(name: "forceShowAll", value: "1"))
            } else {
                queryParameters.append(URLQueryItem(name: "forceShowAll", value: "0"))
            }
        }
        if let knowledgeGraph = knowledgeGraph {
            if knowledgeGraph {
                queryParameters.append(URLQueryItem(name: "knowledgeGraph", value: "1"))
            } else {
                queryParameters.append(URLQueryItem(name: "knowledgeGraph", value: "0"))
            }
        }

        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/image/ImageGetRankedImageKeywords",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParameters,
            messageBody: imageData
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<ImageKeywords>) in
            switch response.result {
            case .success(let imageKeywords): success(imageKeywords)
            case .failure(let error): failure?(error)
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
        fromImageAtURL url: String,
        forceShowAll: Bool? = nil,
        knowledgeGraph: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ImageKeywords) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParameters.append(URLQueryItem(name: "outputMode", value: "json"))
        queryParameters.append(URLQueryItem(name: "url", value: url))
        if let forceShowAll = forceShowAll {
            if forceShowAll {
                queryParameters.append(URLQueryItem(name: "forceShowAll", value: "1"))
            } else {
                queryParameters.append(URLQueryItem(name: "forceShowAll", value: "0"))
            }
        }
        if let knowledgeGraph = knowledgeGraph {
            if knowledgeGraph {
                queryParameters.append(URLQueryItem(name: "knowledgeGraph", value: "1"))
            } else {
                queryParameters.append(URLQueryItem(name: "knowledgeGraph", value: "0"))
            }
        }

        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/url/URLGetRankedImageKeywords",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) { (response: RestResponse<ImageKeywords>) in
            switch response.result {
            case .success(let imageKeywords): success(imageKeywords)
            case .failure(let error): failure?(error)
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
        fromImage imageData: Data,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SceneText) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParameters.append(URLQueryItem(name: "outputMode", value: "json"))
        queryParameters.append(URLQueryItem(name: "imagePostMode", value: "raw"))

        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/url/URLGetRankedImageSceneText",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/x-www-form-urlencoded",
            queryItems: queryParameters,
            messageBody: imageData
        )

        // execute REST requeset
        request.responseObject(responseToError: responseToError) { (response: RestResponse<SceneText>) in
            switch response.result {
            case .success(let sceneTexts): success(sceneTexts)
            case .failure(let error): failure?(error)
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
        fromImageAtURL url: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SceneText) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "apikey", value: apiKey))
        queryParameters.append(URLQueryItem(name: "outputMode", value: "json"))
        queryParameters.append(URLQueryItem(name: "url", value: url))

        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/url/URLGetRankedImageSceneText",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: queryParameters
        )

        // execute REST requeset
        request.responseObject(responseToError: responseToError) { (response: RestResponse<SceneText>) in
            switch response.result {
            case .success(let sceneTexts): success(sceneTexts)
            case .failure(let error): failure?(error)
            }
        }
    }
}
