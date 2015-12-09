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
 *  ImageFace contains attribute information of height, width, positionX, positionY, age and gender
 */
public struct ImageFace : Mappable {
  
    public var age         = [String: AnyObject]()
    public var gender      = [String: AnyObject]()
    public var height:     Int?
    public var positionX:  Int?
    public var positionY:  Int?
    public var width:      Int?
  
    // this will go away once objectmapper can handle pointers
    init(json: JSON) {
        
        height      = json["height"].intValue
        width       = json["width"].intValue
        positionX   = json["positionX"].intValue
        positionY   = json["positionY"].intValue
        
        for (key,subJson):(String, JSON) in json["age"] {
            age[key] = subJson.object
        }
        
        for (key,subJson):(String, JSON) in json["gender"] {
            gender[key] = subJson.object
        }
    }
    
    public init() {
        
    }
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        height      <-  (map["height"], Transformation.stringToInt)
        width       <-  (map["width"], Transformation.stringToInt)
        positionX   <-   map["positionX"]
        positionY   <-   map["positionY"]
        age         <-   map["age"]
        gender      <-   map["gender"]
    }
}
