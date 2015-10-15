//
//  WatsonAuthentication.swift
//  WatsonCore
//
//  Created by Glenn Fisher on 9/18/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation

/**
The WatsonAuthentication class is a concrete implementation of NSURLSessionTaskDelegate that simplifies support for HTTP basic authentication.

To support HTTP basic authentication for an NSURLSession, instantiate a WatsonAuthentication object to use as the NSURLSession's delegate:

let authentication = WatsonAuthentication(serviceURL, username: username, password: password)
let session = NSURLSession(configuration: sessionConfiguration, delegate: authentication, delegateQueue: nil)

:param: serviceURL A string representing the URL of a Watson service. The URL is used to verify the remote server before submitting credentials.
:param: username A string representing the username used to access a Watson service.
:param: password A string representing the password used to access a Watson service.
*/
public class WatsonAuthentication: NSObject, NSURLSessionTaskDelegate {
    
    private let prefix = "[WatsonAuthentication] "
    private let serviceURL: String
    private let username: String
    private let password: String
    
    public init(serviceURL: String, username: String, password: String) {
        
        self.serviceURL = serviceURL
        self.username = username
        self.password = password
        super.init()
        
    }
    


    /**
    This method handles task-level authentication challenges in response to an authentication request from a remote server. In particular, it implements support for HTTP basic authentication.
    
    The authentication request is canceled if any of the following conditions are met:
    - The remote server's URL does not match the service URL provided during initialization.
    - The authentication challenge has a non-zero previous failure count (including failures from *all* protection spaces, not just the current one).
    
    :param: session The session containing the task whose request requires authentication.
    :param: task The task whose request requires authentication.
    :param: challenge An object that contains the request for authentication.
    :param: A handler that your delegate method must call. Its parameters are:
            - disposition—One of several constants that describes how the challenge should be handled.
            - credential—The credential that should be used for authentication if disposition is NSURLSessionAuthChallengeUseCredential; otherwise, NULL.
    */
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
        // perform default handling for all authentication methods besides HTTP basic authentication
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPBasic else {
            let disposition = NSURLSessionAuthChallengeDisposition.PerformDefaultHandling
            let credential: NSURLCredential? = nil
            completionHandler(disposition, credential)
            return
        }
        
        // cancel authentication after any previous failures
        guard challenge.previousFailureCount == 0 else {
            Log.sharedLogger.error("WatsonAuthentication: Authentication request canceled due to previous authentication failure.")
            let disposition = NSURLSessionAuthChallengeDisposition.CancelAuthenticationChallenge
            let credential: NSURLCredential? = nil
            completionHandler(disposition, credential)
            return
        }
        
        // todo: cancel authentication if the remote server's URL does not match the provided service URL
        
        let disposition = NSURLSessionAuthChallengeDisposition.UseCredential
        let credential = NSURLCredential(user: username, password: password, persistence: .ForSession)
        completionHandler(disposition, credential)
        
    }

}