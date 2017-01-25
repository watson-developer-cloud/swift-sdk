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


public struct RelationArgument: JSONDecodable,JSONEncodable {
    
    public let entities: [RelationEntity]?
    /// Text that corresponds to the argument
    public let text: String?

    /**
     Initialize a `RelationArgument` with required member variables.


     - returns: An initialized `RelationArgument`.
    */
    public init() {
    }

    /**
    Initialize a `RelationArgument` with all member variables.

     - parameter entities: 
     - parameter text: Text that corresponds to the argument

    - returns: An initialized `RelationArgument`.
    */
    public init(entities: [RelationEntity], text: String) {
        self.entities = entities
        self.text = text
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `RelationArgument` model from JSON.
    public init(json: JSON) throws {
        entities = try? json.getString(at: "entities")
        text = try? json.getString(at: "text")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `RelationArgument` model to JSON.
    func toJSONObject() -> Any {
        var json = [String: Any]()
        if let entities = entities {
            json["entities"] = entities.map { entitiesElem in entitiesElem.toJSONObject() }
        }
        if let text = text { json["text"] = text }
        return json
    }
}
