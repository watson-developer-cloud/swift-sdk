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

/**

 **KnowledgeGraph**

 The KnowledgeGraph contains info on how keys are determined

 */

public struct KnowledgeGraph: JSONDecodable {

    /** the path along the graph to the key */
    public let typeHierarchy: String?

    /// Used internally to initialize a KnowledgeGraph object
    public init(json: JSONWrapper) throws {
        typeHierarchy = try? json.getString(at: "typeHierarchy")
    }
}

