/**
 * (C) Copyright IBM Corp. 2022.
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
 An object that contains a new name or description for a classifier, updated training data, or new or updated test data.
 */
public struct UpdateDocumentClassifier: Codable, Equatable {

    /**
     A new name for the classifier.
     */
    public var name: String?

    /**
     A new description for the classifier.
     */
    public var description: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
    }

    /**
      Initialize a `UpdateDocumentClassifier` with member variables.

      - parameter name: A new name for the classifier.
      - parameter description: A new description for the classifier.

      - returns: An initialized `UpdateDocumentClassifier`.
     */
    public init(
        name: String? = nil,
        description: String? = nil
    )
    {
        self.name = name
        self.description = description
    }

}
