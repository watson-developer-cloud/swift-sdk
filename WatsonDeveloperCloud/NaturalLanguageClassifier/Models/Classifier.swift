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
import ObjectMapper

extension NaturalLanguageClassifier {
    
    public enum Status: String {
        case Available = "Available"
        case Failed = "Failed"
        case NonExistent = "Non Existent"
        case Training = "Training"
        case Unavailable = "Unavailable"
    }
    
    public struct Classifier: Mappable {
        /// Date and time (UTC) the classifier was created
        public var created: NSDate = NSDate()
        /// Unique identifier for this classifier
        public var id: String?
        /// The language used for the classifier
        public var language: String?
        /// User-supplied name for the classifier
        public var name: String?
        ///  ['Non Existent' or 'Training' or 'Failed' or 'Available' or 'Unavailable']: The state of the classifier
        public var status: Status = Status.NonExistent
        /// Additional detail about the status
        public var statusDescription: String?
        ///  Link to the classifer
        public var url: String?
        
        public init?(_ map: Map) {}
        
        public mutating func mapping(map: Map) {
            created            <- (map["created"], DateTransform())
            id                 <- (map["classifier_id"])
            language           <- map["language"]
            name               <- map["name"]
            url                <- map["url"]
            status             <- (map["status"], EnumTransform())
            statusDescription  <- map["status_description"]
        }
    }
}















