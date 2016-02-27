//
//  SpeechToTextStop.swift
//  WatsonDeveloperCloud
//
//  Created by Glenn Fisher on 1/28/16.
//  Copyright © 2016 Glenn R. Fisher. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 A `SpeechToTextStop` object signals the end of an audio transmission to Watson Speech to Text.
 */
struct SpeechToTextStop: Mappable {

    /// The action to perform. Must be `stop` to end the request.
    private var action = "stop"

    init() { }

    init?(_ map: Map) { }

    mutating func mapping(map: Map) {
        action <- map["action"]
    }
}
