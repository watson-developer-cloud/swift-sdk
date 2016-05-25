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
 
 **SentimentResponse**
 
 Returned by the AlchemyLanguage service.
 
 */

public struct SentimentResponse: JSONDecodable {
    public let totalTransactions: Int?
    public let language: String?
    public let url: String?
    public let text: String?
    public let docSentiment: Sentiment?
    
    public init(json: JSON) throws {
        if let totalTransactionsString = try? json.string("totalTransactions") {
            totalTransactions = Int(totalTransactionsString)
        } else {
            totalTransactions = 1
        }
        language = try? json.string("language")
        url = try? json.string("url")
        text = try? json.string("text")
        docSentiment = try? json.decode("docSentiment", type: Sentiment.self)
    }
}

