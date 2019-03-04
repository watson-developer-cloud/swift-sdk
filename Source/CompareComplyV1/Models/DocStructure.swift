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
 The structure of the input document.
 */
public struct DocStructure: Codable, Equatable {

    /**
     An array containing one object per section or subsection identified in the input document.
     */
    public var sectionTitles: [SectionTitles]?

    /**
     An array containing one object per section or subsection, in parallel with the `section_titles` array, that details
     the leading sentences in the corresponding section or subsection.
     */
    public var leadingSentences: [LeadingSentence]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case sectionTitles = "section_titles"
        case leadingSentences = "leading_sentences"
    }

}
