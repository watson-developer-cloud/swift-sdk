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

/** WordError. */
public struct WordError {

    /// A key-value pair that describes an error associated with the definition of a word in the words resource. Each pair has the format `"element": "message"`, where `element` is the aspect of the definition that caused the problem and `message` describes the problem. The following example describes a problem with one of the word's sounds-like definitions: `"sounds_like_string": "Numbers are not allowed in sounds-like. You can try for example 'suggested_string'."` You must correct the error before you can train the model.
    public var element: String

    /**
     Initialize a `WordError` with member variables.

     - parameter element: A key-value pair that describes an error associated with the definition of a word in the words resource. Each pair has the format `"element": "message"`, where `element` is the aspect of the definition that caused the problem and `message` describes the problem. The following example describes a problem with one of the word's sounds-like definitions: `"sounds_like_string": "Numbers are not allowed in sounds-like. You can try for example 'suggested_string'."` You must correct the error before you can train the model.

     - returns: An initialized `WordError`.
    */
    public init(element: String) {
        self.element = element
    }
}

extension WordError: Codable {

    private enum CodingKeys: String, CodingKey {
        case element = "element"
        static let allValues = [element]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        element = try container.decode(String.self, forKey: .element)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(element, forKey: .element)
    }

}
