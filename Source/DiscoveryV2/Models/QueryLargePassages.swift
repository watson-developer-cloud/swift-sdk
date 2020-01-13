/**
 * (C) Copyright IBM Corp. 2019, 2020.
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
 Configuration for passage retrieval.
 */
public struct QueryLargePassages: Codable, Equatable {

    /**
     A passages query that returns the most relevant passages from the results.
     */
    public var enabled: Bool?

    /**
     When `true`, passages will be returned within their respective result.
     */
    public var perDocument: Bool?

    /**
     Maximum number of passages to return per result.
     */
    public var maxPerDocument: Int?

    /**
     A list of fields that passages are drawn from. If this parameter not specified, then all top-level fields are
     included.
     */
    public var fields: [String]?

    /**
     The maximum number of passages to return. The search returns fewer passages if the requested total is not found.
     The default is `10`. The maximum is `100`.
     */
    public var count: Int?

    /**
     The approximate number of characters that any one passage will have.
     */
    public var characters: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case enabled = "enabled"
        case perDocument = "per_document"
        case maxPerDocument = "max_per_document"
        case fields = "fields"
        case count = "count"
        case characters = "characters"
    }

    /**
     Initialize a `QueryLargePassages` with member variables.

     - parameter enabled: A passages query that returns the most relevant passages from the results.
     - parameter perDocument: When `true`, passages will be returned within their respective result.
     - parameter maxPerDocument: Maximum number of passages to return per result.
     - parameter fields: A list of fields that passages are drawn from. If this parameter not specified, then all
       top-level fields are included.
     - parameter count: The maximum number of passages to return. The search returns fewer passages if the requested
       total is not found. The default is `10`. The maximum is `100`.
     - parameter characters: The approximate number of characters that any one passage will have.

     - returns: An initialized `QueryLargePassages`.
     */
    public init(
        enabled: Bool? = nil,
        perDocument: Bool? = nil,
        maxPerDocument: Int? = nil,
        fields: [String]? = nil,
        count: Int? = nil,
        characters: Int? = nil
    )
    {
        self.enabled = enabled
        self.perDocument = perDocument
        self.maxPerDocument = maxPerDocument
        self.fields = fields
        self.count = count
        self.characters = characters
    }

}
