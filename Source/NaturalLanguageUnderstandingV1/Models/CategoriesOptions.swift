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

/** An option specifying if the analyzed content should be categorized into a hierarchical 5-level taxonomy. */
public struct CategoriesOptions: JSONEncodable {
    
    /// The JSON object to internally serialize the model to JSON.
    public let json: [String: Any]?
    
    /**
     Initialize a `CategoriesOptions` with all member variables.
     
     - returns: An initialized `CategoriesOptions`.
     */
    public init() {
        json = [String: Any]()
    }
    
    /// Used internally to serialize a `CategoriesOptions` model to JSON.
    public func toJSONObject() -> Any {
        return json ?? [String: Any]()
    }
}
