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

/** The detected anger, disgust, fear, joy, or sadness that is conveyed 
    by the content. Emotion information can be returned for detected entities, 
    keywords, or user-specified target phrases found in the text. */
public struct EmotionResult: JSONDecodable {
    
    /// The returned emotion results across the document.
    public let document: DocumentEmotionResults?
    
    /// The returned emotion results per specified target.
    public let targets: [TargetedEmotionResults]?

    /// Used internally to initialize an `EmotionResult` model from JSON.
    public init(json: JSON) throws {
        document = try? json.decode(at: "document", type: DocumentEmotionResults.self)
        targets = try? json.decodedArray(at: "targets", type: TargetedEmotionResults.self)
    }
}

/** An object containing the emotion results of a document. */
public struct DocumentEmotionResults: JSONDecodable {
    
    /// The returned emotion result.
    public let emotion: EmotionScores?
    
    /// Used internally to initialize a 'DocumentEmotionResults' model from JSON.
    public init(json: JSON) throws {
        emotion = try? json.decode(at: "emotion", type: EmotionScores.self)
    }
}

/** An object containing all the emotion results in a document. */
public struct EmotionScores: JSONDecodable {
    
    /// Anger score from 0 to 1. A higher score means that the text is more likely to convey anger.
    public let anger: Double?
    
    /// Disgust score from 0 to 1. A higher score means that the text is more likely to convey disgust.
    public let disgust: Double?
    
    /// Fear score from 0 to 1. A higher score means that the text is more likely to convey fear.
    public let fear: Double?
    
    /// Joy score from 0 to 1. A higher score means that the text is more likely to convey joy.
    public let joy: Double?
    
    /// Sadness score from 0 to 1. A higher score means that the text is more likely to convey sadness.
    public let sadness: Double?
    
    /// Used internally to intialize a 'DocumentEmotionResults' model from JSON.
    public init(json: JSON) throws {
        anger = try? json.getDouble(at: "anger")
        disgust = try? json.getDouble(at: "disgust")
        fear = try? json.getDouble(at: "fear")
        joy = try? json.getDouble(at: "joy")
        sadness = try? json.getDouble(at: "sadness")
    }
}

/** An object containing the emotion results per target specified. */
public struct TargetedEmotionResults: JSONDecodable {
    
    /// Targeted text.
    public let text: String?
    
    /// The emotion results of the targetted text.
    public let emotion: EmotionScores?
    
    /// Used internally to initialize a `TargetedEmotionResults` model from JSON.
    public init(json: JSON) throws {
        text = try? json.getString(at: "text")
        emotion = try? json.decode(at: "emotion", type: EmotionScores.self)
    }
}
