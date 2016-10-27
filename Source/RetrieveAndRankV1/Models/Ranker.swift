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

/** A model containing information about a specific ranker. */
public struct Ranker: JSONDecodable {
    
    /// The unique identifier for this ranker.
    public let rankerID: String
    
    /// The link to this ranker.
    public let url: String
    
    /// The user-supplied name for this ranker.
    public let name: String
    
    /// The date and time, in UTC, that the ranker was created.
    public let created: String
    
    /// Used internally to initialize a `Ranker` model from JSON.
    public init(json: JSON) throws {
        rankerID = try json.getString(at: "ranker_id")
        url = try json.getString(at: "url")
        name = try json.getString(at: "name")
        created = try json.getString(at: "created")
    }
}
