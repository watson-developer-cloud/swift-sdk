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
 Options which are specific to a particular enrichment.
 */
public struct EnrichmentOptions: Codable {

    /**
     An object representing the enrichment features that will be applied to the specified field.
     */
    public var features: NluEnrichmentFeatures?

    /**
     *For use with `elements` enrichments only.* The element extraction model to use. Models available are: `contract`.
     */
    public var model: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case features = "features"
        case model = "model"
    }

    /**
     Initialize a `EnrichmentOptions` with member variables.

     - parameter features: An object representing the enrichment features that will be applied to the specified
       field.
     - parameter model: *For use with `elements` enrichments only.* The element extraction model to use. Models
       available are: `contract`.

     - returns: An initialized `EnrichmentOptions`.
    */
    public init(
        features: NluEnrichmentFeatures? = nil,
        model: String? = nil
    )
    {
        self.features = features
        self.model = model
    }

}
