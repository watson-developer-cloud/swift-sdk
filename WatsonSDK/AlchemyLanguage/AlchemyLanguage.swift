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
public final class AlchemyLanguage: Service {
    
    private typealias alcs = AlchemyLanguageConstants
    private typealias optm = alcs.OutputMode
    private typealias wuri = alcs.WatsonURI
    private typealias luri = alcs.LanguageURI

    
    init() {

        print(AlchemyLanguageConstants.LanguageURI.SourceText.cleaned_or_raw)
        
        print(luri.SourceText.cleaned_or_raw)
        
        super.init(
            type: ServiceType.Alchemy,
            serviceURL: alcs.Calls()
        )
        
    }
    
    convenience init(apiKey:String) {
        
        self.init()
        _apiKey = apiKey
        
    }
    
    /** A dictionary of parameters used in all Alchemy Language API calls */
    private var commonParameters: [String : String] {
        
        return [
            
            wuri.APIKey.rawValue : _apiKey,
            
            luri.OutputMode.rawValue : optm.JSON.rawValue
            
        ]
        
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
    
    public struct GetEntitiesParameters: AlchemyLanguageParameters {
        
        init(){}
        
        var disambiguate: Int? = 1
        var linkedData: Int? = 1
        var coreference: Int? = 1
        var quotations: Int? = 0
        var sentiment: Int? = 0
        var sourceText: luri.SourceText? = luri.SourceText.cleaned_or_raw
        var showSourceText: Int? = 0
        var cquery: String? = ""
        var xpath: String? = ""
        var maxRetrieve: Int? = 50
        var baseUrl: String? = ""
        var knowledgGraph: Int? = 0
        var stucturedEntities: Int? = 1
        
    }
    
    /**
     Extracts a grouped, ranked list of named entities (people, companies,
     organizations, etc.) from text, a URL or HTML.
     
     - Parameters:
     - The parameters to be used in the service call, text, html or url should be specified.
     
     - Returns: An **Entities** object.
     */
    public func getEntities(requestType rt: AlchemyLanguageConstants.RequestType,
        html: String?,
        url: String?,
        entitiesParameters ep: GetEntitiesParameters = GetEntitiesParameters(),
        completionHandler: (error: NSError, returnValue: Entities)->() ) {
            
            let accessString = AlchemyLanguageConstants.GetEntities(fromRequestType: rt)
            let endpoint = getEndpoint(accessString)
            
            let entitiesParamDict = ep.asDictionary()
            var parameters = AlchemyCombineDictionaryUtil.combineParameterDictionary(commonParameters, withDictionary: entitiesParamDict)

            if let html = html { parameters["html"] = html }
            if let url = url { parameters["url"] = url }
            
            NetworkUtils.performBasicAuthRequest(endpoint,
                method: HTTPMethod.POST,
                parameters: parameters,
                encoding: ParameterEncoding.URL) {
                    
                    response in
                    
                    // TODO: explore NSError, for now assume non-nil is guaranteed
                    assert(response.error != nil, "AlchemyLanguage: getAuthor: reponse.error should not be nil.")
                    
                    let error = response.error!
                    let data = response.data ?? nil
                    
                    let entities = Mapper<Entities>().map(data)!
                    
                    completionHandler(error: error, returnValue: entities)
                    
            }
            
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
    
    public struct GetKeywordsParameters: AlchemyLanguageParameters {
        
        init(){}
        
        var sentiment: Int? = 0
        var sourceText: luri.SourceText? = luri.SourceText.cleaned_or_raw
        var showSourceText: Int? = 0
        var cquery: String? = ""
        var xpath: String? = ""
        var maxRetrieve: Int? = 50
        var baseUrl: String? = ""
        var knowledgGraph: Int? = 0
        var keywordExtractMode: luri.KeywordExtractMode = luri.KeywordExtractMode.normal
        
    }
    
    public func getRankedKeywords(requestType rt: AlchemyLanguageConstants.RequestType,
        html: String?,
        url: String?,
        keywordsParameters kp: GetKeywordsParameters = GetKeywordsParameters(),
        completionHandler: (error: NSError, returnValue: Keywords)->() ) {
            
            let accessString = AlchemyLanguageConstants.GetEntities(fromRequestType: rt)
            let endpoint = getEndpoint(accessString)
            
            let keywordsParamDict = kp.asDictionary()
            var parameters = AlchemyCombineDictionaryUtil.combineParameterDictionary(commonParameters, withDictionary: keywordsParamDict)
            
            if let html = html { parameters["html"] = html }
            if let url = html { parameters["url"] = url }
            
            NetworkUtils.performBasicAuthRequest(endpoint,
                method: HTTPMethod.POST,
                parameters: parameters,
                encoding: ParameterEncoding.URL) {
                    
                    response in
                    
                    // TODO: explore NSError, for now assume non-nil is guaranteed
                    assert(response.error != nil, "AlchemyLanguage: getAuthor: reponse.error should not be nil.")
                    
                    let error = response.error!
                    let data = response.data ?? nil
                    
                    let keywords = Mapper<Keywords>().map(data)!
                    
                    completionHandler(error: error, returnValue: keywords)
                    
            }
            
    }
    
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
public extension AlchemyLanguage {
    
    public func getAuthors(requestType rt: AlchemyLanguageConstants.RequestType,
        html: String?,
        url: String?,
        completionHandler: (error: NSError, returnValue: DocumentAuthors)->() ) {
            
            var parameters = commonParameters
            
            let accessString = AlchemyLanguageConstants.GetAuthors(fromRequestType: rt)
            let endpoint = getEndpoint(accessString)
            
            // update parameters
            if let html = html { parameters["html"] = html }
            if let url = url { parameters["url"] = url }
            
            NetworkUtils.performBasicAuthRequest(endpoint,
                method: HTTPMethod.POST,
                parameters: parameters,
                encoding: ParameterEncoding.URL) {
                    
                    response in
                    
                    // TODO: explore NSError, for now assume non-nil is guaranteed
                    assert(response.error != nil, "AlchemyLanguage: getAuthor: reponse.error should not be nil.")
                    
                    let error = response.error!
                    let data = response.data ?? nil
                    
                    let documentAuthors = Mapper<DocumentAuthors>().map(data)!
                    
                    completionHandler(error: error, returnValue: documentAuthors)
                    
            }
    }
    
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
    
    // TODO: raw or not raw text parameter
    public func getText(requestType rt: AlchemyLanguageConstants.RequestType,
        html: String?,
        url: String?,
        useMetadata: Int = 1,
        extractLinks: Int = 0,
        sourceText: luri.SourceText = luri.SourceText.cleaned_or_raw,
        completionHandler: (error: NSError, returnValue: DocumentText)->() ) {
            
            var parameters = commonParameters
            
            let accessString = AlchemyLanguageConstants.GetText(fromRequestType: rt)
            let endpoint = getEndpoint(accessString)
            
            // update parameters
            if let html = html { parameters["html"] = html }
            if let url = url { parameters["url"] = url }
            
            NetworkUtils.performBasicAuthRequest(endpoint,
                method: HTTPMethod.POST,
                parameters: parameters,
                encoding: ParameterEncoding.URL) {
                    
                    response in
                    
                    // TODO: explore NSError, for now assume non-nil is guaranteed
                    assert(response.error != nil, "AlchemyLanguage: getText: reponse.error should not be nil.")
                    
                    let error = response.error!
                    let data = response.data ?? nil
                    
                    let documentText = Mapper<DocumentText>().map(data)!
                    
                    completionHandler(error: error, returnValue: documentText)
                    
            }
            
    }
    
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
