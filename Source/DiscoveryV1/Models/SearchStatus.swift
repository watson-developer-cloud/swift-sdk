/**
 * Copyright IBM Corporation 2018
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
 Information about the Continuous Relevancy Training for this environment.
 */
public struct SearchStatus: Codable, Equatable {

    /**
     The current status of Continuous Relevancy Training for this environment.
     */
    public enum Status: String {
        case noData = "NO_DATA"
        case insufficentData = "INSUFFICENT_DATA"
        case training = "TRAINING"
        case trained = "TRAINED"
        case notApplicable = "NOT_APPLICABLE"
    }

    /**
     Current scope of the training. Always returned as `environment`.
     */
    public var scope: String?

    /**
     The current status of Continuous Relevancy Training for this environment.
     */
    public var status: String?

    /**
     Long description of the current Continuous Relevancy Training status.
     */
    public var statusDescription: String?

    /**
     The date stamp of the most recent completed training for this environment.
     */
    public var lastTrained: Date?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case scope = "scope"
        case status = "status"
        case statusDescription = "status_description"
        case lastTrained = "last_trained"
    }

}
