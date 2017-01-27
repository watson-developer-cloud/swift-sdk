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
import RestKit

/**  */
public struct Model: JSONDecodable,JSONEncodable {
    /// Shows as available if the model is ready for use
    public let status: String?
    /// Unique model ID
    public let modelId: String?
    /// ISO 639-1 code indicating the language of the model
    public let language: String?
    /// Model description
    public let description: String?

    /**
     Initialize a `Model` with required member variables.


     - returns: An initialized `Model`.
    */
    public init() {
    }

    /**
    Initialize a `Model` with all member variables.

     - parameter status: Shows as available if the model is ready for use
     - parameter modelId: Unique model ID
     - parameter language: ISO 639-1 code indicating the language of the model
     - parameter description: Model description

    - returns: An initialized `Model`.
    */
    public init(status: String, modelId: String, language: String, description: String) {
        self.status = status
        self.modelId = modelId
        self.language = language
        self.description = description
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `Model` model from JSON.
    public init(json: JSON) throws {
        status = try? json.getString(at: "status")
        modelId = try? json.getString(at: "model_id")
        language = try? json.getString(at: "language")
        description = try? json.getString(at: "description")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `Model` model to JSON.
    func toJSONObject() -> Any {
        var json = [String: Any]()
        if let status = status { json["status"] = status }
        if let modelId = modelId { json["model_id"] = modelId }
        if let language = language { json["language"] = language }
        if let description = description { json["description"] = description }
        return json
    }
}
