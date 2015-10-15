//
//  ImageKeyWordsModel.swift
//  Alchemy
//
//  Created by Vincent Herrin on 9/30/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation
import WatsonCore
import SwiftyJSON


public struct ImageKeyWord {

    public let text: String
    public let score: Double
    
    init(text: String, score: Double) {
        
        self.text = text
        self.score = score
    }
}