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
import ObjectMapper

/** The confidence of a word in a Speech to Text transcription. */
public struct SpeechToTextWordConfidence {

    /// A particular word from the transcription.
    public var word: String!

    /// The confidence of the given word, between 0 and 1.
    public var confidence: Double!
    
}

/** An ObjectMapper transformation for `SpeechToTextWordConfidence`. */
struct SpeechToTextWordConfidenceTransform: TransformType {
    typealias Object = SpeechToTextWordConfidence
    typealias JSON = [AnyObject]

    /**
     Transform JSON to a `SpeechToTextWordConfidence`.

     - parameter value: The JSON object to transform.
     
     - returns: A `SpeechToTextWordConfidence` object.
     */
    func transformFromJSON(value: AnyObject?) -> Object? {
        guard let array = value as? [AnyObject],
              let word = array[0] as? String,
              let confidence = array[1] as? Double else
        {
            return nil
        }

        return SpeechToTextWordConfidence(word: word, confidence: confidence)
    }

    /**
     Transform a `SpeechToTextWordConfidence` to JSON.

     - parameter value: The `SpeechToTextWordConfidence` object to transform.

     - returns: A JSON object.
     */
    func transformToJSON(value: Object?) -> JSON? {
        guard let wordConfidence = value else {
            return nil
        }

        return [wordConfidence.word, wordConfidence.confidence]
    }
}
