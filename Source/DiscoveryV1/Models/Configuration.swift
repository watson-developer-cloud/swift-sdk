/**
 * Copyright IBM Corporation 2019
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
 A custom configuration for the environment.
 */
public struct Configuration: Codable, Equatable {

    /**
     The unique identifier of the configuration.
     */
    public var configurationID: String?

    /**
     The name of the configuration.
     */
    public var name: String

    /**
     The creation date of the configuration in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
     */
    public var created: Date?

    /**
     The timestamp of when the configuration was last updated in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
     */
    public var updated: Date?

    /**
     The description of the configuration, if available.
     */
    public var description: String?

    /**
     Document conversion settings.
     */
    public var conversions: Conversions?

    /**
     An array of document enrichment settings for the configuration.
     */
    public var enrichments: [Enrichment]?

    /**
     Defines operations that can be used to transform the final output JSON into a normalized form. Operations are
     executed in the order that they appear in the array.
     */
    public var normalizations: [NormalizationOperation]?

    /**
     Object containing source parameters for the configuration.
     */
    public var source: Source?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case configurationID = "configuration_id"
        case name = "name"
        case created = "created"
        case updated = "updated"
        case description = "description"
        case conversions = "conversions"
        case enrichments = "enrichments"
        case normalizations = "normalizations"
        case source = "source"
    }

    /**
     Initialize a `Configuration` with member variables.

     - parameter name: The name of the configuration.
     - parameter configurationID: The unique identifier of the configuration.
     - parameter created: The creation date of the configuration in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
     - parameter updated: The timestamp of when the configuration was last updated in the format
       yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
     - parameter description: The description of the configuration, if available.
     - parameter conversions: Document conversion settings.
     - parameter enrichments: An array of document enrichment settings for the configuration.
     - parameter normalizations: Defines operations that can be used to transform the final output JSON into a
       normalized form. Operations are executed in the order that they appear in the array.
     - parameter source: Object containing source parameters for the configuration.

     - returns: An initialized `Configuration`.
    */
    public init(
        name: String,
        configurationID: String? = nil,
        created: Date? = nil,
        updated: Date? = nil,
        description: String? = nil,
        conversions: Conversions? = nil,
        enrichments: [Enrichment]? = nil,
        normalizations: [NormalizationOperation]? = nil,
        source: Source? = nil
    )
    {
        self.name = name
        self.configurationID = configurationID
        self.created = created
        self.updated = updated
        self.description = description
        self.conversions = conversions
        self.enrichments = enrichments
        self.normalizations = normalizations
        self.source = source
    }

}
