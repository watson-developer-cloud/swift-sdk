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
    
/** A voice supported by the Text to Speech service. */
public struct Voice: JSONDecodable {
    
    /// The URI of the voice.
    public let url: String
    
    /// The gender of the voice: male or female.
    public let gender: String
    
    /// The name of the voice. Use this value as the voice
    /// identifier in all requests that accept a voice.
    public let name: String
    
    /// The language and region of the voice; for example, en-US for US English.
    public let language: String
    
    /// A description of the voice.
    public let description: String
    
    /// Indicates whether the voice can be customized with a custom voice model.
    public let customizable: Bool
    
    /// A Customization object that provides information about a specific custom voice model
    /// for the voice. Returned only when a customization_id is is specified with the call.
    public let customization: Customization?
    
    /// Used internally to initialize a `Voice` model from JSON.
    public init(json: JSON) throws {
        name = try json.getString(at: "name")
        gender = try json.getString(at: "gender")
        language = try json.getString(at: "language")
        url = try json.getString(at: "url")
        description = try json.getString(at: "description")
        customizable = try json.getBool(at: "customizable")
        customization = try? json.decode(at: "customization")
    }
}
