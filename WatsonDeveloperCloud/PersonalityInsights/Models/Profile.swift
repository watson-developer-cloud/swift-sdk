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

extension PersonalityInsights {

    /// Profile model object that is returned by PersonalityInsights service
    public struct Profile: Mappable {
        
        public var tree:Trait?
        /// The unique identifier for which these characteristics were computed, from the "userid" field of the input ContentItems
        public var ID:String?
        /// The source for which these characteristics were computed, from the "sourceid" field of the input ContentItems
        public var source:String?
        /// The number of words found in the input
        public var wordCount:Int?
        /// A message indicating the number of words found and where that value falls in the range of required or suggested number of words when guidance is available
        public var wordCountMessage:Int?
        /// The language model that was used to process the input, one of "en" or "es"
        public var processedLang:String?
        
        public init?(_ map: Map) {}
        
        public mutating func mapping(map: Map) {
            ID                  <- map["id"]
            source              <- map["source"]
            wordCount           <- map["word_count"]
            wordCountMessage    <- map["word_count_message"]
            processedLang       <- map["processed_lang"]
            tree                <- map["tree"]
        }
    }
}