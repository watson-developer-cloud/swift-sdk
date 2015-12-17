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

extension LanguageTranslation {
    
    // A translation request
    internal struct TranslateRequest: Mappable {
        var modelID: String?
        var source: String?
        var target: String?
        var text: [String]?
        
        init(text: [String], modelID: String) {
            self.text = text
            self.modelID = modelID
        }
        
        init(text: [String], source: String, target: String) {
            self.text = text
            self.source = source
            self.target = target
        }
        
        init?(_ map: Map) {}
        
        mutating func mapping(map: Map) {
            modelID <- map["model_id"]
            source  <- map["source"]
            target  <- map["target"]
            text    <- map["text"]
        }
    }
}