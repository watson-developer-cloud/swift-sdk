//
//  ImageKeyWords.swift
//  AlchemyVision
//
//  Created by Vincent Herrin on 10/13/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation
import SwiftyJSON
import WatsonCore

// ImageKeyWordsEnum

public struct ImageKeyWords {
    
    public let totalTransactions: Int
    public let imageKeyWords: [ImageKeyWord]
    
    init(totalTransactions: Int, imageKeyWords: [ImageKeyWord]) {
        
        self.totalTransactions = totalTransactions
        self.imageKeyWords = imageKeyWords
    }
    
    init(anyObject: AnyObject) {
        var data = JSON(anyObject)
        
        var capturedImageKeywords : [ImageKeyWord] = []
        
        for (_,subJson):(String, JSON) in data["imageKeywords"] {
            let imageKeyword = ImageKeyWord(text: subJson["text"].stringValue, score: subJson["score"].doubleValue)
            capturedImageKeywords.append(imageKeyword)
        }
        
        self.imageKeyWords = capturedImageKeywords
        self.totalTransactions = data["totalTransactions"].intValue
    }
    
}
