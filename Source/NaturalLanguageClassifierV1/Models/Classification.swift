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

/** Response from the classifier for a phrase. */
public struct Classification {

    /// Unique identifier for this classifier.
    public var classifierID: String?

    /// Link to the classifier.
    public var url: String?

    /// The submitted phrase.
    public var text: String?

    /// The class with the highest confidence.
    public var topClass: String?

    /// An array of up to ten class-confidence pairs sorted in descending order of confidence.
    public var classes: [ClassifiedClass]?

    /**
     Initialize a `Classification` with member variables.

     - parameter classifierID: Unique identifier for this classifier.
     - parameter url: Link to the classifier.
     - parameter text: The submitted phrase.
     - parameter topClass: The class with the highest confidence.
     - parameter classes: An array of up to ten class-confidence pairs sorted in descending order of confidence.

     - returns: An initialized `Classification`.
    */
    public init(classifierID: String? = nil, url: String? = nil, text: String? = nil, topClass: String? = nil, classes: [ClassifiedClass]? = nil) {
        self.classifierID = classifierID
        self.url = url
        self.text = text
        self.topClass = topClass
        self.classes = classes
    }
}

extension Classification: Codable {

    private enum CodingKeys: String, CodingKey {
        case classifierID = "classifier_id"
        case url = "url"
        case text = "text"
        case topClass = "top_class"
        case classes = "classes"
        static let allValues = [classifierID, url, text, topClass, classes]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        classifierID = try container.decodeIfPresent(String.self, forKey: .classifierID)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        topClass = try container.decodeIfPresent(String.self, forKey: .topClass)
        classes = try container.decodeIfPresent([ClassifiedClass].self, forKey: .classes)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(classifierID, forKey: .classifierID)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(topClass, forKey: .topClass)
        try container.encodeIfPresent(classes, forKey: .classes)
    }

}
