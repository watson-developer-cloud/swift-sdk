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

public struct LanguageTranslationConstants {

    //Translation model
    static let baseModelID = "base_model_id"
    static let customizable = "customizable"
    static let defaultModel = "default_model"
    static let domain = "domain"
    static let modelID = "model_id"
    static let name = "name"
    static let owner = "owner"
    static let source = "source"
    static let status = "status"
    static let target = "target"
    
    //getModels()
    static let models = "models"
    //Can't use default for key, as this is a Swift reserved word
    static let defaultStr = "default"

    //translate()
    static let text = "text"
    static let translations = "translations"
    static let translation = "translation"

    //identify() and getIdentifiableLanguages()
    static let languages = "languages"
    
}