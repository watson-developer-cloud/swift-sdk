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
import Freddy

/**
 
 **SAORelations**
 
 Response object for **SAORelation** related calls
 
 */

public struct SAORelations: JSONDecodable {
    
    /** extracted language */
    public let language: String?
    
    /** the URL information was requested for */
    public let url: String?
    
    /** document text */
    public let text: String?
    
    /** see **SAORelation** */
    public let relations: [SAORelation]?
    
    /// Used internally to initialize a SAORelations object
    public init(json: JSON) throws {
        language = try? json.string("language")
        url = try? json.string("url")
        text = try? json.string("text")
        relations = try? json.arrayOf("relations", type: SAORelation.self)
    }
}

