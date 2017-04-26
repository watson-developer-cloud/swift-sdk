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

/** An option indicating whether or not to include the author, publication date, and title of 
 the HTML or URL content. */
public struct MetadataOptions: JSONEncodable {
    
    /// The JSON object to internally serialize the model to JSON.
    public let json: [String: Any]?
    
    /**
     Initialize a `MetadataOptions` with all member variables.
     
     - returns: An initialized `MetadataOptions`.
     */
    public init() {
        json = [String: Any]()
    }
    
    /// Used internally to serialize a `MetadataOptions` model to JSON.
    public func toJSONObject() -> Any {
        return json ?? [String: Any]()
    }
}
