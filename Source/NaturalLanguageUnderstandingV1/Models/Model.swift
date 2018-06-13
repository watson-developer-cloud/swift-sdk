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

/** Model. */
public struct Model: Decodable {

    /**
     Shows as available if the model is ready for use.
     */
    public var status: String?

    /**
     Unique model ID.
     */
    public var modelID: String?

    /**
     ISO 639-1 code indicating the language of the model.
     */
    public var language: String?

    /**
     Model description.
     */
    public var description: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case modelID = "model_id"
        case language = "language"
        case description = "description"
    }

}
