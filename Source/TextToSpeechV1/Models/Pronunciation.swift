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

/** Pronunciation. */
public struct Pronunciation {

    /// The pronunciation of the requested text in the specified voice and format.
    public var pronunciation: String

    /**
     Initialize a `Pronunciation` with member variables.

     - parameter pronunciation: The pronunciation of the requested text in the specified voice and format.

     - returns: An initialized `Pronunciation`.
    */
    public init(pronunciation: String) {
        self.pronunciation = pronunciation
    }
}

extension Pronunciation: Codable {

    private enum CodingKeys: String, CodingKey {
        case pronunciation = "pronunciation"
        static let allValues = [pronunciation]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pronunciation = try container.decode(String.self, forKey: .pronunciation)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pronunciation, forKey: .pronunciation)
    }

}
