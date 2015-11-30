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
    var gender: String? { return (self.imageFaceTags.imageFaces[0].gender["gender"]?.description) }
    var age: String? { return (self.imageFaceTags.imageFaces[0].age["ageRange"]?.description) }
    var ageScore: String? { return (self.imageFaceTags.imageFaces[0].age["score"]?.description) }
    
    private var imageFaceTags: ImageFaceTags

    init(name: String, image: String, imageFaceTags: ImageFaceTags) {
        self.name = name
        self.image = image
        self.imageFaceTags = imageFaceTags
        super.init()
    }
}