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

/** Response object for **Emotions** related requests */
public struct DocumentEmotion: JSONDecodable {

    /// content URL
    public let url: String?

    /// total number of transactions made by the request
    public let totalTransactions: Int?

    /// language of the analyzed document
    public let language: String?

    /// see **Emotions**
    public let docEmotions: Emotions?

    /// used internally to initialize a DocumentEmotion object
    public init(json: JSONWrapper) throws {
        let status = try json.getString(at: "status")
        guard status == "OK" else {
            throw JSONWrapper.Error.valueNotConvertible(value: json, to: DocumentEmotion.self)
        }

        url = try? json.getString(at: "url")
        if let totalTransactionsString = try? json.getString(at: "totalTransactions") {
            totalTransactions = Int(totalTransactionsString)
        } else {
            totalTransactions = nil
        }
        language = try? json.getString(at: "language")
        docEmotions = try? json.decode(at: "docEmotions", type: Emotions.self)
    }
}
