//
//  WatsonGateway.swift
//  WatsonCore
//
//  Created by Glenn R. Fisher on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//


/** DEPRECATED -- Use WatsonAuthentication instead. */



/* TODO

- Make requestAuthorizationToken private
- How should we handle the cookie that's returned?
- Support additional kinds of requests, beyond just dataTasks?
- Time alignment with NSDate mis-aligned with server
- Split out baseURL
- Create common logging class (rather than just print())

*/

import Foundation

public class WatsonGateway: NSObject, NSURLSessionTaskDelegate {
    
    private let baseURL = "https://stream.watsonplatform.net/authorization/api/v1/token"
    private let serviceURL: String
    private let username: String
    private let password: String
    public var token: String // debugging
    public var tokenExpiration: NSDate // debugging
    private var tokenDuration: NSTimeInterval = 1 * 55 * 60 // 55 minutes
    
    public init(serviceURL: String, username: String, password: String) {
        
        self.serviceURL = serviceURL
        self.username = username
        self.password = password
        self.token = ""
        self.tokenExpiration = NSDate()
        super.init()
        
    }
    
    public func requestAuthenticationToken(completionHandler: () -> Void) {
        
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
        let url = NSURL(string: "\(baseURL)?url=\(serviceURL)")
        if let url = url {
            
            let dataTask = session.dataTaskWithURL(url) { (let data, let response, let error) in
                
                if let statusCode = (response as? NSHTTPURLResponse)?.statusCode {
                    if statusCode == 200 {
                        if let data = data {
                            self.token = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
                            self.tokenExpiration = NSDate().dateByAddingTimeInterval(self.tokenDuration)
                            // update cookie?
                        }
                    } else {
                        print("Unexpected HTTP status code from Watson authentication server.")
                    }
                } else {
                    print("Error parsing response")
                }
                
                if let error = error {
                    print(error)
                }
                
                completionHandler()
            }
            
            dataTask.resume()
            
        } else {
            print("Error parsing URL.")
        }
        
    }
    
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
        // ensure basic auth
        let disposition: NSURLSessionAuthChallengeDisposition
        let credential: NSURLCredential?
        if challenge.previousFailureCount == 0 {
            disposition = NSURLSessionAuthChallengeDisposition.UseCredential
            credential = NSURLCredential(user: username, password: password, persistence: .None)
        } else {
            disposition = NSURLSessionAuthChallengeDisposition.CancelAuthenticationChallenge
            credential = nil
        }
        completionHandler(disposition, credential)
        
    }
    
    public func sendRequest(configuration: NSURLSessionConfiguration, url: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        
        func sendSession() {
            configuration.HTTPAdditionalHeaders = ["X-Watson-Authorization-Token": token]
            let session = NSURLSession(configuration: configuration)
            let dataTask = session.dataTaskWithURL(url, completionHandler: completionHandler)
            dataTask.resume()
        }
        
        let currentTime = NSDate()
        let expired = currentTime.compare(tokenExpiration) != NSComparisonResult.OrderedAscending
        if expired {
            requestAuthenticationToken(sendSession)
        } else {
            sendSession()
        }
        
    }
    
}