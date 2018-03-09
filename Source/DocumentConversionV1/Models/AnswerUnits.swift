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

/**

 **Answer Units**

 Answer Units are a format that can be used with other Watson services, such as the
 Watson Retrieve and Rank Service

 */
public struct AnswerUnits: JSONDecodable {

    /** an Id for the unit */
    public let id: String?

    /** type of the unit */
    public let type: String?

    /** Id of the parent, should the unit have one */
    public let parentId: String?

    /** title of the current unit */
    public let title: String?

    /** the direction the current unit is read (left to right, etc) */
    public let direction: String?

    /** see **Content** */
    public let content: [Content]?

    /** used internally to initialize AnswerUnits objects */
    public init(json: JSONWrapper) throws {
        id = try? json.getString(at: "id")
        type = try? json.getString(at: "type")
        parentId = try? json.getString(at: "parent_id")
        title = try? json.getString(at: "title")
        direction = try? json.getString(at: "direction")
        content = try? json.decodedArray(at: "content", type: Content.self)
    }

}
