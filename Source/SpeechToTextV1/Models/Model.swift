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

/** A model supported by the Speech to Text service. */
public struct Model: JSONDecodable {

    /// The name of the model for use as an identifier in calls
    /// to the service (for example, `en-US_BroadbandModel`).
    public let name: String

    /// The sample rate (minimum acceptable rate for audio) used by the model in Hertz.
    public let rate: Int

    /// The language identifier for the model (for example, `en-US`).
    public let language: String

    /// The URI of the model.
    public let url: String

    /// The additional service features supported with the model.
    public let supportedFeatures: SupportedFeatures

    /// A brief description of the model.
    public let description: String

    /// Used internally to initialize a `Model` from JSON.
    public init(json: JSONWrapper) throws {
        name = try json.getString(at: "name")
        rate = try json.getInt(at: "rate")
        language = try json.getString(at: "language")
        url = try json.getString(at: "url")
        supportedFeatures = try json.decode(at: "supported_features")
        description = try json.getString(at: "description")
    }
}

/** The additional service features supported with a model. */
public struct SupportedFeatures: JSONDecodable {

    /// Indicates whether the model can be customized with a custom language model.
    public let customLanguageModel: Bool

    /// Used internally to initialize a `SupportedFeatures` model from JSON.
    public init(json: JSONWrapper) throws {
        customLanguageModel = try json.getBool(at: "custom_language_model")
    }
}
