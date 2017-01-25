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


public struct SemanticRolesObject: JSONDecodable,JSONEncodable {
    /// Object text
    public let text: String?
    
    public let keywords: [SemanticRolesKeyword]?

    /**
     Initialize a `SemanticRolesObject` with required member variables.


     - returns: An initialized `SemanticRolesObject`.
    */
    public init() {
    }

    /**
    Initialize a `SemanticRolesObject` with all member variables.

     - parameter text: Object text
     - parameter keywords: 

    - returns: An initialized `SemanticRolesObject`.
    */
    public init(text: String, keywords: [SemanticRolesKeyword]) {
        self.text = text
        self.keywords = keywords
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `SemanticRolesObject` model from JSON.
    public init(json: JSON) throws {
        text = try? json.getString(at: "text")
        keywords = try? json.getString(at: "keywords")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `SemanticRolesObject` model to JSON.
    func toJSONObject() -> Any {
        var json = [String: Any]()
        if let text = text { json["text"] = text }
        if let keywords = keywords {
            json["keywords"] = keywords.map { keywordsElem in keywordsElem.toJSONObject() }
        }
        return json
    }
}
