/**
 * Copyright IBM Corporation 2019
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

/** TrainingDataSet. */
public struct TrainingDataSet: Codable, Equatable {

    /**
     The environment id associated with this training data set.
     */
    public var environmentID: String?

    /**
     The collection id associated with this training data set.
     */
    public var collectionID: String?

    /**
     Array of training queries.
     */
    public var queries: [TrainingQuery]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case environmentID = "environment_id"
        case collectionID = "collection_id"
        case queries = "queries"
    }

}
