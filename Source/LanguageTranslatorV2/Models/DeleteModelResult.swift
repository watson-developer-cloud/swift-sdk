/**
 * Copyright IBM Corporation 2018
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

/** DeleteModelResult. */
public struct DeleteModelResult {

    /// "OK" indicates that the model was successfully deleted.
    public var status: String

    /**
     Initialize a `DeleteModelResult` with member variables.

     - parameter status: "OK" indicates that the model was successfully deleted.

     - returns: An initialized `DeleteModelResult`.
    */
    public init(status: String) {
        self.status = status
    }
}

extension DeleteModelResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case status = "status"
        static let allValues = [status]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(String.self, forKey: .status)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
    }

}
