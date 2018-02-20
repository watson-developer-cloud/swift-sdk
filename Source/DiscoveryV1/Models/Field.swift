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

/** Field. */
public struct Field {

    /// The type of the field.
    public enum FieldType: String {
        case nested = "nested"
        case string = "string"
        case date = "date"
        case long = "long"
        case integer = "integer"
        case short = "short"
        case byte = "byte"
        case double = "double"
        case float = "float"
        case boolean = "boolean"
        case binary = "binary"
    }

    /// The name of the field.
    public var fieldName: String?

    /// The type of the field.
    public var fieldType: String?

    /**
     Initialize a `Field` with member variables.

     - parameter fieldName: The name of the field.
     - parameter fieldType: The type of the field.

     - returns: An initialized `Field`.
    */
    public init(fieldName: String? = nil, fieldType: String? = nil) {
        self.fieldName = fieldName
        self.fieldType = fieldType
    }
}

extension Field: Codable {

    private enum CodingKeys: String, CodingKey {
        case fieldName = "field"
        case fieldType = "type"
        static let allValues = [fieldName, fieldType]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fieldName = try container.decodeIfPresent(String.self, forKey: .fieldName)
        fieldType = try container.decodeIfPresent(String.self, forKey: .fieldType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(fieldName, forKey: .fieldName)
        try container.encodeIfPresent(fieldType, forKey: .fieldType)
    }

}
