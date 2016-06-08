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

public struct Mention: JSONDecodable {
    
    public let mentionID: String
    public let type: String
    public let begin: Int
    public let end: Int
    public let headBegin: Int
    public let headEnd: Int
    public let entityID: String
    public let entityType: String
    public let entityRole: String
    public let metonymy: Bool
    public let mentionClass: String
    public let score: Double
    public let corefScore: Double
    public let text: String
    
    public init(json: JSON) throws {
        mentionID = try json.string("mid")
        type = try json.string("mtype")
        begin = try json.int("begin")
        end = try json.int("end")
        headBegin = try json.int("head-begin")
        headEnd = try json.int("head-end")
        entityID = try json.string("eid")
        entityType = try json.string("etype")
        entityRole = try json.string("role")
        metonymy = try json.bool("metonymy")
        mentionClass = try json.string("class")
        score = try json.double("score")
        corefScore = try json.double("corefScore")
        text = try json.string("text")
    }
}
