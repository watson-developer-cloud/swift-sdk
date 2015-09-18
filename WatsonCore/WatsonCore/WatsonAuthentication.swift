//
//  WatsonAuthentication.swift
//  WatsonCore
//
//  Created by Glenn Fisher on 9/18/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation

public class WatsonAuthentication: NSObject, NSURLSessionTaskDelegate {
    
    private let serviceURL: String
    private let username: String
    private let password: String
    
    public init(serviceURL: String, username: String, password: String) {
        
        self.serviceURL = serviceURL
        self.username = username
        self.password = password
        super.init()
        
    }

    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
        // todo: check against service url?
        // todo: ensure http basic auth?
        
        let disposition: NSURLSessionAuthChallengeDisposition
        let credential: NSURLCredential?
        if challenge.previousFailureCount == 0 {
            disposition = NSURLSessionAuthChallengeDisposition.UseCredential
            credential = NSURLCredential(user: username, password: password, persistence: .ForSession)
        } else {
            disposition = NSURLSessionAuthChallengeDisposition.CancelAuthenticationChallenge
            credential = nil
        }
        completionHandler(disposition, credential)
        
    }

}