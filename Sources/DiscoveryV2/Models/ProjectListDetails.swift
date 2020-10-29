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
 Details about a specific project.
 */
public struct ProjectListDetails: Codable, Equatable {

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
     The unique identifier of this project.
     */
    public var projectID: String?

    /**
     The human readable name of this project.
     */
    public var name: String?

    /**
     The project type of this project.
     */
    public var type: String?

    /**
     Relevancy training status information for this project.
     */
    public var relevancyTrainingStatus: ProjectListDetailsRelevancyTrainingStatus?

    /**
     The number of collections configured in this project.
     */
    public var collectionCount: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case projectID = "project_id"
        case name = "name"
        case type = "type"
        case relevancyTrainingStatus = "relevancy_training_status"
        case collectionCount = "collection_count"
    }

}
