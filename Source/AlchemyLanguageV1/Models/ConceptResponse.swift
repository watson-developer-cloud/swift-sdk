/**
 * Copyright IBM Corporation 2015
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

/**
 
 **ConceptResponse**
 
 Returned by the AlchemyLanguage service.
 
 */

public struct ConceptResponse: JSONDecodable {
    
    public let language: String?
    public let url: String?
    public let totalTransactions: Int?
    public let concepts: [Concept]?
    
    public init(json: JSON) throws {
        language = try? json.string("language")
        url = try? json.string("url")
        if let totalTransactionsString = try? json.string("totalTransactions") {
            totalTransactions = Int(totalTransactionsString)
        } else {
            totalTransactions = 1
        }
        concepts = try? json.arrayOf("concepts", type: Concept.self)
    }
}


