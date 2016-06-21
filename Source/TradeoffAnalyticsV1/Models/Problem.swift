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
import Freddy

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
    public func toJSON() -> JSON {
        var json = [String: JSON]()
        json["columns"] = .Array(columns.map { column in column.toJSON() })
        json["options"] = .Array(options.map { option in option.toJSON() })
        json["subject"] = .String(subject)
        return JSON.Dictionary(json)
    }
    
    /// Used internally to initialize a `Problem` model from JSON.
    public init(json: JSON) throws {
        columns = try json.arrayOf("columns", type: Column.self)
        options = try json.arrayOf("options", type: Option.self)
        subject = try json.string("subject")
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
    public func toJSON() -> JSON {
        var json = [String: JSON]()
        json["key"] = .String(key)
        json["type"] = type?.toJSON()
        json["goal"] = goal?.toJSON()
        if let isObjective = isObjective {
            json["is_objective"] = .Bool(isObjective)
        }
        json["range"] = range?.toJSON()
        if let preference = preference {
            json["preference"] = .Array(preference.map { .String($0) })
        }
        if let significantGain = significantGain {
            json["significant_gain"] = .Double(significantGain)
        }
        if let significantLoss = significantLoss {
            json["significant_loss"] = .Double(significantLoss)
        }
        if let insignificantLoss = insignificantLoss {
            json["insignificant_loss"] = .Double(insignificantLoss)
        }
        if let format = format {
            json["format"] = .String(format)
        }
        if let fullName = fullName {
            json["full_name"] = .String(fullName)
        }
        if let description = description {
            json["description"] = .String(description)
        }
        return JSON.Dictionary(json)
    }
    
    /// Used internally to initialize a `Column` model from JSON.
    public init(json: JSON) throws {
        key = try json.string("key")
        if let typeString = try? json.string("type") {
            type = ColumnType(rawValue: typeString)
        } else {
            type = nil
        }
        if let goalString = try? json.string("goal") {
            goal = Goal(rawValue: goalString)
        } else {
            goal = nil
        }
        isObjective = try? json.bool("is_objective")
        range = try? json.decode("range")
        preference = try? json.arrayOf("preference", type: String.self)
        significantGain = try? json.double("significant_gain")
        significantLoss = try? json.double("significant_loss")
        insignificantLoss = try? json.double("insignificant_loss")
        format = try? json.string("format")
        fullName = try? json.string("full_name")
        description = try? json.string("description")
    }
}

/// The type of an objective.
public enum ColumnType: String {
    
    /// A categorical objective.
    case Categorical = "categorical"
    
    /// A date and time objective.
    case DateTime = "datetime"
    
    /// A numeric objective.
    case Numeric = "numeric"
    
    /// A text objective.
    case Text = "text"
}

/// The value of a particular option.
public enum OptionValue: JSONEncodable, JSONDecodable {
    
    /// An `Int` value for an option.
    case Int(Swift.Int)
    
    /// A `Double` value for an option.
    case Double(Swift.Double)
    
    /// An `NSDate` value for an option.
    case NSDate(Foundation.NSDate)
    
    /// A `String` value for an option.
    case String(Swift.String)
    
    /// Used internally to serialize an `OptionValue` model to JSON.
    public func toJSON() -> JSON {
        switch self {
        case Int(let x): return .Int(x)
        case Double(let x): return .Double(x)
        case NSDate(let x): return .String(Range.dateFormatter.stringFromDate(x))
        case String(let x): return .String(x)
        }
    }
    
    /// Used internally to initialize an `OptionValue` model from JSON.
    public init(json: JSON) throws {
        if let int = try? json.int() {
            self = .Int(int)
        } else if let double = try? json.double() {
            self = .Double(double)
        } else if let dateString = try? json.string(), let date = Range.dateFormatter.dateFromString(dateString) {
            self = .NSDate(date)
        } else if let string = try? json.string() {
            self = .String(string)
        } else {
            self = String("Error: JSON could not be converted to `OptionValue`.")
            throw JSON.Error.ValueNotConvertible(value: json, to: OptionValue.self)
        }
    }
}

/// The direction of a column (i.e. minimize or maximize).
public enum Goal: String {
    
    /// Minimize the given column.
    case Minimize = "min"
    
    /// Maximize the given column.
    case Maximize = "max"
}

/// A range of valid values for a column.
public enum Range: JSONEncodable, JSONDecodable {
    
    /// High and low values that define the range of a `DateTime`
    /// column. Valid only for `DateTime` columns.
    case DateRange(low: NSDate, high: NSDate)
    
    /// High and low `Double` values that define the range of a
    /// `Numeric` column. Valid only for `Numeric` columns.
    case NumericRange(low: Double, high: Double)
    
    /// An array of valid values that define the range of possible values
    /// for a `Categorical` column. Valid only for `Categorical` columns.
    case CategoricalRange(categories: [String])
    
    /// A date formatter to convert between `NSDate` and `String`.
    private static let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()
    
    /// Used internally to serialize a `Range` model to JSON.
    public func toJSON() -> JSON {
        var json = [String: JSON]()
        switch self {
        case .DateRange(let low, let high):
            json["low"] = .String(Range.dateFormatter.stringFromDate(low))
            json["high"] = .String(Range.dateFormatter.stringFromDate(high))
            return .Dictionary(json)
        case .NumericRange(let low, let high):
            json["low"] = .Double(low)
            json["high"] = .Double(high)
            return .Dictionary(json)
        case .CategoricalRange(let categories):
            return .Array(categories.map { .String($0) })
        }
    }
    
    /// Used internally to initialize a `Range` model from JSON.
    public init(json: JSON) throws {
        // try to parse as `Range.DateRange`
        if let low = try? json.string("low"), high = try? json.string("high") {
            let lowDate = Range.dateFormatter.dateFromString(low)
            let highDate = Range.dateFormatter.dateFromString(high)
            if let lowDate = lowDate, highDate = highDate {
                self = .DateRange(low: lowDate, high: highDate)
                return
            }
        }
        
        // try to parse as `Range.NumericRange`
        if let low = try? json.double("low"), high = try? json.double("high") {
            self = .NumericRange(low: low, high: high)
            return
        }
        
        // try to parse as `Range.CategoricalRange`
        if let categories = try? json.arrayOf(type: String.self) {
            self = .CategoricalRange(categories: categories)
            return
        }
        
        throw JSON.Error.ValueNotConvertible(value: json, to: Range.self)
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
    public let appData: JSON?
    
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
        appData: JSON? = nil)
    {
        self.key = key
        self.values = values
        self.name = name
        self.descriptionHTML = descriptionHTML
        self.appData = appData
    }
 
    /// Used internally to serialize an `Option` model to JSON.
    public func toJSON() -> JSON {
        var json = [String: JSON]()
        json["key"] = .String(key)
        json["values"] = .Dictionary(values.map { $0.toJSON() })
        if let name = name {
            json["name"] = .String(name)
        }
        if let descriptionHTML = descriptionHTML {
            json["description_html"] = .String(descriptionHTML)
        }
        if let appData = appData {
            json["app_data"] = appData
        }
        return .Dictionary(json)
    }

    /// Used internally to initialize an `Option` model from JSON.
    public init(json: JSON) throws {
        key = try json.string("key")
        values = try json.dictionary("values").map {
            json in try json.decode()
        }
        name = try? json.string("name")
        descriptionHTML = try? json.string("description_html")
        appData = json["app_data"]
    }
}
