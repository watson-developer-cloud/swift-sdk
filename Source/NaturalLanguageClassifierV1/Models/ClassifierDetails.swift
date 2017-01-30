/**
 * Copyright IBM Corporation 2016
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
import RestKit

/** A classifer supported by the Natural Language Classifier service. */
public struct ClassifierDetails: JSONDecodable {
    
    /// A unique identifier for this classifier.
    public let classifierId: String
    
    /// The user-supplied name of the classifier.
    public let name: String?
    
    /// The language used for the classifier.
    public let language: String
    
    /// The date and time (UTC) that the classifier was created.
    public let created: String
    
    /// A link to the classifer.
    public let url: String
    
    /// The classifier's status.
    public let status: ClassifierStatus
    
    /// A human-readable descriptiono of the classifier's status.
    public let statusDescription: String
    
    /// Used internally to initialize a `ClassifierDetails` model from JSON.
    public init(json: JSON) throws {
        classifierId = try json.getString(at: "classifier_id")
        name = try? json.getString(at: "name")
        language = try json.getString(at: "language")
        created = try json.getString(at: "created")
        url = try json.getString(at: "url")
        statusDescription = try json.getString(at: "status_description")
        
        guard let classifierStatus = ClassifierStatus(rawValue: try json.getString(at: "status")) else {
            throw JSON.Error.valueNotConvertible(value: json, to: ClassifierStatus.self)
        }
        status = classifierStatus
    }
}

/** The status of a classifier. */
public enum ClassifierStatus: String {
    
    /// Available
    case available = "Available"
    
    /// Failed
    case failed = "Failed"
    
    /// NonExistent
    case nonExistent = "Non Existent"
    
    /// Training
    case training = "Training"
    
    /// Unavailable
    case unavailable = "Unavailable"
}
