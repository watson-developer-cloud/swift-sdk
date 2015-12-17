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
 
 **Language**
 
 Returned by the AlchemyLanguage service.
 
 */
public struct Language: AlchemyLanguageGenericModel, Mappable {
    
    // MARK: AlchemyGenericModel
    public var totalTransactions: Int?
    
    // MARK: AlchemyLanguageGenericModel
    public var language: String?
    public var url: String?
    
    // MARK: Keyword
    /** link to Ethnologue containing information on the detected language */
    public var ethnologue: String?

    /** ISO-639-1 code for the detected language */
    public var iso6391: String?

    /** ISO-639-2 code for the detected language */
    public var iso6392: String?

    /** ISO-639-3 code for the detected language */
    public var iso6393: String?

    /** how many people speak this language */
    public var nativeSpeakers: String?

    /** a useful wiki on this language */
    public var wikipedia: String?
    
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        
        // alchemyGenericModel
        totalTransactions <- (map["totalTransactions"], Transformation.stringToInt)
        
        // alchemyLanguageGenericModel
        language <- map["language"]
        url <- map["url"]
        
        // keyword
        ethnologue <- map["ethnologue"]
        iso6391 <- map["iso-639-1"]
        iso6392 <- map["iso-639-2"]
        iso6393 <- map["iso-639-3"]
        nativeSpeakers <- map["native-speakers"]
        wikipedia <- map["wikipedia"]
        
    }
    
}
