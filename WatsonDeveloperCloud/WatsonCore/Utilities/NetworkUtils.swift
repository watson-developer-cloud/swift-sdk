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
import ObjectMapper

/**
 Watson content types
 
 - Text: Plain text
 - JSON: JSON
 - XML: XML
 - URLEncoded: Form URL Encoded
 */
public enum ContentType: String {
    case Text =         "text/plain"
    case JSON =         "application/json"
    case XML =          "application/xml"
    case URLEncoded =   "application/x-www-form-urlencoded"
    case AUDIO_OPUS =   "audio/ogg; codecs=opus"
    case AUDIO_WAV  =   "audio/wav"
    case AUDIO_FLAC =   "audio/flac"
}

/// Alias to HTTPMethod to remove dependency on Alamofire from individual projects
public typealias HTTPMethod = Alamofire.Method
/// Alias to ParameterEncoding to remove dependency on Alamofire from individual projects
public typealias ParameterEncoding = Alamofire.ParameterEncoding

/// Networking utilities used for performing REST operations into Watson services and parsing the input
public class NetworkUtils {
    private static let _httpContentTypeHeader = "Content-Type"
    private static let _httpAcceptHeader = "Accept"
    private static let _httpAuthorizationHeader = "Authorization"
    
    /**
     This helper function will manipulate the header as needed for a proper payload
     
     - parameter contentType: Changes the input to text or JSON.  Default is JSON
     
     - returns: The manipulated string for properly invoking the web call
     */
    private static func buildHeader(contentType: ContentType = ContentType.JSON, accept: ContentType = ContentType.JSON, apiKey: String? = nil)-> [String: String]  {
        Log.sharedLogger.debug("Entered buildHeader")
        
        var header = Dictionary<String, String>()
        
        if let localKey = apiKey { header.updateValue(localKey as String, forKey: _httpAuthorizationHeader )}
        
        guard (header.updateValue(contentType.rawValue, forKey: _httpContentTypeHeader) == nil) else {
            Log.sharedLogger.error("Error adding Content Type in header")
            return [:]
        }
        
        guard (header.updateValue(accept.rawValue, forKey: _httpAcceptHeader) == nil) else {
            Log.sharedLogger.error("Error adding Accept info in header")
            return [:]
        }
        
        return header
    }
    
    /**
     Request a Watson Authentication token. Tokens expire after one hour.
     
     - parameter tokenURL:          The URL of the token authentication endpoint (e.g. "https://stream.watsonplatform.net/authorization/api/v1/token")
     - parameter serviceURL:        The URL of the service for which you want to obtain a token (e.g. "https://stream.watsonplatform.net/text-to-speech/api")
     - parameter apiKey:            The authentication string used for HTTP basic authorization.
     - parameter completionHandler: The closure called when the token request is complete.
     */
    public static func requestAuthToken(tokenURL: String, serviceURL: String, apiKey: String? = nil, completionHandler: (token: String?, error: NSError?) -> Void) {
        
        Log.sharedLogger.debug("Entered requestAuthToken")
        
        let parameters = ["url": serviceURL]
        Alamofire.request(.GET, tokenURL, parameters: parameters, headers: buildHeader(.URLEncoded, accept: .URLEncoded, apiKey: apiKey))
            .responseString {response in
                Log.sharedLogger.debug("Entered requestAuthToken.responseString")
                completionHandler(token: response.result.value, error: response.result.error)
            }
    }
    
    /**
     This core function will make a basic authorization request by adding header information as part of the authentication.
     
     - parameter url:               The full URL to use for the web REST call
     - parameter method:            Indicates the method type such as POST or GET
     - parameter parameters:        Dictionary of parameters to use as part of the HTTP query
     - parameter contentType:       This will switch the input and outout request from text or json
     - parameter completionHandler: Returns CoreResponse which is a payload of valid AnyObject data or a NSError
     */
    public static func performBasicAuthRequest(url: String, method: HTTPMethod = HTTPMethod.GET, parameters: [String: AnyObject]? = [:], contentType: ContentType = ContentType.JSON, accept: ContentType = ContentType.JSON, encoding: ParameterEncoding = ParameterEncoding.URL, apiKey:String? = nil, completionHandler: (returnValue: CoreResponse) -> Void) {
        
        Log.sharedLogger.debug("Entered performBasicAuthRequest")
        
        Alamofire.request(method, url, parameters: parameters, encoding: encoding, headers: buildHeader(contentType, accept:accept, apiKey: apiKey) )
            // This will validate for return status codes between the specified ranges and fail if it falls outside of them
            .responseJSON {response in
                Log.sharedLogger.debug("Entered performBasicAuthRequest.responseJSON")
                if(contentType == ContentType.JSON) { completionHandler( returnValue: CoreResponse.getCoreResponse(response)) }
            }
            .responseString {response in
                Log.sharedLogger.debug("Entered performBasicAuthRequest.responseString")
                if(contentType == ContentType.Text) { completionHandler( returnValue: CoreResponse.getCoreResponse(response)) }
            }
            .responseData { response in
                Log.sharedLogger.debug("Entered performBasicAuthRequest.responseData")
              if(contentType == ContentType.AUDIO_OPUS ||
                 contentType == ContentType.AUDIO_WAV ||
                 contentType == ContentType.AUDIO_FLAC) {
                 completionHandler ( returnValue: CoreResponse.getCoreResponse(response))
              }
            }
    }
    
    /**
     This core function will perform a request passing in parameters.  This does not manipulate the request header or request body
     
     - parameter url:               The full URL to use for the web REST call
     - parameter method:            Indicates the method type such as POST or GET
     - parameter parameters:        Dictionary of parameters to use as part of the HTTP query
     - parameter completionHandler: Returns CoreResponse which is a payload of valid AnyObject data or a NSError
     */
    public static func performRequest(url: String, method: HTTPMethod = HTTPMethod.GET, parameters: [String: AnyObject] = [:], completionHandler: (returnValue: CoreResponse) -> Void) {
        
        Log.sharedLogger.debug("Entered performRequest")
        
        Alamofire.request(method, url, parameters: parameters)
            .responseJSON { response in
                Log.sharedLogger.debug("Entered performRequest.responseJSON")
                completionHandler( returnValue: CoreResponse.getCoreResponse(response))
        }
    }
    
    /**
     This Core function will upload a file to the give URL.  The header is manipulated for authentication
     TODO: this has the capability of uploading multiple files so this should be updated to take in a dictionary of fileURL,fielURLKey values
     
     - parameter url:               Full URL to use for the web REST call
     - parameter fileURLKey:        Key used with the fileURL
     - parameter fileURL:           File passed in as a NSURL
     - parameter parameters:        Dictionary of parameters to use as part of the HTTP query
     - parameter completionHandler: Returns CoreResponse which is a payload of valid AnyObject data or a NSError
     */
    public static func performBasicAuthFileUploadMultiPart(url: String, fileURLs: [String:NSURL], parameters: [String: AnyObject]=[:], apiKey: String? = nil, contentType: ContentType = ContentType.URLEncoded, accept: ContentType = ContentType.URLEncoded, completionHandler: (returnValue: CoreResponse) -> Void) {
        
        Log.sharedLogger.debug("Entered performBasicAuthFileUploadMultiPart")
        
        Alamofire.upload(Alamofire.Method.POST, url, headers: buildHeader(contentType, accept: accept, apiKey: apiKey),
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: key)
                }
                for (fileKey, fileValue) in fileURLs {
                    multipartFormData.appendBodyPart(fileURL: fileValue, name: fileKey)
                }
            },
            encodingCompletion: { encodingResult in
                Log.sharedLogger.debug("Entered performBasicAuthFileUploadMultiPart.encodingCompletion")
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        Log.sharedLogger.debug("Entered performBasicAuthFileUploadMultiPart.encodingCompletion.responseJSON")
                        completionHandler(returnValue: CoreResponse.getCoreResponse(response))
                    }
                case .Failure(let encodingError):
                    Log.sharedLogger.error("\(encodingError)")
                }
            }
        )
    }
    
    /**
     This Core function will upload one file to the give URL.
     
     - parameter url:               Full URL to use for the web REST call
     - parameter fileURL:           File passed in as a NSURL
     - parameter parameters:        Dictionary of parameters to use as part of the HTTP query
     - parameter completionHandler: Returns CoreResponse which is a payload of valid AnyObject data or a NSError
     */
     // TODO: STILL IN PROGRESS
    public static func performBasicAuthFileUpload(url: String, fileURL: NSURL, parameters: [String: AnyObject]=[:], apiKey: String? = nil, completionHandler: (returnValue: CoreResponse) -> Void) {
        
        // TODO: This is not optimal but I had to append the params to the url in order for this to work correctly.
        // I will get back to looking into this at some point but want to get it working
        
        let appendedUrl = addQueryStringParameter(url,values:parameters)
        
        Alamofire.upload(Alamofire.Method.POST, appendedUrl, headers: buildHeader(ContentType.URLEncoded, accept:ContentType.URLEncoded, apiKey:apiKey), file: fileURL)
            .responseJSON { response in
                Log.sharedLogger.debug("Entered performBasicAuthFileUpload.responseJSON")
                completionHandler( returnValue: CoreResponse.getCoreResponse(response))
        }
    }
  
    /**
     Adds to or updates a query parameter to a URL
     
     - parameter url:   Base URL
     - parameter key:   Parameter key
     - parameter value: Parameter value
     
     - returns: URL with key/value pair added/updated
     */
    private static func addOrUpdateQueryStringParameter(url: String, key: String, value: String?) -> String {
        if let components = NSURLComponents(string: url), v = value {
            var queryItems = [NSURLQueryItem]()
            if components.queryItems != nil {
                queryItems = components.queryItems!
            }
            queryItems.append(NSURLQueryItem(name: key, value: v))
            components.queryItems = queryItems
            return components.string!
        }
        return url
    }
    
    /**
     Add query parameters to a URL
     
     - parameter url:    Base URL to which variables should be added
     - parameter values: Dictionary of query parameters
     
     - returns: Base URL with query parameters appended
     */
    private static func addQueryStringParameter(url: String, values: [String: AnyObject]) -> String {
        var newUrl = url
        
        for item in values {
            if case let value as String = item.1 {
                newUrl = addOrUpdateQueryStringParameter(newUrl, key: item.0, value: value)
            }
            else {
                Log.sharedLogger.error("error in adding value to parameter \(item) to URL string")
            }
        }
        return newUrl
    }
}