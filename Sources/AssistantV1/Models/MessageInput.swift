/**
 * (C) Copyright IBM Corp. 2017, 2020.
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
import IBMSwiftSDKCore

/**
 An input object that includes the input text.
 */
public struct MessageInput: Codable, Equatable {

    /**
     The text of the user input. This string cannot contain carriage return, newline, or tab characters.
     */
    public var text: String?

    /**
     Whether to use spelling correction when processing the input. This property overrides the value of the
     **spelling_suggestions** property in the workspace settings.
     */
    public var spellingSuggestions: Bool?

    /**
     Whether to use autocorrection when processing the input. If spelling correction is used and this property is
     `false`, any suggested corrections are returned in the **suggested_text** property of the message response. If this
     property is `true`, any corrections are automatically applied to the user input, and the original text is returned
     in the **original_text** property of the message response. This property overrides the value of the
     **spelling_auto_correct** property in the workspace settings.
     */
    public var spellingAutoCorrect: Bool?

    /**
     Any suggested corrections of the input text. This property is returned only if spelling correction is enabled and
     autocorrection is disabled.
     */
    public var suggestedText: String?

    /**
     The original user input text. This property is returned only if autocorrection is enabled and the user input was
     corrected.
     */
    public var originalText: String?

    /// Additional properties associated with this model.
    public var additionalProperties: [String: JSON]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case text = "text"
        case spellingSuggestions = "spelling_suggestions"
        case spellingAutoCorrect = "spelling_auto_correct"
        case suggestedText = "suggested_text"
        case originalText = "original_text"
        static let allValues = [text, spellingSuggestions, spellingAutoCorrect, suggestedText, originalText]
    }

    /**
      Initialize a `MessageInput` with member variables.

      - parameter text: The text of the user input. This string cannot contain carriage return, newline, or tab
        characters.
      - parameter spellingSuggestions: Whether to use spelling correction when processing the input. This property
        overrides the value of the **spelling_suggestions** property in the workspace settings.
      - parameter spellingAutoCorrect: Whether to use autocorrection when processing the input. If spelling correction
        is used and this property is `false`, any suggested corrections are returned in the **suggested_text** property
        of the message response. If this property is `true`, any corrections are automatically applied to the user input,
        and the original text is returned in the **original_text** property of the message response. This property
        overrides the value of the **spelling_auto_correct** property in the workspace settings.
      - parameter suggestedText: Any suggested corrections of the input text. This property is returned only if
        spelling correction is enabled and autocorrection is disabled.
      - parameter originalText: The original user input text. This property is returned only if autocorrection is
        enabled and the user input was corrected.

      - returns: An initialized `MessageInput`.
     */
    public init(
        text: String? = nil,
        spellingSuggestions: Bool? = nil,
        spellingAutoCorrect: Bool? = nil,
        suggestedText: String? = nil,
        originalText: String? = nil,
        additionalProperties: [String: JSON] = [:]
    )
    {
        self.text = text
        self.spellingSuggestions = spellingSuggestions
        self.spellingAutoCorrect = spellingAutoCorrect
        self.suggestedText = suggestedText
        self.originalText = originalText
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        spellingSuggestions = try container.decodeIfPresent(Bool.self, forKey: .spellingSuggestions)
        spellingAutoCorrect = try container.decodeIfPresent(Bool.self, forKey: .spellingAutoCorrect)
        suggestedText = try container.decodeIfPresent(String.self, forKey: .suggestedText)
        originalText = try container.decodeIfPresent(String.self, forKey: .originalText)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)
        additionalProperties = try dynamicContainer.decode([String: JSON].self, excluding: CodingKeys.allValues)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(spellingSuggestions, forKey: .spellingSuggestions)
        try container.encodeIfPresent(spellingAutoCorrect, forKey: .spellingAutoCorrect)
        try container.encodeIfPresent(suggestedText, forKey: .suggestedText)
        try container.encodeIfPresent(originalText, forKey: .originalText)
        var dynamicContainer = encoder.container(keyedBy: DynamicKeys.self)
        try dynamicContainer.encodeIfPresent(additionalProperties)
    }

}
