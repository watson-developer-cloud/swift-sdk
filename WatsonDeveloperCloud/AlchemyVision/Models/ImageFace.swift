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
import ObjectMapper

/**
 *  ImageFace contains attribute information of height, width, positionX, positionY, age and gender
 */
public struct ImageFace : Mappable {
  
    /// Approximate age range for a detected face (with an associated confidence score)
    public var age         = [String: AnyObject]()
    /// Gender for a detected face (with an associated confidence score)
    public var gender      = [String: AnyObject]()
    /// Height, in pixels, of a detected face
    public var height:     Int?
    /// Coordinate of the left-most pixel for a detected face
    public var positionX:  Int?
    /// Coordinate of the top-most pixel for a detected face
    public var positionY:  Int?
    /// Width, in pixels, of a detected face
    public var width:      Int?

    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        
        Log.sharedLogger.error("ERRRRRR \(map[""])")
        
        height      <-  (map["height"], Transformation.stringToInt)
        width       <-  (map["width"], Transformation.stringToInt)
        positionX   <-  (map["positionX"], Transformation.anyObjectToInt)
        positionY   <-  (map["positionY"], Transformation.anyObjectToInt)
        age         <-   map["age"]
        gender      <-   map["gender"]
    }
}
