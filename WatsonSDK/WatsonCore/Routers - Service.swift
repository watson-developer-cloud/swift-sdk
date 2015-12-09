//
//  WatsonService.swift
//  WatsonSDK
//
//  Created by Glenn Fisher on 11/17/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation

/// The superclass for all Watson services.
public class WatsonService {
    
    /// The client's username for the service.
    internal let user: String
    
    /// The client's password for the service.
    internal let password: String
    
    /**
     Initialize a new service with the given credentials.
     
     - parameter user:     The username for the service.
     - parameter password: The password for the service.
     
     - returns: An instantiation of the service.
     */
    init(user: String, password: String) {
        self.user = user
        self.password = password
    }
}

/// The superclass for all Alchemy services.
public class AlchemyService {
    
    /// The client's Alchemy API key credential for the service.
    internal let AlchemyAPIKey: String
    
    /**
     Initialize a new service with the given credentials.

     - parameter AlchemyAPIKey: The API key used to authenticate with the service.
    
     - returns: An instantiation of the service.
     */
    init(AlchemyAPIKey: String) {
        self.AlchemyAPIKey = AlchemyAPIKey
    }
}