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

/**
 Object containing the schedule information for the source.
 */
public struct SourceSchedule: Codable {

    /**
     The crawl schedule in the specified **time_zone**.
     -  `daily`: Runs every day between 00:00 and 06:00.
     -  `weekly`: Runs every week on Sunday between 00:00 and 06:00.
     -  `monthly`: Runs the on the first Sunday of every month between 00:00 and 06:00.
     */
    public enum Frequency: String {
        case daily = "daily"
        case weekly = "weekly"
        case monthly = "monthly"
    }

    /**
     When `true`, the source is re-crawled based on the **frequency** field in this object. When `false` the source is
     not re-crawled; When `false` and connecting to Salesforce the source is crawled annually.
     */
    public var enabled: Bool?

    /**
     The time zone to base source crawl times on. Possible values correspond to the IANA (Internet Assigned Numbers
     Authority) time zones list.
     */
    public var timeZone: String?

    /**
     The crawl schedule in the specified **time_zone**.
     -  `daily`: Runs every day between 00:00 and 06:00.
     -  `weekly`: Runs every week on Sunday between 00:00 and 06:00.
     -  `monthly`: Runs the on the first Sunday of every month between 00:00 and 06:00.
     */
    public var frequency: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case enabled = "enabled"
        case timeZone = "time_zone"
        case frequency = "frequency"
    }

    /**
     Initialize a `SourceSchedule` with member variables.

     - parameter enabled: When `true`, the source is re-crawled based on the **frequency** field in this object. When
       `false` the source is not re-crawled; When `false` and connecting to Salesforce the source is crawled annually.
     - parameter timeZone: The time zone to base source crawl times on. Possible values correspond to the IANA
       (Internet Assigned Numbers Authority) time zones list.
     - parameter frequency: The crawl schedule in the specified **time_zone**.
       -  `daily`: Runs every day between 00:00 and 06:00.
       -  `weekly`: Runs every week on Sunday between 00:00 and 06:00.
       -  `monthly`: Runs the on the first Sunday of every month between 00:00 and 06:00.

     - returns: An initialized `SourceSchedule`.
    */
    public init(
        enabled: Bool? = nil,
        timeZone: String? = nil,
        frequency: String? = nil
    )
    {
        self.enabled = enabled
        self.timeZone = timeZone
        self.frequency = frequency
    }

}
