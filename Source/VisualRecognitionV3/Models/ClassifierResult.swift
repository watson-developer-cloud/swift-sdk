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

/** Classifier and score combination. */
public struct ClassifierResult {

    /// Name of the classifier.
    public var name: String

    /// The ID of a classifier identified in the image.
    public var classifierID: String

    /// An array of classes within the classifier.
    public var classes: [ClassResult]

    /**
     Initialize a `ClassifierResult` with member variables.

     - parameter name: Name of the classifier.
     - parameter classifierID: The ID of a classifier identified in the image.
     - parameter classes: An array of classes within the classifier.

     - returns: An initialized `ClassifierResult`.
    */
    public init(name: String, classifierID: String, classes: [ClassResult]) {
        self.name = name
        self.classifierID = classifierID
        self.classes = classes
    }
}

extension ClassifierResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case classifierID = "classifier_id"
        case classes = "classes"
        static let allValues = [name, classifierID, classes]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        classifierID = try container.decode(String.self, forKey: .classifierID)
        classes = try container.decode([ClassResult].self, forKey: .classes)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(classifierID, forKey: .classifierID)
        try container.encode(classes, forKey: .classes)
    }

}
