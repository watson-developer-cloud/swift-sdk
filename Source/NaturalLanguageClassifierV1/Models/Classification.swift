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
 Response from the classifier for a phrase.
 */
public struct Classification: Decodable {

    /**
     Unique identifier for this classifier.
     */
    public var classifierID: String?

    /**
     Link to the classifier.
     */
    public var url: String?

    /**
     The submitted phrase.
     */
    public var text: String?

    /**
     The class with the highest confidence.
     */
    public var topClass: String?

    /**
     An array of up to ten class-confidence pairs sorted in descending order of confidence.
     */
    public var classes: [ClassifiedClass]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case classifierID = "classifier_id"
        case url = "url"
        case text = "text"
        case topClass = "top_class"
        case classes = "classes"
    }

}
