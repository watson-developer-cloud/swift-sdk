/**
 * (C) Copyright IBM Corp. 2021.
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
 Information about a custom prompt.
 */
public struct Prompt: Codable, Equatable {

    /**
     The user-specified text of the prompt.
     */
    public var prompt: String

    /**
     The user-specified identifier (name) of the prompt.
     */
    public var promptID: String

    /**
     The status of the prompt:
     * `processing`: The service received the request to add the prompt and is analyzing the validity of the prompt.
     * `available`: The service successfully validated the prompt, which is now ready for use in a speech synthesis
     request.
     * `failed`: The service's validation of the prompt failed. The status of the prompt includes an `error` field that
     describes the reason for the failure.
     */
    public var status: String

    /**
     If the status of the prompt is `failed`, an error message that describes the reason for the failure. The field is
     omitted if no error occurred.
     */
    public var error: String?

    /**
     The speaker ID (GUID) of the speaker for which the prompt was defined. The field is omitted if no speaker ID was
     specified.
     */
    public var speakerID: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case prompt = "prompt"
        case promptID = "prompt_id"
        case status = "status"
        case error = "error"
        case speakerID = "speaker_id"
    }

}
