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

/** Translation. */
public struct Translation {

    /// Translation output in UTF-8.
    public var translationOutput: String

    /**
     Initialize a `Translation` with member variables.

     - parameter translationOutput: Translation output in UTF-8.

     - returns: An initialized `Translation`.
    */
    public init(translationOutput: String) {
        self.translationOutput = translationOutput
    }
}

extension Translation: Codable {

    private enum CodingKeys: String, CodingKey {
        case translationOutput = "translation"
        static let allValues = [translationOutput]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        translationOutput = try container.decode(String.self, forKey: .translationOutput)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(translationOutput, forKey: .translationOutput)
    }

}
