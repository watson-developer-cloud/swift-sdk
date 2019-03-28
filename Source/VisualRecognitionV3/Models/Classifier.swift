/**
 * Copyright IBM Corporation 2019
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
 Information about a classifier.
 */
public struct Classifier: Codable, Equatable {

    /**
     Training status of classifier.
     */
    public enum Status: String {
        case ready = "ready"
        case training = "training"
        case retraining = "retraining"
        case failed = "failed"
    }

    /**
     ID of a classifier identified in the image.
     */
    public var classifierID: String

    /**
     Name of the classifier.
     */
    public var name: String

    /**
     Unique ID of the account who owns the classifier. Might not be returned by some requests.
     */
    public var owner: String?

    /**
     Training status of classifier.
     */
    public var status: String?

    /**
     Whether the classifier can be downloaded as a Core ML model after the training status is `ready`.
     */
    public var coreMLEnabled: Bool?

    /**
     If classifier training has failed, this field might explain why.
     */
    public var explanation: String?

    /**
     Date and time in Coordinated Universal Time (UTC) that the classifier was created.
     */
    public var created: Date?

    /**
     Classes that define a classifier.
     */
    public var classes: [Class]?

    /**
     Date and time in Coordinated Universal Time (UTC) that the classifier was updated. Might not be returned by some
     requests. Identical to `updated` and retained for backward compatibility.
     */
    public var retrained: Date?

    /**
     Date and time in Coordinated Universal Time (UTC) that the classifier was most recently updated. The field matches
     either `retrained` or `created`. Might not be returned by some requests.
     */
    public var updated: Date?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case classifierID = "classifier_id"
        case name = "name"
        case owner = "owner"
        case status = "status"
        case coreMLEnabled = "core_ml_enabled"
        case explanation = "explanation"
        case created = "created"
        case classes = "classes"
        case retrained = "retrained"
        case updated = "updated"
    }

}
