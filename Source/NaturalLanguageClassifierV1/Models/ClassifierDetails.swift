/**
 * Copyright IBM Corporation 2015
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

extension NaturalLanguageClassifierV1 {
    
    public struct ClassifierDetails: JSONDecodable {
        
        /// Unique identifier for this classifier
        public let classifierId: String
        
        /// User-supplied name for the classifier
        public let name: String?
        
        /// The language used for the classifier
        public let language: String
        
        /// Date and time (UTC) the classifier was created
        public let created: String
        
        /// Link to the classifer
        public let url: String
        
        /// The state of the classifier: [`Non Existent` or `Training` or `Failed` or `Available` or `Unavailable`]
        public let status: String
        
        /// Additional details about the status
        public let statusDescription: String
        
        /// Used internally to initialize a `ClassifierDetails` model from JSON.
        public init(json: JSON) throws {
            classifierId = try json.string("classifier_id")
            name = try json.string("name")
            language = try json.string("language")
            created = try json.string("created")
            url = try json.string("url")
            status = try json.string("status")
            statusDescription = try json.string("status_description")
        }
    }
}
