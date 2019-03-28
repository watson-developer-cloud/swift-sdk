/**
 * Copyright IBM Corporation 2019
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
 List of document attributes.
 */
public struct Attribute: Codable, Equatable {

    /**
     The type of attribute.
     */
    public enum TypeEnum: String {
        case currency = "Currency"
        case datetime = "DateTime"
        case duration = "Duration"
        case location = "Location"
        case organization = "Organization"
        case percentage = "Percentage"
        case person = "Person"
    }

    /**
     The type of attribute.
     */
    public var type: String?

    /**
     The text associated with the attribute.
     */
    public var text: String?

    /**
     The numeric location of the identified element in the document, represented with two integers labeled `begin` and
     `end`.
     */
    public var location: Location?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case text = "text"
        case location = "location"
    }

}
