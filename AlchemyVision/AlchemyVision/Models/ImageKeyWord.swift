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


private enum ImageKeyWordEnum:String {
    case Text = "text"
    case Score = "score"
}

public struct ImageKeyWord {

    var text = ""
    var score = 0.0
    
    init(text: String, score: Double) {
        self.text = text
        self.score = score
    }
    
    init(json: JSON) {
        text    = json[ImageKeyWordEnum.Text.rawValue].stringValue
        score   = json[ImageKeyWordEnum.Score.rawValue].doubleValue
    }
}