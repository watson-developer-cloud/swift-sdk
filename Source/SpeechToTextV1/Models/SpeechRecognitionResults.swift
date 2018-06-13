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

/** SpeechRecognitionResults. */
public struct SpeechRecognitionResults: Decodable {

    /**
     An array that can include interim and final results (interim results are returned only if supported by the method).
     Final results are guaranteed not to change; interim results might be replaced by further interim results and final
     results. The service periodically sends updates to the results list; the `result_index` is set to the lowest index
     in the array that has changed; it is incremented for new results.
     */
    public var results: [SpeechRecognitionResult]?

    /**
     An index that indicates a change point in the `results` array. The service increments the index only for additional
     results that it sends for new audio for the same request.
     */
    public var resultIndex: Int?

    /**
     An array that identifies which words were spoken by which speakers in a multi-person exchange. Returned in the
     response only if `speaker_labels` is `true`. When interim results are also requested for methods that support them,
     it is possible for a `SpeechRecognitionResults` object to include only the `speaker_labels` field.
     */
    public var speakerLabels: [SpeakerLabelsResult]?

    /**
     An array of warning messages associated with the request:
     * Warnings for invalid parameters or fields can include a descriptive message and a list of invalid argument
     strings, for example, `"Unknown arguments:"` or `"Unknown url query arguments:"` followed by a list of the form
     `"invalid_arg_1, invalid_arg_2."`
     * The following warning is returned if the request passes a custom model that is based on an older version of a
     base model for which an updated version is available: `"Using previous version of base model, because your custom
     model has been built with it. Please note that this version will be supported only for a limited time. Consider
     updating your custom model to the new base model. If you do not do that you will be automatically switched to base
     model when you used the non-updated custom model."`
     In both cases, the request succeeds despite the warnings.
     */
    public var warnings: [String]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case results = "results"
        case resultIndex = "result_index"
        case speakerLabels = "speaker_labels"
        case warnings = "warnings"
    }

}
