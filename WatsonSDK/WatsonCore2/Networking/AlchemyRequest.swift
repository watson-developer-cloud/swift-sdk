//
//  AlchemyRequest.swift
//  WatsonSDK
//
//  Created by Glenn Fisher on 11/19/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation
import Alamofire

/**
 An AlchemyRequest object represents a REST request supported by an IBM Watson AlchemyAPI
 service. The object captures all arguments required to construct an HTTP requst message
 and can represent itself as an NSMutableURLRequest for use with Alamofire.
 */
internal class AlchemyRequest: WatsonRequest {
    
    /**
     Initialize a new AlchemyRequest with the given arguments.
     
     - parameter method:       The operation's HTTP method.
     - parameter serviceURL:   The service's URL.
     - parameter endpoint:     The operation's endpoint. (e.g. "/v2/profile")
     - parameter accept:       The acceptable MediaType for the response.
     - parameter contentType:  The MediaType of the message body.
     - parameter apiKey:       An Alchemy API key credential.
     - parameter urlParams:    The query parameters to be encoded in the URL.
     - parameter headerParams: A dictionary of parameters to be encoded in the header.
     - parameter messageBody:  The data to be included in the message body.
     
     - returns: An AlchemyRequest object for use with Alamofire.
     */
    init(
        method: HTTPMethod,
        serviceURL: String,
        endpoint: String,
        accept: MediaType? = nil,
        contentType: MediaType? = nil,
        apiKey: String,
        urlParams: [NSURLQueryItem]? = nil,
        headerParams: [String: String]? = nil,
        messageBody: NSData? = nil) {
        
        // add apiKey to the url-encoded query parameters
        var urlParamsWithKey = [NSURLQueryItem]()
        if let urlParams = urlParams { urlParamsWithKey = urlParams }
        urlParamsWithKey.append(NSURLQueryItem(name: "apikey", value: apiKey))
        
        // construct a WatsonRequest
        super.init(
            method: method,
            serviceURL: serviceURL,
            endpoint: endpoint,
            accept: accept,
            contentType: contentType,
            urlParams: urlParamsWithKey,
            headerParams: headerParams,
            messageBody: messageBody)
    }
}