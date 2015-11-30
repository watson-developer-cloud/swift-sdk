//
//  VisionImage.swift
//  VisionInsights
//
//  Created by Vincent Herrin on 11/28/15.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit
import WatsonSDK

class VisionImage: NSObject {
    var name: String
    var image: String
    var gender: String {
        var genderValue = ""
        if (self.imageFaceTags.imageFaces.count > 0) {
            genderValue = (self.imageFaceTags.imageFaces[0].gender["gender"]!.description)
        }
        return genderValue
    }
    var age: String {
        var ageValue = ""
        if(self.imageFaceTags.imageFaces.count > 0) {
            ageValue = (self.imageFaceTags.imageFaces[0].age["ageRange"]?.description)!
        }
        return ageValue
    }
    var ageScore: String {
        var ageScoreValue = ""
        if(self.imageFaceTags.imageFaces.count > 0) {
            ageScoreValue = (self.imageFaceTags.imageFaces[0].age["score"]!.description)
        }
        return ageScoreValue
    }
    
    private var imageFaceTags: ImageFaceTags

    init(name: String, image: String, imageFaceTags: ImageFaceTags) {
        self.name = name
        self.image = image
        self.imageFaceTags = imageFaceTags
        super.init()
    }
}