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
    
    public struct Classification: Mappable {
        
        /// Unique identifier for this classifier
        public var id: String?
        /// Link to the classifer
        public var url: String?
        /// The submitted phrase
        public var text: String?
        /// The class with the highest confidence
        public var topClass: String?
        /// Top confidence level
        public var topConfidence: Double? {
            guard let classes = self.classes else {
                return nil
            }
            var double = 0.0
            for classifiedClass in classes {
                if(classifiedClass.name == topClass) {
                    double = classifiedClass.confidence!
                }
            }
            return double
        }
        ///  An array of up to ten class-confidence pairs sorted in descending order of confidence
        public var classes: [ClassifiedClass]?
        
        public init?(_ map: Map) {}
        
        public mutating func mapping(map: Map) {
            id        <- map["classifier_id"]
            text      <- map["text"]
            url       <- map["url"]
            topClass  <- map["top_class"]
            classes   <- map["classes"]
        }
    }
}