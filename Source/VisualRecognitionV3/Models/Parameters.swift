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

/** Additional options of a classify request. */
internal struct Parameters: Encodable {

    /// A string with the image URL to analyze. Must be in .jpg, or .png format. The minimum recommended
    /// pixel density is 32X32 pixels per inch, and the maximum image size is 10 MB.
    internal let url: String?

    /// A floating point value that specifies the minimum score a class must have to be displayed in the response.
    /// The default threshold for returning scores from a classifier is `0.5`. Set the threshold to `0.0` to ignore
    /// the classification score and return all values.
    internal let threshold: Double?

    /// An array of the categories of classifiers to apply. Use `IBM` to classify against the `default`
    /// general classifier, and use `me` to classify against your custom classifiers. To analyze the image against
    /// both classifier categories, set the value to both `IBM` and `me`. The built-in `default` classifier is
    /// used if both **classifier_ids** and **owners** parameters are empty. The **classifier_ids** parameter
    /// overrides **owners**, so make sure that **classifier_ids** is empty.
    internal let owners: [String]?

    /// Specifies which classifiers to apply and overrides the **owners** parameter. You can
    /// specify both custom and built-in classifiers. The built-in `default` classifier is used if both
    /// **classifier_ids** and **owners** parameters are empty.  The following built-in classifier IDs
    /// require no training:
    ///     - `default`: Returns classes from thousands of general tags.
    ///     - `food`: (Beta) Enhances specificity and accuracy for images of food items.
    ///     - `explicit`: (Beta) Evaluates whether the image might be pornographic.
    internal let classifierIDs: [String]?

    enum CodingKeys: String, CodingKey {
        case url
        case threshold
        case owners
        case classifierIDs = "classifier_ids"
    }
}
