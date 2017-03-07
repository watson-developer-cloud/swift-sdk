/**
 * Copyright IBM Corporation 2017
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
import RestKit

/** An object containing information about speaker label object. */
public struct SpeakerLabel: JSONDecodable {
    
    public let fromTime: Double
    public let toTime: Double
    public let confidence: Double
    public let speaker: Int
    public let final: Bool
    
    public init(json: JSON) throws {
        let dict = try json.getDictionaryObject()
        
        fromTime = dict["from"] as! Double
        toTime = dict["to"] as! Double
        confidence = dict["confidence"] as! Double
        speaker = dict["speaker"] as! Int
        final = dict["final"] as! Bool
    }
}
