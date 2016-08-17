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
import Freddy

/** A term from the request that was identified as an entity. */
public struct Entity: JSONEncodable, JSONDecodable {
    
    /// The name of the recognized entity.
    public let entity: String?
    
    /// The location where the entity value begins and ends in the input text.
    public let location: EntityLocation?
    
    /// The term in the input text that was recognized.
    public let value: String?
    
    /**
     Create an `Entity`.
 
     - parameter entity: The name of the recognized entity.
     - parameter location: The location where the entity value begins and ends in the input text.
     - parameter value: The term in the input text that was recognized.
     */
    public init(entity: String?, location: EntityLocation?, value: String?) {
        self.entity = entity
        self.location = location
        self.value = value
    }
    
    /// Used internally to initialize an `Entity` model from JSON.
    public init(json: JSON) throws {
        entity = try? json.string("entity")
        location = try? json.decode("location")
        value = try? json.string("value")
    }
    
    /// Used internally to serialize an `Entity` model to JSON.
    public func toJSON() -> JSON {
        var json = [String: JSON]()
        if let entity = entity {
            json["entity"] = .String(entity)
        }
        if let location = location {
            json["location"] = location.toJSON()
        }
        if let value = value {
            json["value"] = .String(value)
        }
        return JSON.Dictionary(json)
    }
}

/** The location where an entity value begins and ends in the input text. */
public struct EntityLocation: JSONEncodable, JSONDecodable {
    
    /// The zero-based character offset that indicates
    /// where an entity value begins in the input text.
    public let startIndex: Int
    
    /// The zero-based character offset that indicates
    /// where an entity value ends in the input text.
    public let endIndex: Int
    
    /**
     Create an `EntityLocation`.
 
     - parameter startIndex: The zero-based character offset that
        indicates where an entity value begins in the input text.
     - parameter endIndex: The zero-based character offset that
        indicates where an entity value ends in the input text.
    */
    public init(startIndex: Int, endIndex: Int) {
        self.startIndex = startIndex
        self.endIndex = endIndex
    }
    
    /// Used internally to initialize an `EntityLocation` model from JSON.
    public init(json: JSON) throws {
        let indices = try json.arrayOf(type: Swift.Int)
        startIndex = indices[0]
        endIndex = indices[1]
    }
    
    /// Used internally to serialize an `EntityLocation` model to JSON.
    public func toJSON() -> JSON {
        let json = [JSON.Int(startIndex), JSON.Int(endIndex)]
        return JSON.Array(json)
    }
}
