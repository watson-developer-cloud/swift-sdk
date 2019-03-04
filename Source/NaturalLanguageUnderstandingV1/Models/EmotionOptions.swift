/**
 * Copyright IBM Corporation 2019
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
 Detects anger, disgust, fear, joy, or sadness that is conveyed in the content or by the context around target phrases
 specified in the targets parameter. You can analyze emotion for detected entities with `entities.emotion` and for
 keywords with `keywords.emotion`.
 Supported languages: English.
 */
public struct EmotionOptions: Codable, Equatable {

    /**
     Set this to `false` to hide document-level emotion results.
     */
    public var document: Bool?

    /**
     Emotion results will be returned for each target string that is found in the document.
     */
    public var targets: [String]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case document = "document"
        case targets = "targets"
    }

    /**
     Initialize a `EmotionOptions` with member variables.

     - parameter document: Set this to `false` to hide document-level emotion results.
     - parameter targets: Emotion results will be returned for each target string that is found in the document.

     - returns: An initialized `EmotionOptions`.
    */
    public init(
        document: Bool? = nil,
        targets: [String]? = nil
    )
    {
        self.document = document
        self.targets = targets
    }

}
