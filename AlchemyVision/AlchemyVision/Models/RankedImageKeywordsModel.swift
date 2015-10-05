//
//  File.swift
//  Alchemy
//
//  Created by Vincent Herrin on 9/30/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation

public class RankedImageKeywordsModel: BaseModel {
    
    internal var totalTransactions: Int = -1
    internal var imageKeyWords: [ImageKeyWordsModel] = []

    
    init(totalTransactions: Int, imageKeyWords: [ImageKeyWordsModel], resultStatus: ResultStatusModel, rawData: NSData) {

        self.totalTransactions = totalTransactions
        self.imageKeyWords = imageKeyWords
       
        super.init()
        self.rawData = rawData
    }

    override init() {
        super.init()
    }
    
    public static func getRankedImageKeywordsModel(rawData: NSData)->RankedImageKeywordsModel {
        
        let rankedImageKeywords = RankedImageKeywordsModel()
        do {
            let xmlDoc = try AEXMLDocument(xmlData: rawData)
            
            #if DEBUG
                
                // prints the same XML structure as original
                print(xmlDoc.xmlString)
                
                for child in xmlDoc.root.children {
                    print(child.name)
                }
                
            #endif
            
            //let rankedImageKeywords = RankedImageKeywordsModel()
            
            
            var tempImageKeyWords : [ImageKeyWordsModel] = []
            if let imageKeywords = xmlDoc.root["imageKeywords"]["keyword"].all {
                for keyword in imageKeywords {
                    
                    var imageKeyword = ImageKeyWordsModel(text: keyword["text"].stringValue, score: keyword["score"].doubleValue, rawData: rawData)
                    tempImageKeyWords.append(imageKeyword)
                }
            }
            
          //  rankedImageKeywords = RankedImageKeywordsModel(xmlDoc.root["totalTransactions"].intValue, tempImageKeyWords, rawData)
            rankedImageKeywords.totalTransactions = xmlDoc.root["totalTransactions"].intValue
            rankedImageKeywords.rawData = rawData
            rankedImageKeywords.imageKeyWords = tempImageKeyWords
        }
        catch{
            print("\(error)")
            rankedImageKeywords.modelError = "Failed to create RankedImageKeywordsModel - " + Constants.Status.ERROR.rawValue
        }
       
        return rankedImageKeywords
    }
    
}