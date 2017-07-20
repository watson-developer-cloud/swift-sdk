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

/** UpdateCounterexample. */
public struct UpdateCounterexample: JSONDecodable, JSONEncodable {

    /// The text of the example to be marked as irrelevant input.
    public let text: String?

    /**
     Initialize a `UpdateCounterexample` with member variables.

     - parameter text: The text of the example to be marked as irrelevant input.

     - returns: An initialized `UpdateCounterexample`.
    */
    public init(text: String? = nil) {
        self.text = text
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `UpdateCounterexample` model from JSON.
    public init(json: JSON) throws {
        text = try? json.getString(at: "text")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `UpdateCounterexample` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let text = text { json["text"] = text }
        return json
    }
}
