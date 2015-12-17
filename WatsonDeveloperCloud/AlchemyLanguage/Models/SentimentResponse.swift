/**
 * Copyright 2015 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import ObjectMapper

/**
 
 **SentimentResponse**
 
 Returned by the AlchemyLanguage service.
 
 */
public struct SentimentResponse: AlchemyLanguageGenericModel, Mappable {
    
    // MARK: AlchemyGenericModel
    public var totalTransactions: Int?
    
    // MARK: AlchemyLanguageGenericModel
    public var language: String?
    public var url: String?
    
    // MARK: DocSentiment
    /** response when normal sentimented call is used */
    public var docSentiment: Sentiment?                     // Normal

    /** response when targeted sentimented call is used */
    public var sentimentResults: [DocumentSentiment]?       // Targeted

    /** (undocumented) */
    public var usage: String?

    /** warnings about incorrect usage or failures in detection */
    public var warningMessage: String?

    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        
        // alchemyGenericModel
        totalTransactions <- (map["totalTransactions"], Transformation.stringToInt)
        
        // alchemyLanguageGenericModel
        language <- map["language"]
        url <- map["url"]
        
        // sentiment - alchemyLanguage sometimes returns as "docSentiment," sometimes as "sentiment"
        docSentiment <- map["docSentiment"]
        sentimentResults <- map["results"]

        usage <- map["usage"]
        warningMessage <- map["warningMessage"]
        
    }
    
}
