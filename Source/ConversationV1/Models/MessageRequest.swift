/**
 * Copyright IBM Corporation 2016
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
import Freddy

//Struct for Messages
public struct MessageRequest: JSONEncodable, JSONDecodable {
    
    var input:   [String: JSON]!
    var context: [String: JSON]?
    
    public init(message: String, tags: [String]? = nil, context: [String: JSON]? = nil) {
        self.input  = ["text" : JSON.String(message)]
        self.context = context
    }
    
    public init(json: JSON) throws {
        input   = try json.dictionary("input")
        context = try? json.dictionary("context")
    }
    
    public func toJSON() -> JSON {
        var json = [String: JSON]()
        json["input"] = .Dictionary(input)
        if let context = context { json["context"] = .Dictionary(context) }
        return JSON.Dictionary(json)
    }
}