/**
 * (C) Copyright IBM Corp. 2019, 2020.
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
 Provide images to the IBM Watson&trade; Visual Recognition service for analysis. The service detects objects based on a
 set of images with training data.
 */
public class VisualRecognition {

    /// The base URL to use when contacting the service.
    public var serviceURL: String? = "https://gateway.watsonplatform.net/visual-recognition/api"

    /// Service identifiers
    internal let serviceName = "WatsonVisionCombined"
    internal let serviceVersion = "v4"
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
     Use the HTTP response and data received by the Visual Recognition v4 service to extract
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
     Analyze images.

     Analyze images by URL, by file, or both against your own collection. Make sure that
     **training_status.objects.ready** is `true` for the feature before you use a collection to analyze images.
     Encode the image and .zip file names in UTF-8 if they contain non-ASCII characters. The service assumes UTF-8
     encoding if it encounters non-ASCII characters.

     - parameter collectionIDs: The IDs of the collections to analyze.
     - parameter features: The features to analyze.
     - parameter imagesFile: An array of image files (.jpg or .png) or .zip files with images.
       - Include a maximum of 20 images in a request.
       - Limit the .zip file to 100 MB.
       - Limit each image file to 10 MB.
       You can also include an image with the **image_url** parameter.
     - parameter imageURL: An array of URLs of image files (.jpg or .png).
       - Include a maximum of 20 images in a request.
       - Limit each image file to 10 MB.
       - Minimum width and height is 30 pixels, but the service tends to perform better with images that are at least
       300 x 300 pixels. Maximum is 5400 pixels for either height or width.
       You can also include images with the **images_file** parameter.
     - parameter threshold: The minimum score a feature must have to be returned.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func analyze(
        collectionIDs: [String],
        features: [String],
        imagesFile: [FileWithMetadata]? = nil,
        imageURL: [String]? = nil,
        threshold: Double? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<AnalyzeResponse>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()

        // HAND EDIT: join collectionIDs into CSV string
        if let csvCollectionIDsData = collectionIDs.joined(separator: ",").data(using: .utf8) {
            multipartFormData.append(csvCollectionIDsData, withName: "collection_ids")
        }

        // HAND EDIT: join features into CSV string
        if let csvFeaturesData = features.joined(separator: ",").data(using: .utf8) {
            multipartFormData.append(csvFeaturesData, withName: "features")
        }

        if let imagesFile = imagesFile {
            for item in imagesFile {
                multipartFormData.append(item.data, withName: "images_file", mimeType: item.contentType, fileName: item.filename)
            }
        }
        if let imageURL = imageURL {
            for item in imageURL {
                if let itemData = item.data(using: .utf8) {
                    multipartFormData.append(itemData, withName: "image_url")
                }
            }
        }
        if let threshold = threshold {
            if let thresholdData = "\(threshold)".data(using: .utf8) {
                multipartFormData.append(thresholdData, withName: "threshold")
            }
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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "analyze")
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
            url: serviceEndpoint + "/v4/analyze",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Create a collection.

     Create a collection that can be used to store images.
     To create a collection without specifying a name and description, include an empty JSON object in the request body.
     Encode the name and description in UTF-8 if they contain non-ASCII characters. The service assumes UTF-8 encoding
     if it encounters non-ASCII characters.

     - parameter name: The name of the collection. The name can contain alphanumeric, underscore, hyphen, and dot
       characters. It cannot begin with the reserved prefix `sys-`.
     - parameter description: The description of the collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createCollection(
        name: String? = nil,
        description: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Collection>?, WatsonError?) -> Void)
    {
        // construct body
        let createCollectionRequest = BaseCollection(
            name: name,
            description: description)
        guard let body = try? JSON.encoder.encode(createCollectionRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createCollection")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

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
            url: serviceEndpoint + "/v4/collections",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List collections.

     Retrieves a list of collections for the service instance.

     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listCollections(
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<CollectionsList>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listCollections")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

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
            method: "GET",
            url: serviceEndpoint + "/v4/collections",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Get collection details.

     Get details of one collection.

     - parameter collectionID: The identifier of the collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getCollection(
        collectionID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Collection>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getCollection")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v4/collections/\(collectionID)"
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
     Update a collection.

     Update the name or description of a collection.
     Encode the name and description in UTF-8 if they contain non-ASCII characters. The service assumes UTF-8 encoding
     if it encounters non-ASCII characters.

     - parameter collectionID: The identifier of the collection.
     - parameter name: The name of the collection. The name can contain alphanumeric, underscore, hyphen, and dot
       characters. It cannot begin with the reserved prefix `sys-`.
     - parameter description: The description of the collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateCollection(
        collectionID: String,
        name: String? = nil,
        description: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Collection>?, WatsonError?) -> Void)
    {
        // construct body
        let updateCollectionRequest = BaseCollection(
            name: name,
            description: description)
        guard let body = try? JSON.encoder.encodeIfPresent(updateCollectionRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateCollection")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v4/collections/\(collectionID)"
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
     Delete a collection.

     Delete a collection from the service instance.

     - parameter collectionID: The identifier of the collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteCollection(
        collectionID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteCollection")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v4/collections/\(collectionID)"
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
     Add images.

     Add images to a collection by URL, by file, or both.
     Encode the image and .zip file names in UTF-8 if they contain non-ASCII characters. The service assumes UTF-8
     encoding if it encounters non-ASCII characters.

     - parameter collectionID: The identifier of the collection.
     - parameter imagesFile: An array of image files (.jpg or .png) or .zip files with images.
       - Include a maximum of 20 images in a request.
       - Limit the .zip file to 100 MB.
       - Limit each image file to 10 MB.
       You can also include an image with the **image_url** parameter.
     - parameter imageURL: The array of URLs of image files (.jpg or .png).
       - Include a maximum of 20 images in a request.
       - Limit each image file to 10 MB.
       - Minimum width and height is 30 pixels, but the service tends to perform better with images that are at least
       300 x 300 pixels. Maximum is 5400 pixels for either height or width.
       You can also include images with the **images_file** parameter.
     - parameter trainingData: Training data for a single image. Include training data only if you add one image with
       the request.
       The `object` property can contain alphanumeric, underscore, hyphen, space, and dot characters. It cannot begin
       with the reserved prefix `sys-` and must be no longer than 32 characters.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func addImages(
        collectionID: String,
        imagesFile: [FileWithMetadata]? = nil,
        imageURL: [String]? = nil,
        trainingData: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ImageDetailsList>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        if let imagesFile = imagesFile {
            for item in imagesFile {
                multipartFormData.append(item.data, withName: "images_file", mimeType: item.contentType, fileName: item.filename)
            }
        }
        if let imageURL = imageURL {
            for item in imageURL {
                if let itemData = item.data(using: .utf8) {
                    multipartFormData.append(itemData, withName: "image_url")
                }
            }
        }
        if let trainingData = trainingData {
            if let trainingDataData = trainingData.data(using: .utf8) {
                multipartFormData.append(trainingDataData, withName: "training_data")
            }
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
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "addImages")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v4/collections/\(collectionID)/images"
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
     List images.

     Retrieves a list of images in a collection.

     - parameter collectionID: The identifier of the collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listImages(
        collectionID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ImageSummaryList>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listImages")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v4/collections/\(collectionID)/images"
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
     Get image details.

     Get the details of an image in a collection.

     - parameter collectionID: The identifier of the collection.
     - parameter imageID: The identifier of the image.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getImageDetails(
        collectionID: String,
        imageID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ImageDetails>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getImageDetails")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v4/collections/\(collectionID)/images/\(imageID)"
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
     Delete an image.

     Delete one image from a collection.

     - parameter collectionID: The identifier of the collection.
     - parameter imageID: The identifier of the image.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteImage(
        collectionID: String,
        imageID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteImage")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v4/collections/\(collectionID)/images/\(imageID)"
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
     Get a JPEG file of an image.

     Download a JPEG representation of an image.

     - parameter collectionID: The identifier of the collection.
     - parameter imageID: The identifier of the image.
     - parameter size: The image size. Specify `thumbnail` to return a version that maintains the original aspect
       ratio but is no larger than 200 pixels in the larger dimension. For example, an original 800 x 1000 image is
       resized to 160 x 200 pixels.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getJpegImage(
        collectionID: String,
        imageID: String,
        size: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Data>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getJpegImage")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "image/jpeg"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let size = size {
            let queryParameter = URLQueryItem(name: "size", value: size)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let path = "/v4/collections/\(collectionID)/images/\(imageID)/jpeg"
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
     List object metadata.

     Retrieves a list of object names in a collection.

     - parameter collectionID: The identifier of the collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listObjectMetadata(
        collectionID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ObjectMetadataList>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listObjectMetadata")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v4/collections/\(collectionID)/objects"
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
     Update an object name.

     Update the name of an object. A successful request updates the training data for all images that use the object.

     - parameter collectionID: The identifier of the collection.
     - parameter object: The name of the object.
     - parameter newObject: The updated name of the object. The name can contain alphanumeric, underscore, hyphen,
       space, and dot characters. It cannot begin with the reserved prefix `sys-`.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func updateObjectMetadata(
        collectionID: String,
        object: String,
        newObject: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<UpdateObjectMetadata>?, WatsonError?) -> Void)
    {
        // construct body
        // HAND EDIT: cannot use UpdateObjectMetadata struct due to required count property
        let updateObjectMetadataRequest = ["object": newObject]
        guard let body = try? JSON.encoder.encode(updateObjectMetadataRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "updateObjectMetadata")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v4/collections/\(collectionID)/objects/\(object)"
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
     Get object metadata.

     Get the number of bounding boxes for a single object in a collection.

     - parameter collectionID: The identifier of the collection.
     - parameter object: The name of the object.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getObjectMetadata(
        collectionID: String,
        object: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ObjectMetadata>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getObjectMetadata")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v4/collections/\(collectionID)/objects/\(object)"
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
     Delete an object.

     Delete one object from a collection. A successful request deletes the training data from all images that use the
     object.

     - parameter collectionID: The identifier of the collection.
     - parameter object: The name of the object.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteObject(
        collectionID: String,
        object: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteObject")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v4/collections/\(collectionID)/objects/\(object)"
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
     Train a collection.

     Start training on images in a collection. The collection must have enough training data and untrained data (the
     **training_status.objects.data_changed** is `true`). If training is in progress, the request queues the next
     training job.

     - parameter collectionID: The identifier of the collection.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func train(
        collectionID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Collection>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "train")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v4/collections/\(collectionID)/train"
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
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Add training data to an image.

     Add, update, or delete training data for an image. Encode the object name in UTF-8 if it contains non-ASCII
     characters. The service assumes UTF-8 encoding if it encounters non-ASCII characters.
     Elements in the request replace the existing elements.
     - To update the training data, provide both the unchanged and the new or changed values.
     - To delete the training data, provide an empty value for the training data.

     - parameter collectionID: The identifier of the collection.
     - parameter imageID: The identifier of the image.
     - parameter objects: Training data for specific objects.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func addImageTrainingData(
        collectionID: String,
        imageID: String,
        objects: [TrainingDataObject]? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TrainingDataObjects>?, WatsonError?) -> Void)
    {
        // construct body
        let addImageTrainingDataRequest = BaseTrainingDataObjects(
            objects: objects)
        guard let body = try? JSON.encoder.encode(addImageTrainingDataRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "addImageTrainingData")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v4/collections/\(collectionID)/images/\(imageID)/training_data"
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
     Get training usage.

     Information about the completed training events. You can use this information to determine how close you are to the
     training limits for the month.

     - parameter startTime: The earliest day to include training events. Specify dates in YYYY-MM-DD format. If empty
       or not specified, the earliest training event is included.
     - parameter endTime: The most recent day to include training events. Specify dates in YYYY-MM-DD format. All
       events for the day are included. If empty or not specified, the current day is used. Specify the same value as
       `start_time` to request events for a single day.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getTrainingUsage(
        startTime: String? = nil,
        endTime: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TrainingEvents>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getTrainingUsage")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let startTime = startTime {
            let queryParameter = URLQueryItem(name: "start_time", value: startTime)
            queryParameters.append(queryParameter)
        }
        if let endTime = endTime {
            let queryParameter = URLQueryItem(name: "end_time", value: endTime)
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
            url: serviceEndpoint + "/v4/training_usage",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete labeled data.

     Deletes all data associated with a specified customer ID. The method has no effect if no data is associated with
     the customer ID.
     You associate a customer ID with data by passing the `X-Watson-Metadata` header with a request that passes data.
     For more information about personal data and customer IDs, see [Information
     security](https://cloud.ibm.com/docs/visual-recognition?topic=visual-recognition-information-security).

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
            url: serviceEndpoint + "/v4/user_data",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

}
