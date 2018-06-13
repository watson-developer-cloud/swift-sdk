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

/** VoiceModel. */
public struct VoiceModel: Decodable {

    /**
     The customization ID (GUID) of the custom voice model. The **Create a custom model** method returns only this
     field. It does not not return the other fields of this object.
     */
    public var customizationID: String

    /**
     The name of the custom voice model.
     */
    public var name: String?

    /**
     The language identifier of the custom voice model (for example, `en-US`).
     */
    public var language: String?

    /**
     The GUID of the service credentials for the instance of the service that owns the custom voice model.
     */
    public var owner: String?

    /**
     The date and time in Coordinated Universal Time (UTC) at which the custom voice model was created. The value is
     provided in full ISO 8601 format (`YYYY-MM-DDThh:mm:ss.sTZD`).
     */
    public var created: String?

    /**
     The date and time in Coordinated Universal Time (UTC) at which the custom voice model was last modified. Equals
     `created` when a new voice model is first added but has yet to be updated. The value is provided in full ISO 8601
     format (`YYYY-MM-DDThh:mm:ss.sTZD`).
     */
    public var lastModified: String?

    /**
     The description of the custom voice model.
     */
    public var description: String?

    /**
     An array of `Word` objects that lists the words and their translations from the custom voice model. The words are
     listed in alphabetical order, with uppercase letters listed before lowercase letters. The array is empty if the
     custom model contains no words. This field is returned only by the **Get a voice** method and only when you specify
     the customization ID of a custom voice model.
     */
    public var words: [Word]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case customizationID = "customization_id"
        case name = "name"
        case language = "language"
        case owner = "owner"
        case created = "created"
        case lastModified = "last_modified"
        case description = "description"
        case words = "words"
    }

}
