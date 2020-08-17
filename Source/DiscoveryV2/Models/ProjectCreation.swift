/**
 * (C) Copyright IBM Corp. 2020.
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
 Detailed information about the specified project.
 */
internal struct ProjectCreation: Codable, Equatable {

    /**
     The project type of this project.
     */
    public enum TypeEnum: String {
        case documentRetrieval = "document_retrieval"
        case answerRetrieval = "answer_retrieval"
        case contentMining = "content_mining"
        case other = "other"
    }

    /**
     The human readable name of this project.
     */
    public var name: String

    /**
     The project type of this project.
     */
    public var type: String

    /**
     Default query parameters for this project.
     */
    public var defaultQueryParameters: DefaultQueryParams?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case type = "type"
        case defaultQueryParameters = "default_query_parameters"
    }

    /**
      Initialize a `ProjectCreation` with member variables.

      - parameter name: The human readable name of this project.
      - parameter type: The project type of this project.
      - parameter defaultQueryParameters: Default query parameters for this project.

      - returns: An initialized `ProjectCreation`.
     */
    public init(
        name: String,
        type: String,
        defaultQueryParameters: DefaultQueryParams? = nil
    )
    {
        self.name = name
        self.type = type
        self.defaultQueryParameters = defaultQueryParameters
    }

}
