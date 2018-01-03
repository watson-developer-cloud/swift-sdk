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

 **Document**

 A single document retuned by the AlchemyDataNews service

 */
public struct Document: JSONDecodable {

    /** a unique identifier for the document */
    public let id: String?

    /** see **DocumentSource** */
    public let source: DocumentSource?

    /** the timestamp of publication */
    public let timestamp: CLong?

    /// used internally to initialize a Document object
    public init(json: JSONWrapper) throws {
        id = try? json.getString(at: "id")
        source = try? json.decode(at: "source", type: DocumentSource.self)
        timestamp = try? json.decode(at: "timestamp", type: CLong.self)
    }

}
