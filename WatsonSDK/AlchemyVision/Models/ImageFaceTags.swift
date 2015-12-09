/**
 * Copyright IBM Corporation 2015
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import SwiftyJSON
import ObjectMapper

/**
 *  Image face tags that holds the image faces array and transactions
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