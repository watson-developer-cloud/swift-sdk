//
//  ImageFaceTags.swift
//  AlchemyVision
//
//  Created by Vincent Herrin on 10/20/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

/**
 *  <#Description#>
 */
public struct ImageFaceTags : Mappable {
  
  
    var totalTransactions: Int?
    public var imageFaces: [ImageFace] = []
    
    init(totalTransactions: Int, imageFaces: [ImageFace]) {
        
        self.totalTransactions = totalTransactions
        self.imageFaces = imageFaces
    }
  
  /**
   This populates the ImageFaceTags object from the payload
   
   - parameter anyObject: Payload from request call
   
   TODO: This will be removed once ObjectMapper supports StringPointers
   */
    init(anyObject: AnyObject?) {
        guard let anyObject = anyObject else {
            Log.sharedLogger.debug("Nil object passed into initializer")
            return
        }
        var data = JSON(anyObject)
        
        var capturedImageFaces: [ImageFace] = []
        for (_,subJson):(String, JSON) in data["imageFaces"] {
            let imageFace = ImageFace(json: subJson)
            capturedImageFaces.append(imageFace)
        }
        self.imageFaces = capturedImageFaces
        self.totalTransactions = data["totalTransactions"].intValue
    }
    
    public init() {
        
    }
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        totalTransactions   <- (map["totalTransactions"], Transformation.stringToInt)
        imageFaces          <- map["imageFaces"]
    }
    
}