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

/** Warning. */
public struct Warning: Decodable {

    /**
     The identifier of the warning message.
     */
    public enum WarningID: String {
        case wordCountMessage = "WORD_COUNT_MESSAGE"
        case jsonAsText = "JSON_AS_TEXT"
        case contentTruncated = "CONTENT_TRUNCATED"
        case partialTextUsed = "PARTIAL_TEXT_USED"
    }

    /**
     The identifier of the warning message.
     */
    public var warningID: String

    /**
     The message associated with the `warning_id`:
     * `WORD_COUNT_MESSAGE`: "There were {number} words in the input. We need a minimum of 600, preferably 1,200 or
     more, to compute statistically significant estimates."
     * `JSON_AS_TEXT`: "Request input was processed as text/plain as indicated, however detected a JSON input. Did you
     mean application/json?"
     * `CONTENT_TRUNCATED`: "For maximum accuracy while also optimizing processing time, only the first 250KB of input
     text (excluding markup) was analyzed. Accuracy levels off at approximately 3,000 words so this did not affect the
     accuracy of the profile."
     * `PARTIAL_TEXT_USED`, "The text provided to compute the profile was trimmed for performance reasons. This action
     does not affect the accuracy of the output, as not all of the input text was required." Applies only when Arabic
     input text exceeds a threshold at which additional words do not contribute to the accuracy of the profile.
     */
    public var message: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case warningID = "warning_id"
        case message = "message"
    }

}
