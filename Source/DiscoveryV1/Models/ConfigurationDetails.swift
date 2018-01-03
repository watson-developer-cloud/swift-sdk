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

/** A custom configuration for the environment. */
public struct ConfigurationDetails: JSONDecodable, JSONEncodable {

    /// The unique identifier of the configuration.
    public let configurationID: String?

    /// The creation date of the configuration in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
    public let created: String?

    /// The timestamp of when the configuration was last updated in the format
    /// yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
    public let updated: String?

    /// The name of the configuration.
    public let name: String

    /// The description of the configuration, if available.
    public let description: String?

    /// The configuration's document conversion settings.
    public let conversions: Conversion?

    /// The configuration's document enrichment settings.
    public let enrichments: [Enrichment]?

    /// The configuration's document normalization settings.
    public let normalizations: [Normalization]?

    /// Used internally to initialize a `ConfigurationDetails` model from JSON.
    public init(json: JSONWrapper) throws {
        configurationID = try? json.getString(at: "configuration_id")
        created = try json.getString(at: "created")
        updated = try json.getString(at: "updated")
        name = try json.getString(at: "name")
        description = try? json.getString(at: "description")
        conversions = try? json.decode(at: "conversions")
        enrichments = try? json.decodedArray(at: "enrichments")
        normalizations = try? json.decodedArray(at: "normalizations")
    }

    /**
     Create a `ConfigurationDetails`.

     - parameter name: Name that identifies the configuration. Must be unique in the environment.
     - parameter description: Description of the configuration.
     - parameter conversions: The configuration's doucment conversion settings.
     - parameter enrichments: The configuration's document enrichment settings.
     - parameter normalizations: The configuration's document normalization settings.
     */
    public init(
        name: String,
        description: String? = nil,
        conversions: Conversion? = nil,
        enrichments: [Enrichment]? = nil,
        normalizations: [Normalization]? = nil)
    {
        self.name = name
        self.description = description
        self.conversions = conversions
        self.enrichments = enrichments
        self.normalizations = normalizations

        self.configurationID = nil
        self.created = nil
        self.updated = nil
    }

    /// Used internally to serialize a `ConfigurationDetails` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["name"] = name
        if let description = description {
            json["description"] = description
        }
        if let conversions = conversions {
            json["conversions"] = conversions.toJSONObject()
        }
        if let enrichments = enrichments {
            json["enrichments"] = enrichments.map { enrichment in enrichment.toJSONObject() }
        }
        if let normalizations = normalizations {
            json["normalizations"] = normalizations.map { normalization in normalization.toJSONObject() }
        }
        return json
    }
}

/** The configuration's document conversion settings. */
public struct Conversion: JSONDecodable {

    /// A list of Word conversion settings, including the conversions applied to different types of
    /// headings as defined by font attributes and to different formatting styles of text.
    public let word: [String: Any]?

    /// A list of PDF conversion settings, including the conversions applied to different types of
    /// headings as defined by font attributes.
    public let pdf: [String: Any]?

    /// A list of HTML conversion settings, including tags that are to be excluded completely; tags
    /// that are to be discarded but their content kept; content that is to be excluded as defined
    /// by xpaths; content that is to be kept as defined by xpaths; and tag attributes that are to
    /// be excluded.
    public let html: [String: Any]?

    /// An array of JSON normalization operations.
    public let jsonNormalizations: [Normalization]?

    /// Used internally to initialize a `Conversion` model from JSON.
    public init(json: JSONWrapper) throws {
        word = try? json.getDictionary(at: "word")
        pdf = try? json.getDictionary(at: "pdf")
        html = try? json.getDictionary(at: "html")
        jsonNormalizations = try json.decodedArray(at: "json_normalizations")
    }

    /**
     Create a `Conversion`.

     - parameter word: A list of Word conversion settings, including the conversions applied to
            different types of headings as defined by font attributes and to different formatting
            styles of text.
     - parameter pdf: A list of PDF conversion settings, including the conversions applied to
            different types of headings as defined by font attributes.
     - parameter html: A list of HTML conversion settings, including tags that are to be excluded
            completely; tags that are to be discarded but their content kept; content that is to
            be excluded as defined by xpaths; content that is to be kept as defined by xpaths; and
            tag attributes that are to be excluded.
     - parameter jsonNormalizations: An array of JSON normalization operations.
     */
    public init(
        word: [String: Any]? = nil,
        pdf: [String: Any]? = nil,
        html: [String: Any]? = nil,
        jsonNormalizations: [Normalization]? = [])
    {
        self.word = word
        self.pdf = pdf
        self.html = html
        self.jsonNormalizations = jsonNormalizations
    }

    /// Used internally to serialize a `Conversion` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let word = word {
            json["word"] = word
        }
        if let pdf = pdf {
            json["pdf"] = pdf
        }
        if let html = html {
            json["html"] = html
        }
        if let jsonNormalizations = jsonNormalizations {
            json["json_normalizations"] = jsonNormalizations.map { normalization in normalization.toJSONObject() }
        }
        return json
    }
}

/** The configuration document's enrichment settings. */
public struct Enrichment: JSONDecodable {

    /// The field into which the service writes the enriched material.
    public let destinationField: String

    /// The field that contains the material that is to be enriched.
    public let sourceField: String

    /// The type of enrichment being applied.
    public let enrichment: String

    /// A list of options specific to the enrichment.
    public let options: [String: Any]

    /// Used internally to initialize an `Enrichment` model from JSON.
    public init(json: JSONWrapper) throws {
        destinationField = try json.getString(at: "destination_field")
        sourceField = try json.getString(at: "source_field")
        enrichment = try json.getString(at: "enrichment")
        options = try json.getDictionary(at: "options")
    }

    /**
     Create an `Enrichment`.

     - parameter destinationField: The field into which the service writes the enriched material.
     - parameter sourceField: The field that contains the material that is to be enriched.
     - parameter enrichment: The type of enrichment being applied.
     - parameter options: A list of options specific to the enrichment.
     */
    public init(
        destinationField: String,
        sourceField: String,
        enrichment: String,
        options: [String: Any])
    {
        self.destinationField = destinationField
        self.sourceField = sourceField
        self.enrichment = enrichment
        self.options = options
    }

    /// Used internally to serialize an `Enrichment` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["destination_field"] = destinationField
        json["source_field"] = sourceField
        json["enrichment"] = enrichment
        json["options"] = options
        return json
    }
}

/** A JSON normalization operation. */
public struct Normalization: JSONDecodable {

    /// Can be one of the following: copy, move, merge, remove, or remove_nulls. For more
    /// information, please refer to the documentation page here:
    /// https://www.ibm.com/watson/developercloud/discovery/api/v1/#json_normalizations
    public let operation: NormalizationOperation

    /// The field that contains the original information.
    public let sourceField: String?

    /// The field that information is written to.
    public let destinationField: String?

    /// Used internally to initialize a `Normalization` model from JSON.
    public init(json: JSONWrapper) throws {
        guard let normalizationOperation = NormalizationOperation(rawValue: try json.getString(at: "operation")) else {
            throw JSONWrapper.Error.valueNotConvertible(value: json, to: NormalizationOperation.self)
        }
        operation = normalizationOperation
        sourceField = try? json.getString(at: "source_field")
        destinationField = try? json.getString(at: "destination_field")
    }

    /**
     Create a `Normalization`.

     - parameter operation: Can be one of the following: copy, move, merge, remove, or remove_nulls.
            For more information, please refer to the documentation page here:
            https://www.ibm.com/watson/developercloud/discovery/api/v1/#json_normalizations
     - parameter sourceField: The field that contains the original information.
     - parameter destinationField: The field that information is written to.
     */
    public init(
        operation: NormalizationOperation,
        sourceField: String? = nil,
        destinationField: String? = nil)
    {
        self.operation = operation
        self.sourceField = sourceField
        self.destinationField = destinationField
    }

    /// Used internally to serialize a `Normalization` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["operation"] = operation.rawValue
        if let sourceField = sourceField {
            json["source_field"] = sourceField
        }
        if let destinationField = destinationField {
            json["destination_field"] = destinationField
        }
        return json
    }
}

/**
 The different JSON normalization operations. Visit the documentation page for more information:
 https://www.ibm.com/watson/developercloud/discovery/api/v1/#json_normalizations
 */
public enum NormalizationOperation: String {

    /// Copies the value of the source_field to the destination_field.
    case copy = "copy"

    /// Renames (moves) the source_field to the destination_field.
    case move = "move"

    /// Merges the value of the source_field with the value of the destination_field.
    case merge = "merge"

    /// Deletes the source_field.
    case remove = "remove"

    /// Removes all nested null (blank) leaf values from the JSON tree.
    case removeNulls = "remove_nulls"
}
