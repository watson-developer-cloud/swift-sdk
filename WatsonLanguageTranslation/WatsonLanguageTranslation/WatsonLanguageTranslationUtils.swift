//
//  WatsonLanguageTranslationUtils.swift
//  WatsonLanguageTranslation
//
//  Created by Karl Weinmeister on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

//TODO: Move this to a common project
//TODO: Document this class and functions

import Foundation

public class WatsonLanguageTranslationUtils {
    private var _debug: Bool = true
    private let TAG = "[LanguageTranslationSDK] "
    private let _httpContentTypeHeader = "Content-Type"
    private let _httpAcceptHeader = "Accept"
    private let _httpAuthorizationHeader = "Authorization"
    private let _contentTypeJSON = "application/json"
    private let _contentTypeText = "text/plain"
    public var apiKey: String!
    
    public func buildRequest(endpoint:String, method:String, body: NSData?, textContent: Bool = false) -> NSURLRequest {
        
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
            
            // TODO: fix the case where the payload is a ASCII string not a JSON.
            if let data = data {
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as? [String: AnyObject] {
                        
                        callback(json, nil)
                        return
                    } else if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as? [AnyObject] {
                        let returnVal = [ "dataArray" : json]
                        callback(returnVal, nil)
                        return
                    } else {
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