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


public struct SemanticRolesResult: JSONDecodable,JSONEncodable {
    /// Sentence from the source that contains the subject, action, and object
    public let sentence: String?
    
    public let subject: Any?
    
    public let action: Any?
    
    public let object: Any?

    /**
     Initialize a `SemanticRolesResult` with required member variables.


     - returns: An initialized `SemanticRolesResult`.
    */
    public init() {
    }

    /**
    Initialize a `SemanticRolesResult` with all member variables.

     - parameter sentence: Sentence from the source that contains the subject, action, and object
     - parameter subject: 
     - parameter action: 
     - parameter object: 

    - returns: An initialized `SemanticRolesResult`.
    */
    public init(sentence: String, subject: Any, action: Any, object: Any) {
        self.sentence = sentence
        self.subject = subject
        self.action = action
        self.object = object
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `SemanticRolesResult` model from JSON.
    public init(json: JSON) throws {
        sentence = try? json.getString(at: "sentence")
        subject = try? json.getString(at: "subject")
        action = try? json.getString(at: "action")
        object = try? json.getString(at: "object")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `SemanticRolesResult` model to JSON.
    func toJSONObject() -> Any {
        var json = [String: Any]()
        if let sentence = sentence { json["sentence"] = sentence }
        if let subject = subject { json["subject"] = subject }
        if let action = action { json["action"] = action }
        if let object = object { json["object"] = object }
        return json
    }
}
