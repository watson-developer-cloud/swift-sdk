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

public enum ImageFaceEnum: String {
    case Age        = "age"
    case Gender     = "gender"
    case Height     = "height"
    case Width      = "width"
    case PostionX   = "postionX"
    case PostionY   = "postionY"
}

public struct ImageFace {
    
    var age         = [String: AnyObject]()
    var gender      = [String: AnyObject]()
    var height      = 0
    var positionX   = 0
    var positionY   = 0
    var width       = 0
    
    init(age: [String: AnyObject], gender: [String: AnyObject], height: Int, width: Int, positionX: Int, positionY: Int) {
        self.height     = height
        self.width      = width
        self.positionX  = positionX
        self.positionY  = positionY
        self.age        = age
        self.gender     = gender
    }
    
    init(json: JSON) {
        
        height      = json[ImageFaceEnum.Height.rawValue].intValue
        width       = json[ImageFaceEnum.Width.rawValue].intValue
        positionX   = json[ImageFaceEnum.PostionX.rawValue].intValue
        positionY   = json[ImageFaceEnum.PostionY.rawValue].intValue
        
        for (key,subJson):(String, JSON) in json[ImageFaceEnum.Age.rawValue] {
            age[key] = subJson.object
        }
        
        for (key,subJson):(String, JSON) in json[ImageFaceEnum.Gender.rawValue] {
            gender[key] = subJson.object
        }
    }
}