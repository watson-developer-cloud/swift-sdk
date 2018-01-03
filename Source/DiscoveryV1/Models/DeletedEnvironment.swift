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

/** An object with information about the deleted environment. */
public struct DeletedEnvironment: JSONDecodable {

    /// Unique identifier for the deleted environment.
    public let environmentID: String

    /// Status of the environment. A status of `deleted` indicates that the environment
    /// was successfully deleted.
    public let status: String

    /// Used internally to initialize a `DeletedEnvironment` model from JSON.
    public init(json: JSONWrapper) throws {
        environmentID = try json.getString(at: "environment_id")
        status = try json.getString(at: "status")
    }
}
