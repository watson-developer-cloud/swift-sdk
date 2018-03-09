/**
 * Copyright IBM Corporation 2016
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

/// A decision problem.
public struct Problem: JSONEncodable, JSONDecodable {

    /// A list of objectives. This property typically specifies the columns for the tabular
    /// representation of the data.
    public let columns: [Column]

    /// A list of options for the decision problem. This property typically specifies the rows
    /// for the tabular representation of the data.
    public let options: [Option]

    /// The name of the decision problem. Typically, the name of the column representing the
    /// option names in the tabular representation of your data.
    public let subject: String

    /**
     Initialize a `Problem` to be analyzed by Tradeoff Analytics.

     - parameter columns: A list of objectives (i.e. the columns in a tabular representation of the data).
     - parameter options: A list of options (i.e. the rows in a tabular representation of the data).
     - parameter subject: The name of the decision problem.

     - returns: A `Problem` that can be analyzed by Tradeoff Analytics.
     */
    public init(columns: [Column], options: [Option], subject: String) {
        self.columns = columns
        self.options = options
        self.subject = subject
    }

    /// Used internally to serialize a `Problem` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["columns"] = columns.map { column in column.toJSONObject() }
        json["options"] = options.map { option in option.toJSONObject() }
        json["subject"] = subject
        return json
    }

    /// Used internally to initialize a `Problem` model from JSON.
    public init(json: JSONWrapper) throws {
        columns = try json.decodedArray(at: "columns", type: Column.self)
        options = try json.decodedArray(at: "options", type: Option.self)
        subject = try json.getString(at: "subject")
    }
}

/// An objective (i.e. a column in a tabular representation of the data).
public struct Column: JSONEncodable, JSONDecodable {

    /// An identifier for the column that is unique among all columns for the problem.
    public let key: String

    /// An indication of whether a column is specified as a `Numeric` value, a `Categorical` value,
    /// a `DateTime`, or as `Text`. Specify a list of valid values for a `Categorical` column by
    /// using the `range` property. For `DateAndTime` columns, options must specify values in
    /// full ISO 8601 format (`YYYY-MM-DDThh:mm:ss.sTZD`). By default, the type is `Text`.
    public let type: ColumnType?

    /// The direction of the column. The direction can be minimized (e.g. price of a car) or
    /// maximized (e.g. safety of a car). Meaningful only for columns for which `isObjective` is
    /// `true`. By default, the goal is `Maximize`.
    public let goal: Goal?

    /// An indication of whether the column is an objective for the problem. If `true`, the column
    /// contributes to the resolution; if false, the column does not contribute to the resolution.
    /// By default, the value is `false`. A column with type `Text` cannot be set to `true`.
    public let isObjective: Bool?

    /// The range of valid values for the column. Any option whose value is outside of the
    /// specified range is marked as `incomplete` and is excluded from the resolution. By default,
    /// the range is calculated from the minimum and maximum values provided in the data set for
    /// the column. See the `Range` model for examples of specifying ranges.
    public let range: Range?

    /// For columns whose type is `categorical`, a subset of the values in the range that indicates
    /// their preference; valid only for `categorical` columns. If goal is `min`, elements in the
    /// low position of the array are favored; if goal is `max`, elements in the high position are
    /// favored. By default, preference matches the order of the values in range and the direction
    /// indicated by goal.
    public let preference: [String]?

    /// A significant gain for the column in the range of 0 to 1. The value is a proportion of
    /// the complete range for the column. The field is relevant only for columns whose
    /// `isObjective` property is `true`.
    public let significantGain: Double?

    /// A significant loss for the column in the range of 0 to 1. The value is a proportion of
    /// the complete range for the column. The field is relevant only for columns whose
    /// `isObjective` property is `true`.
    public let significantLoss: Double?

    /// An insignificant loss for the column in the range of 0 to 1. The value is a proportion of
    /// the complete range for the column. The field is relevant only for columns whose
    /// `isObjective` property is `true`.
    public let insignificantLoss: Double?

    /// For columns whose type is `Numeric` or `DateTime`, specifies a number or date pattern
    /// that indicates how the value is to be presented by the visualization. For `Numeric`
    /// columns, examples include "number:2", "currency:'USD$':1", "taPrefix:'g'", "taSuffix:'g'",
    /// and combinations of the form "number:2 | taSuffix:'g'". For `DateTime` columns, examples
    /// include "date:'MMM dd, yyyy'" and "date:'h:m:s a'". For more information about `number`,
    /// `currency`, and `date` formatters, see the descriptions of the corresponding filter
    /// components in the AngularJS documentation. Used only by the Tradeoff Analytics widget;
    /// not part of the problem definition.
    public let format: String?

    /// A descriptive name. Used only by the Tradeoff Analytics widget; not part of the problem
    /// definition.
    public let fullName: String?

    /// A long description of the column. Used only by the Tradeoff Analytics widget; not part
    /// of the problem definition.
    public let description: String?

    /**
     Initialize a `Column` for a decision problem.

     - parameter key: An identifier for the column that is unique among all columns for the problem.
     - parameter type: An indication of whether a column is specified as a `Numeric` value, a
            `Categorical` value, a `DateTime`, or as `Text`. Specify a list of valid values for a
            `Categorical` column by using the `range` property. For `DateAndTime` columns, options
            must specify values in full ISO 8601 format (`YYYY-MM-DDThh:mm:ss.sTZD`). By default,
            the type is `Text`.
     - parameter goal: The direction of the column. The direction can be minimized (e.g. price of a
            car) or maximized (e.g. safety of a car). Meaningful only for columns for which
            `isObjective` is `true`. By default, the goal is `Maximize`.
     - parameter isObjective: An indication of whether the column is an objective for the problem.
            If `true`, the column contributes to the resolution; if false, the column does not
            contribute to the resolution. By default, the value is `false`. A column with type
            `Text` cannot be set to `true`.
     - parameter range: The range of valid values for the column. Any option whose value is outside
            of the specified range is marked as `incomplete` and is excluded from the resolution.
            By default, the range is calculated from the minimum and maximum values provided in the
            data set for the column. See the `Range` model for examples of specifying ranges.
     - parameter preference: For columns whose type is `categorical`, a subset of the values in the
            range that indicates their preference; valid only for `categorical` columns. If goal is
            `min`, elements in the low position of the array are favored; if goal is `max`, elements
            in the high position are favored. By default, preference matches the order of the values
            in range and the direction indicated by goal.
     - parameter significantGain: A significant gain for the column in the range of 0 to 1. The
            value is a proportion of the complete range for the column. The field is relevant only
            for columns whose `isObjective` property is `true`.
     - parameter significantLoss: A significant loss for the column in the range of 0 to 1. The
            value is a proportion of the complete range for the column. The field is relevant only
            for columns whose `isObjective` property is `true`.
     - parameter insignificantLoss: An insignificant loss for the column in the range of 0 to 1.
            The value is a proportion of the complete range for the column. The field is relevant
            only for columns whose `isObjective` property is `true`.
     - parameter format: For columns whose type is `Numeric` or `DateTime`, specifies a number or
            date pattern that indicates how the value is to be presented by the visualization.
            For `Numeric` columns, examples include "number:2", "currency:'USD$':1", "taPrefix:'g'",
            "taSuffix:'g'", and combinations of the form "number:2 | taSuffix:'g'". For `DateTime`
            columns, examples include "date:'MMM dd, yyyy'" and "date:'h:m:s a'". For more
            information about `number`, `currency`, and `date` formatters, see the descriptions of
            the corresponding filter components in the AngularJS documentation. Used only by the
            Tradeoff Analytics widget; not part of the problem definition.
     - parameter fullName: A descriptive name. Used only by the Tradeoff Analytics widget; not part
            of the problem definition.
     - parameter description: A long description of the column. Used only by the Tradeoff Analytics
            widget; not part of the problem definition.

     - returns: A `Column` that can be included in a decision problem.
     */
    public init(
        key: String,
        type: ColumnType? = nil,
        goal: Goal? = nil,
        isObjective: Bool? = nil,
        range: Range? = nil,
        preference: [String]? = nil,
        significantGain: Double? = nil,
        significantLoss: Double? = nil,
        insignificantLoss: Double? = nil,
        format: String? = nil,
        fullName: String? = nil,
        description: String? = nil)
    {
        self.key = key
        self.type = type
        self.goal = goal
        self.isObjective = isObjective
        self.range = range
        self.preference = preference
        self.significantGain = significantGain
        self.significantLoss = significantLoss
        self.insignificantLoss = insignificantLoss
        self.format = format
        self.fullName = fullName
        self.description = description
    }

    /// Used internally to serialize a `Column` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["key"] = key
        json["type"] = type?.rawValue
        json["goal"] = goal?.rawValue
        if let isObjective = isObjective {
            json["is_objective"] = isObjective
        }
        if let range = range {
            json["range"] = range.toJSONObject()
        }
        if let preference = preference {
            json["preference"] = preference
        }
        if let significantGain = significantGain {
            json["significant_gain"] = significantGain
        }
        if let significantLoss = significantLoss {
            json["significant_loss"] = significantLoss
        }
        if let insignificantLoss = insignificantLoss {
            json["insignificant_loss"] = insignificantLoss
        }
        if let format = format {
            json["format"] = format
        }
        if let fullName = fullName {
            json["full_name"] = fullName
        }
        if let description = description {
            json["description"] = description
        }
        return json
    }

    /// Used internally to initialize a `Column` model from JSON.
    public init(json: JSONWrapper) throws {
        key = try json.getString(at: "key")
        if let typeString = try? json.getString(at: "type") {
            type = ColumnType(rawValue: typeString)
        } else {
            type = nil
        }
        if let goalString = try? json.getString(at: "goal") {
            goal = Goal(rawValue: goalString)
        } else {
            goal = nil
        }
        isObjective = try? json.getBool(at: "is_objective")
        range = try? json.decode(at: "range")
        preference = try? json.decodedArray(at: "preference", type: String.self)
        significantGain = try? json.getDouble(at: "significant_gain")
        significantLoss = try? json.getDouble(at: "significant_loss")
        insignificantLoss = try? json.getDouble(at: "insignificant_loss")
        format = try? json.getString(at: "format")
        fullName = try? json.getString(at: "full_name")
        description = try? json.getString(at: "description")
    }
}

/// The type of an objective.
public enum ColumnType: String {

    /// A categorical objective.
    case categorical = "categorical"

    /// A date and time objective.
    case dateTime = "datetime"

    /// A numeric objective.
    case numeric = "numeric"

    /// A text objective.
    case text = "text"
}

/// The value of a particular option.
public enum OptionValue: JSONEncodable, JSONDecodable {

    /// An `Int` value for an option.
    case int(Swift.Int)

    /// A `Double` value for an option.
    case double(Swift.Double)

    /// An `NSDate` value for an option.
    case date(Foundation.Date)

    /// A `String` value for an option.
    case string(Swift.String)

    /// Used internally to serialize an `OptionValue` model to JSON.
    public func toJSONObject() -> Any {
        switch self {
        case .int(let x): return x
        case .double(let x): return x
        case .date(let x): return Range.dateFormatter.string(from: x)
        case .string(let x): return x
        }
    }

    /// Used internally to initialize an `OptionValue` model from JSON.
    public init(json: JSONWrapper) throws {
        if let int = try? json.getInt() {
            self = .int(int)
        } else if let double = try? json.getDouble() {
            self = .double(double)
        } else if let dateString = try? json.getString(), let date = Range.dateFormatter.date(from: dateString) {
            self = .date(date)
        } else if let string = try? json.getString() {
            self = .string(string)
        } else {
            self = .string("Error: JSON could not be converted to `OptionValue`.")
            throw JSONWrapper.Error.valueNotConvertible(value: json, to: OptionValue.self)
        }
    }
}

/// The direction of a column (i.e. minimize or maximize).
public enum Goal: String {

    /// Minimize the given column.
    case minimize = "min"

    /// Maximize the given column.
    case maximize = "max"
}

/// A range of valid values for a column.
public enum Range: JSONEncodable, JSONDecodable {

    /// High and low values that define the range of a `DateTime`
    /// column. Valid only for `DateTime` columns.
    case dateRange(low: Date, high: Date)

    /// High and low `Double` values that define the range of a
    /// `Numeric` column. Valid only for `Numeric` columns.
    case numericRange(low: Double, high: Double)

    /// An array of valid values that define the range of possible values
    /// for a `Categorical` column. Valid only for `Categorical` columns.
    case categoricalRange(categories: [String])

    /// A date formatter to convert between `NSDate` and `String`.
    fileprivate static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()

    /// Used internally to serialize a `Range` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        switch self {
        case .dateRange(let low, let high):
            json["low"] = Range.dateFormatter.string(from: low)
            json["high"] = Range.dateFormatter.string(from: high)
            return json
        case .numericRange(let low, let high):
            json["low"] = low
            json["high"] = high
            return json
        case .categoricalRange(let categories):
            return categories
        }
    }

    /// Used internally to initialize a `Range` model from JSON.
    public init(json: JSONWrapper) throws {
        // try to parse as `Range.DateRange`
        if let low = try? json.getString(at: "low"), let high = try? json.getString(at: "high") {
            let lowDate = Range.dateFormatter.date(from: low)
            let highDate = Range.dateFormatter.date(from: high)
            if let lowDate = lowDate, let highDate = highDate {
                self = .dateRange(low: lowDate, high: highDate)
                return
            }
        }

        // try to parse as `Range.NumericRange`
        if let low = try? json.getDouble(at: "low"), let high = try? json.getDouble(at: "high") {
            self = .numericRange(low: low, high: high)
            return
        }

        // try to parse as `Range.CategoricalRange`
        if let categories = try? json.decodedArray(type: String.self) {
            self = .categoricalRange(categories: categories)
            return
        }

        throw JSONWrapper.Error.valueNotConvertible(value: json, to: Range.self)
    }
}

/// An option in a decision problem (i.e. a row in a tabular representation of the data).
public struct Option: JSONEncodable, JSONDecodable {

    /// An identifier for the option that is unique among all options for the problem.
    public let key: String

    /// Option-specific values for the columns (objectives) defined for the problem. Specify
    /// a dictionary of column keys to option values. Value requirements vary by column type; a
    /// value must be of the type defined for its column. An option that fails to specify a value
    /// for a column for which `isObjective` is `true` is marked as `incomplete` and is excluded
    /// from the resolution. Example: `["Name": .Text("BRZ"), "Price": .NumericInt(27395)]`
    public let values: [String: OptionValue]

    /// The name of the option. Used only by the Tradeoff Analytics widget; not part of the
    /// problem definition.
    public let name: String?

    /// A description in HTML format. Used only by the Tradeoff Analytics widget; not part of the
    /// problem definition.
    public let descriptionHTML: String?

    /// Application-specific data available to the hosting application; the service carries but
    /// does not use the data. Used only by the Tradeoff Analytics widget; not part of the
    /// problem definition.
    public let appData: Any?

    /**
     Initialize an `Option` for a decision problem (i.e. a row in a tabular representation of
     the data).

     - parameter key: An identifier for the option that is unique among all options for the problem.
     - parameter values: Option-specific values for the columns (objectives) defined for the problem.
            Specify a dictionary of column keys to option values. Value requirements vary by column
            type; a value must be of the type defined for its column. An option that fails to
            specify a value for a column for which `isObjective` is `true` is marked as `incomplete`
            and is excluded from the resolution. Example: `["Name": .Text("BRZ"), "Price": .NumericInt(27395)]`
     - parameter name: The name of the option. Used only by the Tradeoff Analytics widget; not part
            of the problem definition.
     - parameter descriptionHTML: A description in HTML format. Used only by the Tradeoff Analytics
            widget; not part of the problem definition.
     - parameter appData: Application-specific data available to the hosting application; the
            service carries but does not use the data. Used only by the Tradeoff Analytics widget;
            not part of the problem definition.

     - returns: An `Option` for a decision problem.
     */
    public init(
        key: String,
        values: [String: OptionValue],
        name: String? = nil,
        descriptionHTML: String? = nil,
        appData: Any? = nil)
    {
        self.key = key
        self.values = values
        self.name = name
        self.descriptionHTML = descriptionHTML
        self.appData = appData
    }

    /// Used internally to serialize an `Option` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["key"] = key
        json["values"] = values.map { $0.toJSONObject() }
        if let name = name {
            json["name"] = name
        }
        if let descriptionHTML = descriptionHTML {
            json["description_html"] = descriptionHTML
        }
        if let appData = appData {
            json["app_data"] = appData
        }
        return json
    }

    /// Used internally to initialize an `Option` model from JSON.
    public init(json: JSONWrapper) throws {
        key = try json.getString(at: "key")
        values = try json.getDictionary(at: "values").map {
            json in try json.decode()
        }
        name = try? json.getString(at: "name")
        descriptionHTML = try? json.getString(at: "description_html")
        appData = try? json.getJSON(at: "app_data")
    }
}
