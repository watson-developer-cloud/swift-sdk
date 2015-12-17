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

extension LanguageTranslation {
    
    internal struct Constants {
        
        static let serviceURL = "https://gateway.watsonplatform.net/language-translation/api"
        static let tokenURL = "https://gateway.watsonplatform.net/authorization/api/v1/token"
        static let errorDomain = "com.watsonplatform.languagetranslation"
        
        static let identifiableLanguages = "/v2/identifiable_languages"
        static let identify = "/v2/identify"
        static let translate = "/v2/translate"
        static let models = "/v2/models"
        static func model(modelID: String) -> String {
            return "/v2/models/\(modelID)"
        }
    }
}