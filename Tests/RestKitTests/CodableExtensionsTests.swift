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
@testable import RestKit

class CodableExtensionsTests: XCTestCase {
    
    static var allTests = [
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
        ("testEncodeMetadataModel", testEncodeMetadataModel),
        ("testEncodeDynamicModel", testEncodeDynamicModel),
        ("testEncodeOptionalModel", testEncodeOptionalModel),
        ("testEncodeOptionalModelEmpty", testEncodeOptionalModelEmpty),
        ("testEncodeOptionalModelNil", testEncodeOptionalModelNil),
        ("testEncodeNil", testEncodeNil),
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
        ("testDecodeMetadataModel", testDecodeMetadataModel),
        ("testDecodeDynamicModel", testDecodeDynamicModel),
        ("testDecodeOptionalModel", testDecodeOptionalModel),
        ("testDecodeOptionalModelEmpty", testDecodeOptionalModelEmpty),
        ("testDecodeOptionalModelNil", testDecodeOptionalModelNil)
    ]
    
    func testEncodeNull() {
        let object: [String: Any] = ["key": NSNull()]
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)
        XCTAssertEqual(json, "{\"key\":null}")
    }
    
    func testEncodeBool() {
        let object: [String: Any] = ["key": true]
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)
        XCTAssertEqual(json, "{\"key\":true}")
    }
    
    func testEncodeInt() {
        let object: [String: Any] = ["key": 1]
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)
        XCTAssertEqual(json, "{\"key\":1}")
    }
    
    func testEncodeDouble() {
        let object: [String: Any] = ["key": 0.5]
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)
        XCTAssertEqual(json, "{\"key\":0.5}")
    }
    
    func testEncodeString() {
        let object: [String: Any] = ["key": "this is a string"]
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)
        XCTAssertEqual(json, "{\"key\":\"this is a string\"}")
    }
    
    func testEncodeArray() {
        let object: [String: Any] = ["key": [NSNull(), true, 1, 0.5, "this is a string"]]
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)
        XCTAssertEqual(json, "{\"key\":[null,true,1,0.5,\"this is a string\"]}")
    }
    
    func testEncodeTopLevelArray() {
        let array: [Any] = [NSNull(), true, 1, 0.5, "this is a string"]
        let data = try! JSONEncoder().encode(array)
        let json = String(data: data, encoding: .utf8)
        XCTAssertEqual(json, "[null,true,1,0.5,\"this is a string\"]")
    }
    
    func testEncodeNestedArrays() {
        let array: [Any] = [[1, 2, 3], [4, 5, 6]]
        let data = try! JSONEncoder().encode(array)
        let json = String(data: data, encoding: .utf8)
        XCTAssertEqual(json, "[[1,2,3],[4,5,6]]")
    }
    
    func testEncodeArrayOfObjects() {
        let array: [Any] = [["x": 1], ["y": 2], ["z": 3]]
        let data = try! JSONEncoder().encode(array)
        let json = String(data: data, encoding: .utf8)
        XCTAssertEqual(json, "[{\"x\":1},{\"y\":2},{\"z\":3}]")
    }

    func testEncodeObject() {
        let object: [String: Any] = ["key": ["null": NSNull(), "bool": true, "int": 1, "double": 0.5, "string": "this is a string"]]
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)
        XCTAssertEqual(json, "{\"key\":{\"bool\":true,\"double\":0.5,\"string\":\"this is a string\",\"int\":1,\"null\":null}}")
    }
    
    func testEncodeEmptyObject() {
        let object = [String: Any]()
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)
        XCTAssertEqual(json, "{}")
    }

    func testEncodeNested() {
        let object: [String: Any] = ["key": ["array": [1, 2, 3], "object": ["x": 1, "y": 2, "z": 3]]]
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)
        XCTAssertEqual(json, "{\"key\":{\"array\":[1,2,3],\"object\":{\"y\":2,\"x\":1,\"z\":3}}}")
    }
    
    func testEncodeDeeplyNested() {
        let object: [String: Any] = ["key1": ["key2": ["key3": ["key4": [1, 2, 3]]]]]
        let data = try! JSONEncoder().encode(object)
        let json = String(data: data, encoding: .utf8)
        XCTAssertEqual(json, "{\"key1\":{\"key2\":{\"key3\":{\"key4\":[1,2,3]}}}}")
    }
    
    func testEncodeMetadataModel() {
        let metadata: [String: Any] = ["null": NSNull(), "bool": true, "int": 1, "double": 0.5, "string": "this is a string"]
        let model = TestModel(name: "name", metadata: metadata, additionalProperties: [:])
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(model)
        let json = String(data: data, encoding: .utf8)
        let expected = """
            {
              \"name\" : \"name\",
              \"metadata\" : {
                \"bool\" : true,
                \"double\" : 0.5,
                \"string\" : \"this is a string\",
                \"int\" : 1,
                \"null\" : null
              }
            }
            """
        XCTAssertEqual(json, expected)
    }
    
    func testEncodeDynamicModel() {
        let additionalProperties: [String: Any] = ["null": NSNull(), "bool": true, "int": 1, "double": 0.5, "string": "this is a string"]
        let model = TestModel(name: "name", metadata: [:], additionalProperties: additionalProperties)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(model)
        let json = String(data: data, encoding: .utf8)
        let expected = """
            {
              \"double\" : 0.5,
              \"int\" : 1,
              \"string\" : \"this is a string\",
              \"null\" : null,
              \"bool\" : true,
              \"metadata\" : {

              },
              \"name\" : \"name\"
            }
            """
        XCTAssertEqual(json, expected)
    }
    
    func testEncodeOptionalModel() {
        let metadata: [String: Any] = ["null": NSNull(), "bool": true, "int": 1, "double": 0.5, "string": "this is a string"]
        let additionalProperties: [String: Any] = ["null": NSNull(), "bool": true, "int": 1, "double": 0.5, "string": "this is a string"]
        let model = TestModelOptional(name: "name", metadata: metadata, additionalProperties: additionalProperties)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(model)
        let json = String(data: data, encoding: .utf8)
        let expected = """
            {
              \"double\" : 0.5,
              \"int\" : 1,
              \"string\" : \"this is a string\",
              \"null\" : null,
              \"bool\" : true,
              \"metadata\" : {
                \"bool\" : true,
                \"double\" : 0.5,
                \"string\" : \"this is a string\",
                \"int\" : 1,
                \"null\" : null
              },
              \"name\" : \"name\"
            }
            """
        XCTAssertEqual(json, expected)
    }
    
    func testEncodeOptionalModelEmpty() {
        let model = TestModelOptional(name: "", metadata: [:], additionalProperties: [:])
        let encoder = JSONEncoder()
        let data = try! encoder.encode(model)
        let json = String(data: data, encoding: .utf8)
        let expected = "{\"name\":\"\"}"
        XCTAssertEqual(json, expected)
    }
    
    func testEncodeOptionalModelNil() {
        let model = TestModelOptional(name: nil, metadata: nil, additionalProperties: nil)
        let encoder = JSONEncoder()
        let data = try! encoder.encode(model)
        let json = String(data: data, encoding: .utf8)
        XCTAssertEqual(json, "{}")
    }
    
    func testEncodeNil() {
        let model: TestModelOptional? = nil
        let encoder = JSONEncoder()
        let data = try! encoder.encode(model)
        let json = String(data: data, encoding: .utf8)
        XCTAssertEqual(json, "")
    }
    
    func testDecodeNull() {
        let json = "{ \"key\": null }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: Any].self, from: data)
        XCTAssertTrue(object["key"] is NSNull)
    }

    func testDecodeBool() {
        let json = "{ \"key\": true }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: Any].self, from: data)
        XCTAssertEqual(object["key"] as? Bool, true)
    }

    func testDecodeInt() {
        let json = "{ \"key\": 1 }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: Any].self, from: data)
        XCTAssertEqual(object["key"] as? Int, 1)
    }

    func testDecodeDouble() {
        let json = "{ \"key\": 0.5 }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: Any].self, from: data)
        XCTAssertEqual(object["key"] as? Double, 0.5)
    }

    func testDecodeString() {
        let json = "{ \"key\": \"this is a string\" }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: Any].self, from: data)
        XCTAssertEqual(object["key"] as? String, "this is a string")
    }

    func testDecodeArray() {
        let json = "{ \"key\": [null, true, 1, 0.5, \"this is a string\"] }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: Any].self, from: data)
        let array = object["key"] as! [Any]
        XCTAssertEqual(array.count, 5)
        XCTAssertTrue(array[0] is NSNull)
        XCTAssertEqual(array[1] as? Bool, true)
        XCTAssertEqual(array[2] as? Int, 1)
        XCTAssertEqual(array[3] as? Double, 0.5)
        XCTAssertEqual(array[4] as? String, "this is a string")
    }
    
    func testDecodeTopLevelArray() {
        let json = "[ null, true, 1, 0.5, \"this is a string\" ]"
        let data = json.data(using: .utf8)!
        let array = try! JSONDecoder().decode([Any].self, from: data)
        XCTAssertEqual(array.count, 5)
        XCTAssertTrue(array[0] is NSNull)
        XCTAssertEqual(array[1] as? Bool, true)
        XCTAssertEqual(array[2] as? Int, 1)
        XCTAssertEqual(array[3] as? Double, 0.5)
        XCTAssertEqual(array[4] as? String, "this is a string")
    }
    
    func testDecodeNestedArrays() {
        let json = "[[1, 2, 3], [4, 5, 6]]"
        let data = json.data(using: .utf8)!
        let array = try! JSONDecoder().decode([Any].self, from: data)
        let subarray1 = array[0] as! [Int]
        let subarray2 = array[1] as! [Int]
        XCTAssertEqual(subarray1[0], 1)
        XCTAssertEqual(subarray1[1], 2)
        XCTAssertEqual(subarray1[2], 3)
        XCTAssertEqual(subarray2[0], 4)
        XCTAssertEqual(subarray2[1], 5)
        XCTAssertEqual(subarray2[2], 6)
    }
    
    func testDecodeArrayOfObjects() {
        let json = "[{ \"x\": 1 }, { \"y\": 2}, { \"z\": 3 }]"
        let data = json.data(using: .utf8)!
        let array = try! JSONDecoder().decode([Any].self, from: data)
        let object1 = array[0] as! [String: Int]
        let object2 = array[1] as! [String: Int]
        XCTAssertEqual(object1["x"], 1)
        XCTAssertEqual(object2["y"], 2)
    }

    func testDecodeObject() {
        let json = "{ \"key\": { \"null\": null, \"bool\": true, \"int\": 1, \"double\": 0.5, \"string\": \"this is a string\" }}"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: Any].self, from: data)
        let subobject = object["key"] as! [String: Any]
        XCTAssertTrue(subobject["null"] is NSNull)
        XCTAssertEqual(subobject["bool"] as? Bool, true)
        XCTAssertEqual(subobject["int"] as? Int, 1)
        XCTAssertEqual(subobject["double"] as? Double, 0.5)
        XCTAssertEqual(subobject["string"] as? String, "this is a string")
    }
    
    func testDecodeEmptyObject() {
        let json = "{ }"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: Any].self, from: data)
        XCTAssertEqual(object.count, 0)
    }

    func testDecodeNested() {
        let json = "{ \"key\": { \"array\": [1, 2, 3], \"object\": { \"x\": 1, \"y\": 2, \"z\": 3 }}}"
        let data = json.data(using: .utf8)!
        let object = try! JSONDecoder().decode([String: Any].self, from: data)
        let subobject = object["key"] as! [String: Any]
        let array = subobject["array"] as! [Any]
        let subsubobject = subobject["object"] as! [String: Any]
        XCTAssertEqual(array[0] as? Int, 1)
        XCTAssertEqual(array[1] as? Int, 2)
        XCTAssertEqual(array[2] as? Int, 3)
        XCTAssertEqual(subsubobject["x"] as? Int, 1)
        XCTAssertEqual(subsubobject["y"] as? Int, 2)
        XCTAssertEqual(subsubobject["z"] as? Int, 3)
    }
    
    func testDecodeDeeplyNested() {
        let json = "{ \"key1\": { \"key2\": { \"key3\": { \"key4\": [1,2,3] }}}}"
        let data = json.data(using: .utf8)!
        let object1 = try! JSONDecoder().decode([String: Any].self, from: data)
        let object2 = object1["key1"] as! [String: Any]
        let object3 = object2["key2"] as! [String: Any]
        let object4 = object3["key3"] as! [String: Any]
        let array = object4["key4"] as! [Int]
        XCTAssertEqual(array[0], 1)
        XCTAssertEqual(array[1], 2)
        XCTAssertEqual(array[2], 3)
    }
    
    func testDecodeMetadataModel() {
        let json = """
            {
              \"name\" : \"name\",
              \"metadata\" : {
                \"null\" : null,
                \"bool\" : true,
                \"int\" : 1,
                \"double\" : 0.5,
                \"string\" : \"this is a string\"
              }
            }
            """
        let data = json.data(using: .utf8)!
        let model = try! JSONDecoder().decode(TestModel.self, from: data)
        XCTAssertEqual(model.name, "name")
        XCTAssertTrue(model.metadata["null"] is NSNull)
        XCTAssertEqual(model.metadata["bool"] as? Bool, true)
        XCTAssertEqual(model.metadata["int"] as? Int, 1)
        XCTAssertEqual(model.metadata["double"] as? Double, 0.5)
        XCTAssertEqual(model.metadata["string"] as? String, "this is a string")
        XCTAssertEqual(model.additionalProperties.count, 0)
    }
    
    func testDecodeDynamicModel() {
        let json = """
            {
              \"name\" : \"name\",
              \"metadata\" : { },
              \"null\" : null,
              \"bool\" : true,
              \"int\" : 1,
              \"double\" : 0.5,
              \"string\" : \"this is a string\"
            }
            """
        let data = json.data(using: .utf8)!
        let model = try! JSONDecoder().decode(TestModel.self, from: data)
        XCTAssertEqual(model.name, "name")
        XCTAssertEqual(model.metadata.count, 0)
        XCTAssertTrue(model.additionalProperties["null"] is NSNull)
        XCTAssertEqual(model.additionalProperties["bool"] as? Bool, true)
        XCTAssertEqual(model.additionalProperties["int"] as? Int, 1)
        XCTAssertEqual(model.additionalProperties["double"] as? Double, 0.5)
        XCTAssertEqual(model.additionalProperties["string"] as? String, "this is a string")
    }
    
    func testDecodeOptionalModel() {
        let json = """
            {
              \"name\" : \"name\",
              \"metadata\" : {
                \"null\" : null,
                \"bool\" : true,
                \"int\" : 1,
                \"double\" : 0.5,
                \"string\" : \"this is a string\"
              },
              \"null\" : null,
              \"bool\" : true,
              \"int\" : 1,
              \"double\" : 0.5,
              \"string\" : \"this is a string\"
            }
            """
        let data = json.data(using: .utf8)!
        let model = try! JSONDecoder().decode(TestModelOptional.self, from: data)
        let metadata = model.metadata!
        let additionalProperties = model.additionalProperties!
        XCTAssertEqual(model.name!, "name")
        XCTAssertTrue(metadata["null"] is NSNull)
        XCTAssertEqual(metadata["bool"] as? Bool, true)
        XCTAssertEqual(metadata["int"] as? Int, 1)
        XCTAssertEqual(metadata["double"] as? Double, 0.5)
        XCTAssertEqual(metadata["string"] as? String, "this is a string")
        XCTAssertTrue(additionalProperties["null"] is NSNull)
        XCTAssertEqual(additionalProperties["bool"] as? Bool, true)
        XCTAssertEqual(additionalProperties["int"] as? Int, 1)
        XCTAssertEqual(additionalProperties["double"] as? Double, 0.5)
        XCTAssertEqual(additionalProperties["string"] as? String, "this is a string")
    }
    
    func testDecodeOptionalModelEmpty() {
        let json = "{\"name\":\"\"}"
        let data = json.data(using: .utf8)!
        let model = try! JSONDecoder().decode(TestModelOptional.self, from: data)
        XCTAssertEqual(model.name, "")
        XCTAssertNil(model.metadata)
        XCTAssertNil(model.additionalProperties)
    }
    
    func testDecodeOptionalModelNil() {
        let json = "{ }"
        let data = json.data(using: .utf8)!
        let model = try! JSONDecoder().decode(TestModelOptional.self, from: data)
        XCTAssertNil(model.name)
        XCTAssertNil(model.metadata)
        XCTAssertNil(model.additionalProperties)
    }
}

