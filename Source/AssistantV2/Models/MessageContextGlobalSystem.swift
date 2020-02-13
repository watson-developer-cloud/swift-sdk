/**
 * (C) Copyright IBM Corp. 2018, 2020.
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
 Built-in system properties that apply to all skills used by the assistant.
 */
public struct MessageContextGlobalSystem: Codable, Equatable {

    /**
     The language code for localization in the user input. The specified locale overrides the default for the assistant,
     and is used for interpreting entity values in user input such as date values. For example, `04/03/2018` might be
     interpreted either as April 3 or March 4, depending on the locale.
      This property is included only if the new system entities are enabled for the skill.
     */
    public enum Locale: String {
        case enUs = "en-us"
        case enCa = "en-ca"
        case enGb = "en-gb"
        case arAr = "ar-ar"
        case csCz = "cs-cz"
        case deDe = "de-de"
        case esEs = "es-es"
        case frFr = "fr-fr"
        case itIt = "it-it"
        case jaJp = "ja-jp"
        case koKr = "ko-kr"
        case nlNl = "nl-nl"
        case ptBr = "pt-br"
        case zhCn = "zh-cn"
        case zhTw = "zh-tw"
    }

    /**
     The user time zone. The assistant uses the time zone to correctly resolve relative time references.
     */
    public var timezone: String?

    /**
     A string value that identifies the user who is interacting with the assistant. The client must provide a unique
     identifier for each individual end user who accesses the application. For Plus and Premium plans, this user ID is
     used to identify unique users for billing purposes. This string cannot contain carriage return, newline, or tab
     characters.
     */
    public var userID: String?

    /**
     A counter that is automatically incremented with each turn of the conversation. A value of 1 indicates that this is
     the the first turn of a new conversation, which can affect the behavior of some skills (for example, triggering the
     start node of a dialog).
     */
    public var turnCount: Int?

    /**
     The language code for localization in the user input. The specified locale overrides the default for the assistant,
     and is used for interpreting entity values in user input such as date values. For example, `04/03/2018` might be
     interpreted either as April 3 or March 4, depending on the locale.
      This property is included only if the new system entities are enabled for the skill.
     */
    public var locale: String?

    /**
     The base time for interpreting any relative time mentions in the user input. The specified time overrides the
     current server time, and is used to calculate times mentioned in relative terms such as `now` or `tomorrow`. This
     can be useful for simulating past or future times for testing purposes, or when analyzing documents such as news
     articles.
     This value must be a UTC time value formatted according to ISO 8601 (for example, `2019-06-26T12:00:00Z` for noon
     on 26 June 2019.
     This property is included only if the new system entities are enabled for the skill.
     */
    public var referenceTime: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case timezone = "timezone"
        case userID = "user_id"
        case turnCount = "turn_count"
        case locale = "locale"
        case referenceTime = "reference_time"
    }

    /**
     Initialize a `MessageContextGlobalSystem` with member variables.

     - parameter timezone: The user time zone. The assistant uses the time zone to correctly resolve relative time
       references.
     - parameter userID: A string value that identifies the user who is interacting with the assistant. The client
       must provide a unique identifier for each individual end user who accesses the application. For Plus and Premium
       plans, this user ID is used to identify unique users for billing purposes. This string cannot contain carriage
       return, newline, or tab characters.
     - parameter turnCount: A counter that is automatically incremented with each turn of the conversation. A value
       of 1 indicates that this is the the first turn of a new conversation, which can affect the behavior of some
       skills (for example, triggering the start node of a dialog).
     - parameter locale: The language code for localization in the user input. The specified locale overrides the
       default for the assistant, and is used for interpreting entity values in user input such as date values. For
       example, `04/03/2018` might be interpreted either as April 3 or March 4, depending on the locale.
        This property is included only if the new system entities are enabled for the skill.
     - parameter referenceTime: The base time for interpreting any relative time mentions in the user input. The
       specified time overrides the current server time, and is used to calculate times mentioned in relative terms such
       as `now` or `tomorrow`. This can be useful for simulating past or future times for testing purposes, or when
       analyzing documents such as news articles.
       This value must be a UTC time value formatted according to ISO 8601 (for example, `2019-06-26T12:00:00Z` for noon
       on 26 June 2019.
       This property is included only if the new system entities are enabled for the skill.

     - returns: An initialized `MessageContextGlobalSystem`.
     */
    public init(
        timezone: String? = nil,
        userID: String? = nil,
        turnCount: Int? = nil,
        locale: String? = nil,
        referenceTime: String? = nil
    )
    {
        self.timezone = timezone
        self.userID = userID
        self.turnCount = turnCount
        self.locale = locale
        self.referenceTime = referenceTime
    }

}
