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
 The feedback to be added to an element in the document.
 */
internal struct FeedbackInput: Codable, Equatable {

    /**
     An optional string identifying the user.
     */
    public var userID: String?

    /**
     An optional comment on or description of the feedback.
     */
    public var comment: String?

    /**
     Feedback data for submission.
     */
    public var feedbackData: FeedbackDataInput

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case comment = "comment"
        case feedbackData = "feedback_data"
    }

    /**
     Initialize a `FeedbackInput` with member variables.

     - parameter feedbackData: Feedback data for submission.
     - parameter userID: An optional string identifying the user.
     - parameter comment: An optional comment on or description of the feedback.

     - returns: An initialized `FeedbackInput`.
    */
    public init(
        feedbackData: FeedbackDataInput,
        userID: String? = nil,
        comment: String? = nil
    )
    {
        self.feedbackData = feedbackData
        self.userID = userID
        self.comment = comment
    }

}
