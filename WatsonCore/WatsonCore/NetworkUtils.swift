//
//  NetworkUtils.swift
//  WatsonCore
//
//  Created by Karl Weinmeister on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

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
}

/**
HTTP Methods used for REST operations

- GET:    Get
- POST:   Post
- PUT:    Put
- DELETE: Delete
*/
public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    
    /**
    Converts enum value from Watson HTTP methods to Alamofire methods, so that projects don't have to import Alamofire
    
    - returns: Equivalent Alamofire method
    */
    func toAlamofireMethod() -> Alamofire.Method
    {
        switch self {
        case .GET:
            return Alamofire.Method.GET
        case .POST:
            return Alamofire.Method.POST
        case .PUT:
            return Alamofire.Method.PUT
        case .DELETE:
            return Alamofire.Method.DELETE
        }
    }
}

/**
Enumeration of possible parameter encodings used in Watson iOS SDK

- URL:                                 A query string to be set as or appended to any existing URL query for GET, HEAD, and DELETE requests, or set as the body for requests with any other HTTP method.
- URLEncodedInURL:                    Creates query string to be set as or appended to any existing URL query.
- JSON:                               Uses NSJSONSerialization to create a JSON representation of the parameters object, which is set as the body of the request.
- PropertyList:                       Uses NSPropertyListSerialization to create a plist representation of the parameters object.
- Custom->:                           Uses the associated closure value to construct a new request given an existing request and parameters.
*/
public enum ParameterEncoding {
    case URL
    case URLEncodedInURL
    case JSON
    case PropertyList(NSPropertyListFormat, NSPropertyListWriteOptions)
    case Custom((URLRequestConvertible, [String: AnyObject]?) -> (NSMutableURLRequest, NSError?))
    
    /**
    Converts enum value from Watson parameter encodings to Alamofire encdogins, so that projects don't have to import Alamofire
    
    - returns: Equivalent Alamofire parameter encoding
    */
    func toAlamofireParameterEncoding()->Alamofire.ParameterEncoding {
        switch(self) {
        case ParameterEncoding.URL:
            return Alamofire.ParameterEncoding.URL
        case ParameterEncoding.URLEncodedInURL:
            return Alamofire.ParameterEncoding.URLEncodedInURL
        case ParameterEncoding.JSON:
            return Alamofire.ParameterEncoding.JSON
        default:
            Log.sharedLogger.error("Unexpected parameter encoding conversion")
            return Alamofire.ParameterEncoding.URL
        }
    }
}

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
            debugPrint(self)
        #endif
        return self
    }
}

/// Networking utilities used for performing REST operations into Watson services and parsing the input
public class NetworkUtils {
    private static let TAG = "[Core] "
    private static var _debug: Bool = true
    private static let _httpContentTypeHeader = "Content-Type"
    private static let _httpAcceptHeader = "Accept"
    private static let _httpAuthorizationHeader = "Authorization"
    
    /**
    Helper function to create a URL encoded string for query parameters from a dictionary
    
    - parameter queryParams: query parameters
    
    - returns: URL encoded string that includes query parameters
    */
    private static func parseQueryParameters(queryParams: NSDictionary?) -> String {
        var paramString:String = ""
        if let params = queryParams {
            if params.count > 0 {
                paramString += "?"
                var first = true
                for (key, value) in params {
                    if !first {
                        paramString += "&"
                    }
                    paramString += "\(key)=\(value)"
                    first = false
                }
            }
        }
        guard let escapedString = paramString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {
            Log.sharedLogger.info("parseQueryParameters(): Unable to URL encode query parameter string: \(paramString)")
            return ""
        }
        return escapedString
    }
    
    /**
    This helper function will manipulate the header as needed for a proper payload
    
    - parameter contentType: Changes the input to text or JSON.  Default is JSON
    
    - returns: The manipulated string for properly invoking the web call
    */
    private static func buildHeader(contentType: ContentType = ContentType.JSON, apiKey: String?)-> [String: String]  {
        Log.sharedLogger.debug("\(TAG): Entered buildHeader")
       
        var header = Dictionary<String, String>()

        if let localKey = apiKey { header.updateValue(localKey as String, forKey: _httpAuthorizationHeader )}
        
        guard (header.updateValue(contentType.rawValue, forKey: _httpContentTypeHeader) == nil) else {
            Log.sharedLogger.error("\(TAG): Error adding Content Type in header")
            return [:]
        }
        
        guard (header.updateValue(contentType.rawValue, forKey: _httpAcceptHeader) == nil) else {
            Log.sharedLogger.error("\(TAG): Error adding Accept info in header")
            return [:]
        }
        
        return header
    }
    
    /**
    This core function will make a basic authorization request by adding header information as part of the authentication.
    
    - parameter url:               The full URL to use for the web REST call
    - parameter method:            Indicates the method type such as POST or GET
    - parameter parameters:        Dictionary of parameters to use as part of the HTTP query
    - parameter contentType:       This will switch the input and outout request from text or json
    - parameter completionHandler: Returns CoreResponse which is a payload of valid AnyObject data or a NSError
    */
    public static func performBasicAuthRequest(url: String, method: HTTPMethod = HTTPMethod.GET, parameters: [String: AnyObject]? = [:], contentType: ContentType = ContentType.JSON, encoding: ParameterEncoding = ParameterEncoding.URL, apiKey:String, completionHandler: (returnValue: CoreResponse) -> ()) {
        Log.sharedLogger.debug("\(TAG): Entered performBasicAuthRequest")
        Alamofire.request(method.toAlamofireMethod(), url, parameters: parameters, encoding: encoding.toAlamofireParameterEncoding(), headers: buildHeader(contentType, apiKey: apiKey) )
            // This will validate for return status codes between the specified ranges and fail if it falls outside of them
            .debugLog()
            .validate(statusCode: 200..<300)
            .responseJSON {response in
                Log.sharedLogger.debug("\(self.TAG): Entered performBasicAuthRequest.responseJSON")
                if(contentType == ContentType.JSON) { completionHandler( returnValue: self.handleResponse(response)) }
            }
            .responseString {response in
                Log.sharedLogger.debug("\(self.TAG): Entered performBasicAuthRequest.responseString")
                if(contentType == ContentType.Text) { completionHandler( returnValue: self.handleResponse(response)) }
            }
    }
    
    /**
    This core function will perform a request passing in parameters.  This does not manipulate the request header or request body
    
    - parameter url:               The full URL to use for the web REST call
    - parameter method:            Indicates the method type such as POST or GET
    - parameter parameters:        Dictionary of parameters to use as part of the HTTP query
    - parameter completionHandler: Returns CoreResponse which is a payload of valid AnyObject data or a NSError
    */
    public static func performRequest(url: String, method: HTTPMethod = HTTPMethod.GET, parameters: [String: AnyObject] = [:], completionHandler: (returnValue: CoreResponse) -> ()) {
    
        
        Log.sharedLogger.debug("CORE: Entered performRequest")
        Alamofire.request(method.toAlamofireMethod(), url, parameters: parameters)
            .debugLog()
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                Log.sharedLogger.debug("\(self.TAG): Entered performRequest.responseJSON")
                completionHandler( returnValue: self.handleResponse(response))
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
    public static func performBasicAuthFileUploadMultiPart(url: String, fileURLKey: String, fileURL: NSURL, parameters: [String: AnyObject]=[:], apiKey: String, completionHandler: (returnValue: CoreResponse) -> ()) {
 
        Log.sharedLogger.debug("\(self.TAG): Entered performBasicAuthFileUploadMultiPart")
        Alamofire.upload(Alamofire.Method.POST, url, headers: buildHeader(ContentType.URLEncoded, apiKey: apiKey),
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: key)
                }
                multipartFormData.appendBodyPart(fileURL: fileURL, name: fileURLKey)                
            },
            encodingCompletion: { encodingResult in
                Log.sharedLogger.debug("\(self.TAG): Entered performBasicAuthFileUploadMultiPart.encodingCompletion")
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        Log.sharedLogger.debug("\(self.TAG): Entered performBasicAuthFileUploadMultiPart.encodingCompletion.responseJSON")
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions.MutableLeaves) as? [String: AnyObject]
                            let coreResponse = CoreResponse(anyObject: json!, httpresponse: response.response!)
                            completionHandler(returnValue: coreResponse)
                        }
                        catch let error as NSError {
                            let coreResponse = CoreResponse(anyObject: error, httpresponse: response.response!)
                            completionHandler(returnValue: coreResponse)
                        }
                    }
                case .Failure(let encodingError):
                    print(encodingError)
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
    public static func performBasicAuthFileUpload(url: String, fileURL: NSURL, parameters: [String: AnyObject]=[:], apiKey: String, completionHandler: (returnValue: CoreResponse) -> ()) {
        
        // TODO: This is not optimal but I had to append the params to the url in order for this to work correctly.
        // I will get back to looking into this at some point but want to get it working
        
        let appendedUrl = addQueryStringParameter(url,values:parameters)

        Alamofire.upload(Alamofire.Method.POST, appendedUrl, headers: buildHeader(ContentType.URLEncoded, apiKey: apiKey), file: fileURL)
            .debugLog()
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                Log.sharedLogger.debug("\(self.TAG): Entered performBasicAuthFileUpload.responseJSON")
                completionHandler( returnValue: self.handleResponse(response))
            }
    }
    
    // TODO: Combine the two handleResponses
    private static func handleResponse(response: Response<AnyObject, NSError>)->CoreResponse {
        switch response.result {
        case .Success(let data):
            Log.sharedLogger.info("\(self.TAG): Successful Response")
            let coreResponse = CoreResponse(anyObject: data, httpresponse: (response.response != nil ? response.response! : nil))
            return coreResponse
        case .Failure(let error):
            let coreResponse = CoreResponse(anyObject: error, httpresponse: (response.response != nil ? response.response! : nil))
            Log.sharedLogger.error("\(self.TAG): Failure Response")
            return coreResponse
        }
    }

    private static func handleResponse(response: Response<String, NSError>)->CoreResponse {
        switch response.result {
        case .Success(let result):
            Log.sharedLogger.info("\(self.TAG): Successful Response")
            let coreResponse = CoreResponse(anyObject: result, httpresponse: (response.response != nil ? response.response! : nil))
            return coreResponse
        case .Failure(let error):
            let coreResponse = CoreResponse(anyObject: error, httpresponse: (response.response != nil ? response.response! : nil))
            Log.sharedLogger.error("\(self.TAG): Failure Response")
            return coreResponse
        }
    }
    
    private static func addOrUpdateQueryStringParameter(url: String, key: String, value: String?) -> String {
        if let components = NSURLComponents(string: url),
            var queryItems = (components.queryItems ?? []) as? [NSURLQueryItem] {
                // Key doesn't exist if reaches here
                if let v = value {
                    // Add key to URL query string
                    queryItems.append(NSURLQueryItem(name: key, value: v))
                    components.queryItems = queryItems
                    return components.string!
                }
        }
        
        return url
    }
    
    private static func addQueryStringParameter(url: String, values: [String: AnyObject]) -> String {
        var newUrl = url
        
        for item in values {
            if let anyObject:String = (item.1 as! String) {
                newUrl = addOrUpdateQueryStringParameter(newUrl, key: item.0, value: anyObject)
            }
            else {
                Log.sharedLogger.error("error in adding value to parameter \(item) to URL string")
            }
        }
        return newUrl
    }
    
    /*
    private func handleResponse<T>(response: T)->CoreResponse {
        
    
        if((response is Response<AnyObject, NSError>)) {
            
        }
        
        if((response is Response<String, NSError>)) {
            
        }
    }
    */
    
    public static func getEndpoints() -> JSON {
        
        var jsonObj: JSON = JSON.null
        if let path = NSBundle.mainBundle().pathForResource("alchemy_endpoints", ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                jsonObj = JSON(data)
                if jsonObj == JSON.null {
                    print("could not get json from file, make sure that file contains valid json.")
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        return jsonObj
    }
}