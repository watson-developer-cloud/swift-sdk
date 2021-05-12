/**
 * (C) Copyright IBM Corp. 2021.
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
import IBMSwiftSDKCore

/**
 SentimentModel.
 */
public struct SentimentModel: Codable, Equatable {

    /**
     When the status is `available`, the model is ready to use.
     */
    public enum Status: String {
        case starting = "starting"
        case training = "training"
        case deploying = "deploying"
        case available = "available"
        case error = "error"
        case deleted = "deleted"
    }

    /**
     The service features that are supported by the custom model.
     */
    public var features: [String]?

    /**
     When the status is `available`, the model is ready to use.
     */
    public var status: String?

    /**
     Unique model ID.
     */
    public var modelID: String?

    /**
     dateTime indicating when the model was created.
     */
    public var created: Date?

    /**
     dateTime of last successful model training.
     */
    public var lastTrained: Date?

    /**
     dateTime of last successful model deployment.
     */
    public var lastDeployed: Date?

    /**
     A name for the model.
     */
    public var name: String?

    /**
     An optional map of metadata key-value pairs to store with this model.
     */
    public var userMetadata: [String: JSON]?

    /**
     The 2-letter language code of this model.
     */
    public var language: String?

    /**
     An optional description of the model.
     */
    public var description: String?

    /**
     An optional version string.
     */
    public var modelVersion: String?

    /**
     Deprecated — use `model_version`.
     */
    public var version: String?

    /**
     ID of the Watson Knowledge Studio workspace that deployed this model to Natural Language Understanding.
     */
    public var workspaceID: String?

    /**
     The description of the version.
     */
    public var versionDescription: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case features = "features"
        case status = "status"
        case modelID = "model_id"
        case created = "created"
        case lastTrained = "last_trained"
        case lastDeployed = "last_deployed"
        case name = "name"
        case userMetadata = "user_metadata"
        case language = "language"
        case description = "description"
        case modelVersion = "model_version"
        case version = "version"
        case workspaceID = "workspace_id"
        case versionDescription = "version_description"
    }

}
