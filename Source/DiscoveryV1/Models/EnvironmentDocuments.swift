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

/**
 Summary of the document usage statistics for the environment.
 */
public struct EnvironmentDocuments: Codable, Equatable {

    /**
     Number of documents indexed for the environment.
     */
    public var indexed: Int?

    /**
     Total number of documents allowed in the environment's capacity.
     */
    public var maximumAllowed: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case indexed = "indexed"
        case maximumAllowed = "maximum_allowed"
    }

}
