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

public struct Sentence: JSONDecodable {
    public let sid: Int
    public let begin: Int
    public let end: Int
    public let text: String
    public let parse: Parse
    public let dependencyParse: String
    public let usdDependencyParse: String
    public let tokens: [Token]
    
    public init(json: JSON) throws {
        sid = try json.int("sid")
        begin = try json.int("begin")
        end = try json.int("end")
        text = try json.string("text")
        parse = try json.decode("parse")
        dependencyParse = try json.string("dependency_parse")
        usdDependencyParse = try json.string("usd_dependency_parse")
        tokens = try json.arrayOf("tokens", "token", type: Token.self)
    }
}

public struct Parse: JSONDecodable {
    public let score: Double
    public let text: String
    
    public init(json: JSON) throws {
        score = try json.double("score")
        text = try json.string("text")
    }
}

public struct Token: JSONDecodable {
    public let pos: String
    public let begin: Int
    public let end: Int
    public let lemma: String
    public let text: String
    public let tokenID: Int
    public let type: Int
    
    public init(json: JSON) throws {
        pos = try json.string("POS")
        begin = try json.int("begin")
        end = try json.int("end")
        lemma = try json.string("lemma")
        text = try json.string("text")
        tokenID = try json.int("tid")
        type = try json.int("type")
    }
}


