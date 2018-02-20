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
public struct LanguageModel {

    /// The current status of the custom language model: * `pending` indicates that the model was created but is waiting either for training data to be added or for the service to finish analyzing added data. * `ready` indicates that the model contains data and is ready to be trained. * `training` indicates that the model is currently being trained. * `available` indicates that the model is trained and ready to use. * `upgrading` indicates that the model is currently being upgraded. * `failed` indicates that training of the model failed.
    public enum Status: String {
        case pending = "pending"
        case ready = "ready"
        case training = "training"
        case available = "available"
        case upgrading = "upgrading"
        case failed = "failed"
    }

    /// The customization ID (GUID) of the custom language model. **Note:** When you create a new custom language model, the service returns only the GUID of the new model; it does not return the other fields of this object.
    public var customizationID: String

    /// The date and time in Coordinated Universal Time (UTC) at which the custom language model was created. The value is provided in full ISO 8601 format (`YYYY-MM-DDThh:mm:ss.sTZD`).
    public var created: String?

    /// The language identifier of the custom language model (for example, `en-US`).
    public var language: String?

    /// The dialect of the language for the custom language model. By default, the dialect matches the language of the base model; for example, `en-US` for either of the US English language models. For Spanish models, the field indicates the dialect for which the model was created: * `es-ES` for Castilian Spanish (the default) * `es-LA` for Latin American Spanish * `es-US` for North American (Mexican) Spanish.
    public var dialect: String?

    /// A list of the available versions of the custom language model. Each element of the array indicates a version of the base model with which the custom model can be used. Multiple versions exist only if the custom model has been upgraded; otherwise, only a single version is shown.
    public var versions: [String]?

    /// The GUID of the service credentials for the instance of the service that owns the custom language model.
    public var owner: String?

    /// The name of the custom language model.
    public var name: String?

    /// The description of the custom language model.
    public var description: String?

    /// The name of the language model for which the custom language model was created.
    public var baseModelName: String?

    /// The current status of the custom language model: * `pending` indicates that the model was created but is waiting either for training data to be added or for the service to finish analyzing added data. * `ready` indicates that the model contains data and is ready to be trained. * `training` indicates that the model is currently being trained. * `available` indicates that the model is trained and ready to use. * `upgrading` indicates that the model is currently being upgraded. * `failed` indicates that training of the model failed.
    public var status: String?

    /// A percentage that indicates the progress of the custom language model's current training. A value of `100` means that the model is fully trained. **Note:** The `progress` field does not currently reflect the progress of the training; the field changes from `0` to `100` when training is complete.
    public var progress: Int?

    /// If the request included unknown query parameters, the following message: `Unexpected query parameter(s) ['parameters'] detected`, where `parameters` is a list that includes a quoted string for each unknown parameter.
    public var warnings: String?

    /**
     Initialize a `LanguageModel` with member variables.

     - parameter customizationID: The customization ID (GUID) of the custom language model. **Note:** When you create a new custom language model, the service returns only the GUID of the new model; it does not return the other fields of this object.
     - parameter created: The date and time in Coordinated Universal Time (UTC) at which the custom language model was created. The value is provided in full ISO 8601 format (`YYYY-MM-DDThh:mm:ss.sTZD`).
     - parameter language: The language identifier of the custom language model (for example, `en-US`).
     - parameter dialect: The dialect of the language for the custom language model. By default, the dialect matches the language of the base model; for example, `en-US` for either of the US English language models. For Spanish models, the field indicates the dialect for which the model was created: * `es-ES` for Castilian Spanish (the default) * `es-LA` for Latin American Spanish * `es-US` for North American (Mexican) Spanish.
     - parameter versions: A list of the available versions of the custom language model. Each element of the array indicates a version of the base model with which the custom model can be used. Multiple versions exist only if the custom model has been upgraded; otherwise, only a single version is shown.
     - parameter owner: The GUID of the service credentials for the instance of the service that owns the custom language model.
     - parameter name: The name of the custom language model.
     - parameter description: The description of the custom language model.
     - parameter baseModelName: The name of the language model for which the custom language model was created.
     - parameter status: The current status of the custom language model: * `pending` indicates that the model was created but is waiting either for training data to be added or for the service to finish analyzing added data. * `ready` indicates that the model contains data and is ready to be trained. * `training` indicates that the model is currently being trained. * `available` indicates that the model is trained and ready to use. * `upgrading` indicates that the model is currently being upgraded. * `failed` indicates that training of the model failed.
     - parameter progress: A percentage that indicates the progress of the custom language model's current training. A value of `100` means that the model is fully trained. **Note:** The `progress` field does not currently reflect the progress of the training; the field changes from `0` to `100` when training is complete.
     - parameter warnings: If the request included unknown query parameters, the following message: `Unexpected query parameter(s) ['parameters'] detected`, where `parameters` is a list that includes a quoted string for each unknown parameter.

     - returns: An initialized `LanguageModel`.
    */
    public init(customizationID: String, created: String? = nil, language: String? = nil, dialect: String? = nil, versions: [String]? = nil, owner: String? = nil, name: String? = nil, description: String? = nil, baseModelName: String? = nil, status: String? = nil, progress: Int? = nil, warnings: String? = nil) {
        self.customizationID = customizationID
        self.created = created
        self.language = language
        self.dialect = dialect
        self.versions = versions
        self.owner = owner
        self.name = name
        self.description = description
        self.baseModelName = baseModelName
        self.status = status
        self.progress = progress
        self.warnings = warnings
    }
}

extension LanguageModel: Codable {

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
        static let allValues = [customizationID, created, language, dialect, versions, owner, name, description, baseModelName, status, progress, warnings]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        customizationID = try container.decode(String.self, forKey: .customizationID)
        created = try container.decodeIfPresent(String.self, forKey: .created)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        dialect = try container.decodeIfPresent(String.self, forKey: .dialect)
        versions = try container.decodeIfPresent([String].self, forKey: .versions)
        owner = try container.decodeIfPresent(String.self, forKey: .owner)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        baseModelName = try container.decodeIfPresent(String.self, forKey: .baseModelName)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        progress = try container.decodeIfPresent(Int.self, forKey: .progress)
        warnings = try container.decodeIfPresent(String.self, forKey: .warnings)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(customizationID, forKey: .customizationID)
        try container.encodeIfPresent(created, forKey: .created)
        try container.encodeIfPresent(language, forKey: .language)
        try container.encodeIfPresent(dialect, forKey: .dialect)
        try container.encodeIfPresent(versions, forKey: .versions)
        try container.encodeIfPresent(owner, forKey: .owner)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(baseModelName, forKey: .baseModelName)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(progress, forKey: .progress)
        try container.encodeIfPresent(warnings, forKey: .warnings)
    }

}
