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
 Information returned from the `POST /v1/feedback` method.
 */
public struct FeedbackDataOutput: Codable, Equatable {

    /**
     A string identifying the user adding the feedback. The only permitted value is `element_classification`.
     */
    public var feedbackType: String?

    /**
     Brief information about the input document.
     */
    public var document: ShortDoc?

    /**
     An optional string identifying the model ID. The only permitted value is `contracts`.
     */
    public var modelID: String?

    /**
     An optional string identifying the version of the model used.
     */
    public var modelVersion: String?

    /**
     The numeric location of the identified element in the document, represented with two integers labeled `begin` and
     `end`.
     */
    public var location: Location?

    /**
     The text to which the feedback applies.
     */
    public var text: String?

    /**
     The original labeling from the input document, without the submitted feedback.
     */
    public var originalLabels: OriginalLabelsOut?

    /**
     The updated labeling from the input document, accounting for the submitted feedback.
     */
    public var updatedLabels: UpdatedLabelsOut?

    /**
     Pagination details, if required by the length of the output.
     */
    public var pagination: Pagination?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case feedbackType = "feedback_type"
        case document = "document"
        case modelID = "model_id"
        case modelVersion = "model_version"
        case location = "location"
        case text = "text"
        case originalLabels = "original_labels"
        case updatedLabels = "updated_labels"
        case pagination = "pagination"
    }

}
