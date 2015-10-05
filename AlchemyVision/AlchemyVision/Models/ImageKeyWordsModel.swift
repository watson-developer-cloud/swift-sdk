//
//  ImageKeyWordsModel.swift
//  Alchemy
//
//  Created by Vincent Herrin on 9/30/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation

public class ImageKeyWordsModel : BaseModel {

    internal var text = ""
    internal var score = 0.0
    
    init(text: String, score: Double, rawData: NSData) {
        
        self.text = text
        self.score = score
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    /**
    Helper method to create an instance of ResultStatusModel
    
    - parameter rawData: <#rawData description#>
    
    - returns: <#return value description#>
    */
    public static func getRankedImageKeywordsModel(rawData: NSData)->ImageKeyWordsModel {
        
        let imageKeyWordsModel = ImageKeyWordsModel()
        do {
            let xmlDoc = try AEXMLDocument(xmlData: rawData)
            
            #if DEBUG
                
                // prints the same XML structure as original
                print(xmlDoc.xmlString)
                
                for child in xmlDoc.root.children {
                    print(child.name)
                }
                
            #endif
            
        }
        catch{
            print("\(error)")
        }
        
        imageKeyWordsModel.modelError = "failed to create ImageKeyWordsModel - " + Constants.Status.ERROR.rawValue
        return imageKeyWordsModel
    }
    
}