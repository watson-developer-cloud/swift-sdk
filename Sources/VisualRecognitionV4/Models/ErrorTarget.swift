/**
 * (C) Copyright IBM Corp. 2019.
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
 Details about the specific area of the problem.
 */
public struct ErrorTarget: Codable, Equatable {

    /**
     The parameter or property that is the focus of the problem.
     */
    public enum TypeEnum: String {
        case field = "field"
        case parameter = "parameter"
        case header = "header"
    }

    /**
     The parameter or property that is the focus of the problem.
     */
    public var type: String

    /**
     The property that is identified with the problem.
     */
    public var name: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case name = "name"
    }

}
