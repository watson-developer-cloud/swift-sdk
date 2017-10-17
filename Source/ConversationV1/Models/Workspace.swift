/**
 * Copyright IBM Corporation 2017
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

/** Workspace. */
public struct Workspace {

    /// The name of the workspace.
    public var name: String

    /// The language of the workspace.
    public var language: String

    /// The timestamp for creation of the workspace.
    public var created: String

    /// The timestamp for the last update to the workspace.
    public var updated: String

    /// The workspace ID.
    public var workspaceID: String

    /// The description of the workspace.
    public var description: String?

    /// Any metadata that is required by the workspace.
    public var metadata: [String: JSON]?

    /// Whether training data from the workspace can be used by IBM for general service improvements. `true` indicates that workspace training data is not to be used.
    public var learningOptOut: Bool?

    /**
     Initialize a `Workspace` with member variables.

     - parameter name: The name of the workspace.
     - parameter language: The language of the workspace.
     - parameter created: The timestamp for creation of the workspace.
     - parameter updated: The timestamp for the last update to the workspace.
     - parameter workspaceID: The workspace ID.
     - parameter description: The description of the workspace.
     - parameter metadata: Any metadata that is required by the workspace.
     - parameter learningOptOut: Whether training data from the workspace can be used by IBM for general service improvements. `true` indicates that workspace training data is not to be used.

     - returns: An initialized `Workspace`.
    */
    public init(name: String, language: String, created: String, updated: String, workspaceID: String, description: String? = nil, metadata: [String: JSON]? = nil, learningOptOut: Bool? = nil) {
        self.name = name
        self.language = language
        self.created = created
        self.updated = updated
        self.workspaceID = workspaceID
        self.description = description
        self.metadata = metadata
        self.learningOptOut = learningOptOut
    }
}

extension Workspace: Codable {

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case language = "language"
        case created = "created"
        case updated = "updated"
        case workspaceID = "workspace_id"
        case description = "description"
        case metadata = "metadata"
        case learningOptOut = "learning_opt_out"
        static let allValues = [name, language, created, updated, workspaceID, description, metadata, learningOptOut]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        language = try container.decode(String.self, forKey: .language)
        created = try container.decode(String.self, forKey: .created)
        updated = try container.decode(String.self, forKey: .updated)
        workspaceID = try container.decode(String.self, forKey: .workspaceID)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        metadata = try container.decodeIfPresent([String: JSON].self, forKey: .metadata)
        learningOptOut = try container.decodeIfPresent(Bool.self, forKey: .learningOptOut)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(language, forKey: .language)
        try container.encode(created, forKey: .created)
        try container.encode(updated, forKey: .updated)
        try container.encode(workspaceID, forKey: .workspaceID)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encodeIfPresent(learningOptOut, forKey: .learningOptOut)
    }

}
