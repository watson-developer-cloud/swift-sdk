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

/** List of available classifiers. */
public struct ClassifierList {

    /// The classifiers available to the user. Returns an empty array if no classifiers are available.
    public var classifiers: [Classifier]

    /**
     Initialize a `ClassifierList` with member variables.

     - parameter classifiers: The classifiers available to the user. Returns an empty array if no classifiers are available.

     - returns: An initialized `ClassifierList`.
    */
    public init(classifiers: [Classifier]) {
        self.classifiers = classifiers
    }
}

extension ClassifierList: Codable {

    private enum CodingKeys: String, CodingKey {
        case classifiers = "classifiers"
        static let allValues = [classifiers]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        classifiers = try container.decode([Classifier].self, forKey: .classifiers)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(classifiers, forKey: .classifiers)
    }

}
