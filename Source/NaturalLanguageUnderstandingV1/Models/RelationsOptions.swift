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

public struct RelationsOptions: JSONDecodable,JSONEncodable {
    /// Enter a custom model ID to override the default &#x60;en-news&#x60; model&lt;br&gt;&lt;ul&gt;&lt;li&gt;es-news: Spanish news&lt;/li&gt;&lt;li&gt;ar-news: Arabic news&lt;/li&gt;&lt;/ul&gt;
    public let model: String?

    /**
     Initialize a `RelationsOptions` with required member variables.

     - returns: An initialized `RelationsOptions`.
    */
    public init() {
        self.model = nil
    }

    /**
    Initialize a `RelationsOptions` with all member variables.

     - parameter model: Enter a custom model ID to override the default &#x60;en-news&#x60; model&lt;br&gt;&lt;ul&gt;&lt;li&gt;es-news: Spanish news&lt;/li&gt;&lt;li&gt;ar-news: Arabic news&lt;/li&gt;&lt;/ul&gt;

    - returns: An initialized `RelationsOptions`.
    */
    public init(model: String) {
        self.model = model
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `RelationsOptions` model from JSON.
    public init(json: JSON) throws {
        model = try? json.getString(at: "model")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `RelationsOptions` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let model = model { json["model"] = model }
        return json
    }
}
