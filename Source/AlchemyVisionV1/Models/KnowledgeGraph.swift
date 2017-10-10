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

/** A hierarchy of categories for a given object in the Alchemy Knowledge Graph. */
public struct KnowledgeGraph: JSONDecodable {

    /// A hierarchy of categories for the given object.
    public let typeHierarchy: String

    /// Used internally to initialize a `KnowledgeGraph` model from JSON.
    public init(json: JSONWrapper) throws {
        typeHierarchy = try json.getString(at: "typeHierarchy")
    }
}
