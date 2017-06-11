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

/** An input object that includes the input text. */
public struct Input: JSONEncodable, JSONDecodable {

    /// The raw JSON object used to construct this model.
    public let json: [String: Any]

    /// The user's input.
    public let text: String

    /**
     Create an `Input` with the user's input text.

     - parameter text: The user's input text.
     */
    public init(text: String) {
        self.json = ["text": text]
        self.text = text
    }

    /// Used internally to initialize an `Input` model from JSON.
    public init(json: JSON) throws {
        self.json = try json.getDictionaryObject()
        text = try json.getString(at: "text")
    }

    /// Used internally to serialize an `Input` model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}
