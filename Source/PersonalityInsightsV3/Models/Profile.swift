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

/** Profile. */
public struct Profile {

    /// The language model that was used to process the input.
    public enum ProcessedLanguage: String {
        case ar = "ar"
        case en = "en"
        case es = "es"
        case ja = "ja"
        case ko = "ko"
    }

    /// The language model that was used to process the input.
    public var processedLanguage: String

    /// The number of words that were found in the input.
    public var wordCount: Int

    /// When guidance is appropriate, a string that provides a message that indicates the number of words found and where that value falls in the range of required or suggested number of words.
    public var wordCountMessage: String?

    /// Detailed results for the Big Five personality characteristics (dimensions and facets) inferred from the input text.
    public var personality: [Trait]

    /// Detailed results for the Needs characteristics inferred from the input text.
    public var values: [Trait]

    /// Detailed results for the Values characteristics inferred from the input text.
    public var needs: [Trait]

    /// For JSON content that is timestamped, detailed results about the social behavior disclosed by the input in terms of temporal characteristics. The results include information about the distribution of the content over the days of the week and the hours of the day.
    public var behavior: [Behavior]?

    /// If the `consumption_preferences` query parameter is `true`, detailed results for each category of consumption preferences. Each element of the array provides information inferred from the input text for the individual preferences of that category.
    public var consumptionPreferences: [ConsumptionPreferencesCategory]?

    /// Warning messages associated with the input text submitted with the request. The array is empty if the input generated no warnings.
    public var warnings: [Warning]

    /**
     Initialize a `Profile` with member variables.

     - parameter processedLanguage: The language model that was used to process the input.
     - parameter wordCount: The number of words that were found in the input.
     - parameter personality: Detailed results for the Big Five personality characteristics (dimensions and facets) inferred from the input text.
     - parameter values: Detailed results for the Needs characteristics inferred from the input text.
     - parameter needs: Detailed results for the Values characteristics inferred from the input text.
     - parameter warnings: Warning messages associated with the input text submitted with the request. The array is empty if the input generated no warnings.
     - parameter wordCountMessage: When guidance is appropriate, a string that provides a message that indicates the number of words found and where that value falls in the range of required or suggested number of words.
     - parameter behavior: For JSON content that is timestamped, detailed results about the social behavior disclosed by the input in terms of temporal characteristics. The results include information about the distribution of the content over the days of the week and the hours of the day.
     - parameter consumptionPreferences: If the `consumption_preferences` query parameter is `true`, detailed results for each category of consumption preferences. Each element of the array provides information inferred from the input text for the individual preferences of that category.

     - returns: An initialized `Profile`.
    */
    public init(processedLanguage: String, wordCount: Int, personality: [Trait], values: [Trait], needs: [Trait], warnings: [Warning], wordCountMessage: String? = nil, behavior: [Behavior]? = nil, consumptionPreferences: [ConsumptionPreferencesCategory]? = nil) {
        self.processedLanguage = processedLanguage
        self.wordCount = wordCount
        self.personality = personality
        self.values = values
        self.needs = needs
        self.warnings = warnings
        self.wordCountMessage = wordCountMessage
        self.behavior = behavior
        self.consumptionPreferences = consumptionPreferences
    }
}

extension Profile: Codable {

    private enum CodingKeys: String, CodingKey {
        case processedLanguage = "processed_language"
        case wordCount = "word_count"
        case wordCountMessage = "word_count_message"
        case personality = "personality"
        case values = "values"
        case needs = "needs"
        case behavior = "behavior"
        case consumptionPreferences = "consumption_preferences"
        case warnings = "warnings"
        static let allValues = [processedLanguage, wordCount, wordCountMessage, personality, values, needs, behavior, consumptionPreferences, warnings]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        processedLanguage = try container.decode(String.self, forKey: .processedLanguage)
        wordCount = try container.decode(Int.self, forKey: .wordCount)
        wordCountMessage = try container.decodeIfPresent(String.self, forKey: .wordCountMessage)
        personality = try container.decode([Trait].self, forKey: .personality)
        values = try container.decode([Trait].self, forKey: .values)
        needs = try container.decode([Trait].self, forKey: .needs)
        behavior = try container.decodeIfPresent([Behavior].self, forKey: .behavior)
        consumptionPreferences = try container.decodeIfPresent([ConsumptionPreferencesCategory].self, forKey: .consumptionPreferences)
        warnings = try container.decode([Warning].self, forKey: .warnings)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(processedLanguage, forKey: .processedLanguage)
        try container.encode(wordCount, forKey: .wordCount)
        try container.encodeIfPresent(wordCountMessage, forKey: .wordCountMessage)
        try container.encode(personality, forKey: .personality)
        try container.encode(values, forKey: .values)
        try container.encode(needs, forKey: .needs)
        try container.encodeIfPresent(behavior, forKey: .behavior)
        try container.encodeIfPresent(consumptionPreferences, forKey: .consumptionPreferences)
        try container.encode(warnings, forKey: .warnings)
    }

}
