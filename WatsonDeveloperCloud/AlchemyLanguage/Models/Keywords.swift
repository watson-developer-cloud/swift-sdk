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
 
 **Keywords**
 
 Returned by the AlchemyLanguage service.
 
 */
public struct Keywords: AlchemyLanguageGenericModel, Mappable {
    
    // MARK: AlchemyGenericModel
    public var totalTransactions: Int?
    
    // MARK: AlchemyLanguageGenericModel
    public var language: String?
    public var url: String?
    
    // MARK: Keywords
    /** keywords response (see **Keyword**) */
    public var keywords: [Keyword]?

    /** inputted text */
    public var text: String?
    
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        
        // alchemyGenericModel
        totalTransactions <- (map["totalTransactions"], Transformation.stringToInt)
        
        // alchemyLanguageGenericModel
        language <- map["language"]
        url <- map["url"]
        
        // keywords
        keywords <- map["keywords"]
        text <- map["text"]
        
    }
    
}
