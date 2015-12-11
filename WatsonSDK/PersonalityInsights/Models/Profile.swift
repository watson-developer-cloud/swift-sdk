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
        
        var tree:Trait?
        var ID:String?
        var source:String?
        var wordCount:Int?
        var wordCountMessage:Int?
        var processedLang:String?
        
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