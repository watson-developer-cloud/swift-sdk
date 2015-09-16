//
//  WatsonGateway.swift
//  WatsonCore
//
//  Created by Glenn Fisher on 9/16/15.
//  Copyright © 2015 MIL. All rights reserved.
//

/* TODO:

    - Can the expiration date be set based on the response from the service?
      That way it would be robust to any API changes (e.g. 60 minute TTL reduced to 15 minutes).

*/

import Foundation

public class WatsonGateway {
    
    private let baseURL = "https://stream.watsonplatform.net/authorization/api/v1/token"
    private let username: String
    private let password: String
    private var token: String
    private var expirationDate: Date
    
    
}
