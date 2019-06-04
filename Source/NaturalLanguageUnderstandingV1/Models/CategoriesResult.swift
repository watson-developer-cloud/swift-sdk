/**
 * (C) Copyright IBM Corp. 2017, 2019.
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
 A categorization of the analyzed text.
 */
public struct CategoriesResult: Codable, Equatable {

    /**
     The path to the category through the 5-level taxonomy hierarchy. For the complete list of categories, see the
     [Categories
     hierarchy](https://cloud.ibm.com/docs/services/natural-language-understanding?topic=natural-language-understanding-categories#categories-hierarchy)
     documentation.
     */
    public var label: String?

    /**
     Confidence score for the category classification. Higher values indicate greater confidence.
     */
    public var score: Double?

    /**
     Information that helps to explain what contributed to the categories result.
     */
    public var explanation: CategoriesResultExplanation?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case label = "label"
        case score = "score"
        case explanation = "explanation"
    }

}
