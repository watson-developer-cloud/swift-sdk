//
//  ContentItem.swift
//  PersonalityInsights
//
//  Created by Karl Weinmeister on 10/28/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import Foundation
import ObjectMapper

public struct ContentItem: Mappable {

    var ID:String?
    var userID: String?
    var sourceID: String?
    var created: Int?
    var updated: Int?
    var contentType: String?
    var charset: String?
    var language: String?
    var content: String?
    var parentID: String?
    var reply: Bool?
    var forward: Bool?
    
    public init?(_ map: Map) {}
    
    public init(ID:String?, userID:String?, sourceID:String?, created:Int?, updated:Int?, contentType:String?, charset:String?, language:String?, content:String?, parentID:String?, reply:Bool?, forward:Bool?) {
        self.ID = ID
        self.userID = userID
        self.sourceID = sourceID
        self.created = created
        self.updated = updated
        self.contentType = contentType
        self.charset = charset
        self.language = language
        self.content = content
        self.parentID = parentID
        self.reply = reply
        self.forward = forward
    }
    
    public mutating func mapping(map: Map) {
        ID          <- map["id"]
        userID      <- map["userid"]
        sourceID    <- map["sourceid"]
        created     <- map["created"]
        updated     <- map["updated"]
        contentType <- map["contenttype"]
        charset     <- map["charset"]
        language    <- map["language"]
        content     <- map["content"]
        parentID    <- map["parentid"]
        reply       <- map["reply"]
        forward     <- map["forward"]
    }
}