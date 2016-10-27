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
import RestKit

/**
 
 **ImageKeyword**
 
 A set of keywords for an image analyzed by the Alchemy Vision service.
 
 */

public struct ImageKeyword: JSONDecodable {
    
    /** A keyword that is associated with the specified image. */
    public let text: String?
    
    /** The likelihood that this keyword corresponds to the image. */
    public let score: Double?
    
    /// Used internally to initialize an ImageKeyword object
    public init(json: JSON) throws {
        text = try? json.getString(at: "text")
        if let scoreString = try? json.getString(at: "score") {
            score = Double(scoreString)
        } else {
            score = nil
        }
    }
}
