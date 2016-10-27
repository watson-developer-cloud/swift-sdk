/**
 * Copyright IBM Corporation 2015
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

/**
 
 **Keywords**
 
 Response object for **Microformat** related calls
 
 */

public struct Microformats: JSONDecodable {
    
    /** the URL information was requested for */
    public let url: String?
    
    /** see **Microformat** */
    public let microformats: [Microformat]?
    
    /// Used internally to initialize a Microformats object
    public init(json: JSON) throws {
        let status = try json.getString(at: "status")
        guard status == "OK" else {
            throw JSON.Error.valueNotConvertible(value: json, to: Microformats.self)
        }
        
        url = try? json.getString(at: "url")
        microformats = try? json.decodedArray(at: "microformats", type: Microformat.self)
    }
}
