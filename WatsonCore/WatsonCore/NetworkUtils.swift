//
//  WatsonNetworkUtils.swift
//  WatsonCore
//
//  Created by Karl Weinmeister on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/**
Watson service types

- Streaming: Watson services using streaming, i.e. Text to Speech and Speech to Text
- Standard: Other Watson services written by IBM team
- Alchemy: Alchemy Watson services
*/
public enum ServiceType: String {
    case Streaming = "stream.watsonplatform.net"
    case Standard = "gateway.watsonplatform.net"
    case Alchemy = "gateway-a.watsonplatform.net"
}

public enum ContentType: String {
    case Text = "text/plain"
    case JSON = "application/json"
    case XML = "application/xml"
}

/**
HTTP Methods used for REST operations

- GET:    Get
- POST:   Post
- PUT:    Put
- DELETE: Delete
*/
public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

/// Networking utilities used for performing REST operations into Watson services and parsing the input
public class NetworkUtils {
    private let TAG = "[Core] "
    private var _debug: Bool = true
    private let _httpContentTypeHeader = "Content-Type"
    private let _httpAcceptHeader = "Accept"
    private let _httpAuthorizationHeader = "Authorization"
    private let _protocol = "https"
    private var _host = ""
    private var apiKey: String!
    
    /**
    Initialize the networking utilities with a service type
    
    - parameter type: Service type
    */
    public init(type:ServiceType = ServiceType.Standard) {
        configureHost(type)
    }
    
    /**
    Initialize the network utilities with a service type and authenticate
    
    - parameter username: username
    - parameter password: password
    - parameter type:     service type
    
    */
    public init(username:String, password:String, type:ServiceType = ServiceType.Standard) {
        setUsernameAndPassword(username, password: password)
        configureHost(type)
    }
    
    /**
    Configures the host for service invocation
    
    - parameter type: service type
    */
    private func configureHost(type:ServiceType)
    {
        _host = type.rawValue
    }
    
    /**
    Sets the username and password on the service for invocation. Combines both together into an API Key.
    
    - parameter username: username
    - parameter password: password
    */
    public func setUsernameAndPassword(username:String, password:String)
    {
        let authorizationString = username + ":" + password
        apiKey = "Basic " + (authorizationString.dataUsingEncoding(NSASCIIStringEncoding)?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding76CharacterLineLength))!
        
    }
    
    /**
    Build up the request to be passed into a Watson service
    
    - parameter path:        Path to the service, not including hostname
    - parameter method:      The HTTP method to use
    - parameter queryParams: The HTTP query parameters
    - parameter body:        The HTTP request body
    - parameter textContent: If the
    
    - returns: A populated request object
    */
    public func buildRequest(path:String, method:HTTPMethod, body: NSData?, contentType: ContentType = ContentType.JSON, queryParams: NSDictionary? = nil, accept: ContentType = ContentType.JSON) -> NSURLRequest? {
        
        let endpoint = _protocol + "://" + _host + path + parseQueryParameters(queryParams)
        
        if let url = NSURL(string: endpoint) {
            
            let request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = method.rawValue
            request.addValue(apiKey, forHTTPHeaderField: _httpAuthorizationHeader)
            request.addValue(accept.rawValue, forHTTPHeaderField: _httpAcceptHeader)
            request.addValue(contentType.rawValue, forHTTPHeaderField: _httpContentTypeHeader)
            Log.sharedLogger.debug("buildRequest(): Content Type = \(request.valueForHTTPHeaderField(_httpContentTypeHeader)!)")
            
            if let bodyData = body {
                request.HTTPBody = bodyData
            }
            Log.sharedLogger.debug("\(self.TAG) buildRequest(): \(method.rawValue) \(endpoint)")
            return request
        }
        Log.sharedLogger.info("\(self.TAG) buildRequest(): Invalid endpoint")
        return nil
    }
    
    /**
    Helper function to create a URL encoded string for query parameters from a dictionary
    
    - parameter queryParams: query parameters
    
    - returns: URL encoded string that includes query parameters
    */
    private func parseQueryParameters(queryParams: NSDictionary?) -> String {
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
    
    public func buildEndpoint(endpoint: String)->String {
        
        return _protocol + "://" + _host + endpoint
    }
    
    /**
    This helper function will manipulate the header as needed for a proper payload
    
    - parameter contentType: Changes the input to text or JSON.  Default is JSON
    
    - returns: The manipulated string for properly invoking the web call
    */
    private func buildHeader(contentType: ContentType = ContentType.JSON)-> [String: String]  {
        Log.sharedLogger.debug("Core: Entered buildHeader")
        guard apiKey != nil else {
            Log.sharedLogger.error("No apiKey present to build header")
            return [:]
        }
        
        var header = [_httpAuthorizationHeader : apiKey as String]
        
        guard (header.updateValue(contentType.rawValue, forKey: _httpContentTypeHeader) == nil) else {
            Log.sharedLogger.error("Error adding Content Type in header")
            return [:]
        }
        
        guard (header.updateValue(ContentType.Text.rawValue, forKey: _httpAcceptHeader) == nil) else {
            Log.sharedLogger.error("Error adding Accept info in header")
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
    public func performBasicAuthRequest(url: String, method: Alamofire.Method, parameters: Dictionary<String,String>, contentType: ContentType = ContentType.JSON, completionHandler: (returnValue: CoreResponse) -> ()) {
        Log.sharedLogger.debug("CORE: Entered performBasicAuthRequest")
        Alamofire.request(method, url, parameters: parameters, headers: buildHeader(contentType) )
            // This will validate for return status codes between the specified ranges and fail if it falls outside of them
            .validate(statusCode: 200..<300)
            .responseJSON {response in
                Log.sharedLogger.debug("CORE: Entered performBasicAuthRequest.responseJSON")
                if(contentType == ContentType.JSON) { completionHandler( returnValue: self.handleResponse(response)) }
            }
            .responseString {response in
                Log.sharedLogger.debug("CORE: Entered performBasicAuthRequest.responseString")
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
    public func performRequest(url: String, method: Alamofire.Method, parameters: Dictionary<String,String>, completionHandler: (returnValue: CoreResponse) -> ()) {
        Log.sharedLogger.debug("CORE: Entered performRequest")
        Alamofire.request(method, url, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                Log.sharedLogger.debug("CORE: Entered performRequest.responseJSON")
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
    public func performBasicAuthFileUploadMultiPart(url: String, fileURLKey: String, fileURL: NSURL, parameters: Dictionary<String,String>, completionHandler: (returnValue: CoreResponse) -> ()) {
        Log.sharedLogger.debug("CORE: Entered performBasicAuthFileUploadMultiPart")
        Alamofire.upload(Alamofire.Method.POST, url, headers: buildHeader(),
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: fileURL, name: fileURLKey)
                
                for (key, value) in parameters {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                }
            },
            encodingCompletion: { encodingResult in
                Log.sharedLogger.debug("CORE: Entered performBasicAuthFileUploadMultiPart.encodingCompletion")
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        Log.sharedLogger.debug("CORE: Entered performBasicAuthFileUploadMultiPart.encodingCompletion.responseJSON")
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions.MutableLeaves) as? [String: AnyObject]
                            let coreResponse = CoreResponse(anyObject: json!, statusCode: response.response!.statusCode)
                            completionHandler(returnValue: coreResponse)
                        }
                        catch let error as NSError {
                            let coreResponse = CoreResponse(anyObject: error, statusCode: response.response!.statusCode)
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
    public func performBasicAuthFileUpload(url: String, fileURL: NSURL, parameters: Dictionary<String,String>, completionHandler: (returnValue: CoreResponse) -> ()) {
        Log.sharedLogger.debug("CORE: Entered performBasicAuthFileUpload")
        Alamofire.upload(Alamofire.Method.POST, url, headers: buildHeader(), file: fileURL)
            .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                Log.sharedLogger.info("\(totalBytesWritten)")
                // This closure is NOT called on the main queue for performance
                dispatch_async(dispatch_get_main_queue()) {
                    Log.sharedLogger.info("Total bytes written on main queue: \(totalBytesWritten)")
                }
            }
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                Log.sharedLogger.debug("CORE: Entered performBasicAuthFileUpload.responseJSON")
                completionHandler( returnValue: self.handleResponse(response))
        }
    }
    
    // TODO: Combine the to handleResponses
    private func handleResponse(response: Response<AnyObject, NSError>)->CoreResponse {
        switch response.result {
        case .Success(let data):
            Log.sharedLogger.info("CORE: Successfully Response")
            let coreResponse = CoreResponse(anyObject: data, statusCode: (response.response?.statusCode)!)
            return coreResponse
        case .Failure(let error):
            Log.sharedLogger.info("CORE: Failure Response")
            let coreResponse = CoreResponse(anyObject: error, statusCode: (response.response?.statusCode)!)
            return coreResponse
        }
    }

    // TODO: Combine the to handleResponses
    private func handleResponse(response: Response<String, NSError>)->CoreResponse {
        switch response.result {
        case .Success(let result):
            Log.sharedLogger.info("CORE: Successfully Response")
            let coreResponse = CoreResponse(anyObject: result, statusCode: (response.response?.statusCode)!)
            return coreResponse
        case .Failure(let error):
            Log.sharedLogger.info("CORE: Failure Response")
            let coreResponse = CoreResponse(anyObject: error, statusCode: (response.response?.statusCode)!)
            return coreResponse
        }
        
    }
    
    /**
    Invoke rest operation asynchronously and then call callback handler
    - parameter request:  Request object populated from buildRequest()
    - parameter callback: Callback handler to be invoked when a response is received
    */
    public func performRequest(request:NSURLRequest, callback:([String: AnyObject]!, NSError!)->()) {
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error in
            
            guard error == nil else {
                Log.sharedLogger.info("\(self.TAG) performRequest(): Error received when invoking operation - \(error?.localizedDescription)")
                callback(nil, error)
                return
            }
            
            if let data = data {
                do {
                    let httpResponse = response as! NSHTTPURLResponse
                    let contentType = httpResponse.allHeaderFields[self._httpContentTypeHeader] as? String
                    
                    //Missing contentType in header
                    if contentType == nil {
                        Log.sharedLogger.info("\(self.TAG) performRequest(): Response is missing content-type header")
                        callback(nil,nil)
                    }
                        //Plain text
                    else if contentType!.rangeOfString(ContentType.Text.rawValue) != nil {
                        let returnVal = [ "rawData" : data]
                        callback(returnVal, nil)
                    }
                        // XML wrapper
                    else if contentType!.rangeOfString("application/xml") != nil {
                        let returnVal = [ "rawData"  : data]
                        callback(returnVal, nil)
                    }
                        //Unknown content type
                    else if contentType!.rangeOfString(ContentType.JSON.rawValue) == nil {
                        Log.sharedLogger.info("\(self.TAG) performRequest(): Unsupported content type returned: \(contentType!)")
                        callback(nil,nil)
                    }
                        //JSON Dictionary
                    else if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as? [String: AnyObject] {
                        
                        if let _ = json["code"] as? String,  message = json["message"] as? String {
                            let errorDetails = [NSLocalizedFailureReasonErrorKey: message]
                            let error = NSError(domain: "NetworkUtils", code: 1, userInfo: errorDetails)
                            callback( nil, error)
                            return
                        }
                        callback(json, nil)
                    }
                        //JSON Array
                    else if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as? [AnyObject] {
                        let returnVal = [ "dataArray" : json]
                        callback(returnVal, nil)
                    }
                        //JSON Unknown Type
                    else {
                        let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                        Log.sharedLogger.info("\(self.TAG) performRequest(): Neither array nor dictionary type found in JSON response: \(dataString as! String) \(error)")
                        let returnVal = [ "rawData" : data]
                        callback(returnVal, nil)
                    }
                } catch let error as NSError {
                    let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    Log.sharedLogger.info("\(self.TAG) performRequest(): \(dataString as! String) \(error)")
                    callback(nil, error)
                }
                
            } else {
                Log.sharedLogger.info("\(self.TAG) performRequest(): No response data.")
                callback(nil, nil)
            }
        })
        task.resume()
    }
    
    /**
    Convert dictionary object to JSON
    
    - parameter dictionary: dictionary object to be converted
    
    - returns: NSData object populated with JSON
    */
    public func dictionaryToJSON(dictionary: NSDictionary) -> NSData? {
        
        do {
            let json = try NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions())
            return json
        } catch let error as NSError {
            Log.sharedLogger.warning("\(self.TAG) dictionaryToJSON(): Could not convert dictionary object to JSON. \(error.localizedDescription)")
        }
        return nil
    }
    
    public func getEndpoints() -> JSON {
        
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