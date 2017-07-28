/**
 * Copyright IBM Corporation 2017
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
import RestKit

/** A custom language model. */
public struct Customization: JSONDecodable {
    
    /// The ID of this custom language model.
    public let customizationID: String
    
    /// The creation date of the custom language model, in the format YYYY-MM-DDThh:mm:ss.sTZD.
    public let created: String
    
    /// The language of the custom language model. For example, `en-US` or `ja-JP`.
    public let language: String
    
    /// The dialect of the language for the custom model. For US English and Japanese models,
    /// the field is always `en-US` or `ja-JP`. For Spanish models, the field indicates the
    /// dialect for which the model was created: `es-ES` for Castilian Spanish (the default);
    /// `es-LA` for Latin-American Spanish; or `es-US` for North-American (Mexican) Spanish.
    public let dialect: String
    
    /// The ID of the service credentials for the owner of this model.
    public let owner: String
    
    /// The name of the custom language model.
    public let name: String
    
    /// The description of the custom language model.
    public let description: String
    
    /// The name of the base language model for which this custom language model was created.
    public let baseModelName: String
    
    /// The current status of the custom language model.
    public let status: CustomizationStatus
    
    /// A percentage indicating the progress of the model's current training. A value of `100` 
    /// means that the model is fully trained.
    public let progress: Int
    
    /// If the request contained unknown query parameters, a list of those unknown parameters will 
    /// be included here.
    public let warnings: String?
    
    /// Used internally to initialize a `Customization` model from JSON.
    public init(json: JSON) throws {
        customizationID = try json.getString(at: "customization_id")
        created = try json.getString(at: "created")
        language = try json.getString(at: "language")
        dialect = try json.getString(at: "dialect")
        owner = try json.getString(at: "owner")
        name = try json.getString(at: "name")
        description = try json.getString(at: "description")
        baseModelName = try json.getString(at: "base_model_name")
        guard let customizationStatus = CustomizationStatus(rawValue: try json.getString(at: "status")) else {
            throw JSON.Error.valueNotConvertible(value: json, to: CustomizationStatus.self)
        }
        status = customizationStatus
        progress = try json.getInt(at: "progress")
        warnings = try? json.getString(at: "warnings")
    }
}

/** The current status of the custom language model. */
public enum CustomizationStatus: String {
    
    /// The model was created but is waiting either for training data to be added or for the 
    /// service to finish analyzing added data.
    case pending = "pending"
    
    /// The model contains data and is ready to be trained.
    case ready = "ready"
    
    /// The model is currently being trained.
    case training = "training"
    
    /// The model is trained and ready to use.
    case available = "available"
    
    /// Training of the model failed.
    case failed = "failed"
}
