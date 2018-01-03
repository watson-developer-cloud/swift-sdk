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

/** Information for how keywords are determined. */
public struct KnowledgeGraph: JSONDecodable {
    /// Path along the graph to the key.
    public let typeHierarchy: String?

    /// The raw JSON object used to construct this model.
    public let json: [String: Any]

    /// Used internally to initialize a KnowledgeGraph object
    public init(json: JSONWrapper) throws {
        typeHierarchy = try? json.getString(at: "typeHierarchy")
        self.json = try json.getDictionaryObject()
    }

    /// Used internally to serialize a 'KnowledgeGraph' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}
