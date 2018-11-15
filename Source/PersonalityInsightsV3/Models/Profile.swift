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
public struct Profile: Codable, Equatable {

    /**
     The language model that was used to process the input.
     */
    public enum ProcessedLanguage: String {
        case ar = "ar"
        case en = "en"
        case es = "es"
        case ja = "ja"
        case ko = "ko"
    }

    /**
     The language model that was used to process the input.
     */
    public var processedLanguage: String

    /**
     The number of words from the input that were used to produce the profile.
     */
    public var wordCount: Int

    /**
     When guidance is appropriate, a string that provides a message that indicates the number of words found and where
     that value falls in the range of required or suggested number of words.
     */
    public var wordCountMessage: String?

    /**
     A recursive array of `Trait` objects that provides detailed results for the Big Five personality characteristics
     (dimensions and facets) inferred from the input text.
     */
    public var personality: [Trait]

    /**
     Detailed results for the Needs characteristics inferred from the input text.
     */
    public var needs: [Trait]

    /**
     Detailed results for the Values characteristics inferred from the input text.
     */
    public var values: [Trait]

    /**
     For JSON content that is timestamped, detailed results about the social behavior disclosed by the input in terms of
     temporal characteristics. The results include information about the distribution of the content over the days of
     the week and the hours of the day.
     */
    public var behavior: [Behavior]?

    /**
     If the **consumption_preferences** parameter is `true`, detailed results for each category of consumption
     preferences. Each element of the array provides information inferred from the input text for the individual
     preferences of that category.
     */
    public var consumptionPreferences: [ConsumptionPreferencesCategory]?

    /**
     Warning messages associated with the input text submitted with the request. The array is empty if the input
     generated no warnings.
     */
    public var warnings: [Warning]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case processedLanguage = "processed_language"
        case wordCount = "word_count"
        case wordCountMessage = "word_count_message"
        case personality = "personality"
        case needs = "needs"
        case values = "values"
        case behavior = "behavior"
        case consumptionPreferences = "consumption_preferences"
        case warnings = "warnings"
    }

}
