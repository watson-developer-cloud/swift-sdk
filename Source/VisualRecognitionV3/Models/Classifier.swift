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

/** Information about a classifier. */
public struct Classifier {

    /// The training status of classifier.
    public enum Status: String {
        case ready = "ready"
        case training = "training"
        case retraining = "retraining"
        case failed = "failed"
    }

    /// ID of a classifier identified in the image.
    public var classifierID: String

    /// Name of the classifier.
    public var name: String

    /// Unique ID of the account who owns the classifier. Returned when verbose=`true`. Might not be returned by some requests.
    public var owner: String?

    /// The training status of classifier.
    public var status: String?

    /// If classifier training has failed, this field may explain why.
    public var explanation: String?

    /// Date and time in Coordinated Universal Time that the classifier was created.
    public var created: String?

    /// Array of classes that define a classifier.
    public var classes: [Class]?

    /// Date and time in Coordinated Universal Time that the classifier was updated. Returned when verbose=`true`. Might not be returned by some requests.
    public var retrained: String?

    /// If the classifier is CoreML Enabled.
    public let coreMLEnabled: Bool?

    /**
     Initialize a `Classifier` with member variables.

     - parameter classifierID: ID of a classifier identified in the image.
     - parameter name: Name of the classifier.
     - parameter owner: Unique ID of the account who owns the classifier. Returned when verbose=`true`. Might not be returned by some requests.
     - parameter status: The training status of classifier.
     - parameter explanation: If classifier training has failed, this field may explain why.
     - parameter created: Date and time in Coordinated Universal Time that the classifier was created.
     - parameter classes: Array of classes that define a classifier.
     - parameter retrained: Date and time in Coordinated Universal Time that the classifier was updated. Returned when verbose=`true`. Might not be returned by some requests.
     - parameter coreMLEnabled: If the classifier is CoreML Enabled.

     - returns: An initialized `Classifier`.
    */
    public init(classifierID: String, name: String, owner: String? = nil, status: String? = nil, explanation: String? = nil, created: String? = nil, classes: [Class]? = nil, retrained: String? = nil, coreMLEnabled: Bool? = nil) {
        self.classifierID = classifierID
        self.name = name
        self.owner = owner
        self.status = status
        self.explanation = explanation
        self.created = created
        self.classes = classes
        self.retrained = retrained
        self.coreMLEnabled = coreMLEnabled
    }
}

extension Classifier: Codable {

    private enum CodingKeys: String, CodingKey {
        case classifierID = "classifier_id"
        case name = "name"
        case owner = "owner"
        case status = "status"
        case explanation = "explanation"
        case created = "created"
        case classes = "classes"
        case retrained = "retrained"
        case coreMLEnabled = "core_ml_enabled"
        static let allValues = [classifierID, name, owner, status, explanation, created, classes, retrained, coreMLEnabled]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        classifierID = try container.decode(String.self, forKey: .classifierID)
        name = try container.decode(String.self, forKey: .name)
        owner = try container.decodeIfPresent(String.self, forKey: .owner)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        explanation = try container.decodeIfPresent(String.self, forKey: .explanation)
        created = try container.decodeIfPresent(String.self, forKey: .created)
        classes = try container.decodeIfPresent([Class].self, forKey: .classes)
        retrained = try container.decodeIfPresent(String.self, forKey: .retrained)
        coreMLEnabled = try container.decodeIfPresent(Bool.self, forKey: .coreMLEnabled)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(classifierID, forKey: .classifierID)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(owner, forKey: .owner)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(explanation, forKey: .explanation)
        try container.encodeIfPresent(created, forKey: .created)
        try container.encodeIfPresent(classes, forKey: .classes)
        try container.encodeIfPresent(retrained, forKey: .retrained)
        try container.encodeIfPresent(coreMLEnabled, forKey: .coreMLEnabled)
    }

}
