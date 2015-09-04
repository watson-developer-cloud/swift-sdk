//
//  LanguageTranslationUtils.swift
//  LanguageTranslationSDK
//
//  Created by Karl Weinmeister on 9/3/15.
//  Copyright (c) 2015 IBM MIL. All rights reserved.
//

//TODO: Move this to a common project
//TODO: Document this class and functions
import Foundation

public class LanguageTranslationUtils {
    private var _debug: Bool = true
    private let TAG = "[LanguageTranslationSDK] "
    private let _httpContentTypeHeader = "Accept"
    private let _httpAuthorizationHeader = "Authorization"
    private let _contentTypeJSON = "application/json"
    public var apiKey: String!

    public func buildRequest(endpoint:String, method:String, body: NSData?) -> NSURLRequest {
        
        if let url = NSURL(string: endpoint) {
            
            let request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = method
            request.addValue(apiKey, forHTTPHeaderField: _httpAuthorizationHeader)
            request.addValue(_contentTypeJSON, forHTTPHeaderField: _httpContentTypeHeader)
            
            if let bodyData = body {
                request.HTTPBody = bodyData
            }
            
            return request
        }
        
        return NSURLRequest()
    }

    
    public func performRequest(request:NSURLRequest, callback:(NSDictionary!)->()) {
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error in
            
            if (error != nil) {
                print(error)
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
                    }
                    
                } else {
                    self.printDebug("No response data.")
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
            println(TAG + message)
        }
    }
}