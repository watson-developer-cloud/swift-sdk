//
//  ImageKeyWordsModel.swift
//  Alchemy
//
//  Created by Vincent Herrin on 9/30/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation
import WatsonCore

public class ImageKeyWordsModel : WatsonCore.BaseModel {

    var text = ""
    var score = 0.0
    
    init(text: String = "", score: Double = 0.0, rawData: AnyObject) {
        
        self.text = text
        self.score = score
        super.init(rawData: rawData)
    }
    
}