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
 Information about the document and the submitted feedback.
 */
public struct FeedbackReturn: Codable, Equatable {

    /**
     The unique ID of the feedback object.
     */
    public var feedbackID: String?

    /**
     An optional string identifying the person submitting feedback.
     */
    public var userID: String?

    /**
     An optional comment from the person submitting the feedback.
     */
    public var comment: String?

    /**
     Timestamp listing the creation time of the feedback submission.
     */
    public var created: Date?

    /**
     Information returned from the `POST /v1/feedback` method.
     */
    public var feedbackData: FeedbackDataOutput?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case feedbackID = "feedback_id"
        case userID = "user_id"
        case comment = "comment"
        case created = "created"
        case feedbackData = "feedback_data"
    }

}
