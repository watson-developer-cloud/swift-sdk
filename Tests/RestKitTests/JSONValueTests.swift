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

import XCTest

class JSONValueTests: XCTestCase {

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
        // equal values
        XCTAssertEqual(JSONValue.null, JSONValue.null)
        XCTAssertEqual(JSONValue.boolean(true), JSONValue.boolean(true))
        XCTAssertEqual(JSONValue.string("hello"), JSONValue.string("hello"))
        XCTAssertEqual(JSONValue.int(1), JSONValue.int(1))
        XCTAssertEqual(JSONValue.double(0.5), JSONValue.double(0.5))
        XCTAssertEqual(JSONValue.array([JSONValue.int(1), JSONValue.int(2)]),
                       JSONValue.array([JSONValue.int(1), JSONValue.int(2)]))
        XCTAssertEqual(JSONValue.object(["x": JSONValue.int(1), "y": JSONValue.int(2)]),
                       JSONValue.object(["y": JSONValue.int(2), "x": JSONValue.int(1)]))

        // unequal values
        XCTAssertNotEqual(JSONValue.boolean(true), JSONValue.boolean(false))
        XCTAssertNotEqual(JSONValue.string("hello"), JSONValue.string("world"))
        XCTAssertNotEqual(JSONValue.int(1), JSONValue.int(2))
        XCTAssertNotEqual(JSONValue.double(3.14), JSONValue.double(2.72))
        XCTAssertNotEqual(JSONValue.double(3.14), JSONValue.double(2.72))
        XCTAssertNotEqual(JSONValue.array([JSONValue.int(1), JSONValue.int(2)]),
                          JSONValue.array([JSONValue.int(2), JSONValue.int(1)]))
        XCTAssertNotEqual(JSONValue.object(["x": JSONValue.int(1), "y": JSONValue.int(2)]),
                          JSONValue.object(["x": JSONValue.int(2), "y": JSONValue.int(1)]))

        // unequal types
        XCTAssertNotEqual(JSONValue.null, JSONValue.boolean(true))
        XCTAssertNotEqual(JSONValue.boolean(true), JSONValue.string("true"))
        XCTAssertNotEqual(JSONValue.string("true"), JSONValue.int(1))
        XCTAssertNotEqual(JSONValue.int(1), JSONValue.double(1.0))
        XCTAssertNotEqual(JSONValue.double(1.0), JSONValue.array([JSONValue.double(1.0)]))
        XCTAssertNotEqual(JSONValue.array([JSONValue.double(1.0)]),
                          JSONValue.object(["x": JSONValue.double(1.0)]))
    }

    func testEncodeNull() {
        let object: [String: JSONValue] = ["key": .null]
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)!
        let expected = "{\"key\":null}"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeBool() {
        let object: [String: JSONValue] = ["key": .boolean(true)]
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)!
        let expected = "{\"key\":true}"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeInt() {
        let object: [String: JSONValue] = ["key": .int(1)]
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)!
        let expected = "{\"key\":1}"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeDouble() {
        let object: [String: JSONValue] = ["key": .double(0.5)]
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)!
        let expected = "{\"key\":0.5}"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeString() {
        let object: [String: JSONValue] = ["key": .string("this is a string")]
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)!
        let expected = "{\"key\":\"this is a string\"}"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeArray() {
        let object: [String: JSONValue] = ["key": .array([.null, .boolean(true), .int(1), .double(0.5), .string("this is a string")])]
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)!
        let expected = "{\"key\":[null,true,1,0.5,\"this is a string\"]}"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeTopLevelArray() {
        let array: [JSONValue] = [.null, .boolean(true), .int(1), .double(0.5), .string("this is a string")]
        let data = try! JSONEncoder().encode(array)
        let json = String(data: data, encoding: .utf8)!
        let expected = "[null,true,1,0.5,\"this is a string\"]"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeNestedArrays() {
        let array: [JSONValue] = [.array([.int(1), .int(2), .int(3)]), .array([.int(4), .int(5), .int(6)])]
        let data = try! JSONEncoder().encode(array)
        let json = String(data: data, encoding: .utf8)!
        let expected = "[[1,2,3],[4,5,6]]"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeArrayOfObjects() {
        let array: [JSONValue] = [.object(["x": .int(1)]), .object(["y": .int(2)]), .object(["z": .int(3)])]
        let data = try! JSONEncoder().encode(array)
        let json = String(data: data, encoding: .utf8)!
        let expected = "[{\"x\":1},{\"y\":2},{\"z\":3}]"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeObject() {
        let object: [String: JSONValue] = ["key": .object(["null": .null, "bool": .boolean(true), "int": .int(1), "double": .double(0.5), "string": .string("this is a string")])]
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)!
        let expected = "{\"key\":{\"bool\":true,\"double\":0.5,\"string\":\"this is a string\",\"int\":1,\"null\":null}}"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeEmptyObject() {
        let object = [String: JSONValue]()
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)!
        let expected = "{}"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeNested() {
        let object: [String: JSONValue] = ["key": .object(["array": .array([.int(1), .int(2), .int(3)]), "object": .object(["x": .int(1), "y": .int(2), "z": .int(3)])])]
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)!
        let expected = "{\"key\":{\"array\":[1,2,3],\"object\":{\"y\":2,\"x\":1,\"z\":3}}}"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testEncodeDeeplyNested() {
        let object: [String: JSONValue] = ["key1": .object(["key2": .object(["key3": .object(["key4": .array([.int(1), .int(2), .int(3)])])])])]
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)!
        let expected = "{\"key1\":{\"key2\":{\"key3\":{\"key4\":[1,2,3]}}}}"
        XCTAssertEqual(json.sorted(), expected.sorted())
    }

    func testDecodeNull() {
        let json = "{ \"key\": null }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: JSONValue].self, from: data)
        XCTAssertEqual(object["key"], .null)
    }

    func testDecodeBool() {
        let json = "{ \"key\": true }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: JSONValue].self, from: data)
        XCTAssertEqual(object["key"], .boolean(true))
    }

    func testDecodeInt() {
        let json = "{ \"key\": 1 }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: JSONValue].self, from: data)
        XCTAssertEqual(object["key"], .int(1))
    }

    func testDecodeDouble() {
        let json = "{ \"key\": 0.5 }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: JSONValue].self, from: data)
        XCTAssertEqual(object["key"], .double(0.5))
    }

    func testDecodeString() {
        let json = "{ \"key\": \"this is a string\" }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: JSONValue].self, from: data)
        XCTAssertEqual(object["key"], .string("this is a string"))
    }

    func testDecodeArray() {
        let json = "{ \"key\": [null, true, 1, 0.5, \"this is a string\"] }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: JSONValue].self, from: data)
        guard case let .array(array) = object["key"]! else { XCTFail(); return }
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
        let array = try! JSONDecoder().decode([JSONValue].self, from: data)
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
        let array = try! JSONDecoder().decode([JSONValue].self, from: data)
        guard case let .array(subarray1) = array[0] else { XCTFail(); return }
        guard case let .array(subarray2) = array[1] else { XCTFail(); return }
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
        let array = try! JSONDecoder().decode([JSONValue].self, from: data)
        guard case let .object(object1) = array[0] else { XCTFail(); return }
        guard case let .object(object2) = array[1] else { XCTFail(); return }
        XCTAssertEqual(object1["x"], .int(1))
        XCTAssertEqual(object2["y"], .int(2))
    }

    func testDecodeObject() {
        let json = "{ \"key\": { \"null\": null, \"bool\": true, \"int\": 1, \"double\": 0.5, \"string\": \"this is a string\" }}"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: JSONValue].self, from: data)
        guard case let .object(subobject) = object["key"]! else { XCTFail(); return }
        XCTAssertEqual(subobject["null"], .null)
        XCTAssertEqual(subobject["bool"], .boolean(true))
        XCTAssertEqual(subobject["int"], .int(1))
        XCTAssertEqual(subobject["double"], .double(0.5))
        XCTAssertEqual(subobject["string"], .string("this is a string"))
    }

    func testDecodeEmptyObject() {
        let json = "{ }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: JSONValue].self, from: data)
        XCTAssertEqual(object.count, 0)
    }

    func testDecodeNested() {
        let json = "{ \"key\": { \"array\": [1, 2, 3], \"object\": { \"x\": 1, \"y\": 2, \"z\": 3 }}}"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: JSONValue].self, from: data)
        guard case let .object(subobject) = object["key"]! else { XCTFail(); return }
        guard case let .array(array) = subobject["array"]! else { XCTFail(); return }
        guard case let .object(subsubobject) = subobject["object"]! else { XCTFail(); return }
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
        let object1 = try! JSONDecoder().decode([String: JSONValue].self, from: data)
        guard case let .object(object2) = object1["key1"]! else { XCTFail(); return }
        guard case let .object(object3) = object2["key2"]! else { XCTFail(); return }
        guard case let .object(object4) = object3["key3"]! else { XCTFail(); return }
        guard case let .array(array) = object4["key4"]! else { XCTFail(); return }
        XCTAssertEqual(array[0], .int(1))
        XCTAssertEqual(array[1], .int(2))
        XCTAssertEqual(array[2], .int(3))
    }
}
