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

/**
 A classifier for natural language phrases.
 */
public struct Classifier: Decodable {

    /**
     The state of the classifier.
     */
    public enum Status: String {
        case nonExistent = "Non Existent"
        case training = "Training"
        case failed = "Failed"
        case available = "Available"
        case unavailable = "Unavailable"
    }

    /**
     User-supplied name for the classifier.
     */
    public var name: String?

    /**
     Link to the classifier.
     */
    public var url: String

    /**
     The state of the classifier.
     */
    public var status: String?

    /**
     Unique identifier for this classifier.
     */
    public var classifierID: String

    /**
     Date and time (UTC) the classifier was created.
     */
    public var created: String?

    /**
     Additional detail about the status.
     */
    public var statusDescription: String?

    /**
     The language used for the classifier.
     */
    public var language: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
        case status = "status"
        case classifierID = "classifier_id"
        case created = "created"
        case statusDescription = "status_description"
        case language = "language"
    }

}
