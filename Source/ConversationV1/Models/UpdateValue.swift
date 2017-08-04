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

/** UpdateValue. */
public struct UpdateValue: JSONDecodable, JSONEncodable {

    /// The text of the entity value.
    public let value: String?

    /// Any metadata related to the entity value.
    public let metadata: [String: Any]?

    /// An array of synonyms for the entity value.
    public let synonyms: [String]?

    /**
     Initialize a `UpdateValue` with member variables.

     - parameter value: The text of the entity value.
     - parameter metadata: Any metadata related to the entity value.
     - parameter synonyms: An array of synonyms for the entity value.

     - returns: An initialized `UpdateValue`.
    */
    public init(value: String? = nil, metadata: [String: Any]? = nil, synonyms: [String]? = nil) {
        self.value = value
        self.metadata = metadata
        self.synonyms = synonyms
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `UpdateValue` model from JSON.
    public init(json: JSON) throws {
        value = try? json.getString(at: "value")
        metadata = try? json.getDictionaryObject(at: "metadata")
        synonyms = try? json.decodedArray(at: "synonyms", type: String.self)
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `UpdateValue` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let value = value { json["value"] = value }
        if let metadata = metadata { json["metadata"] = metadata }
        if let synonyms = synonyms {
            json["synonyms"] = synonyms.map { $0 }
        }
        return json
    }
}
