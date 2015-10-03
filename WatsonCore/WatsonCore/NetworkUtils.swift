//
//  WatsonNetworkUtils.swift
//  WatsonCore
//
//  Created by Karl Weinmeister on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation

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
    - parameter body:        The HTTP request body
    - parameter textContent: If the
    
    - returns: A populated request object
    */
    public func buildRequest(path:String, method:HTTPMethod, body: NSData?, contentType: ContentType = ContentType.JSON, accept: ContentType = ContentType.JSON) -> NSURLRequest? {
        
        let endpoint = _protocol + "://" + _host + path
        if let url = NSURL(string: endpoint) {
            
            let request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = method.rawValue
            request.addValue(apiKey, forHTTPHeaderField: _httpAuthorizationHeader)
            request.addValue(accept.rawValue, forHTTPHeaderField: _httpAcceptHeader)
            request.addValue(contentType.rawValue, forHTTPHeaderField: _httpContentTypeHeader)
            WatsonDebug("buildRequest(): Content Type = " + request.valueForHTTPHeaderField(_httpContentTypeHeader)!, prefix:self.TAG)
            
            if let bodyData = body {
                request.HTTPBody = bodyData
            }
            WatsonDebug("buildRequest(): " + method.rawValue + " " + endpoint, prefix:self.TAG)
            return request
        }
        WatsonLog("buildRequest(): Invalid endpoint", prefix:self.TAG)
        return nil
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
                WatsonLog("performRequest(): Error received when invoking operation - \(error?.localizedDescription)", prefix:self.TAG)
                callback(nil, error)
                return
            }
            
            if let data = data {
                do {
                    let httpResponse = response as! NSHTTPURLResponse
                    let contentType = httpResponse.allHeaderFields[self._httpContentTypeHeader] as? String
                    
                    //Missing contentType in header
                    if contentType == nil {
                        WatsonLog("performRequest(): Response is missing content-type header", prefix:self.TAG)
                        callback(nil,nil)
                    }
                        //Plain text
                    else if contentType!.rangeOfString(ContentType.Text.rawValue) != nil {
                        let returnVal = [ "rawData" : data]
                        callback(returnVal, nil)
                    }
                        //Unknown content type
                    else if contentType!.rangeOfString(ContentType.JSON.rawValue) == nil {
                        WatsonLog("performRequest(): Unsupported content type returned: " + contentType!, prefix:self.TAG)
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
                        WatsonLog("performRequest(): Neither array nor dictionary type found in JSON response: " + (dataString as! String) + "\(error)", prefix:self.TAG)
                        let returnVal = [ "rawData" : data]
                        callback(returnVal, nil)
                    }
                } catch let error as NSError {
                    let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    WatsonLog("performRequest(): " + (dataString as! String) + " \(error)", prefix:self.TAG)
                    callback(nil, error)
                }
                
            } else {
                WatsonLog("performRequest(): No response data.", prefix:self.TAG)
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
            WatsonLog("dictionaryToJSON(): Could not convert dictionary object to JSON. \(error.localizedDescription)", prefix:self.TAG)
        }
        return nil
    }
}