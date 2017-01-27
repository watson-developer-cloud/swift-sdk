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

public struct EntitiesOptions: JSONDecodable,JSONEncodable {
    /// Maximum number of entities to return
    public let limit: Int?
    /// Enter a custom model ID to override the standard entity detection model
    public let model: String?
    /// Set this to false to hide entity disambiguation information in the response
    public let disambiguation: Bool?
    /// Set this to true to return sentiment information for detected entities
    public let sentiment: Bool?

    /**
     Initialize a `EntitiesOptions` with required member variables.

     - returns: An initialized `EntitiesOptions`.
    */
    public init() {
        self.limit = nil
        self.model = nil
        self.disambiguation = nil
        self.sentiment = nil
    }

    /**
    Initialize a `EntitiesOptions` with all member variables.

     - parameter limit: Maximum number of entities to return
     - parameter model: Enter a custom model ID to override the standard entity detection model
     - parameter disambiguation: Set this to false to hide entity disambiguation information in the response
     - parameter sentiment: Set this to true to return sentiment information for detected entities

    - returns: An initialized `EntitiesOptions`.
    */
    public init(limit: Int, model: String, disambiguation: Bool, sentiment: Bool) {
        self.limit = limit
        self.model = model
        self.disambiguation = disambiguation
        self.sentiment = sentiment
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `EntitiesOptions` model from JSON.
    public init(json: JSON) throws {
        limit = try? json.getInt(at: "limit")
        model = try? json.getString(at: "model")
        disambiguation = try? json.getBool(at: "disambiguation")
        sentiment = try? json.getBool(at: "sentiment")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `EntitiesOptions` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let limit = limit { json["limit"] = limit }
        if let model = model { json["model"] = model }
        if let disambiguation = disambiguation { json["disambiguation"] = disambiguation }
        if let sentiment = sentiment { json["sentiment"] = sentiment }
        return json
    }
}
