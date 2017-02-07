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

/** An option specifying if the relationships found between entities in the analyzed content should 
 be returned. */
public struct RelationsOptions: JSONEncodable {
    
    /// Enter a custom model ID to override the default `en-news` model. Use `es-news` for Spanish
    /// news, and `ar-news` for Arabic news.
    public let model: String?

    /**
    Initialize a `RelationsOptions` with all member variables.

     - parameter model: Enter a custom model ID to override the default `en-news` model. Use 
        `es-news` for Spanish news, and `ar-news` for Arabic news.
    
     - returns: An initialized `RelationsOptions`.
    */
    public init(model: String? = nil) {
        self.model = model
    }

    /// Used internally to serialize a `RelationsOptions` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let model = model { json["model"] = model }
        return json
    }
}
