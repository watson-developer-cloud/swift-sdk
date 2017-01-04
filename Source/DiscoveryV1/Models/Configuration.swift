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

/** A custom configuration for the environment. */
public struct Configuration: JSONDecodable {
    
    /// The unique identifier of the configuration.
    public let configurationID: String?

    /// The creation date of the configuration in the format yyyy-MM-dd'T'HH:mm
    /// :ss.SSS'Z'.
    public let created: String
    
    /// The timestamp of when the configuration was last updated in the format
    /// yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
    public let updated: String
    
    /// The name of the configuration.
    public let name: String
    
    /// The description of the configuration, if available.
    public let description: String?
    
    /// Used internally to initialize a `Configuration` model from JSON.
    public init(json: JSON) throws {
        configurationID = try? json.getString(at: "configuration_id")
        created = try json.getString(at: "created")
        updated = try json.getString(at: "updated")
        name = try json.getString(at: "name")
        description = try? json.getString(at: "description")
    }
}
