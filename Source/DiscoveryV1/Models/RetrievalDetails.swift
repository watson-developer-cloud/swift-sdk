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

/**
 An object contain retrieval type information.
 */
public struct RetrievalDetails: Codable, Equatable {

    /**
     Indentifies the document retrieval strategy used for this query. `relevancy_training` indicates that the results
     were returned using a relevancy trained model. `continuous_relevancy_training` indicates that the results were
     returned using the continuous relevancy training model created by result feedback analysis. `untrained` means the
     results were returned using the standard untrained model.
      **Note**: In the event of trained collections being queried, but the trained model is not used to return results,
     the **document_retrieval_strategy** will be listed as `untrained`.
     */
    public enum DocumentRetrievalStrategy: String {
        case untrained = "untrained"
        case relevancyTraining = "relevancy_training"
        case continuousRelevancyTraining = "continuous_relevancy_training"
    }

    /**
     Indentifies the document retrieval strategy used for this query. `relevancy_training` indicates that the results
     were returned using a relevancy trained model. `continuous_relevancy_training` indicates that the results were
     returned using the continuous relevancy training model created by result feedback analysis. `untrained` means the
     results were returned using the standard untrained model.
      **Note**: In the event of trained collections being queried, but the trained model is not used to return results,
     the **document_retrieval_strategy** will be listed as `untrained`.
     */
    public var documentRetrievalStrategy: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case documentRetrievalStrategy = "document_retrieval_strategy"
    }

}
