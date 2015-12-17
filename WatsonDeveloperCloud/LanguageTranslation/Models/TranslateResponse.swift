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
    
    internal struct Translation: Mappable {
        var translation: String?
        
        init?(_ map: Map) {}
        
        mutating func mapping(map: Map) {
            translation <- map["translation"]
        }
    }
    
    internal struct TranslateResponse: Mappable {
        var wordCount: Int?
        var characterCount: Int?
        var translations: [Translation]?
        var translationStrings: [String]? {
            if let translations = translations {
                var strings = [String]()
                for translation in translations {
                    if let string = translation.translation {
                        strings.append(string)
                    }
                }
                return strings
            }
            return nil
        }
        
        init?(_ map: Map) {}
        
        mutating func mapping(map: Map) {
            wordCount      <- map["word_count"]
            characterCount <- map["character_count"]
            translations   <- map["translations"]
        }
    }
}