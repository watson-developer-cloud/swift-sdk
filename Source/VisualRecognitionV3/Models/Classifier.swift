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
import Freddy

/** A classifier for the Visual Recognition service. */
public struct Classifier: JSONDecodable {
    
    /// The id of the classifier.
    public let classifierID: String
    
    /// The name of the classifier.
    public let name: String
    
    /// The owner of the classifier.
    public let owner: String
    
    /// The status of the classifier.
    public let status: String
    
    /// The creation date of the classifier.
    public let created: String
    
    /// The classes of the classifier.
    public let classes: [Class]
    
    /// Used internally to initialize a `Classifier` model from JSON.
    public init(json: JSON) throws {
        classifierID = try json.getString(at: "classifier_id")
        name = try json.getString(at: "name")
        owner = try json.getString(at: "owner")
        status = try json.getString(at: "status")
        created = try json.getString(at: "created")
        classes = try json.decodedArray(at: "classes", type: Class.self)
    }
}
