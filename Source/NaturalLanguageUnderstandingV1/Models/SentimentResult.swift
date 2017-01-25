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
import RestKit


public struct SentimentResult: JSONDecodable,JSONEncodable {
    
    public let document: DocumentSentimentResults?
    
    public let targets: [TargetedSentimentResults]?

    /**
     Initialize a `SentimentResult` with required member variables.


     - returns: An initialized `SentimentResult`.
    */
    public init() {
    }

    /**
    Initialize a `SentimentResult` with all member variables.

     - parameter document: 
     - parameter targets: 

    - returns: An initialized `SentimentResult`.
    */
    public init(document: DocumentSentimentResults, targets: [TargetedSentimentResults]) {
        self.document = document
        self.targets = targets
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `SentimentResult` model from JSON.
    public init(json: JSON) throws {
        document = try? json.getString(at: "document")
        targets = try? json.getString(at: "targets")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `SentimentResult` model to JSON.
    func toJSONObject() -> Any {
        var json = [String: Any]()
        if let document = document { json["document"] = document }
        if let targets = targets {
            json["targets"] = targets.map { targetsElem in targetsElem.toJSONObject() }
        }
        return json
    }
}
