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
 
 **Microformat**
 
 Semantic information extracted from a document by the AlchemyLanguage service
 
 */

public struct Microformat: JSONDecodable {
    
    /** Microformat field data */
    public let fieldData: String?
    
    /** Microformat field name */
    public let fieldName: String?
    
    /// Used internally to initialize a Microformat object
    public init(json: JSON) throws {
        fieldData = try? json.getString(at: "fieldData")
        fieldName = try? json.getString(at: "fieldName")
    }
}

