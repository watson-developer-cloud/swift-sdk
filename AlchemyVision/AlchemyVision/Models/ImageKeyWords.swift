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

private enum ImageKeyWordsEnum: String {
    case ImageKeywords = "imageKeywords"
    case TotalTransactions = "totalTransactions"
}

public struct ImageKeyWords {
    
    public let totalTransactions: Int
    public let imageKeyWords: [ImageKeyWord]
    
    init(totalTransactions: Int, imageKeyWords: [ImageKeyWord]) {
        self.totalTransactions = totalTransactions
        self.imageKeyWords = imageKeyWords
    }
    
    init(anyObject: AnyObject?) {
        guard let anyObject = anyObject else {
            Log.sharedLogger.debug("Nil object passed into initializer")
            totalTransactions = 0
            imageKeyWords = []
            return
        }

        var data = JSON(anyObject)
        
        var capturedImageKeywords: [ImageKeyWord] = []
        for (_,subJson):(String, JSON) in data[ImageKeyWordsEnum.ImageKeywords.rawValue] {
            let imageKeyword = ImageKeyWord(json: subJson)
            capturedImageKeywords.append(imageKeyword)
        }
        self.imageKeyWords = capturedImageKeywords
        self.totalTransactions = data[ImageKeyWordsEnum.TotalTransactions.rawValue].intValue
    }
    
}
