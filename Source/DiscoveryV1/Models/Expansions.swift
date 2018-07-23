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
 The query expansion definitions for the specified collection.
 */
public struct Expansions: Codable {

    /**
     An array of query expansion definitions.
      Each object in the `expansions` array represents a term or set of terms that will be expanded into other terms.
     Each expansion object can be configured so that all terms are expanded to all other terms in the object -
     bi-directional, or a set list of terms can be expanded into a second list of terms - uni-directional.
      To create a bi-directional expansion specify an `expanded_terms` array. When found in a query, all items in the
     `expanded_terms` array are then expanded to the other items in the same array.
      To create a uni-directional expansion, specify both an array of `input_terms` and an array of `expanded_terms`.
     When items in the `input_terms` array are present in a query, they are expanded using the items listed in the
     `expanded_terms` array.
     */
    public var expansions: [Expansion]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case expansions = "expansions"
    }

    /**
     Initialize a `Expansions` with member variables.

     - parameter expansions: An array of query expansion definitions.
        Each object in the `expansions` array represents a term or set of terms that will be expanded into other terms.
       Each expansion object can be configured so that all terms are expanded to all other terms in the object -
       bi-directional, or a set list of terms can be expanded into a second list of terms - uni-directional.
        To create a bi-directional expansion specify an `expanded_terms` array. When found in a query, all items in the
       `expanded_terms` array are then expanded to the other items in the same array.
        To create a uni-directional expansion, specify both an array of `input_terms` and an array of `expanded_terms`.
       When items in the `input_terms` array are present in a query, they are expanded using the items listed in the
       `expanded_terms` array.

     - returns: An initialized `Expansions`.
    */
    public init(
        expansions: [Expansion]
    )
    {
        self.expansions = expansions
    }

}
