//
//  WatsonGateway.swift
//  WatsonCore
//
//  Created by Glenn R. Fisher on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

/* TODO

    - Make requestAuthorizationToken private
    - How should we handle the cookie that's returned?
    - Support additional kinds of requests, beyond just dataTasks?
    - Time alignment with NSDate mis-aligned with server
    - Split out baseURL

*/

import Foundation

public class WatsonGateway: NSObject, NSURLSessionDelegate {
    
    private let baseURL = "https://stream.watsonplatform.net/authorization/api/v1/token"
    private let serviceURL: String
    private let username: String
    private let password: String
    private var token: String
    private var tokenExpiration: NSDate
    
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
        let url = NSURL(string: "\(baseURL)?\(serviceURL)")
        if let url = url {
            let dataTask = session.dataTaskWithURL(url) {
                (let data, let response, let error) in
                print(data)
                print(response)
                print(error)
                // todo: update token, expiration, and cookie?
                completionHandler()
            }
            dataTask.resume()
        }
        
    }
    
    public func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
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
        if currentTime >= tokenExpiration {
            requestAuthenticationToken(sendSession)
        } else {
            sendSession()
        }
        
    }
    
}