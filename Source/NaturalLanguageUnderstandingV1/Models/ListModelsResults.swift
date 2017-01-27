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

/** Models available for Relations and Entities features */
public struct ListModelsResults: JSONDecodable,JSONEncodable {
    public let models: [Model]?

    /**
     Initialize a `ListModelsResults` with required member variables.

     - returns: An initialized `ListModelsResults`.
    */
    public init() {
        self.models = nil
    }

    /**
    Initialize a `ListModelsResults` with all member variables.

     - parameter models: 

    - returns: An initialized `ListModelsResults`.
    */
    public init(models: [Model]) {
        self.models = models
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `ListModelsResults` model from JSON.
    public init(json: JSON) throws {
        models = try? json.decodedArray(at: "models", type: Model.self)
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `ListModelsResults` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let models = models {
            json["models"] = models.map { modelsElem in modelsElem.toJSONObject() }
        }
        return json
    }
}
