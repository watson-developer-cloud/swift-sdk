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

/** DocumentSnapshot. */
public struct DocumentSnapshot: Decodable {

    public enum Step: String {
        case htmlInput = "html_input"
        case htmlOutput = "html_output"
        case jsonOutput = "json_output"
        case jsonNormalizationsOutput = "json_normalizations_output"
        case enrichmentsOutput = "enrichments_output"
        case normalizationsOutput = "normalizations_output"
    }

    public var step: String?

    public var snapshot: [String: JSON]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case step = "step"
        case snapshot = "snapshot"
    }

}
