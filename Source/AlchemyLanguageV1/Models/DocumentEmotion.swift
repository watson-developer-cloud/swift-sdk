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

public struct DocumentEmotion: JSONDecodable {
    
    public let url: String?
    public let totalTransactions: Int?
    public let language: String?
    public let docEmotions: Emotions?
    
    public init(json: JSON) throws {
        url = try? json.string("url")
        if let totalTransactionsString = try? json.string("totalTransactions") {
            totalTransactions = Int(totalTransactionsString)
        } else {
            totalTransactions = nil
        }
        language = try? json.string("language")
        docEmotions = try? json.decode("docEmotions", type: Emotions.self)
    }
}