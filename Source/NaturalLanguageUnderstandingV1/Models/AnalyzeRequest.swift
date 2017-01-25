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

/** An object containing request parameters for the 'analyze' NLU endpoint. */
public struct AnalyzeRequest: JSONEncodable {
    
    public let text: String?
    public let html: String?
    public let url: String?
    public let concepts: ConceptsRequest?
    public let emotion: EmotionRequest?
    public let entities: EntitiesRequest?
    public let keywords: KeywordsRequest?
    public let metadata: MetadataRequest?
    // public let relations: Relations?
    public let semanticRoles: SemanticRolesRequest?
    public let sentiment: SentimentRequest?
    public let categories: Categories?
    public let clean: Bool?
    public let xpath: String?
    public let fallbackToRaw: Bool?
    public let returnAnalyzedText: Bool?
    public let language: String?
    
    /**
     Create an `AnalyzeRequest` object.
     
     - parameter
     */
    public init()
    {
    }
    
    public func toJSONObject() -> Any {
        
    }
}

public struct ConceptsRequest: JSONEncodable {
    public let limit: Int
//    public let linkedData: Bool
}

public struct EmotionRequest: JSONEncodable {
    public let document: Bool
    public let targets: [String]
}

public struct EntitiesRequest: JSONEncodable {
    public let limit: Int
    public let model: String
    public let sentiment: Bool
//    public let emotion: Bool
//    public let disambiguation: Bool
}

public struct KeywordsRequest: JSONEncodable {
    public let limit: Int
    public let sentiment: Bool
//    public let emotion: Bool
}

public struct MetadataRequest: JSONEncodable {
}

public struct SemanticRolesRequest: JSONEncodable {
    public let limit: Int
    public let keywords: Bool
    public let entities: Bool
    // public let requireEntities: Bool
    public let disambiguate: Bool
}

public struct SentimentRequest: JSONEncodable {
    public let document: Bool
    public let targets: [String]
}

public struct Categories: JSONEncodable {
    
}
