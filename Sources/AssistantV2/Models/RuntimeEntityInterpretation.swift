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

/** RuntimeEntityInterpretation. */
public struct RuntimeEntityInterpretation: Codable, Equatable {

    /**
     The precision or duration of a time range specified by a recognized `@sys-time` or `@sys-date` entity.
     */
    public enum Granularity: String {
        case day = "day"
        case fortnight = "fortnight"
        case hour = "hour"
        case instant = "instant"
        case minute = "minute"
        case month = "month"
        case quarter = "quarter"
        case second = "second"
        case week = "week"
        case weekend = "weekend"
        case year = "year"
    }

    /**
     The calendar used to represent a recognized date (for example, `Gregorian`).
     */
    public var calendarType: String?

    /**
     A unique identifier used to associate a recognized time and date. If the user input contains a date and time that
     are mentioned together (for example, `Today at 5`, the same **datetime_link** value is returned for both the
     `@sys-date` and `@sys-time` entities).
     */
    public var datetimeLink: String?

    /**
     A locale-specific holiday name (such as `thanksgiving` or `christmas`). This property is included when a
     `@sys-date` entity is recognized based on a holiday name in the user input.
     */
    public var festival: String?

    /**
     The precision or duration of a time range specified by a recognized `@sys-time` or `@sys-date` entity.
     */
    public var granularity: String?

    /**
     A unique identifier used to associate multiple recognized `@sys-date`, `@sys-time`, or `@sys-number` entities that
     are recognized as a range of values in the user's input (for example, `from July 4 until July 14` or `from 20 to
     25`).
     */
    public var rangeLink: String?

    /**
     The word in the user input that indicates that a `sys-date` or `sys-time` entity is part of an implied range where
     only one date or time is specified (for example, `since` or `until`).
     */
    public var rangeModifier: String?

    /**
     A recognized mention of a relative day, represented numerically as an offset from the current date (for example,
     `-1` for `yesterday` or `10` for `in ten days`).
     */
    public var relativeDay: Double?

    /**
     A recognized mention of a relative month, represented numerically as an offset from the current month (for example,
     `1` for `next month` or `-3` for `three months ago`).
     */
    public var relativeMonth: Double?

    /**
     A recognized mention of a relative week, represented numerically as an offset from the current week (for example,
     `2` for `in two weeks` or `-1` for `last week).
     */
    public var relativeWeek: Double?

    /**
     A recognized mention of a relative date range for a weekend, represented numerically as an offset from the current
     weekend (for example, `0` for `this weekend` or `-1` for `last weekend`).
     */
    public var relativeWeekend: Double?

    /**
     A recognized mention of a relative year, represented numerically as an offset from the current year (for example,
     `1` for `next year` or `-5` for `five years ago`).
     */
    public var relativeYear: Double?

    /**
     A recognized mention of a specific date, represented numerically as the date within the month (for example, `30`
     for `June 30`.).
     */
    public var specificDay: Double?

    /**
     A recognized mention of a specific day of the week as a lowercase string (for example, `monday`).
     */
    public var specificDayOfWeek: String?

    /**
     A recognized mention of a specific month, represented numerically (for example, `7` for `July`).
     */
    public var specificMonth: Double?

    /**
     A recognized mention of a specific quarter, represented numerically (for example, `3` for `the third quarter`).
     */
    public var specificQuarter: Double?

    /**
     A recognized mention of a specific year (for example, `2016`).
     */
    public var specificYear: Double?

    /**
     A recognized numeric value, represented as an integer or double.
     */
    public var numericValue: Double?

    /**
     The type of numeric value recognized in the user input (`integer` or `rational`).
     */
    public var subtype: String?

    /**
     A recognized term for a time that was mentioned as a part of the day in the user's input (for example, `morning` or
     `afternoon`).
     */
    public var partOfDay: String?

    /**
     A recognized mention of a relative hour, represented numerically as an offset from the current hour (for example,
     `3` for `in three hours` or `-1` for `an hour ago`).
     */
    public var relativeHour: Double?

    /**
     A recognized mention of a relative time, represented numerically as an offset in minutes from the current time (for
     example, `5` for `in five minutes` or `-15` for `fifteen minutes ago`).
     */
    public var relativeMinute: Double?

    /**
     A recognized mention of a relative time, represented numerically as an offset in seconds from the current time (for
     example, `10` for `in ten seconds` or `-30` for `thirty seconds ago`).
     */
    public var relativeSecond: Double?

    /**
     A recognized specific hour mentioned as part of a time value (for example, `10` for `10:15 AM`.).
     */
    public var specificHour: Double?

    /**
     A recognized specific minute mentioned as part of a time value (for example, `15` for `10:15 AM`.).
     */
    public var specificMinute: Double?

    /**
     A recognized specific second mentioned as part of a time value (for example, `30` for `10:15:30 AM`.).
     */
    public var specificSecond: Double?

    /**
     A recognized time zone mentioned as part of a time value (for example, `EST`).
     */
    public var timezone: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case calendarType = "calendar_type"
        case datetimeLink = "datetime_link"
        case festival = "festival"
        case granularity = "granularity"
        case rangeLink = "range_link"
        case rangeModifier = "range_modifier"
        case relativeDay = "relative_day"
        case relativeMonth = "relative_month"
        case relativeWeek = "relative_week"
        case relativeWeekend = "relative_weekend"
        case relativeYear = "relative_year"
        case specificDay = "specific_day"
        case specificDayOfWeek = "specific_day_of_week"
        case specificMonth = "specific_month"
        case specificQuarter = "specific_quarter"
        case specificYear = "specific_year"
        case numericValue = "numeric_value"
        case subtype = "subtype"
        case partOfDay = "part_of_day"
        case relativeHour = "relative_hour"
        case relativeMinute = "relative_minute"
        case relativeSecond = "relative_second"
        case specificHour = "specific_hour"
        case specificMinute = "specific_minute"
        case specificSecond = "specific_second"
        case timezone = "timezone"
    }

    /**
      Initialize a `RuntimeEntityInterpretation` with member variables.

      - parameter calendarType: The calendar used to represent a recognized date (for example, `Gregorian`).
      - parameter datetimeLink: A unique identifier used to associate a recognized time and date. If the user input
        contains a date and time that are mentioned together (for example, `Today at 5`, the same **datetime_link** value
        is returned for both the `@sys-date` and `@sys-time` entities).
      - parameter festival: A locale-specific holiday name (such as `thanksgiving` or `christmas`). This property is
        included when a `@sys-date` entity is recognized based on a holiday name in the user input.
      - parameter granularity: The precision or duration of a time range specified by a recognized `@sys-time` or
        `@sys-date` entity.
      - parameter rangeLink: A unique identifier used to associate multiple recognized `@sys-date`, `@sys-time`, or
        `@sys-number` entities that are recognized as a range of values in the user's input (for example, `from July 4
        until July 14` or `from 20 to 25`).
      - parameter rangeModifier: The word in the user input that indicates that a `sys-date` or `sys-time` entity is
        part of an implied range where only one date or time is specified (for example, `since` or `until`).
      - parameter relativeDay: A recognized mention of a relative day, represented numerically as an offset from the
        current date (for example, `-1` for `yesterday` or `10` for `in ten days`).
      - parameter relativeMonth: A recognized mention of a relative month, represented numerically as an offset from
        the current month (for example, `1` for `next month` or `-3` for `three months ago`).
      - parameter relativeWeek: A recognized mention of a relative week, represented numerically as an offset from the
        current week (for example, `2` for `in two weeks` or `-1` for `last week).
      - parameter relativeWeekend: A recognized mention of a relative date range for a weekend, represented
        numerically as an offset from the current weekend (for example, `0` for `this weekend` or `-1` for `last
        weekend`).
      - parameter relativeYear: A recognized mention of a relative year, represented numerically as an offset from the
        current year (for example, `1` for `next year` or `-5` for `five years ago`).
      - parameter specificDay: A recognized mention of a specific date, represented numerically as the date within the
        month (for example, `30` for `June 30`.).
      - parameter specificDayOfWeek: A recognized mention of a specific day of the week as a lowercase string (for
        example, `monday`).
      - parameter specificMonth: A recognized mention of a specific month, represented numerically (for example, `7`
        for `July`).
      - parameter specificQuarter: A recognized mention of a specific quarter, represented numerically (for example,
        `3` for `the third quarter`).
      - parameter specificYear: A recognized mention of a specific year (for example, `2016`).
      - parameter numericValue: A recognized numeric value, represented as an integer or double.
      - parameter subtype: The type of numeric value recognized in the user input (`integer` or `rational`).
      - parameter partOfDay: A recognized term for a time that was mentioned as a part of the day in the user's input
        (for example, `morning` or `afternoon`).
      - parameter relativeHour: A recognized mention of a relative hour, represented numerically as an offset from the
        current hour (for example, `3` for `in three hours` or `-1` for `an hour ago`).
      - parameter relativeMinute: A recognized mention of a relative time, represented numerically as an offset in
        minutes from the current time (for example, `5` for `in five minutes` or `-15` for `fifteen minutes ago`).
      - parameter relativeSecond: A recognized mention of a relative time, represented numerically as an offset in
        seconds from the current time (for example, `10` for `in ten seconds` or `-30` for `thirty seconds ago`).
      - parameter specificHour: A recognized specific hour mentioned as part of a time value (for example, `10` for
        `10:15 AM`.).
      - parameter specificMinute: A recognized specific minute mentioned as part of a time value (for example, `15`
        for `10:15 AM`.).
      - parameter specificSecond: A recognized specific second mentioned as part of a time value (for example, `30`
        for `10:15:30 AM`.).
      - parameter timezone: A recognized time zone mentioned as part of a time value (for example, `EST`).

      - returns: An initialized `RuntimeEntityInterpretation`.
     */
    public init(
        calendarType: String? = nil,
        datetimeLink: String? = nil,
        festival: String? = nil,
        granularity: String? = nil,
        rangeLink: String? = nil,
        rangeModifier: String? = nil,
        relativeDay: Double? = nil,
        relativeMonth: Double? = nil,
        relativeWeek: Double? = nil,
        relativeWeekend: Double? = nil,
        relativeYear: Double? = nil,
        specificDay: Double? = nil,
        specificDayOfWeek: String? = nil,
        specificMonth: Double? = nil,
        specificQuarter: Double? = nil,
        specificYear: Double? = nil,
        numericValue: Double? = nil,
        subtype: String? = nil,
        partOfDay: String? = nil,
        relativeHour: Double? = nil,
        relativeMinute: Double? = nil,
        relativeSecond: Double? = nil,
        specificHour: Double? = nil,
        specificMinute: Double? = nil,
        specificSecond: Double? = nil,
        timezone: String? = nil
    )
    {
        self.calendarType = calendarType
        self.datetimeLink = datetimeLink
        self.festival = festival
        self.granularity = granularity
        self.rangeLink = rangeLink
        self.rangeModifier = rangeModifier
        self.relativeDay = relativeDay
        self.relativeMonth = relativeMonth
        self.relativeWeek = relativeWeek
        self.relativeWeekend = relativeWeekend
        self.relativeYear = relativeYear
        self.specificDay = specificDay
        self.specificDayOfWeek = specificDayOfWeek
        self.specificMonth = specificMonth
        self.specificQuarter = specificQuarter
        self.specificYear = specificYear
        self.numericValue = numericValue
        self.subtype = subtype
        self.partOfDay = partOfDay
        self.relativeHour = relativeHour
        self.relativeMinute = relativeMinute
        self.relativeSecond = relativeSecond
        self.specificHour = specificHour
        self.specificMinute = specificMinute
        self.specificSecond = specificSecond
        self.timezone = timezone
    }

}
