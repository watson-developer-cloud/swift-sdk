//
//  Profile.swift
//  PersonalityInsights
//
//  Created by Karl Weinmeister on 10/27/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Profile: Mappable {
    //var tree:TraitTreeNode?
    var ID:String?
    var source:String?
    var wordCount:Int?
    var wordCountMessage:Int?
    var processedLang:String?
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        ID                  <- map["id"]
        source              <- map["source"]
        wordCount           <- map["word_count"]
        wordCountMessage    <- map["word_count_message"]
        processedLang       <- map["processed_lang"]
    }
}