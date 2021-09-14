/**
 * (C) Copyright IBM Corp. 2021.
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

/**
 Object that contains details about the status of the authentication process.
 */
public struct StatusDetails: Codable, Equatable {

    /**
     Indicates whether the credential is accepted by the target data source.
     */
    public var authenticated: Bool?

    /**
     If `authenticated` is `false`, a message describes why the authentication was unsuccessful.
     */
    public var errorMessage: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case authenticated = "authenticated"
        case errorMessage = "error_message"
    }

    /**
      Initialize a `StatusDetails` with member variables.

      - parameter authenticated: Indicates whether the credential is accepted by the target data source.
      - parameter errorMessage: If `authenticated` is `false`, a message describes why the authentication was
        unsuccessful.

      - returns: An initialized `StatusDetails`.
     */
    public init(
        authenticated: Bool? = nil,
        errorMessage: String? = nil
    )
    {
        self.authenticated = authenticated
        self.errorMessage = errorMessage
    }

}
