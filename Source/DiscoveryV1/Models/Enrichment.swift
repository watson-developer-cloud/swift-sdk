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
public struct Enrichment: Codable, Equatable {

    /**
     Describes what the enrichment step does.
     */
    public var description: String?

    /**
     Field where enrichments will be stored. This field must already exist or be at most 1 level deeper than an existing
     field. For example, if `text` is a top-level field with no sub-fields, `text.foo` is a valid destination but
     `text.foo.bar` is not.
     */
    public var destinationField: String

    /**
     Field to be enriched.
     */
    public var sourceField: String

    /**
     Indicates that the enrichments will overwrite the destination_field field if it already exists.
     */
    public var overwrite: Bool?

    /**
     Name of the enrichment service to call. Current options are `natural_language_understanding` and `elements`.
      When using `natual_language_understanding`, the **options** object must contain Natural Language Understanding
     options.
      When using `elements` the **options** object must contain Element Classification options. Additionally, when using
     the `elements` enrichment the configuration specified and files ingested must meet all the criteria specified in
     [the documentation](https://cloud.ibm.com/docs/services/discovery/element-classification.html)
      Previous API versions also supported `alchemy_language`.
     */
    public var enrichmentName: String

    /**
     If true, then most errors generated during the enrichment process will be treated as warnings and will not cause
     the document to fail processing.
     */
    public var ignoreDownstreamErrors: Bool?

    /**
     Options which are specific to a particular enrichment.
     */
    public var options: EnrichmentOptions?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case description = "description"
        case destinationField = "destination_field"
        case sourceField = "source_field"
        case overwrite = "overwrite"
        case enrichmentName = "enrichment"
        case ignoreDownstreamErrors = "ignore_downstream_errors"
        case options = "options"
    }

    /**
     Initialize a `Enrichment` with member variables.

     - parameter destinationField: Field where enrichments will be stored. This field must already exist or be at
       most 1 level deeper than an existing field. For example, if `text` is a top-level field with no sub-fields,
       `text.foo` is a valid destination but `text.foo.bar` is not.
     - parameter sourceField: Field to be enriched.
     - parameter enrichmentName: Name of the enrichment service to call. Current options are
       `natural_language_understanding` and `elements`.
        When using `natual_language_understanding`, the **options** object must contain Natural Language Understanding
       options.
        When using `elements` the **options** object must contain Element Classification options. Additionally, when
       using the `elements` enrichment the configuration specified and files ingested must meet all the criteria
       specified in [the documentation](https://cloud.ibm.com/docs/services/discovery/element-classification.html)
        Previous API versions also supported `alchemy_language`.
     - parameter description: Describes what the enrichment step does.
     - parameter overwrite: Indicates that the enrichments will overwrite the destination_field field if it already
       exists.
     - parameter ignoreDownstreamErrors: If true, then most errors generated during the enrichment process will be
       treated as warnings and will not cause the document to fail processing.
     - parameter options: Options which are specific to a particular enrichment.

     - returns: An initialized `Enrichment`.
    */
    public init(
        destinationField: String,
        sourceField: String,
        enrichmentName: String,
        description: String? = nil,
        overwrite: Bool? = nil,
        ignoreDownstreamErrors: Bool? = nil,
        options: EnrichmentOptions? = nil
    )
    {
        self.destinationField = destinationField
        self.sourceField = sourceField
        self.enrichmentName = enrichmentName
        self.description = description
        self.overwrite = overwrite
        self.ignoreDownstreamErrors = ignoreDownstreamErrors
        self.options = options
    }

}
