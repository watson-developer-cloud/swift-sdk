/**
 * Copyright IBM Corporation 2018
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

/**
 An intent identified in the user input.
 */
public struct RuntimeIntent: Codable, Equatable {

    /**
     The name of the recognized intent.
     */
    public var intent: String

    /**
     A decimal percentage that represents Watson's confidence in the intent.
     */
    public var confidence: Double

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case intent = "intent"
        case confidence = "confidence"
    }

    /**
     Initialize a `RuntimeIntent` with member variables.

     - parameter intent: The name of the recognized intent.
     - parameter confidence: A decimal percentage that represents Watson's confidence in the intent.

     - returns: An initialized `RuntimeIntent`.
    */
    public init(
        intent: String,
        confidence: Double
    )
    {
        self.intent = intent
        self.confidence = confidence
    }

}
