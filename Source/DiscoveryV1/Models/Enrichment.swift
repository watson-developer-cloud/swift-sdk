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

/** Enrichment. */
public struct Enrichment {

    /// Describes what the enrichment step does.
    public var description: String?

    /// Field where enrichments will be stored. This field must already exist or be at most 1 level deeper than an existing field. For example, if `text` is a top-level field with no sub-fields, `text.foo` is a valid destination but `text.foo.bar` is not.
    public var destinationField: String

    /// Field to be enriched.
    public var sourceField: String

    /// Indicates that the enrichments will overwrite the destination_field field if it already exists.
    public var overwrite: Bool?

    /// Name of the enrichment service to call. Current options are `natural_language_understanding` and `elements`.   When using `natual_language_understanding`, the `options` object must contain Natural Language Understanding Options.   When using `elements` the `options` object must contain Element Classification options. Additionally, when using the `elements` enrichment the configuration specified and files ingested must meet all the criteria specified in [the documentation](https://console.bluemix.net/docs/services/discovery/element-classification.html)     Previous API versions also supported `alchemy_language`.
    public var enrichmentName: String

    /// If true, then most errors generated during the enrichment process will be treated as warnings and will not cause the document to fail processing.
    public var ignoreDownstreamErrors: Bool?

    /// A list of options specific to the enrichment.
    public var options: EnrichmentOptions?

    /**
     Initialize a `Enrichment` with member variables.

     - parameter destinationField: Field where enrichments will be stored. This field must already exist or be at most 1 level deeper than an existing field. For example, if `text` is a top-level field with no sub-fields, `text.foo` is a valid destination but `text.foo.bar` is not.
     - parameter sourceField: Field to be enriched.
     - parameter enrichmentName: Name of the enrichment service to call. Current options are `natural_language_understanding` and `elements`.   When using `natual_language_understanding`, the `options` object must contain Natural Language Understanding Options.   When using `elements` the `options` object must contain Element Classification options. Additionally, when using the `elements` enrichment the configuration specified and files ingested must meet all the criteria specified in [the documentation](https://console.bluemix.net/docs/services/discovery/element-classification.html)     Previous API versions also supported `alchemy_language`.
     - parameter description: Describes what the enrichment step does.
     - parameter overwrite: Indicates that the enrichments will overwrite the destination_field field if it already exists.
     - parameter ignoreDownstreamErrors: If true, then most errors generated during the enrichment process will be treated as warnings and will not cause the document to fail processing.
     - parameter options: A list of options specific to the enrichment.

     - returns: An initialized `Enrichment`.
    */
    public init(destinationField: String, sourceField: String, enrichmentName: String, description: String? = nil, overwrite: Bool? = nil, ignoreDownstreamErrors: Bool? = nil, options: EnrichmentOptions? = nil) {
        self.destinationField = destinationField
        self.sourceField = sourceField
        self.enrichmentName = enrichmentName
        self.description = description
        self.overwrite = overwrite
        self.ignoreDownstreamErrors = ignoreDownstreamErrors
        self.options = options
    }
}

extension Enrichment: Codable {

    private enum CodingKeys: String, CodingKey {
        case description = "description"
        case destinationField = "destination_field"
        case sourceField = "source_field"
        case overwrite = "overwrite"
        case enrichmentName = "enrichment"
        case ignoreDownstreamErrors = "ignore_downstream_errors"
        case options = "options"
        static let allValues = [description, destinationField, sourceField, overwrite, enrichmentName, ignoreDownstreamErrors, options]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        destinationField = try container.decode(String.self, forKey: .destinationField)
        sourceField = try container.decode(String.self, forKey: .sourceField)
        overwrite = try container.decodeIfPresent(Bool.self, forKey: .overwrite)
        enrichmentName = try container.decode(String.self, forKey: .enrichmentName)
        ignoreDownstreamErrors = try container.decodeIfPresent(Bool.self, forKey: .ignoreDownstreamErrors)
        options = try container.decodeIfPresent(EnrichmentOptions.self, forKey: .options)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(destinationField, forKey: .destinationField)
        try container.encode(sourceField, forKey: .sourceField)
        try container.encodeIfPresent(overwrite, forKey: .overwrite)
        try container.encode(enrichmentName, forKey: .enrichmentName)
        try container.encodeIfPresent(ignoreDownstreamErrors, forKey: .ignoreDownstreamErrors)
        try container.encodeIfPresent(options, forKey: .options)
    }

}
