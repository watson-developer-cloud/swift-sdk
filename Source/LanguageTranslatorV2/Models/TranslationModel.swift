/**
 * Copyright IBM Corporation 2016
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

/** A translation model that can be used to translate between a source and target language. */
public struct TranslationModel: JSONDecodable {

    /// A globally unique string that identifies the underllying model that is used for
    /// translation. This string contains all the information about source language,
    /// target language, domain, and various other related configurations.
    public let modelID: String

    /// If a model is trained by a user, there might be an optional "name" parameter
    /// attached during training to help the user identify the model.
    public let name: String

    /// Source language in two-letter language code. Use the five letter code when clarifying
    /// between multiple supported languages. When `modelID` is used directly, it will
    /// override the source-target language combination. Also, when a two-letter language
    /// code is used, but no suitable default is found, it returns an error.
    public let source: String

    /// Target language in two-letter language code.
    public let target: String

    /// If this model is a custom model, this returns the base model that it is trained on.
    /// For a base model, this response value is empty.
    public let baseModelID: String

    /// The domain of the translation model.
    public let domain: String

    /// Whether this model can be used as a base for customization.
    public let customizable: Bool

    /// Whether this model is considered a default model and is used when the source and
    /// target languages are specified without the `modelID`.
    public let defaultModel: Bool

    /// Returns the Bluemix ID of the instance that created the model, or an empty
    /// string if it is a model that is trained by IBM.
    public let owner: String

    /// Availability of model (available, training, or error).
    public let status: TrainingStatus

    /// Used internally to initialize a `TranslationModel` model from JSON.
    public init(json: JSONWrapper) throws {
        modelID = try json.getString(at: "model_id")
        name = try json.getString(at: "name")
        source = try json.getString(at: "source")
        target = try json.getString(at: "target")
        baseModelID = try json.getString(at: "base_model_id")
        domain = try json.getString(at: "domain")
        customizable = try json.getBool(at: "customizable")
        defaultModel = try json.getBool(at: "default_model")
        owner = try json.getString(at: "owner")

        guard let status = TrainingStatus(rawValue: try json.getString(at: "status")) else {
            throw JSONWrapper.Error.valueNotConvertible(value: json, to: TrainingStatus.self)
        }
        self.status = status
    }
}
