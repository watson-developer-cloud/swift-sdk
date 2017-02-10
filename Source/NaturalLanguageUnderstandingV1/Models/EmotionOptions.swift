/**
 * Copyright IBM Corporation 2017
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

/** Whether or not to return emotion analysis of the content. */
public struct EmotionOptions: JSONEncodable {
    
    /// Set this to false to hide document-level emotion results.
    public let document: Bool?
    
    /// Emotion results will be returned for each target string that is found in the document.
    public let targets: [String]?
    
    /**
    Initialize a `EmotionOptions` with all member variables.

     - parameter document: Set this to false to hide document-level emotion results.
     - parameter targets: Emotion results will be returned for each target string that is found in the document.

    - returns: An initialized `EmotionOptions`.
    */
    public init(document: Bool? = nil, targets: [String]? = nil) {
        self.document = document
        self.targets = targets
    }

    /// Used internally to serialize a `EmotionOptions` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let document = document { json["document"] = document }
        if let targets = targets {
            json["targets"] = targets
        }
        return json
    }
}
