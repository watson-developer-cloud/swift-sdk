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

public struct TextToSpeechResponse: Mappable {
    
    var voices: [Voice]?
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
     
        voices      <-  map["voices"]
    }
}

public struct Voice: Mappable {
    
    // URL for addressing the voice in a synthesize call
    var url: String?
    
    // Gender of the voice
    var gender: String?
    
    // Name of the voice
    var name: String?
    
    // Language of the voice
    var language: String?
    
    // Description of the voice
    var description: String?
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        url         <- map["url"]
        gender      <- map["gender"]
        name        <- map["name"]
        language    <- map["language"]
        description <- map["description"]
    }
    
}