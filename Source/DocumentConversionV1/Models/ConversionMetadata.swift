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

 **ConversionMetadata**

 Metadata extracted from converted document

 */
public struct ConversionMetadata: JSONDecodable {

    /** Key of the extracted metadata */
    public let name: String

    /** Value of the extracted metadata */
    public let content: String

    /** used interally to initialize ConversationMetadata objects */
    public init(json: JSONWrapper) throws {
        name = try json.getString(at: "name")
        content = try json.getString(at: "content")
    }

}
