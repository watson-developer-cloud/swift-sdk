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

/** A wrapper object that contains results from a Speech to Text recognition request. */
internal struct SpeechRecognitionEvent: JSONDecodable {

    /// Index indicating change point in the results array.
    /// (See description of `results` array for more information.)
    internal let resultIndex: Int?

    /// The results array consists of 0 or more final results, followed by 0 or 1 interim
    /// result. The final results are guaranteed not to change, while the interim result may
    /// be replaced by 0 or more final results, followed by 0 or 1 interim result. The service
    /// periodically sends "updates" to the result list, with the `resultIndex` set to the
    /// lowest index in the array that has changed. `resultIndex` always points to the slot
    /// just after the most recent final result.
    internal let results: [SpeechRecognitionResult]?

    /// An array that identifies which words were spoken by which speakers in a multi-person exchange.
    /// Returned in the response only if the `speakerLabels` recognition setting is `true`.
    internal let speakerLabels: [SpeakerLabel]?

    /// Used internally to initialize a `SpeechRecognitionEvent` model from JSON.
    internal init(json: JSONWrapper) throws {
        resultIndex = try? json.getInt(at: "result_index")
        results = try? json.decodedArray(at: "results", type: SpeechRecognitionResult.self)
        speakerLabels = try? json.decodedArray(at: "speaker_labels", type: SpeakerLabel.self)
        if resultIndex == nil && results == nil && speakerLabels == nil {
            throw JSONWrapper.Error.valueNotConvertible(value: json, to: SpeechRecognitionEvent.self)
        }
    }
}
