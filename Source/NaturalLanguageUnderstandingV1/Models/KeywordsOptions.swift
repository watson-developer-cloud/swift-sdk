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

/** An option indicating whether or not important keywords from the analyzed content should be returned. */
public struct KeywordsOptions: JSONEncodable {
    
    /// Maximum number of keywords to return.
    public let limit: Int?
    
    /// Set this to true to return sentiment information for detected keywords.
    public let sentiment: Bool?

    /**
    Initialize a `KeywordsOptions` with all member variables.

     - parameter limit: Maximum number of keywords to return
     - parameter sentiment: Set this to true to return sentiment information for detected keywords

    - returns: An initialized `KeywordsOptions`.
    */
    public init(limit: Int? = nil, sentiment: Bool? = nil) {
        self.limit = limit
        self.sentiment = sentiment
    }

    /// Used internally to serialize a `KeywordsOptions` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let limit = limit { json["limit"] = limit }
        if let sentiment = sentiment { json["sentiment"] = sentiment }
        return json
    }
}
