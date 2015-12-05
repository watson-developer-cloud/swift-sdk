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
 *  A recursive model that contains information about a personality trait
 */
public struct Trait: Mappable {
    var ID:String?
    var name:String?
    var category:String?
    var percentage:Double?
    var samplingError:Double?
    var rawScore:Double?
    var rawSamplingError:Double?
    var children:[Trait]?
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        ID                  <- map["id"]
        name                <- map["name"]
        category            <- map["category"]
        percentage          <- map["percentage"]
        samplingError       <- map["sampling_error"]
        rawScore            <- map["raw_score"]
        rawSamplingError    <- map["raw_sampling_error"]
        children            <- map["children"]
    }
}