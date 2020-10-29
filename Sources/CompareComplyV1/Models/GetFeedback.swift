/**
 * (C) Copyright IBM Corp. 2018, 2019.
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
 The results of a successful **Get Feedback** request for a single feedback entry.
 */
public struct GetFeedback: Codable, Equatable {

    /**
     A string uniquely identifying the feedback entry.
     */
    public var feedbackID: String?

    /**
     A timestamp identifying the creation time of the feedback entry.
     */
    public var created: Date?

    /**
     A string containing the user's comment about the feedback entry.
     */
    public var comment: String?

    /**
     Information returned from the **Add Feedback** method.
     */
    public var feedbackData: FeedbackDataOutput?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case feedbackID = "feedback_id"
        case created = "created"
        case comment = "comment"
        case feedbackData = "feedback_data"
    }

}
