//
//  SpeechToTextStop.swift
//  WatsonDeveloperCloud
//
//  Created by Glenn Fisher on 1/28/16.
//  Copyright © 2016 Glenn R. Fisher. All rights reserved.
//

import Foundation
import ObjectMapper

/** Signals the end of an audio transmission to Speech to Text. */
struct SpeechToTextStop: Mappable {

    /// The action to perform. Must be `stop` to end the request.
    private var action = "stop"

    /// Initialize a stop action.
    init() { }

    /// Used internally to initialize a `SpeechToTextStop` from JSON.
    init?(_ map: Map) { }

    /// Used internally to serialize and deserialize JSON.
    mutating func mapping(map: Map) {
        action <- map["action"]
    }
}
