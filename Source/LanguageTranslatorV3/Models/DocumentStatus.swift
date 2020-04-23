/**
 * (C) Copyright IBM Corp. 2019, 2020.
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
 Document information, including translation status.
 */
public struct DocumentStatus: Codable, Equatable {

    /**
     The status of the translation job associated with a submitted document.
     */
    public enum Status: String {
        case processing = "processing"
        case available = "available"
        case failed = "failed"
    }

    /**
     System generated ID identifying a document being translated using one specific translation model.
     */
    public var documentID: String

    /**
     filename from the submission (if it was missing in the multipart-form, 'noname.<ext matching content type>' is
     used.
     */
    public var filename: String

    /**
     The status of the translation job associated with a submitted document.
     */
    public var status: String

    /**
     A globally unique string that identifies the underlying model that is used for translation.
     */
    public var modelID: String

    /**
     Model ID of the base model that was used to customize the model. If the model is not a custom model, this will be
     absent or an empty string.
     */
    public var baseModelID: String?

    /**
     Translation source language code.
     */
    public var source: String

    /**
     A score between 0 and 1 indicating the confidence of source language detection. A higher value indicates greater
     confidence. This is returned only when the service automatically detects the source language.
     */
    public var detectedLanguageConfidence: Double?

    /**
     Translation target language code.
     */
    public var target: String

    /**
     The time when the document was submitted.
     */
    public var created: Date

    /**
     The time when the translation completed.
     */
    public var completed: Date?

    /**
     An estimate of the number of words in the source document. Returned only if `status` is `available`.
     */
    public var wordCount: Int?

    /**
     The number of characters in the source document, present only if status=available.
     */
    public var characterCount: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case documentID = "document_id"
        case filename = "filename"
        case status = "status"
        case modelID = "model_id"
        case baseModelID = "base_model_id"
        case source = "source"
        case detectedLanguageConfidence = "detected_language_confidence"
        case target = "target"
        case created = "created"
        case completed = "completed"
        case wordCount = "word_count"
        case characterCount = "character_count"
    }

}
