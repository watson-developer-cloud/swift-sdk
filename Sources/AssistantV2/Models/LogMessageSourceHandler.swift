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
 An object that identifies the dialog element that generated the error message.

 Enums with an associated value of LogMessageSourceHandler:
    LogMessageSource
 */
public struct LogMessageSourceHandler: Codable, Equatable {

    /**
     A string that indicates the type of dialog element that generated the error message.
     */
    public var type: String

    /**
     The unique identifier of the action that generated the error message.
     */
    public var action: String

    /**
     The unique identifier of the step that generated the error message.
     */
    public var step: String?

    /**
     The unique identifier of the handler that generated the error message.
     */
    public var handler: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case action = "action"
        case step = "step"
        case handler = "handler"
    }

}
