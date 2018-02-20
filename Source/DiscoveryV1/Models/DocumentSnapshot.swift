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
public struct DocumentSnapshot {

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

    /**
     Initialize a `DocumentSnapshot` with member variables.

     - parameter step:
     - parameter snapshot:

     - returns: An initialized `DocumentSnapshot`.
    */
    public init(step: String? = nil, snapshot: [String: JSON]? = nil) {
        self.step = step
        self.snapshot = snapshot
    }
}

extension DocumentSnapshot: Codable {

    private enum CodingKeys: String, CodingKey {
        case step = "step"
        case snapshot = "snapshot"
        static let allValues = [step, snapshot]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        step = try container.decodeIfPresent(String.self, forKey: .step)
        snapshot = try container.decodeIfPresent([String: JSON].self, forKey: .snapshot)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(step, forKey: .step)
        try container.encodeIfPresent(snapshot, forKey: .snapshot)
    }

}
