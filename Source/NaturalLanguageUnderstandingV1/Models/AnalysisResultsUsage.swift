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
 API usage information for the request.
 */
public struct AnalysisResultsUsage: Codable, Equatable {

    /**
     Number of features used in the API call.
     */
    public var features: Int?

    /**
     Number of text characters processed.
     */
    public var textCharacters: Int?

    /**
     Number of 10,000-character units processed.
     */
    public var textUnits: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case features = "features"
        case textCharacters = "text_characters"
        case textUnits = "text_units"
    }

}
