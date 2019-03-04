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
 Result of a class within a classifier.
 */
public struct ClassResult: Codable, Equatable {

    /**
     Name of the class.
     Class names are translated in the language defined by the **Accept-Language** request header for the build-in
     classifier IDs (`default`, `food`, and `explicit`). Class names of custom classifiers are not translated. The
     response might not be in the specified language when the requested language is not supported or when there is no
     translation for the class name.
     */
    public var className: String

    /**
     Confidence score for the property in the range of 0 to 1. A higher score indicates greater likelihood that the
     class is depicted in the image. The default threshold for returning scores from a classifier is 0.5.
     */
    public var score: Double

    /**
     Knowledge graph of the property. For example, `/fruit/pome/apple/eating apple/Granny Smith`. Included only if
     identified.
     */
    public var typeHierarchy: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case className = "class"
        case score = "score"
        case typeHierarchy = "type_hierarchy"
    }

}
