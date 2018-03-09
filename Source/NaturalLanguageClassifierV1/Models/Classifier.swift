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

/** A classifier for natural language phrases. */
public struct Classifier {

    /// The state of the classifier.
    public enum Status: String {
        case nonExistent = "Non Existent"
        case training = "Training"
        case failed = "Failed"
        case available = "Available"
        case unavailable = "Unavailable"
    }

    /// User-supplied name for the classifier.
    public var name: String?

    /// Link to the classifier.
    public var url: String

    /// The state of the classifier.
    public var status: String?

    /// Unique identifier for this classifier.
    public var classifierID: String

    /// Date and time (UTC) the classifier was created.
    public var created: String?

    /// Additional detail about the status.
    public var statusDescription: String?

    /// The language used for the classifier.
    public var language: String?

    /**
     Initialize a `Classifier` with member variables.

     - parameter url: Link to the classifier.
     - parameter classifierID: Unique identifier for this classifier.
     - parameter name: User-supplied name for the classifier.
     - parameter status: The state of the classifier.
     - parameter created: Date and time (UTC) the classifier was created.
     - parameter statusDescription: Additional detail about the status.
     - parameter language: The language used for the classifier.

     - returns: An initialized `Classifier`.
    */
    public init(url: String, classifierID: String, name: String? = nil, status: String? = nil, created: String? = nil, statusDescription: String? = nil, language: String? = nil) {
        self.url = url
        self.classifierID = classifierID
        self.name = name
        self.status = status
        self.created = created
        self.statusDescription = statusDescription
        self.language = language
    }
}

extension Classifier: Codable {

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
        case status = "status"
        case classifierID = "classifier_id"
        case created = "created"
        case statusDescription = "status_description"
        case language = "language"
        static let allValues = [name, url, status, classifierID, created, statusDescription, language]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        url = try container.decode(String.self, forKey: .url)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        classifierID = try container.decode(String.self, forKey: .classifierID)
        created = try container.decodeIfPresent(String.self, forKey: .created)
        statusDescription = try container.decodeIfPresent(String.self, forKey: .statusDescription)
        language = try container.decodeIfPresent(String.self, forKey: .language)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(url, forKey: .url)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encode(classifierID, forKey: .classifierID)
        try container.encodeIfPresent(created, forKey: .created)
        try container.encodeIfPresent(statusDescription, forKey: .statusDescription)
        try container.encodeIfPresent(language, forKey: .language)
    }

}
