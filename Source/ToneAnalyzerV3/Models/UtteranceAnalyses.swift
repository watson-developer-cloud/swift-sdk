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

/** UtteranceAnalyses. */
public struct UtteranceAnalyses: Codable, Equatable {

    /**
     An array of `UtteranceAnalysis` objects that provides the results for each utterance of the input.
     */
    public var utterancesTone: [UtteranceAnalysis]

    /**
     **`2017-09-21`:** A warning message if the content contains more than 50 utterances. The service analyzes only the
     first 50 utterances. **`2016-05-19`:** Not returned.
     */
    public var warning: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case utterancesTone = "utterances_tone"
        case warning = "warning"
    }

}
