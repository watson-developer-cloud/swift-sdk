/**
 * (C) Copyright IBM Corp. 2019.
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
 Object containing example response details for a training query.
 */
public struct TrainingExample: Codable, Equatable {

    /**
     The document ID associated with this training example.
     */
    public var documentID: String

    /**
     The collection ID associated with this training example.
     */
    public var collectionID: String

    /**
     The relevance of the training example.
     */
    public var relevance: Int

    /**
     The date and time the example was created.
     */
    public var created: Date?

    /**
     The date and time the example was updated.
     */
    public var updated: Date?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case documentID = "document_id"
        case collectionID = "collection_id"
        case relevance = "relevance"
        case created = "created"
        case updated = "updated"
    }

    /**
     Initialize a `TrainingExample` with member variables.

     - parameter documentID: The document ID associated with this training example.
     - parameter collectionID: The collection ID associated with this training example.
     - parameter relevance: The relevance of the training example.
     - parameter created: The date and time the example was created.
     - parameter updated: The date and time the example was updated.

     - returns: An initialized `TrainingExample`.
     */
    public init(
        documentID: String,
        collectionID: String,
        relevance: Int,
        created: Date? = nil,
        updated: Date? = nil
    )
    {
        self.documentID = documentID
        self.collectionID = collectionID
        self.relevance = relevance
        self.created = created
        self.updated = updated
    }

}
