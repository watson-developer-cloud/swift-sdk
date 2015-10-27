//
//  Service.swift
//  WatsonCore
//
//  Created by Karl Weinmeister on 10/26/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation

/**
Watson service types

- Streaming: Watson services using streaming, i.e. Text to Speech and Speech to Text
- Standard: Other Watson services written by IBM team
- Alchemy: Alchemy Watson services
*/
public enum ServiceType: String {
    case Streaming = "stream.watsonplatform.net"
    case Standard = "gateway.watsonplatform.net"
    case Alchemy = "gateway-a.watsonplatform.net"
}

public class Service {
    private let _protocol = "https"
    private let _host: String
    private let _serviceURL: String
    public var _apiKey: String!
    
    public func getEndpoint(path:String) -> String {
        let endpoint = _protocol + "://" + _host + _serviceURL + path
        Log.sharedLogger.info("getEndpoint(): \(endpoint)")
        return endpoint
    }
    
    public init(type:ServiceType = ServiceType.Standard, serviceURL:String)
    {
        _host = type.rawValue
        _serviceURL = serviceURL
    }
    
    public convenience init(type:ServiceType = ServiceType.Standard, serviceURL:String, apiKey:String)
    {
        self.init(type:type, serviceURL:serviceURL)
        _apiKey = apiKey
    }
    
    public convenience init(type:ServiceType = ServiceType.Standard, serviceURL:String, username:String, password:String)
    {
        self.init(type:type, serviceURL:serviceURL)
        setUsernameAndPassword(username, password:password)
    }
    
    /**
    Sets the username and password on the service for invocation. Combines both together into an API Key.
    
    - parameter username: username
    - parameter password: password
    */
    public func setUsernameAndPassword(username:String, password:String)
    {
        let authorizationString = username + ":" + password
        _apiKey = "Basic " + (authorizationString.dataUsingEncoding(NSASCIIStringEncoding)?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding76CharacterLineLength))!
    }
}