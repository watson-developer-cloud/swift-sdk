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


public struct KeywordsOptions: JSONDecodable,JSONEncodable {
    /// Maximum number of keywords to return
    public let limit: Int32?
    /// Set this to true to return sentiment information for detected keywords
    public let sentiment: Bool?

    /**
     Initialize a `KeywordsOptions` with required member variables.


     - returns: An initialized `KeywordsOptions`.
    */
    public init() {
    }

    /**
    Initialize a `KeywordsOptions` with all member variables.

     - parameter limit: Maximum number of keywords to return
     - parameter sentiment: Set this to true to return sentiment information for detected keywords

    - returns: An initialized `KeywordsOptions`.
    */
    public init(limit: Int32, sentiment: Bool) {
        self.limit = limit
        self.sentiment = sentiment
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `KeywordsOptions` model from JSON.
    public init(json: JSON) throws {
        limit = try? json.getString(at: "limit")
        sentiment = try? json.getString(at: "sentiment")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `KeywordsOptions` model to JSON.
    func toJSONObject() -> Any {
        var json = [String: Any]()
        if let limit = limit { json["limit"] = limit }
        if let sentiment = sentiment { json["sentiment"] = sentiment }
        return json
    }
}
