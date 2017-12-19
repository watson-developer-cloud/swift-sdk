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

/// Publication date found within the document.
public struct PublicationDate: JSONDecodable {

    /// Confidence level of the detection of the publication date.
    public let confident: String?

    /// Detected publication date in the format yyyy-MM-dd'T'HH:mm
    /// :ss.SSS'Z'.
    public let date: String?

    /// The raw JSON object used to construct this model.
    public let json: [String: Any]

    /// Used internally to initialize a PublicationDate object
    public init(json: JSONWrapper) throws {
        confident = try? json.getString(at: "confident")
        date = try? json.getString(at: "date")
        self.json = try json.getDictionaryObject()
    }

    /// Used internally to serialize an 'PublicationDate' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}
