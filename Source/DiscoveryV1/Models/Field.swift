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

/** Field. */
public struct Field: Codable, Equatable {

    /**
     The type of the field.
     */
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

    /**
     The name of the field.
     */
    public var fieldName: String?

    /**
     The type of the field.
     */
    public var fieldType: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case fieldName = "field"
        case fieldType = "type"
    }

}
