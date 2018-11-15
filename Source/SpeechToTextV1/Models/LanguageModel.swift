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

/** LanguageModel. */
public struct LanguageModel: Codable, Equatable {

    /**
     The current status of the custom language model:
     * `pending` indicates that the model was created but is waiting either for training data to be added or for the
     service to finish analyzing added data.
     * `ready` indicates that the model contains data and is ready to be trained.
     * `training` indicates that the model is currently being trained.
     * `available` indicates that the model is trained and ready to use.
     * `upgrading` indicates that the model is currently being upgraded.
     * `failed` indicates that training of the model failed.
     */
    public enum Status: String {
        case pending = "pending"
        case ready = "ready"
        case training = "training"
        case available = "available"
        case upgrading = "upgrading"
        case failed = "failed"
    }

    /**
     The customization ID (GUID) of the custom language model. The **Create a custom language model** method returns
     only this field of the object; it does not return the other fields.
     */
    public var customizationID: String

    /**
     The date and time in Coordinated Universal Time (UTC) at which the custom language model was created. The value is
     provided in full ISO 8601 format (`YYYY-MM-DDThh:mm:ss.sTZD`).
     */
    public var created: String?

    /**
     The language identifier of the custom language model (for example, `en-US`).
     */
    public var language: String?

    /**
     The dialect of the language for the custom language model. By default, the dialect matches the language of the base
     model; for example, `en-US` for either of the US English language models. For Spanish models, the field indicates
     the dialect for which the model was created:
     * `es-ES` for Castilian Spanish (the default)
     * `es-LA` for Latin American Spanish
     * `es-US` for North American (Mexican) Spanish.
     */
    public var dialect: String?

    /**
     A list of the available versions of the custom language model. Each element of the array indicates a version of the
     base model with which the custom model can be used. Multiple versions exist only if the custom model has been
     upgraded; otherwise, only a single version is shown.
     */
    public var versions: [String]?

    /**
     The GUID of the service credentials for the instance of the service that owns the custom language model.
     */
    public var owner: String?

    /**
     The name of the custom language model.
     */
    public var name: String?

    /**
     The description of the custom language model.
     */
    public var description: String?

    /**
     The name of the language model for which the custom language model was created.
     */
    public var baseModelName: String?

    /**
     The current status of the custom language model:
     * `pending` indicates that the model was created but is waiting either for training data to be added or for the
     service to finish analyzing added data.
     * `ready` indicates that the model contains data and is ready to be trained.
     * `training` indicates that the model is currently being trained.
     * `available` indicates that the model is trained and ready to use.
     * `upgrading` indicates that the model is currently being upgraded.
     * `failed` indicates that training of the model failed.
     */
    public var status: String?

    /**
     A percentage that indicates the progress of the custom language model's current training. A value of `100` means
     that the model is fully trained. **Note:** The `progress` field does not currently reflect the progress of the
     training. The field changes from `0` to `100` when training is complete.
     */
    public var progress: Int?

    /**
     If the request included unknown parameters, the following message: `Unexpected query parameter(s) ['parameters']
     detected`, where `parameters` is a list that includes a quoted string for each unknown parameter.
     */
    public var warnings: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case customizationID = "customization_id"
        case created = "created"
        case language = "language"
        case dialect = "dialect"
        case versions = "versions"
        case owner = "owner"
        case name = "name"
        case description = "description"
        case baseModelName = "base_model_name"
        case status = "status"
        case progress = "progress"
        case warnings = "warnings"
    }

}
