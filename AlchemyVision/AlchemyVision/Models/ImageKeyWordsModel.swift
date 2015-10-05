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

    internal var text = ""
    internal var score = 0.0
    
    init(text: String, score: Double, rawData: NSData) {
        
        self.text = text
        self.score = score
        super.init()
    }
}