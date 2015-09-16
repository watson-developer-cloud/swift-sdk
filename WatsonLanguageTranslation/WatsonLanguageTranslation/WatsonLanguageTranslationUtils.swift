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
    
    
    public func performRequest(request:NSURLRequest, callback:(NSDictionary!)->()) {
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error in
            
            if let error = error {
                self.printDebug("performRequest(): " + error.localizedDescription)
                callback(nil)
            } else {
                if let responseData = data {
                    
                    var error: NSError?
                    if let json = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableLeaves, error: &error) as? NSDictionary {
                        if (error != nil) {
                            let dataString = NSString(data: responseData, encoding: NSUTF8StringEncoding)
                            self.printDebug("Could not parse response. " + (dataString as! String) + "\(error)")
                        } else {
                            callback(json)
                        }
                    } else if let json = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableLeaves, error: &error) as? NSArray {
                        if (error != nil) {
                            let dataString = NSString(data: responseData, encoding: NSUTF8StringEncoding)
                            self.printDebug("Could not parse response. " + (dataString as! String) + "\(error)")
                        } else {
                            let returnVal = NSDictionary(object: json, forKey: "dataArray")
                            callback(returnVal)
                        }
                    } else {
                        self.printDebug("performRequest(): Response is neither an array nor dictionary. Returning as string.")
                        let dataString = NSString(data: responseData, encoding: NSUTF8StringEncoding)
                        let returnVal = NSDictionary(object: dataString!, forKey: "data")
                        callback(returnVal)
                    }
                    
                } else {
                    self.printDebug("performRequest(): No response data.")
                    callback(nil)
                }
                
            }
        })
        task.resume()
    }
    
    private func dictionaryToJSON(dictionary: NSDictionary) -> NSData {
        var error: NSError?
        if let deviceJSON = NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions.allZeros, error: &error) {
            if (error != nil) {
                printDebug("Could not convert dictionary object to JSON. \(error)")
            } else {
                return deviceJSON
            }
            
        } else {
            printDebug("Could not convert dictionary object to JSON.")
        }
        
        return NSData()
        
    }
    
    public func printDebug(message:String) {
        if _debug {
            print(TAG + message)
        }
    }
}