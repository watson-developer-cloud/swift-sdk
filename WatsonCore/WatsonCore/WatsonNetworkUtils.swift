//
//  WatsonNetworkUtils.swift
//  WatsonCore
//
//  Created by Karl Weinmeister on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

//TODO: Document this class and functions

import Foundation

public enum WatsonServiceType {
    case Streaming, Standard
}

public enum WatsonHTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

public class WatsonNetworkUtils {
    private let TAG = "[WatsonCore] "
    private var _debug: Bool = true
    private let _httpContentTypeHeader = "Content-Type"
    private let _httpAcceptHeader = "Accept"
    private let _httpAuthorizationHeader = "Authorization"
    private let _contentTypeJSON = "application/json"
    private let _contentTypeText = "text/plain"
    private let _protocol = "https"
    private var _host = "gateway.watsonplatform.net"
    private var apiKey: String!
    
    public init(type:WatsonServiceType = WatsonServiceType.Standard) {
        configureHost(type)
    }

    public init(username:String, password:String, type:WatsonServiceType = WatsonServiceType.Standard) {
        setUsernameAndPassword(username, password: password)
        configureHost(type)
    }
    
    private func configureHost(type:WatsonServiceType)
    {
        if type == WatsonServiceType.Streaming {
            _host = "stream.watsonplatform.net"
        }
    }
    
    public func setUsernameAndPassword(username:String, password:String)
    {
        let authorizationString = username + ":" + password
        apiKey = "Basic " + (authorizationString.dataUsingEncoding(NSASCIIStringEncoding)?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding76CharacterLineLength))!
        
    }
    
    public func buildRequest(path:String, method:String, body: NSData?, textContent: Bool = false) -> NSURLRequest {
        
        let endpoint = _protocol + "://" + _host + path
        if let url = NSURL(string: endpoint) {
            
            let request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = method
            request.addValue(apiKey, forHTTPHeaderField: _httpAuthorizationHeader)
            if (textContent) {
                request.addValue(_contentTypeText, forHTTPHeaderField: _httpAcceptHeader)
                request.addValue(_contentTypeText, forHTTPHeaderField: _httpContentTypeHeader)
            } else {
                request.addValue(_contentTypeJSON, forHTTPHeaderField: _httpAcceptHeader)
                request.addValue(_contentTypeJSON, forHTTPHeaderField: _httpContentTypeHeader)
            }
            self.printDebug("buildRequest(): Content-Type = " + request.valueForHTTPHeaderField(_httpContentTypeHeader)!)
            
            if let bodyData = body {
                request.HTTPBody = bodyData
            }
            self.printDebug("buildRequest(): " + method + " " + endpoint)
            return request
        }
        self.printDebug("buildRequest(): Invalid endpoint")
        return NSURLRequest()
    }
    
    
    public func performRequest(request:NSURLRequest, callback:([String: AnyObject]!, NSError!)->()) {
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error in
            
            guard error == nil else {
                print(error, terminator: "")
                callback(nil, error)
                return
            }
            
            if let data = data {
                do {
                    let httpResponse = response as! NSHTTPURLResponse
                    let contentType = httpResponse.allHeaderFields["Content-Type"] as? String
                    
                    //Missing contentType in header
                    if contentType == nil {
                        self.printDebug("Response is missing content-type header")
                    }
                        //Plain text
                    else if contentType!.rangeOfString("text/plain") != nil {
                        let returnVal = [ "rawData" : data]
                        callback(returnVal, nil)
                    }
                        //Unknown content type
                    else if contentType!.rangeOfString("application/json") == nil {
                        self.printDebug("Unsupported content type returned: " + contentType!)
                    }
                        //JSON Dictionary
                    else if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as? [String: AnyObject] {
                        
                        if let _ = json["code"] as? String,  message = json["message"] as? String {
                            let errorDetails = [NSLocalizedFailureReasonErrorKey: message]
                            let error = NSError(domain: "WatsonLanguage", code: 1, userInfo: errorDetails)
                            callback( nil, error)
                            return
                        }
                        callback(json, nil)
                        return
                    }
                        //JSON Array
                    else if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as? [AnyObject] {
                        let returnVal = [ "dataArray" : json]
                        callback(returnVal, nil)
                        return
                    }
                        //JSON Unknown Type
                    else {
                        let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                        self.printDebug("Neither array nor dictionary type found in JSON response: " + (dataString as! String) + "\(error)")
                        let returnVal = [ "rawData" : data]
                        callback(returnVal, nil)
                    }
                } catch let error {
                    let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    self.printDebug("Could not parse response. " + (dataString as! String) + "\(error)")
                }
                
            } else {
                self.printDebug("No response data.")
            }
        })
        task.resume()
    }
    
    
    public func dictionaryToJSON(dictionary: [String: AnyObject]) -> NSData {
        
        do {
            let deviceJSON = try NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions())
            return deviceJSON
        } catch let error as NSError {
            printDebug("Could not convert dictionary object to JSON. \(error)")
        }
        
        return NSData()
        
    }
    
    
    public func printDebug(message:String) {
        if _debug {
            print(TAG + message)
        }
    }
}