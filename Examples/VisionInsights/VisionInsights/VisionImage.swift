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
    var age: String {

        return self.imageFaceTags.imageFaces[0].age.description
    }
    
    private var imageFaceTags: ImageFaceTags

    init(name: String, image: String, imageFaceTags: ImageFaceTags) {
        self.name = name
        self.image = image
        self.imageFaceTags = imageFaceTags
        super.init()
    }
}