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
import RestKit

/** A custom configuration for the environment. */
public struct ConfigurationDetails: JSONDecodable, JSONEncodable {
    
    /// The unique identifier of the configuration.
    public let configurationID: String?
    
    /// The creation date of the collection in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
    public let created: String?
    
    /// The timestamp of when the collection was last updated in the format
    /// yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
    public let updated: String?
    
    /// The name of the configurations.
    public let name: String
    
    /// The description of the configuration, if available.
    public let description: String?
    
    public let conversions: Conversion?
    
    public let enrichments: [Enrichment]?
    
    public let normalizations: [Normalization]?
    
    /// Used internally to initialize a `Collection` model from JSON.
    public init(json: JSON) throws {
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
     
     - parameter name: 
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

public struct Conversion: JSONDecodable {
    public let word: [String: Any]?
    public let pdf: [String: Any]?
    public let html: [String: Any]?
    public let jsonNormalizations: [Normalization]?
    
    public init(json: JSON) throws {
        word = try? json.getDictionary(at: "word")
        pdf = try? json.getDictionary(at: "pdf")
        html = try? json.getDictionary(at: "html")
        jsonNormalizations = try? json.decodedArray(at: "json_normalizations")
    }
    
    /**
     Create a `Conversion`.
     
     - parameter name:
     */
    public init(
        word: [String: Any]?,
        pdf: [String: Any]?,
        html: [String: Any]?,
        jsonNormalizations: [Normalization]?)
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
            json["word"] = JSON(dictionary: word)
        }
        return json
    }
}

public struct Enrichment: JSONDecodable {
    public let destinationField: String
    public let sourceField: String
    public let enrichment: String
    public let options: [String: Any]
    
    public init(json: JSON) throws {
        destinationField = try json.getString(at: "destination_field")
        sourceField = try json.getString(at: "source_field")
        enrichment = try json.getString(at: "enrichment")
        options = try json.getDictionary(at: "options")
    }
    
    /**
     Create an `Enrichment`.
     
     - parameter name:
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
        json["options"] = JSON(dictionary: options)
        return json
    }
}

public struct Normalization: JSONDecodable {
    public let operation: NormalizationOperation
    public let sourceField: String?
    public let destinationField: String?
    
    public init(json: JSON) throws {
        guard let normalizationOperation = NormalizationOperation(rawValue: try json.getString(at: "operation")) else {
            throw JSON.Error.valueNotConvertible(value: json, to: NormalizationOperation.self)
        }
        operation = normalizationOperation
        sourceField = try? json.getString(at: "source_field")
        destinationField = try? json.getString(at: "destination_field")
    }
    
    /**
     Create a `Normalization`.
     
     - parameter name:
     */
    public init(
        operation: NormalizationOperation,
        sourceField: String?,
        destinationField: String?)
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

public enum NormalizationOperation: String {
    case copy = "copy"
    case move = "move"
    case merge = "merge"
    case remove = "remove"
    case removeNulls = "remove_nulls"
}
