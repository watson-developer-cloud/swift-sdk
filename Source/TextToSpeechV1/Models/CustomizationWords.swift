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

/** A custom voice model supported by the Text to Speech service. */
public struct CustomizationWords: JSONDecodable {
    /// The GUID of the custom voice model.
    public let customizationID: String
    
    /// The name of the custom voice model.
    public let name: String
    
    /// The language of the custom voice model
    public let language: String
    
    /// GUID of the service credentials for the owner of the custom voice model.
    public let owner: String
    
    /// The UNIX timestamp that indicates when the custom voice model was created.
    /// The timestamp is a count of seconds since the UNIX Epoch of January 1, 1970
    /// Coordinated Universal Time (UTC).
    public let created: Int? // TODO: change to `Int` after service bug is fixed
    
    /// The UNIX timestamp that indicates when the custom voice model was last modified.
    /// Equals created when a new voice model is first added but has yet to be changed.
    public let lastModified: Int? // TODO: change to `Int` after service bug is fixed
    
    /// A description of the custom voice model.
    public let description: String?
    
    /// A list of words and their translations from the custom voice model.
    public let words: [Word]
    
    /// Used internally to initialize a `CustomizationWords` model from JSON.
    public init(json: JSON) throws {
        customizationID = try json.getString(at: "customization_id")
        name = try json.getString(at: "name")
        language = try json.getString(at: "language")
        owner = try json.getString(at: "owner")
        created = try? json.getInt(at: "created")
        lastModified = try? json.getInt(at: "last_modified")
        description = try? json.getString(at: "description")
        words = try json.decodedArray(at: "words", type: Word.self)
    }
}
