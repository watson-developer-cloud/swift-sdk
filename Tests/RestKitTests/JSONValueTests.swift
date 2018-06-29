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

// swiftlint:disable function_body_length force_try force_unwrapping file_length

import XCTest

class JSONTests: XCTestCase {

    // Note: When encoding a JSON object to a string, Mac and Linux produce different key orderings.
    // This is valid, since there is no required order for the keys in a Swift Dictionary or JSON object.
    // However, the different key orderings make it difficult to compare the strings for equality.
    // Instead of directly comparing strings for equality, we have chosen to sort the strings and
    // ensure that they contain the same characters.

    static var allTests = [
        ("testEquality", testEquality),
        ("testEncodeNull", testEncodeNull),
        ("testEncodeBool", testEncodeBool),
        ("testEncodeInt", testEncodeInt),
        ("testEncodeDouble", testEncodeDouble),
        ("testEncodeDate", testEncodeDate),
        ("testEncodeString", testEncodeString),
        ("testEncodeArray", testEncodeArray),
        ("testEncodeTopLevelArray", testEncodeTopLevelArray),
        ("testEncodeNestedArrays", testEncodeNestedArrays),
        ("testEncodeArrayOfObjects", testEncodeArrayOfObjects),
        ("testEncodeObject", testEncodeObject),
        ("testEncodeEmptyObject", testEncodeEmptyObject),
        ("testEncodeNested", testEncodeNested),
        ("testEncodeDeeplyNested", testEncodeDeeplyNested),
        ("testDecodeNull", testDecodeNull),
        ("testDecodeBool", testDecodeBool),
        ("testDecodeInt", testDecodeInt),
        ("testDecodeDouble", testDecodeDouble),
        ("testDecodeDate", testDecodeDate),
        ("testDecodeString", testDecodeString),
        ("testDecodeArray", testDecodeArray),
        ("testDecodeTopLevelArray", testDecodeTopLevelArray),
        ("testDecodeNestedArray", testDecodeNestedArrays),
        ("testDecodeArrayOfObjects", testDecodeArrayOfObjects),
        ("testDecodeObject", testDecodeObject),
        ("testDecodeEmptyObject", testDecodeEmptyObject),
        ("testDecodeNested", testDecodeNested),
        ("testDecodeDeeplyNested", testDecodeDeeplyNested),
    ]

    func testEquality() {
        // date values
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        let stringDate = "2018-05-17T18:45:32.189Z"
        guard let date = dateFormatter.date(from: stringDate) else {
            XCTFail("Failed to construct date")
            return
        }
        let stringDate2 = "2017-04-16T15:45:32.189Z"
        guard let date2 = dateFormatter.date(from: stringDate2) else {
            XCTFail("Failed to construct date2")
            return
        }

        // equal values
        XCTAssertEqual(JSON.null, JSON.null)
        XCTAssertEqual(JSON.boolean(true), JSON.boolean(true))
        XCTAssertEqual(JSON.string("hello"), JSON.string("hello"))
        XCTAssertEqual(JSON.int(1), JSON.int(1))
        XCTAssertEqual(JSON.double(0.5), JSON.double(0.5))
        XCTAssertEqual(JSON.date(date), JSON.date(date))
        XCTAssertEqual(JSON.array([JSON.int(1), JSON.int(2)]),
                       JSON.array([JSON.int(1), JSON.int(2)]))
        XCTAssertEqual(JSON.object(["x": JSON.int(1), "y": JSON.int(2)]),
                       JSON.object(["y": JSON.int(2), "x": JSON.int(1)]))

        // unequal values
        XCTAssertNotEqual(JSON.boolean(true), JSON.boolean(false))
        XCTAssertNotEqual(JSON.string("hello"), JSON.string("world"))
        XCTAssertNotEqual(JSON.int(1), JSON.int(2))
        XCTAssertNotEqual(JSON.double(3.14), JSON.double(2.72))
        XCTAssertNotEqual(JSON.double(3.14), JSON.double(2.72))
        XCTAssertNotEqual(JSON.date(date), JSON.date(date2))
        XCTAssertNotEqual(JSON.array([JSON.int(1), JSON.int(2)]),
                          JSON.array([JSON.int(2), JSON.int(1)]))
        XCTAssertNotEqual(JSON.object(["x": JSON.int(1), "y": JSON.int(2)]),
                          JSON.object(["x": JSON.int(2), "y": JSON.int(1)]))

        // unequal types
        XCTAssertNotEqual(JSON.null, JSON.boolean(true))
        XCTAssertNotEqual(JSON.boolean(true), JSON.string("true"))
        XCTAssertNotEqual(JSON.string("true"), JSON.int(1))
        XCTAssertNotEqual(JSON.int(1), JSON.double(1.0))
        XCTAssertNotEqual(JSON.string("true"), JSON.date(date))
        XCTAssertNotEqual(JSON.double(1.0), JSON.array([JSON.double(1.0)]))
        XCTAssertNotEqual(JSON.array([JSON.double(1.0)]),
                          JSON.object(["x": JSON.double(1.0)]))
    }

    func testEncodeNull() {
        let object: [String: JSON] = ["key": .null]
        guard let data = try? JSONEncoder().encode(object) else {
            XCTFail("Failed to encode object with null value")
            return
        }
        // encoding with utf8 is always safe
        let json = String(data: data, encoding: .utf8)!
        let expected = "{\"key\":null}"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeBool() {
        let object: [String: JSON] = ["key": .boolean(true)]
        guard let data = try? JSONEncoder().encode(object) else {
            XCTFail("Failed to encode object with boolean value")
            return
        }
        // encoding with utf8 is always safe
        let json = String(data: data, encoding: .utf8)!
        let expected = "{\"key\":true}"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeInt() {
        let object: [String: JSON] = ["key": .int(1)]
        guard let data = try? JSONEncoder().encode(object) else {
            XCTFail("Failed to encode object with int value")
            return
        }
        // encoding with utf8 is always safe
        let json = String(data: data, encoding: .utf8)!
        let expected = "{\"key\":1}"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeDouble() {
        let object: [String: JSON] = ["key": .double(0.5)]
        guard let data = try? JSONEncoder().encode(object) else {
            XCTFail("Failed to encode object with double value")
            return
        }
        // encoding with utf8 is always safe
        let json = String(data: data, encoding: .utf8)!
        let expected = "{\"key\":0.5}"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let expected = "2018-05-17T18:45:32.189Z"
        guard let date = dateFormatter.date(from: expected) else {
            XCTFail("Failed to construct expected date")
            return
        }

        let object: [String: JSON] = ["key": .date(date)]
        guard let data = try? JSON.encoder.encode(object) else {
            XCTFail("Failed to encode object with date value")
            return
        }
        // encoding with utf8 is always safe
        let json = String(data: data, encoding: .utf8)!
        XCTAssertTrue(json.contains(expected))
    }

    func testEncodeString() {
        let object: [String: JSON] = ["key": .string("this is a string")]
        guard let data = try? JSONEncoder().encode(object) else {
            XCTFail("Failed to encode object with string value")
            return
        }
        // encoding with utf8 is always safe
        let json = String(data: data, encoding: .utf8)!
        let expected = "{\"key\":\"this is a string\"}"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeArray() {
        let object: [String: JSON] = ["key": .array([.null, .boolean(true), .int(1), .double(0.5), .string("this is a string")])]
        guard let data = try? JSONEncoder().encode(object) else {
            XCTFail("Failed to encode object with array value")
            return
        }
        // encoding with utf8 is always safe
        let json = String(data: data, encoding: .utf8)!
        let expected = "{\"key\":[null,true,1,0.5,\"this is a string\"]}"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeTopLevelArray() {
        let array: [JSON] = [.null, .boolean(true), .int(1), .double(0.5), .string("this is a string")]
        guard let data = try? JSONEncoder().encode(array) else {
            XCTFail("Failed to encode object with array value")
            return
        }
        // encoding with utf8 is always safe
        let json = String(data: data, encoding: .utf8)!
        let expected = "[null,true,1,0.5,\"this is a string\"]"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeNestedArrays() {
        let array: [JSON] = [.array([.int(1), .int(2), .int(3)]), .array([.int(4), .int(5), .int(6)])]
        guard let data = try? JSONEncoder().encode(array) else {
            XCTFail("Failed to encode object with nested array value")
            return
        }
        // encoding with utf8 is always safe
        let json = String(data: data, encoding: .utf8)!
        let expected = "[[1,2,3],[4,5,6]]"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeArrayOfObjects() {
        let array: [JSON] = [.object(["x": .int(1)]), .object(["y": .int(2)]), .object(["z": .int(3)])]
        guard let data = try? JSONEncoder().encode(array) else {
            XCTFail("Failed to encode object with array of objects value")
            return
        }
        // encoding with utf8 is always safe
        let json = String(data: data, encoding: .utf8)!
        let expected = "[{\"x\":1},{\"y\":2},{\"z\":3}]"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeObject() {
        let object: [String: JSON] = ["key": .object(["null": .null, "bool": .boolean(true), "int": .int(1), "double": .double(0.5), "string": .string("this is a string")])]
        guard let data = try? JSONEncoder().encode(object) else {
            XCTFail("Failed to encode object with object value")
            return
        }
        // encoding with utf8 is always safe
        let json = String(data: data, encoding: .utf8)!
        let expected = "{\"key\":{\"bool\":true,\"double\":0.5,\"string\":\"this is a string\",\"int\":1,\"null\":null}}"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeEmptyObject() {
        let object = [String: JSON]()
        guard let data = try? JSONEncoder().encode(object) else {
            XCTFail("Failed to encode object with empty value")
            return
        }
        // encoding with utf8 is always safe
        let json = String(data: data, encoding: .utf8)!
        let expected = "{}"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeNested() {
        let object: [String: JSON] = ["key": .object(["array": .array([.int(1), .int(2), .int(3)]), "object": .object(["x": .int(1), "y": .int(2), "z": .int(3)])])]
        guard let data = try? JSONEncoder().encode(object) else {
            XCTFail("Failed to encode object with nested value")
            return
        }
        // encoding with utf8 is always safe
        let json = String(data: data, encoding: .utf8)!
        let expected = "{\"key\":{\"array\":[1,2,3],\"object\":{\"y\":2,\"x\":1,\"z\":3}}}"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeDeeplyNested() {
        let object: [String: JSON] = ["key1": .object(["key2": .object(["key3": .object(["key4": .array([.int(1), .int(2), .int(3)])])])])]
        guard let data = try? JSONEncoder().encode(object) else {
            XCTFail("Failed to encode object with deeply nested value")
            return
        }
        // encoding with utf8 is always safe
        let json = String(data: data, encoding: .utf8)!
        let expected = "{\"key1\":{\"key2\":{\"key3\":{\"key4\":[1,2,3]}}}}"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testDecodeNull() {
        let json = "{ \"key\": null }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: JSON].self, from: data)
        XCTAssertEqual(object["key"], .null)
    }

    func testDecodeBool() {
        let json = "{ \"key\": true }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: JSON].self, from: data)
        XCTAssertEqual(object["key"], .boolean(true))
    }

    func testDecodeInt() {
        let json = "{ \"key\": 1 }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: JSON].self, from: data)
        XCTAssertEqual(object["key"], .int(1))
    }

    func testDecodeDouble() {
        let json = "{ \"key\": 0.5 }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: JSON].self, from: data)
        XCTAssertEqual(object["key"], .double(0.5))
    }

    func testDecodeDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let stringDate = "2018-05-17T18:45:32.189Z"
        guard let expected = dateFormatter.date(from: stringDate) else {
            XCTFail("Failed to construct expected date")
            return
        }

        let json = "{ \"key\": \"\(stringDate)\" }"
        let data = json.data(using: .utf8)!
        guard let object = try? JSON.decoder.decode([String: JSON].self, from: data) else {
            XCTFail("Failed to decode object with date value")
            return
        }
        XCTAssertEqual(object["key"], .date(expected))
    }

    func testDecodeString() {
        let json = "{ \"key\": \"this is a string\" }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: JSON].self, from: data)
        XCTAssertEqual(object["key"], .string("this is a string"))
    }

    func testDecodeArray() {
        let json = "{ \"key\": [null, true, 1, 0.5, \"this is a string\"] }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: JSON].self, from: data)
        guard case let .array(array) = object["key"]! else {
            XCTFail("Expected element \"key\" not present in decoded object")
            return
        }
        XCTAssertEqual(array.count, 5)
        XCTAssertEqual(array[0], .null)
        XCTAssertEqual(array[1], .boolean(true))
        XCTAssertEqual(array[2], .int(1))
        XCTAssertEqual(array[3], .double(0.5))
        XCTAssertEqual(array[4], .string("this is a string"))
    }

    func testDecodeTopLevelArray() {
        let json = "[ null, true, 1, 0.5, \"this is a string\" ]"
        let data = json.data(using: .utf8)!
        let array = try! JSONDecoder().decode([JSON].self, from: data)
        XCTAssertEqual(array.count, 5)
        XCTAssertEqual(array[0], .null)
        XCTAssertEqual(array[1], .boolean(true))
        XCTAssertEqual(array[2], .int(1))
        XCTAssertEqual(array[3], .double(0.5))
        XCTAssertEqual(array[4], .string("this is a string"))
    }

    func testDecodeNestedArrays() {
        let json = "[[1, 2, 3], [4, 5, 6]]"
        let data = json.data(using: .utf8)!
        let array = try! JSONDecoder().decode([JSON].self, from: data)
        guard case let .array(subarray1) = array[0] else {
            XCTFail("Error decoding nested arrays")
            return
        }
        guard case let .array(subarray2) = array[1] else {
            XCTFail("Error decoding nested arrays")
            return
        }
        XCTAssertEqual(subarray1[0], .int(1))
        XCTAssertEqual(subarray1[1], .int(2))
        XCTAssertEqual(subarray1[2], .int(3))
        XCTAssertEqual(subarray2[0], .int(4))
        XCTAssertEqual(subarray2[1], .int(5))
        XCTAssertEqual(subarray2[2], .int(6))
    }

    func testDecodeArrayOfObjects() {
        let json = "[{ \"x\": 1 }, { \"y\": 2}, { \"z\": 3 }]"
        let data = json.data(using: .utf8)!
        let array = try! JSONDecoder().decode([JSON].self, from: data)
        guard case let .object(object1) = array[0] else {
            XCTFail("Error decoding array of objects")
            return
        }
        guard case let .object(object2) = array[1] else {
            XCTFail("Error decoding array of objects")
            return
        }
        XCTAssertEqual(object1["x"], .int(1))
        XCTAssertEqual(object2["y"], .int(2))
    }

    func testDecodeObject() {
        let json = "{ \"key\": { \"null\": null, \"bool\": true, \"int\": 1, \"double\": 0.5, \"string\": \"this is a string\" }}"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: JSON].self, from: data)
        guard case let .object(subobject) = object["key"]! else {
            XCTFail("Error decoding nested object")
            return
        }
        XCTAssertEqual(subobject["null"], .null)
        XCTAssertEqual(subobject["bool"], .boolean(true))
        XCTAssertEqual(subobject["int"], .int(1))
        XCTAssertEqual(subobject["double"], .double(0.5))
        XCTAssertEqual(subobject["string"], .string("this is a string"))
    }

    func testDecodeEmptyObject() {
        let json = "{ }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: JSON].self, from: data)
        XCTAssertEqual(object.count, 0)
    }

    func testDecodeNested() {
        let json = "{ \"key\": { \"array\": [1, 2, 3], \"object\": { \"x\": 1, \"y\": 2, \"z\": 3 }}}"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: JSON].self, from: data)
        guard case let .object(subobject) = object["key"]! else {
            XCTFail("Error decoding nested object")
            return
        }
        guard case let .array(array) = subobject["array"]! else {
            XCTFail("Error decoding array within nested object")
            return
        }
        guard case let .object(subsubobject) = subobject["object"]! else {
            XCTFail("Error decoding object within nested object")
            return
        }
        XCTAssertEqual(array[0], .int(1))
        XCTAssertEqual(array[1], .int(2))
        XCTAssertEqual(array[2], .int(3))
        XCTAssertEqual(subsubobject["x"], .int(1))
        XCTAssertEqual(subsubobject["y"], .int(2))
        XCTAssertEqual(subsubobject["z"], .int(3))
    }

    func testDecodeDeeplyNested() {
        let json = "{ \"key1\": { \"key2\": { \"key3\": { \"key4\": [1,2,3] }}}}"
        let data = json.data(using: .utf8)!
        let object1 = try! JSONDecoder().decode([String: JSON].self, from: data)
        guard case let .object(object2) = object1["key1"]! else {
            XCTFail("Error decoding nested object")
            return
        }
        guard case let .object(object3) = object2["key2"]! else {
            XCTFail("Error decoding doubly nested object")
            return
        }
        guard case let .object(object4) = object3["key3"]! else {
            XCTFail("Error decoding triply nested object")
            return
        }
        guard case let .array(array) = object4["key4"]! else {
            XCTFail("Error decoding deeply nested object")
            return
        }
        XCTAssertEqual(array[0], .int(1))
        XCTAssertEqual(array[1], .int(2))
        XCTAssertEqual(array[2], .int(3))
    }
}
