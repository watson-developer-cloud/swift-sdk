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
 
 **Sentiment**
 
 Returned by the AlchemyLanguage service.
 
 */
public struct Sentiment: Mappable {
    
    /** is a mix of positive, neutral, and/or negative sentiments detected */
    public var mixed: Int?

    /** strength of prevalent sentiment, 0.0 to 1.0 */
    public var score: Double?

    /** "positive", "neutral", or "negative" */
    public var type: String?
    
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        
        mixed <- (map["mixed"], Transformation.stringToInt)
        score <- (map["score"], Transformation.stringToDouble)
        type <- map["type"]
        
    }
    
}
