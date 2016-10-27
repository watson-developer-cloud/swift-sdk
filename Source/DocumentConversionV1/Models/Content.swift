/**
 * Copyright IBM Corporation 2016
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
 
 **Content**
 
 The content of an **AnswerUnit**
 
 */
public struct Content: JSONDecodable {
    
    /** The type of the content *text/plain, etc */
    public let mediaType: String?
    
    /** The text of the Answer Unit */
    public let text: String?
    
    /** used internally to initialize Content objects */
    public init(json: JSON) throws {
        mediaType = try? json.getString(at: "media_type")
        text = try? json.getString(at: "text")
    }
    
}
