/**
 * Copyright IBM Corporation 2019
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
 An object specifying the sentiment extraction enrichment and related parameters.
 */
public struct NluEnrichmentSentiment: Codable, Equatable {

    /**
     When `true`, sentiment analysis is performed on the entire field.
     */
    public var document: Bool?

    /**
     A comma-separated list of target strings that will have any associated sentiment analyzed.
     */
    public var targets: [String]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case document = "document"
        case targets = "targets"
    }

    /**
     Initialize a `NluEnrichmentSentiment` with member variables.

     - parameter document: When `true`, sentiment analysis is performed on the entire field.
     - parameter targets: A comma-separated list of target strings that will have any associated sentiment analyzed.

     - returns: An initialized `NluEnrichmentSentiment`.
    */
    public init(
        document: Bool? = nil,
        targets: [String]? = nil
    )
    {
        self.document = document
        self.targets = targets
    }

}
