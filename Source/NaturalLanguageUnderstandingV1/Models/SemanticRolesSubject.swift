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


public struct SemanticRolesSubject: JSONDecodable,JSONEncodable {
    /// Text that corresponds to the subject role
    public let text: String?
    
    public let entities: [SemanticRolesEntity]?
    
    public let keywords: [SemanticRolesKeyword]?

    /**
     Initialize a `SemanticRolesSubject` with required member variables.


     - returns: An initialized `SemanticRolesSubject`.
    */
    public init() {
    }

    /**
    Initialize a `SemanticRolesSubject` with all member variables.

     - parameter text: Text that corresponds to the subject role
     - parameter entities: 
     - parameter keywords: 

    - returns: An initialized `SemanticRolesSubject`.
    */
    public init(text: String, entities: [SemanticRolesEntity], keywords: [SemanticRolesKeyword]) {
        self.text = text
        self.entities = entities
        self.keywords = keywords
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `SemanticRolesSubject` model from JSON.
    public init(json: JSON) throws {
        text = try? json.getString(at: "text")
        entities = try? json.getString(at: "entities")
        keywords = try? json.getString(at: "keywords")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `SemanticRolesSubject` model to JSON.
    func toJSONObject() -> Any {
        var json = [String: Any]()
        if let text = text { json["text"] = text }
        if let entities = entities {
            json["entities"] = entities.map { entitiesElem in entitiesElem.toJSONObject() }
        }
        if let keywords = keywords {
            json["keywords"] = keywords.map { keywordsElem in keywordsElem.toJSONObject() }
        }
        return json
    }
}
