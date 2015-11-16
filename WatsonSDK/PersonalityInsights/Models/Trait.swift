//
//  Trait.swift
//  PersonalityInsights
//
//  Created by Karl Weinmeister on 10/28/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 *  A recursive model that contains information about a personality trait
 */
public struct Trait: Mappable {
    var ID:String?
    var name:String?
    var category:String?
    var percentage:Double?
    var samplingError:Double?
    var rawScore:Double?
    var rawSamplingError:Double?
    var children:[Trait]?
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        ID                  <- map["id"]
        name                <- map["name"]
        category            <- map["category"]
        percentage          <- map["percentage"]
        samplingError       <- map["sampling_error"]
        rawScore            <- map["raw_score"]
        rawSamplingError    <- map["raw_sampling_error"]
        children            <- map["children"]
    }
}