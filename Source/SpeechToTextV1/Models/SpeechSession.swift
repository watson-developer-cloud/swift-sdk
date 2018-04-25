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

/** SpeechSession. */
public struct SpeechSession: Decodable {

    /// URI for HTTP REST recognition requests.
    public var recognize: String

    /// URI for WebSocket recognition requests. **Note:** This field is needed only for working with the WebSocket interface.
    public var recognizeWS: String

    /// URI for HTTP REST results observers.
    public var observeResult: String

    /// Identifier for the new session. **Note:** This field is returned only when you create a new session.
    public var sessionID: String?

    /// URI for the new session. **Note:** This field is returned only when you create a new session.
    public var newSessionUri: String?

    /// State of the session. The state must be `initialized` for the session to accept another recognition request. Other internal states are possible, but they have no meaning for the user. **Note:** This field is returned only when you request the status of an existing session.
    public var state: String?

    /// URI for information about the model that is used with the session. **Note:** This field is returned only when you request the status of an existing session.
    public var model: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case recognize = "recognize"
        case recognizeWS = "recognizeWS"
        case observeResult = "observe_result"
        case sessionID = "session_id"
        case newSessionUri = "new_session_uri"
        case state = "state"
        case model = "model"
    }

}
