//
//  WatsonSpeechToTextModel.swift
//  WatsonSpeechToText
//
//  Created by Glenn Fisher on 9/22/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation

public struct WatsonSpeechToTextModel {
    
    let name: String
    let rate: Int
    let language: String
    let description: String
    let url: String
    
    init(name: String, rate: Int, language: String, description: String, url: String) {
        
        self.name = name
        self.rate = rate
        self.language = language
        self.description = description
        self.url = url
        
    }
    
}

/** Watson Speech to Text Models */
let en_us_broadbandModel = "en-US_BroadbandModel"
let en_us_narrowbandModel = "en-US_NarrowbandModel"
let es_us_broadbandModel = "es-ES_BroadbandModel"
let es_us_narrowbandModel = "es-ES_NarrowbandModel"
let ja_us_broadbandModel = "ja-JP_BroadbandModel"
let ja_us_narrowbandModel = "ja-JP_NarrowbandModel"
let pt_us_broadbandModel = "pt-BR_BroadbandModel"
let pt_us_narrowbandModel = "pt-BR_NarrowbandModel"
let zh_us_broadbandModel = "zh-CN_BroadbandModel"
let zh_us_narrowbandModel = "zh-CN_NarrowbandModel"

// todo: write tests for these models