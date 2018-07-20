/**
 * Copyright IBM Corporation 2018
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
 Metadata of a query result.
 */
public struct QueryResultMetadata: Decodable {

    /**
     The raw score of the result. A higher score indicates a greater match to the query parameters.
     */
    public var score: Double?

    /**
     The confidence score of the result's analysis. A higher score indicates greater confidence.
     */
    public var confidence: Double?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case score = "score"
        case confidence = "confidence"
    }

}
