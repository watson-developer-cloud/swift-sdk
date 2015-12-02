//
//  WatsonRequest.swift
//  WatsonSDK
//
//  Created by Glenn Fisher on 11/19/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation
import Alamofire

/// HTTP method definitions
internal typealias HTTPMethod2 = Alamofire.Method

/**
 A WatsonRequest object represents a REST request supported by IBM Watson.
 It captures all arguments required to construct an HTTP request message
 and can represent itself as an NSMutableURLRequest for use with Alamofire.
 */
internal class WatsonRequest: URLRequestConvertible {
    
    /// The operation's HTTP method.
    let method: HTTPMethod2
    
    /// The service's URL.
    /// (e.g. "https://gateway.watsonplatform.net/personality-insights/api")
    let serviceURL: String
    
    /// The operation's endpoint. (e.g. "/v2/profile")
    let endpoint: String
    
    /// The acceptable MediaType of the response.
    let accept: MediaType?
    
    /// The MediaType of the message body.
    let contentType: MediaType?
    
    /// The query parameters to be encoded in the URL.
    let urlParams: [NSURLQueryItem]?
    
    /// A dictionary of parameters to be encoded in the header.
    let headerParams: [String: String]?
    
    /// The data to be included in the message body.
    let messageBody: NSData?
    
    /// A representation of the request as an NSMutableURLRequest.
    var URLRequest: NSMutableURLRequest {
        
        // construct URL
        let urlString = serviceURL + endpoint
        let urlComponents = NSURLComponents(string: urlString)!
        urlComponents.queryItems = urlParams
        let url = urlComponents.URL!
        
        // construct mutable base request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method.rawValue
        request.HTTPBody = messageBody
        
        // set accept type of request
        if let accept = accept {
            request.setValue(accept.rawValue, forHTTPHeaderField: "Accept")
        }
        
        // set content type of request
        if let contentType = contentType {
            request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        }
        
        // add user header parameters to request
        if let headerParams = headerParams {
            for (key, value) in headerParams {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // return request
        return request
    }
    
    /**
     Initialize a new WatsonRequest with the given arguments.
     
     - parameter method:       The operation's HTTP method.
     - parameter serviceURL:   The service's URL.
     - parameter endpoint:     The operation's endpoint. (e.g. "/v2/profile")
     - parameter accept:       The acceptable MediaType for the response.
     - parameter contentType:  The MediaType of the message body.
     - parameter urlParams:    The query parameters to be encoded in the URL.
     - parameter headerParams: A dictionary of parameters to be encoded in the header.
     - parameter messageBody:  The data to be included in the message body.
     
     - returns: A WatsonRequest object for use with Alamofire.
     */
    init(
        method: HTTPMethod2,
        serviceURL: String,
        endpoint: String,
        accept: MediaType? = nil,
        contentType: MediaType? = nil,
        urlParams: [NSURLQueryItem]? = nil,
        headerParams: [String: String]? = nil,
        messageBody: NSData? = nil) {
            
        self.method = method
        self.serviceURL = serviceURL
        self.endpoint = endpoint
        self.accept = accept
        self.contentType = contentType
        self.urlParams = urlParams
        self.headerParams = headerParams
        self.messageBody = messageBody
    }
}