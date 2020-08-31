/**
 * (C) Copyright IBM Corp. 2020.
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
 Spelling correction options for the message. Any options specified on an individual message override the settings
 configured for the skill.
 */
public struct MessageInputOptionsSpelling: Codable, Equatable {

    /**
     Whether to use spelling correction when processing the input. If spelling correction is used and **auto_correct**
     is `true`, any spelling corrections are automatically applied to the user input. If **auto_correct** is `false`,
     any suggested corrections are returned in the **output.spelling** property.
     This property overrides the value of the **spelling_suggestions** property in the workspace settings for the skill.
     */
    public var suggestions: Bool?

    /**
     Whether to use autocorrection when processing the input. If this property is `true`, any corrections are
     automatically applied to the user input, and the original text is returned in the **output.spelling** property of
     the message response. This property overrides the value of the **spelling_auto_correct** property in the workspace
     settings for the skill.
     */
    public var autoCorrect: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case suggestions = "suggestions"
        case autoCorrect = "auto_correct"
    }

    /**
      Initialize a `MessageInputOptionsSpelling` with member variables.

      - parameter suggestions: Whether to use spelling correction when processing the input. If spelling correction is
        used and **auto_correct** is `true`, any spelling corrections are automatically applied to the user input. If
        **auto_correct** is `false`, any suggested corrections are returned in the **output.spelling** property.
        This property overrides the value of the **spelling_suggestions** property in the workspace settings for the
        skill.
      - parameter autoCorrect: Whether to use autocorrection when processing the input. If this property is `true`,
        any corrections are automatically applied to the user input, and the original text is returned in the
        **output.spelling** property of the message response. This property overrides the value of the
        **spelling_auto_correct** property in the workspace settings for the skill.

      - returns: An initialized `MessageInputOptionsSpelling`.
     */
    public init(
        suggestions: Bool? = nil,
        autoCorrect: Bool? = nil
    )
    {
        self.suggestions = suggestions
        self.autoCorrect = autoCorrect
    }

}
