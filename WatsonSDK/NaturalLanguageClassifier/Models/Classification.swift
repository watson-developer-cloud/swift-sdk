//
//  Classification.swift
//  NaturalLanguageClassifier
//
//  Created by Vincent Herrin on 11/7/15.
//  Copyright © 2015 IBM. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Classification: Mappable {
    var id: String?
    var url: String?
    var text: String?
    var topClass: String?
    var topConfidence: Double? {
        guard let classes = self.classes else {
            return nil
        }
        var double = 0.0
        for classifiedClass in classes {
            if(classifiedClass.name == topClass) {
                double = classifiedClass.confidence!
            }
        }
        return double
    }
    var classes: [ClassifiedClass]?
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        id        <- map["classifier_id"]
        text      <- map["text"]
        url       <- map["url"]
        topClass  <- map["top_class"]
        classes   <- map["classes"]
    }
}