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

/** The relations between entities found in the content. */
public struct RelationsResult: JSONDecodable {
    
    /// Confidence score for the relation. Higher values indicate greater confidence.
    public let score: Double?
    
    /// The sentence that contains the relation.
    public let sentence: String?
    
    /// The type of the relation.
    public let type: String?
   
    /// The extracted relation objects from the text.
    public let arguments: [RelationArgument]?

    /// Used internally to initialize a `RelationsResult` model from JSON.
    public init(json: JSON) throws {
        score = try? json.getDouble(at: "score")
        sentence = try? json.getString(at: "sentence")
        type = try? json.getString(at: "type")
        arguments = try? json.decodedArray(at: "arguments", type: RelationArgument.self)
    }
}

/** The extracted relation in the content.. */
public struct RelationArgument: JSONDecodable {
    
    /// The relationship of the entity pulled from a sentence.
    public let entities: [RelationEntity]?
    
    /// Text that corresponds to the argument
    public let text: String?
    
    /// Used internally to initialize a `RelationArgument` model from JSON.
    public init(json: JSON) throws {
        entities = try? json.decodedArray(at: "entities", type: RelationEntity.self)
        text = try? json.getString(at: "text")
    }
}
