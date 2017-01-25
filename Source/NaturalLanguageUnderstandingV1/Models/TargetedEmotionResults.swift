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


public struct TargetedEmotionResults: JSONDecodable,JSONEncodable {
    /// Anger score from 0 to 1. A higher score means that the text is more likely to convey anger
    public let anger: Double?
    /// Disgust score from 0 to 1. A higher score means that the text is more likely to convey disgust
    public let disgust: Double?
    /// Fear score from 0 to 1. A higher score means that the text is more likely to convey fear
    public let fear: Double?
    /// Joy score from 0 to 1. A higher score means that the text is more likely to convey joy
    public let joy: Double?
    /// Sadness score from 0 to 1. A higher score means that the text is more likely to convey sadness
    public let sadness: Double?
    /// Targeted text
    public let text: String?

    /**
     Initialize a `TargetedEmotionResults` with required member variables.


     - returns: An initialized `TargetedEmotionResults`.
    */
    public init() {
    }

    /**
    Initialize a `TargetedEmotionResults` with all member variables.

     - parameter anger: Anger score from 0 to 1. A higher score means that the text is more likely to convey anger
     - parameter disgust: Disgust score from 0 to 1. A higher score means that the text is more likely to convey disgust
     - parameter fear: Fear score from 0 to 1. A higher score means that the text is more likely to convey fear
     - parameter joy: Joy score from 0 to 1. A higher score means that the text is more likely to convey joy
     - parameter sadness: Sadness score from 0 to 1. A higher score means that the text is more likely to convey sadness
     - parameter text: Targeted text

    - returns: An initialized `TargetedEmotionResults`.
    */
    public init(anger: Double, disgust: Double, fear: Double, joy: Double, sadness: Double, text: String) {
        self.anger = anger
        self.disgust = disgust
        self.fear = fear
        self.joy = joy
        self.sadness = sadness
        self.text = text
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `TargetedEmotionResults` model from JSON.
    public init(json: JSON) throws {
        anger = try? json.getString(at: "anger")
        disgust = try? json.getString(at: "disgust")
        fear = try? json.getString(at: "fear")
        joy = try? json.getString(at: "joy")
        sadness = try? json.getString(at: "sadness")
        text = try? json.getString(at: "text")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `TargetedEmotionResults` model to JSON.
    func toJSONObject() -> Any {
        var json = [String: Any]()
        if let anger = anger { json["anger"] = anger }
        if let disgust = disgust { json["disgust"] = disgust }
        if let fear = fear { json["fear"] = fear }
        if let joy = joy { json["joy"] = joy }
        if let sadness = sadness { json["sadness"] = sadness }
        if let text = text { json["text"] = text }
        return json
    }
}
