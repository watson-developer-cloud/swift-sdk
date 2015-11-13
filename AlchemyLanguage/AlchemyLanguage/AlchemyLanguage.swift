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
import WatsonCore

/**

 **AlchemyLanguage**

 http://www.alchemyapi.com/products/alchemylanguage

 * Entity Extraction
 * Sentiment Analysis
 * Keyword Extraction
 * Concept Tagging
 * Relation Extraction
 * Taxonomy Classification
 * Author Extraction
 * Language Detection
 * Text Extraction
 * Microformats Parsing
 * Feed Detection
 * Linked Data Support
 */
public final class AlchemyLanguage: Service {}

        
        
    }
    
        
        
    }

}


// MARK: Entity Extraction
/**
 
 
 http://www.alchemyapi.com/api/entity/proc.html

 public func URLGetRankedNamedEntities() {}
 public func HTMLGetRankedNamedEntities() {}
 public func TextGetRankedNamedEntities() {}

 */
public extension AlchemyLanguage {
    
    /**
     Extracts a grouped, ranked list of named entities (people, companies,
     organizations, etc.) from text, a URL or HTML.
     
     - Parameters:
     - The parameters to be used in the service call, text, html or url should be specified.
     
     - Returns: An **Entities** object.
     */
    public func getEntities(requestType rt: RequestType,
        url: NSURL,
        outputMode: OutputMode,
        jsonp: String,
        disambiguate: Bool = true,
        linkedData: Bool = true,
        coreference: Bool = true,
        quotations: Bool = false,
        sentiment: Bool = false,
        sourceText: SourceText,
        showSourceText: Bool = false,
        cquery: String,
        xpath: String,
        maxRetrieve: Int,
        baseUrl: NSURL,
        knowledgGraph: Bool = false,
        stucturedEntities: Bool = true) -> Entities {
            
            let accessString = _apiKey + AlchemyLanguageConstants.GetEntities(fromRequestType: rt)
            
            print(accessString)
            
            return Entities()
            
    }
    
}


// MARK: Sentiment Analysis
/**

 http://www.alchemyapi.com/api/sentiment/proc.html
 
 */
public extension AlchemyLanguage {
    
    public func URLGetTextSentiment() {}
    public func HTMLGetTextSentiment() {}
    public func TextGetTextSentiment() {}
    
    public func URLGetTargetedSentiment() {}
    public func HTMLGetTargetedSentiment() {}
    public func TextGetTargetedSentiment() {}
    
}


// MARK: Keyword Extraction
/**

 http://www.alchemyapi.com/api/keyword/proc.html
 
 */
public extension AlchemyLanguage {
    
    public func URLGetRankedKeywords() {}
    public func HTMLGetRankedKeywords() {}
    public func TextGetRankedKeywords() {}
    
}


// MARK: Concept Tagging
/**

 http://www.alchemyapi.com/api/concept/proc.html
 
 */
public extension AlchemyLanguage {
    
    public func URLGetRankedConcepts() {}
    public func HTMLGetRankedConcepts() {}
    public func TextGetRankedConcepts() {}
    
}


// MARK: Relation Extraction
/**

 http://www.alchemyapi.com/api/relation/proc.html
 
 */
public extension AlchemyLanguage {
    
    public func URLGetRelations() {}
    public func HTMLGetRelations() {}
    public func TextGetRelations() {}
    
}


// MARK: Taxonomy Classification
/**

 http://www.alchemyapi.com/api/taxonomy_calls/proc.html

*/
public extension AlchemyLanguage {
    
    public func URLGetRankedTaxonomy() {}
    public func HTMLGetRankedTaxonomy() {}
    public func TextGetRankedTaxonomy() {}
    
}


// MARK: Author Extraction
/**

 http://www.alchemyapi.com/api/author/proc.html
 
 */
public extension AlchemyLanguage {
    
    public func URLGetAuthor() {}
    public func HTMLGetAuthor() {}
    public func TextGetAuthor() {}
    
}


// MARK: Language Detection
/**

 http://www.alchemyapi.com/api/lang/proc.html
 
 */
public extension AlchemyLanguage {
    
    public func URLGetLanguage() {}
    public func HTMLGetLanguage() {}
    public func TextGetLanguage() {}
    
}


// MARK: Text Extraction
/**

 http://www.alchemyapi.com/api/text/proc.html
 
 */
public extension AlchemyLanguage {
    
    public func URLGetText() {}
    public func HTMLGetText() {}
    
    public func URLGetRawText() {}
    public func HTMLGetRawText() {}
    
    public func URLGetTitle() {}
    public func HTMLGetTitle() {}
    
}


// MARK: Microformats Parsing
/**

 http://www.alchemyapi.com/api/mformat/proc.html
 
 */
public extension AlchemyLanguage {
    
    public func URLGetMicroformatData() {}
    public func HTMLGetMicroformatData() {}
    
}


// MARK: Feed Detection
/**

 http://www.alchemyapi.com/api/feed-detection/proc.html
 
 */
public extension AlchemyLanguage {
    
    public func URLGetFeedLinks() {}
    public func HTMLGetFeedLinks() {}
    
}
