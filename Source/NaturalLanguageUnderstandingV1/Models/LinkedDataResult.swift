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

public struct LinkedDataResult: JSONDecodable,JSONEncodable {
    /// Name of the Linked Data source
    public let source: String?
    /// URL to the Linked Data page
    public let link: String?

    /**
     Initialize a `LinkedDataResult` with required member variables.

     - returns: An initialized `LinkedDataResult`.
    */
    public init() {
        self.source = nil
        self.link = nil
    }

    /**
    Initialize a `LinkedDataResult` with all member variables.

     - parameter source: Name of the Linked Data source
     - parameter link: URL to the Linked Data page

    - returns: An initialized `LinkedDataResult`.
    */
    public init(source: String, link: String) {
        self.source = source
        self.link = link
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `LinkedDataResult` model from JSON.
    public init(json: JSON) throws {
        source = try? json.getString(at: "source")
        link = try? json.getString(at: "link")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `LinkedDataResult` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let source = source { json["source"] = source }
        if let link = link { json["link"] = link }
        return json
    }
}
