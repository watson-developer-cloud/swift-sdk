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
    
    // A translation model
    public struct TranslationModel: Mappable {
        
        // If this model is a custom model, this returns the base model that it is trained on. For a base model, this response value is empty.
        public var baseModelID: String?
        
        // Whether this model can be used as a base for customization.
        public var customizable: Bool?
        
        // Whether this model is considered a default model and is used when the source and target languages are specified without the model_id.
        public var defaultModel: Bool?
        
        // The domain of the translation model.
        public var domain: String?
        
        // A globally unique string that identifies the underlying model that is used for translation. This string contains all the information about source language, target language, domain, and various other related configurations.
        public var modelID: String?
        
        // If a model is trained by a user, there might be an optional “name” parameter attached during training to help the user identify the model.
        public var name: String?
        
        // Returns the bluemix-instance-id of the instance that created the model, or an empty string, if it’s a model that is trained by IBM.
        public var owner: String?
        
        // Source language in two letter language code. Use the five letter code when clarifying between multiple supported languages. When model_id is used directly, it will override the source-target language combination. Also, when a two letter language code is used, but no suitable default is found, it returns an error.
        public var source: String?
        
        // Availability of a model.
        public var status: String?
        
        // Target language in two letter language code.
        public var target: String?
        
        public init?(_ map: Map) {}
        
        public mutating func mapping(map: Map) {
            baseModelID     <- map["base_model_id"]
            customizable    <- map["customizable"]
            defaultModel    <- map["default"]
            domain          <- map["domain"]
            modelID         <- map["model_id"]
            name            <- map["name"]
            owner           <- map["owner"]
            status          <- map["status"]
            target          <- map["target"]
        }
    }
}