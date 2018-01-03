/**
 * Copyright IBM Corporation 2016-2017
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

//===----------------------------------------------------------------------===//
// Extensions: JSONEncoder
//===----------------------------------------------------------------------===//

internal extension JSONEncoder {

    /// Encode an optional object.
    internal func encodeIfPresent<T: Encodable>(_ value: T?) throws -> Data {
        guard let value = value else { return Data() }
        return try encode(value)
    }

}

//===----------------------------------------------------------------------===//
// Extensions: KeyedEncodingContainer<DynamicKeys>
//===----------------------------------------------------------------------===//

internal extension KeyedEncodingContainer where Key == DynamicKeys {

    /// Encode additional properties.
    internal mutating func encode(_ additionalProperties: [String: JSON]) throws {
        try additionalProperties.forEach { key, value in
            guard let codingKey = DynamicKeys(stringValue: key) else {
                let description = "Cannot construct CodingKey for \(key)"
                let context = EncodingError.Context(codingPath: codingPath, debugDescription: description)
                throw EncodingError.invalidValue(key, context)
            }
            try self.encode(value, forKey: codingKey)
        }
    }

    /// Encode additional properties if they are not nil.
    internal mutating func encodeIfPresent(_ additionalProperties: [String: JSON]?) throws {
        guard let additionalProperties = additionalProperties else { return }
        try encode(additionalProperties)
    }

}

//===----------------------------------------------------------------------===//
// Extensions: KeyedDecodingContainer<DynamicKeys>
//===----------------------------------------------------------------------===//

internal extension KeyedDecodingContainer where Key == DynamicKeys {

    /// Decode additional properties.
    internal func decode(_ type: [String: JSON].Type, excluding keys: [CodingKey]) throws -> [String: JSON] {
        let value = try JSON(from: self, excluding: keys)
        guard case let .object(object) = value else {
            let description = "Expected to decode a JSONValue.object but found \(value) instead."
            let context = DecodingError.Context(codingPath: self.codingPath, debugDescription: description)
            throw DecodingError.dataCorrupted(context)
        }
        return object
    }

}

//===----------------------------------------------------------------------===//
// DynamicKeys
//===----------------------------------------------------------------------===//

/// A coding key to process dynamic objects,
/// whose keys are not known in advance.
internal struct DynamicKeys: CodingKey {
    internal let stringValue: String
    internal let intValue: Int?
    internal init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    internal init?(intValue: Int) {
        self.stringValue = "Index \(intValue)"
        self.intValue = intValue
    }
}
