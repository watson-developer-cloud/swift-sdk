//
//  WatsonError.swift
//  WatsonSDK
//
//  Created by Glenn Fisher on 12/15/15.
//  Copyright © 2015 IBM Watson Developer Cloud. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 A WatsonError object represents the structure of an error response from Watson.
 It can be instantiated from response data using ObjectMapper and can be
 conveniently passed to clients by representing itself as an NSError.
 */
protocol WatsonError: Mappable {
    var nsError: NSError { get }
}