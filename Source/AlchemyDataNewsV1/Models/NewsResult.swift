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

public struct NewsResult: JSONDecodable {
    
    public let docs: [Document]?
    public let next: String?
    public let count: Int?
    public let slices: [Int]?
    
    public init(json: JSON) throws {
        docs = try? json.arrayOf("docs", type: Document.self)
        next = try? json.string("next")
        count = try? json.int("count")
        slices = try? json.arrayOf("slices", type: Int.self)
    }
    
}