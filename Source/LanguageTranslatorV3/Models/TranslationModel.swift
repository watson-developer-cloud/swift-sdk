/**
 * Copyright IBM Corporation 2018
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

/**
 Response payload for models.
 */
public struct TranslationModel: Decodable {

    /**
     Availability of a model.
     */
    public enum Status: String {
        case uploading = "uploading"
        case uploaded = "uploaded"
        case dispatching = "dispatching"
        case queued = "queued"
        case training = "training"
        case trained = "trained"
        case publishing = "publishing"
        case available = "available"
        case deleted = "deleted"
        case error = "error"
    }

    /**
     A globally unique string that identifies the underlying model that is used for translation.
     */
    public var modelID: String

    /**
     Optional name that can be specified when the model is created.
     */
    public var name: String?

    /**
     Translation source language code.
     */
    public var source: String?

    /**
     Translation target language code.
     */
    public var target: String?

    /**
     Model ID of the base model that was used to customize the model. If the model is not a custom model, this will be
     an empty string.
     */
    public var baseModelID: String?

    /**
     The domain of the translation model.
     */
    public var domain: String?

    /**
     Whether this model can be used as a base for customization. Customized models are not further customizable, and
     some base models are not customizable.
     */
    public var customizable: Bool?

    /**
     Whether or not the model is a default model. A default model is the model for a given language pair that will be
     used when that language pair is specified in the source and target parameters.
     */
    public var defaultModel: Bool?

    /**
     Either an empty string, indicating the model is not a custom model, or the ID of the service instance that created
     the model.
     */
    public var owner: String?

    /**
     Availability of a model.
     */
    public var status: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case modelID = "model_id"
        case name = "name"
        case source = "source"
        case target = "target"
        case baseModelID = "base_model_id"
        case domain = "domain"
        case customizable = "customizable"
        case defaultModel = "default_model"
        case owner = "owner"
        case status = "status"
    }

}
