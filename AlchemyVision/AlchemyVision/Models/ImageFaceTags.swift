//
//  ImageFaceTags.swift
//  AlchemyVision
//
//  Created by Vincent Herrin on 10/20/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation
import SwiftyJSON
import WatsonCore

public enum ImageFaceTagsEnum: String {
    case TotalTransactions  = "totalTransactions"
    case ImageFaces         = "imageFaces"
}

public struct ImageFaceTags {
    
    var totalTransactions = 0
    var ImageFaces: [ImageFace] = []
    
    init(totalTransactions: Int, imageFaces: [ImageFace]) {
        
        self.totalTransactions = totalTransactions
        self.ImageFaces = imageFaces
    }
    
    init(anyObject: AnyObject) {
        var data = JSON(anyObject)
        
        var capturedImageFaces: [ImageFace] = []
        for (_,subJson):(String, JSON) in data[ImageFaceTagsEnum.ImageFaces.rawValue] {
            let imageFace = ImageFace(json: subJson)
            capturedImageFaces.append(imageFace)
        }
        self.ImageFaces = capturedImageFaces
        self.totalTransactions = data[ImageFaceTagsEnum.TotalTransactions.rawValue].intValue
    }
    
}