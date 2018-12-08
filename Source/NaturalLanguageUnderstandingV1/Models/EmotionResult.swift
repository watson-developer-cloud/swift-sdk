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
 The detected anger, disgust, fear, joy, or sadness that is conveyed by the content. Emotion information can be returned
 for detected entities, keywords, or user-specified target phrases found in the text.
 */
public struct EmotionResult: Codable, Equatable {

    /**
     Emotion results for the document as a whole.
     */
    public var document: DocumentEmotionResults?

    /**
     Emotion results for specified targets.
     */
    public var targets: [TargetedEmotionResults]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case document = "document"
        case targets = "targets"
    }

}
