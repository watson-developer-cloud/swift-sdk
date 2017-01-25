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

/** Usage information */
public struct Usage: JSONDecodable,JSONEncodable {
    /// Number of features used in the API call
    public let features: Int32?

    /**
     Initialize a `Usage` with required member variables.


     - returns: An initialized `Usage`.
    */
    public init() {
    }

    /**
    Initialize a `Usage` with all member variables.

     - parameter features: Number of features used in the API call

    - returns: An initialized `Usage`.
    */
    public init(features: Int32) {
        self.features = features
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `Usage` model from JSON.
    public init(json: JSON) throws {
        features = try? json.getString(at: "features")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `Usage` model to JSON.
    func toJSONObject() -> Any {
        var json = [String: Any]()
        if let features = features { json["features"] = features }
        return json
    }
}
