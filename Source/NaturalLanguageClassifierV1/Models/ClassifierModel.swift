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
public struct ClassifierModel: JSONDecodable {
    
    /// A unique identifier for this classifier.
    public let classifierId: String
    
    /// A link to the classifer.
    public let url: String
    
    /// The user-supplied name of the classifier.
    public let name: String?
    
    /// The language used for the classifier.
    public let language: String
    
    /// The date and time (UTC) that the classifier was created.
    public let created: String
    
    /// Used internally to initialize a `ClassifierModel` from JSON.
    public init(json: JSON) throws {
        classifierId = try json.getString(at: "classifier_id")
        url = try json.getString(at: "url")
        name = try? json.getString(at: "name")
        language = try json.getString(at: "language")
        created = try json.getString(at: "created")
    }
}
