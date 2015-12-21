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
public final class AlchemyLanguage: AlchemyService {
    
    // The authentication strategy to obtain authorization tokens.
    var authStrategy: AuthenticationStrategy
    
    // The non-expiring Alchemy API key returned by the authentication strategy.
    // TODO: this can be removed after migrating to WatsonGateway
    private var _apiKey: String! {
        return authStrategy.token
    }
    
    public required init(var authStrategy: AuthenticationStrategy) {
        
        self.authStrategy = authStrategy
        
        // refresh to obtain the API key
        // TODO: this can be removed after migrating to WatsonGateway
        authStrategy.refreshToken { error in
            guard error != nil else {
                return
            }
        }
        
    }
    
    public convenience required init(apiKey: String) {
        let authStrategy = APIKeyAuthenticationStrategy(apiKey: apiKey)
        self.init(authStrategy: authStrategy)
    }
    
    private typealias alcs = AlchemyLanguageConstants
    private typealias optm = alcs.OutputMode
    private typealias wuri = alcs.WatsonURI
    private typealias luri = alcs.LanguageURI
    
    /** A dictionary of parameters used in all Alchemy Language API calls */
    private var commonParameters: [String : String] {
        
        return [
            
            wuri.APIKey.rawValue : authStrategy.token!,
            luri.OutputMode.rawValue : optm.JSON.rawValue
            
        ]
        
    }
    
}


// MARK: Entity Extraction
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

     [AlchemyDocs](http://www.alchemyapi.com/api/entity/proc.html)
     
     Extracts a grouped, ranked list of named entities (people, companies, organizations, etc.) from HTML, URL, or Text
     
     - parameter requestType: .HTML, .URL, or .Text
     - parameter html: input html if a .HTML request. otherwise can set to 'nil'
     - parameter url: input url if a .URL request. otherwise can set to 'nil'
     - parameter text: input text if a .Text request. otherwise can set to 'nil'
     - parameter entitiesParameters: instantiate a **GetEntitiesParameters** struct and change any values you'd like to manually set
     - parameter completionHandler: block of code to run on completion. contains result data model instance
     
     - returns: An **Entities** object
     
     */
    public func getEntities(requestType rt: AlchemyLanguageConstants.RequestType,
        html: String?,
        url: String?,
        text: String?,
        entitiesParameters ep: GetEntitiesParameters = GetEntitiesParameters(),
        completionHandler: (error: NSError, returnValue: Entities) -> Void) {
            
            let accessString = AlchemyLanguageConstants.GetEntities(fromRequestType: rt)
            let endpoint = getEndpoint(accessString)
            
            let entitiesParamDict = ep.asDictionary()
            var parameters = AlchemyCombineDictionaryUtil.combineParameterDictionary(commonParameters, withDictionary: entitiesParamDict)

            if let html = html { parameters["html"] = html }
            if let url = url { parameters["url"] = url }
            if let text = text { parameters["text"] = text }
            
            NetworkUtils.performBasicAuthRequest(endpoint,
                method: HTTPMethod.POST,
                parameters: parameters,
                encoding: ParameterEncoding.URL) {
                    
                    response in
                    
                    // TODO: explore NSError, for now assume non-nil is guaranteed
                    assert(response.error != nil, "AlchemyLanguage: reponse.error should not be nil.")
                    
                    let error = response.error!
                    let data = response.data ?? nil
                    
                    let entities = Mapper<Entities>().map(data)!
                    
                    completionHandler(error: error, returnValue: entities)
                    
            }
            
    }
    
}


// MARK: Sentiment Analysis
public extension AlchemyLanguage {
    
    public struct GetSentimentParameters: AlchemyLanguageParameters {
        
        init(){}
        
        var sentiment: Int? = 0
        var showSourceText: Int? = 0
        var sourceText: luri.SourceText? = luri.SourceText.cleaned_or_raw
        var cquery: String? = ""
        var xpath: String? = ""
        var targets: String? = ""           // required if targeted
        
    }
    
    /**
     
     [AlchemyDocs](http://www.alchemyapi.com/api/sentiment/proc.html)
     
     Calculates the sentiment (Positive, Neutral, Negative) for given content.
     
     - parameter requestType: .HTML, .URL, or .Text
     - parameter html: input html if a .HTML request. otherwise can set to 'nil'
     - parameter url: input url if a .URL request. otherwise can set to 'nil'
     - parameter text: input text if a .Text request. otherwise can set to 'nil'
     - parameter sentimentType: .Normal or .Raw (see [AlchemyDocs](http://www.alchemyapi.com/api/sentiment/proc.html) for details)
     - parameter sentimentParameters: instantiate a **GetSentimentParameters** struct and change any values you'd like to manually set
     - parameter completionHandler: block of code to run on completion. contains result data model instance
     
     - returns: A **SentimentResponse** object
     
     */
    public func getSentiment(requestType rt: AlchemyLanguageConstants.RequestType,
        html: String?,
        url: String?,
        text: String?,
        sentimentType: alcs.SentimentType = alcs.SentimentType.Normal,
        sentimentParameters sp: GetSentimentParameters = GetSentimentParameters(),
        completionHandler: (error: NSError, returnValue: SentimentResponse) -> Void) {
            
            var accessString: String!
            
            switch sentimentType {
                
            case .Normal:
                accessString = alcs.GetTextSentiment(fromRequestType: rt)
            
            case .Targeted:
                accessString = alcs.GetTargetedSentiment(fromRequestType: rt)
                assert(sp.targets != "", "WatsonSDK: AlchemyLanguage: getSentiment: When using targeted sentiment calls, \"targets\" cannot be empty.")
            
            }
            
            let endpoint = getEndpoint(accessString)
            
            let sentimentParamDict = sp.asDictionary()
            var parameters = AlchemyCombineDictionaryUtil.combineParameterDictionary(commonParameters, withDictionary: sentimentParamDict)
            
            if let html = html { parameters["html"] = html }
            if let url = url { parameters["url"] = url }
            if let text = text { parameters["text"] = text }
            
            NetworkUtils.performBasicAuthRequest(endpoint,
                method: HTTPMethod.POST,
                parameters: parameters,
                encoding: ParameterEncoding.URL) {
                    
                    response in
                    
                    // TODO: explore NSError, for now assume non-nil is guaranteed
                    assert(response.error != nil, "AlchemyLanguage: getSentiment: reponse.error should not be nil.")
                    
                    let error = response.error!
                    let data = response.data ?? nil
                    
                    let sentimentResponse = Mapper<SentimentResponse>().map(data)!
                    
                    completionHandler(error: error, returnValue: sentimentResponse)
                    
            }
            
    }
    
}


// MARK: Keyword Extraction
public extension AlchemyLanguage {
    
    public struct GetKeywordsParameters: AlchemyLanguageParameters {
        
        init(){}
        
        var sentiment: Int? = 0
        var sourceText: String? = luri.SourceText.cleaned_or_raw.rawValue
        var showSourceText: Int? = 0
        var cquery: String? = ""
        var xpath: String? = ""
        var maxRetrieve: Int? = 50
        var baseUrl: String? = ""
        var knowledgGraph: Int? = 0
        var keywordExtractMode: String? = luri.KeywordExtractMode.normal.rawValue
        
    }
    
     /**
     
     [AlchemyDocs](http://www.alchemyapi.com/api/keyword/proc.html)
     
     Extracts keywords from given content.
     
     - parameter requestType: .HTML, .URL, or .Text
     - parameter html: input html if a .HTML request. otherwise can set to 'nil'
     - parameter url: input url if a .URL request. otherwise can set to 'nil'
     - parameter text: input text if a .Text request. otherwise can set to 'nil'
     - parameter keywordsParameters: instantiate a **GetKeywordsParameters** struct and change any values you'd like to manually set
     - parameter completionHandler: block of code to run on completion. contains result data model instance
     
     - returns: A **Keywords** object
     
     */
    public func getRankedKeywords(requestType rt: AlchemyLanguageConstants.RequestType,
        html: String?,
        url: String?,
        text: String?,
        keywordsParameters kp: GetKeywordsParameters = GetKeywordsParameters(),
        completionHandler: (error: NSError, returnValue: Keywords) -> Void) {
            
            let accessString = AlchemyLanguageConstants.GetRankedKeywords(fromRequestType: rt)
            let endpoint = getEndpoint(accessString)
            
            let keywordsParamDict = kp.asDictionary()
            var parameters = AlchemyCombineDictionaryUtil.combineParameterDictionary(commonParameters, withDictionary: keywordsParamDict)
            
            if let html = html { parameters["html"] = html }
            if let url = url { parameters["url"] = url }
            if let text = text { parameters["text"] = text }
            
            NetworkUtils.performBasicAuthRequest(endpoint,
                method: HTTPMethod.POST,
                parameters: parameters,
                encoding: ParameterEncoding.URL) {
                    
                    response in
                    
                    // TODO: explore NSError, for now assume non-nil is guaranteed
                    assert(response.error != nil, "AlchemyLanguage: reponse.error should not be nil.")
                    
                    let error = response.error!
                    let data = response.data ?? nil
                    
                    let keywords = Mapper<Keywords>().map(data)!
                    
                    completionHandler(error: error, returnValue: keywords)
                    
            }
            
    }
    
}


// MARK: Concept Tagging
public extension AlchemyLanguage {
    
    public struct GetRankedConceptsParameters: AlchemyLanguageParameters {
        
        init(){}

        var linkedData: Int? = 1
        var sourceText: String? = luri.SourceText.cleaned_or_raw.rawValue
        var showSourceText: Int? = 0
        var cquery: String? = ""
        var xpath: String? = ""
        var maxRetrieve: Int? = 50
        var baseUrl: String? = ""
        var knowledgGraph: Int? = 0
        
    }
    
     /**
     
     [AlchemyDocs](http://www.alchemyapi.com/api/concept/proc.html)
     
     Extracts concepts tags for given content.
     
     - parameter requestType: .HTML, .URL, or .Text
     - parameter html: input html if a .HTML request. otherwise can set to 'nil'
     - parameter url: input url if a .URL request. otherwise can set to 'nil'
     - parameter text: input text if a .Text request. otherwise can set to 'nil'
     - parameter conceptsParameters: instantiate a **GetRankedConceptsParameters** struct and change any values you'd like to manually set
     - parameter completionHandler: block of code to run on completion. contains result data model instance
     
     - returns: A **ConceptResponse** object
     
     */
    public func getRankedConcepts(requestType rt: AlchemyLanguageConstants.RequestType,
        html: String?,
        url: String?,
        text: String?,
        conceptsParameters pd: GetRankedConceptsParameters = GetRankedConceptsParameters(),
        completionHandler: (error: NSError, returnValue: ConceptResponse) -> Void) {
            
            let accessString = AlchemyLanguageConstants.GetRankedConcepts(fromRequestType: rt)
            let endpoint = getEndpoint(accessString)
            
            let parametersDictionary = pd.asDictionary()
            var parameters = AlchemyCombineDictionaryUtil.combineParameterDictionary(commonParameters, withDictionary: parametersDictionary)
            
            if let html = html { parameters["html"] = html }
            if let url = url { parameters["url"] = url }
            if let text = text { parameters["text"] = text }
            
            NetworkUtils.performBasicAuthRequest(endpoint,
                method: HTTPMethod.POST,
                parameters: parameters,
                encoding: ParameterEncoding.URL) {
                    
                    response in
                    
                    // TODO: explore NSError, for now assume non-nil is guaranteed
                    assert(response.error != nil, "AlchemyLanguage: reponse.error should not be nil.")
                    
                    let error = response.error!
                    let data = response.data ?? nil
                    
                    let conceptResponse = Mapper<ConceptResponse>().map(data)!
                    
                    completionHandler(error: error, returnValue: conceptResponse)
                    
            }
            
    }
    
}


// MARK: Relation Extraction
public extension AlchemyLanguage {
    
    public struct GetRelationsParameters: AlchemyLanguageParameters {
        
        init(){}
        
        var entities: Int? = 0          // extra call
        var keywords: Int? = 0          // extra call
        var requireEntities: Int? = 0
        var sentimentExcludeEntities: Int? = 1
        var disambiguate: Int? = 1
        var linkedData: Int? = 1
        var coreference: Int? = 1
        var sentiment: Int? = 1         // extra call
        var sourceText: String? = luri.SourceText.cleaned_or_raw.rawValue
        var showSourceText: Int? = 0
        var cquery: String? = ""
        var xpath: String? = ""
        var maxRetrieve: Int? = 50
        var baseUrl: String? = ""
        
    }
    
     /**
     
     [AlchemyDocs](http://www.alchemyapi.com/api/relation/proc.html)
     
     Extracts Subject-Action-Object(SAO) relations from given content.
     
     - parameter requestType: .HTML, .URL, or .Text
     - parameter html: input html if a .HTML request. otherwise can set to 'nil'
     - parameter url: input url if a .URL request. otherwise can set to 'nil'
     - parameter text: input text if a .Text request. otherwise can set to 'nil'
     - parameter relationsParameters: instantiate a **GetRelationsParameters** struct and change any values you'd like to manually set
     - parameter completionHandler: block of code to run on completion. contains result data model instance
     
     - returns: An **SAORelations** object
     
     */
    public func getRelations(requestType rt: AlchemyLanguageConstants.RequestType,
        html: String?,
        url: String?,
        text: String?,
        relationsParameters pd: GetRelationsParameters = GetRelationsParameters(),
        completionHandler: (error: NSError, returnValue: SAORelations) -> Void) {
            
            let accessString = AlchemyLanguageConstants.GetRelations(fromRequestType: rt)
            let endpoint = getEndpoint(accessString)
            
            let parametersDictionary = pd.asDictionary()
            var parameters = AlchemyCombineDictionaryUtil.combineParameterDictionary(commonParameters, withDictionary: parametersDictionary)
            
            if let html = html { parameters["html"] = html }
            if let url = url { parameters["url"] = url }
            if let text = text { parameters["text"] = text }
            
            NetworkUtils.performBasicAuthRequest(endpoint,
                method: HTTPMethod.POST,
                parameters: parameters,
                encoding: ParameterEncoding.URL) {
                    
                    response in
                    
                    // TODO: explore NSError, for now assume non-nil is guaranteed
                    assert(response.error != nil, "AlchemyLanguage: reponse.error should not be nil.")
                    
                    let error = response.error!
                    let data = response.data ?? nil
                    
                    let saoRelations = Mapper<SAORelations>().map(data)!
                    
                    completionHandler(error: error, returnValue: saoRelations)
                    
            }
            
    }
    
}


// MARK: Taxonomy Classification
public extension AlchemyLanguage {
    
    public struct GetRankedTaxonomyParameters: AlchemyLanguageParameters {
        
        init(){}
        
        var sourceText: String? = luri.SourceText.cleaned_or_raw.rawValue
        var cquery: String? = ""
        var xpath: String? = ""
        var baseUrl: String? = ""
        
    }
    
     /**
     
     [AlchemyDocs](http://www.alchemyapi.com/api/taxonomy_calls/proc.html)
     
     Categorize via the taxonomy call.
     
     - parameter requestType: .HTML, .URL, or .Text
     - parameter html: input html if a .HTML request. otherwise can set to 'nil'
     - parameter url: input url if a .URL request. otherwise can set to 'nil'
     - parameter text: input text if a .Text request. otherwise can set to 'nil'
     - parameter taxonomyParameters: instantiate a **GetRankedTaxonomyParameters** struct and change any values you'd like to manually set
     - parameter completionHandler: block of code to run on completion. contains result data model instance
     
     - returns: A **Taxonomies** object
     
     */
    public func getRankedTaxonomy(requestType rt: AlchemyLanguageConstants.RequestType,
        html: String?,
        url: String?,
        text: String?,
        taxonomyParameters pd: GetRankedTaxonomyParameters = GetRankedTaxonomyParameters(),
        completionHandler: (error: NSError, returnValue: Taxonomies) -> Void) {
            
            let accessString = AlchemyLanguageConstants.GetRankedTaxonomy(fromRequestType: rt)
            let endpoint = getEndpoint(accessString)
            
            let parametersDictionary = pd.asDictionary()
            var parameters = AlchemyCombineDictionaryUtil.combineParameterDictionary(commonParameters, withDictionary: parametersDictionary)
            
            if let html = html { parameters["html"] = html }
            if let url = url { parameters["url"] = url }
            if let text = text { parameters["text"] = text }
            
            NetworkUtils.performBasicAuthRequest(endpoint,
                method: HTTPMethod.POST,
                parameters: parameters,
                encoding: ParameterEncoding.URL) {
                    
                    response in
                    
                    // TODO: explore NSError, for now assume non-nil is guaranteed
                    assert(response.error != nil, "AlchemyLanguage: reponse.error should not be nil.")
                    
                    let error = response.error!
                    let data = response.data ?? nil
                    
                    let taxonomies = Mapper<Taxonomies>().map(data)!
                    
                    completionHandler(error: error, returnValue: taxonomies)
                    
            }
            
    }
    
}


// MARK: Author Extraction
public extension AlchemyLanguage {
    
    /**
     
     [AlchemyDocs](http://www.alchemyapi.com/api/api-calls-authors-extraction)
     
     Extracts document authors from given content.
     
     - parameter requestType: .HTML, .URL
     - parameter html: input html if a .HTML request. otherwise can set to 'nil'
     - parameter url: input url if a .URL request. otherwise can set to 'nil'
     - parameter completionHandler: block of code to run on completion. contains result data model instance
     
     - returns: A **DocumentAuthors** object
     
     */
    public func getAuthors(requestType rt: AlchemyLanguageConstants.RequestType,
        html: String?,
        url: String?,
        completionHandler: (error: NSError, returnValue: DocumentAuthors) -> Void) {
            
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
                    assert(response.error != nil, "AlchemyLanguage: reponse.error should not be nil.")
                    
                    let error = response.error!
                    let data = response.data ?? nil
                    
                    let documentAuthors = Mapper<DocumentAuthors>().map(data)!
                    
                    completionHandler(error: error, returnValue: documentAuthors)
                    
            }
    }
    
}


// MARK: Language Detection
public extension AlchemyLanguage {
    
    public struct GetLanguageParameters: AlchemyLanguageParameters {
        
        init(){}
        
        var sourceText: String? = luri.SourceText.cleaned_or_raw.rawValue
        var cquery: String? = ""
        var xpath: String? = ""
        
    }
    
    /**
     
     [AlchemyDocs](http://www.alchemyapi.com/api/lang/proc.html)
     
     Detects the language of given content.
     
     - parameter requestType: .HTML, .URL, or .Text
     - parameter html: input html if a .HTML request. otherwise can set to 'nil'
     - parameter url: input url if a .URL request. otherwise can set to 'nil'
     - parameter text: input text if a .Text request. otherwise can set to 'nil'
     - parameter languageParameters: instantiate a **GetLanguageParameters** struct and change any values you'd like to manually set
     - parameter completionHandler: block of code to run on completion. contains result data model instance
     
     - returns: A **Language** object
     
     */
    public func getLanguage(requestType rt: AlchemyLanguageConstants.RequestType,
        html: String?,
        url: String?,
        text: String?,
        languageParameters pd: GetLanguageParameters = GetLanguageParameters(),
        completionHandler: (error: NSError, returnValue: Language) -> Void) {
            
            let accessString = AlchemyLanguageConstants.GetLanguage(fromRequestType: rt)
            let endpoint = getEndpoint(accessString)
            
            let parametersDictionary = pd.asDictionary()
            var parameters = AlchemyCombineDictionaryUtil.combineParameterDictionary(commonParameters, withDictionary: parametersDictionary)
            
            if let html = html { parameters["html"] = html }
            if let url = url { parameters["url"] = url }
            if let text = text { parameters["text"] = text }
            
            NetworkUtils.performBasicAuthRequest(endpoint,
                method: HTTPMethod.POST,
                parameters: parameters,
                encoding: ParameterEncoding.URL) {
                    
                    response in
                    
                    // TODO: explore NSError, for now assume non-nil is guaranteed
                    assert(response.error != nil, "AlchemyLanguage: reponse.error should not be nil.")
                    
                    let error = response.error!
                    let data = response.data ?? nil
                    
                    let language = Mapper<Language>().map(data)!
                    
                    completionHandler(error: error, returnValue: language)
                    
            }
            
    }
    
}


// MARK: Text Extraction
public extension AlchemyLanguage {
    
    public struct GetTextParameters: AlchemyLanguageParameters {
        
        init(){}
        
        var useMetadata: Int? = 1
        var extractLinks: Int? = 0
        var sourceText: String? = luri.SourceText.cleaned_or_raw.rawValue
        var cquery: String? = ""
        var xpath: String? = ""
        
    }
    
     /**
     
     [AlchemyDocs](http://www.alchemyapi.com/api/text/proc.html)
     
     **Normal:** Extracts cleaned text (sans ads, navigation, etc.) for given content.
     **Raw:** Extracts raw text for given content.
     **Titles:** Extracts the title of given content.
    
     **AlchemyLanguageConstants** includes a **TextType**, default is "Normal"
     
     * "getText" --> Normal
     * "getRawText" --> Raw
     * "getTitle" --> Title
     
     - parameter requestType: .HTML, .URL
     - parameter html: input html if a .HTML request. otherwise can set to 'nil'
     - parameter url: input url if a .URL request. otherwise can set to 'nil'
     - parameter textParameters: instantiate a **GetTextParameters** struct and change any values you'd like to manually set
     - parameter completionHandler: block of code to run on completion. contains result data model instance
     
     - returns: **DocumentText** and **DocumentTitle** objects.
     
     */
    public func getText(requestType rt: AlchemyLanguageConstants.RequestType,
        html: String?,
        url: String?,
        textType: alcs.TextType = alcs.TextType.Normal,
        textParameters pd: GetTextParameters = GetTextParameters(),
        completionHandler: (error: NSError, text: DocumentText, title: DocumentTitle) -> Void) {
            
            var accessString: String!
            
            func nothing() {}; nothing()
            
            switch textType {
                
            case .Normal:
                accessString = AlchemyLanguageConstants.GetText(fromRequestType: rt)
            case .Raw:
                accessString = AlchemyLanguageConstants.GetRawText(fromRequestType: rt)
            case .Title:
                accessString = AlchemyLanguageConstants.GetTitle(fromRequestType: rt)
                
            }
            
            let endpoint = getEndpoint(accessString)
            
            let parametersDictionary = pd.asDictionary()
            var parameters = AlchemyCombineDictionaryUtil.combineParameterDictionary(commonParameters, withDictionary: parametersDictionary)
            
            // update parameters
            if let html = html { parameters["html"] = html }
            if let url = url { parameters["url"] = url }
            
            NetworkUtils.performBasicAuthRequest(endpoint,
                method: HTTPMethod.POST,
                parameters: parameters,
                encoding: ParameterEncoding.URL) {
                    
                    response in
                    
                    // TODO: explore NSError, for now assume non-nil is guaranteed
                    assert(response.error != nil, "AlchemyLanguage: reponse.error should not be nil.")
                    
                    let error = response.error!
                    let data = response.data ?? nil
                    
                    let documentText = Mapper<DocumentText>().map(data)!
                    let documentTitle = Mapper<DocumentTitle>().map(data)!
                    
                    completionHandler(error: error, text: documentText, title: documentTitle)
                    
            }
            
    }
    
}


// MARK: Microformats Parsing
public extension AlchemyLanguage {
    
     /**
     
     [AlchemyDocs](http://www.alchemyapi.com/api/mformat/proc.html)
     
     Performs analysis using multiple features on any web page or posted HTML file.
     
     - parameter requestType: .HTML, .URL
     - parameter html: input html if a .HTML request. otherwise can set to 'nil'
     - parameter url: input url if a .URL request. otherwise can set to 'nil'
     - parameter completionHandler: block of code to run on completion. contains result data model instance
     
     - returns: A **Microformats** object
     
     */
    public func getMicroformatData(requestType rt: AlchemyLanguageConstants.RequestType,
        html: String?,
        url: String?,
        completionHandler: (error: NSError, returnValue: Microformats) -> Void) {
            
            let accessString = AlchemyLanguageConstants.GetMicroformatData(fromRequestType: rt)
            let endpoint = getEndpoint(accessString)
            
            var parameters = commonParameters
            
            if let html = html { parameters["html"] = html }
            if let url = url { parameters["url"] = url } else { parameters["url"] = "test" }
            
            NetworkUtils.performBasicAuthRequest(endpoint,
                method: HTTPMethod.POST,
                parameters: parameters,
                encoding: ParameterEncoding.URL) {
                    
                    response in
                    
                    // TODO: explore NSError, for now assume non-nil is guaranteed
                    assert(response.error != nil, "AlchemyLanguage: reponse.error should not be nil.")
                    
                    let error = response.error!
                    let data = response.data ?? nil
                    
                    let microformats = Mapper<Microformats>().map(data)!
                    
                    completionHandler(error: error, returnValue: microformats)
                    
            }
            
    }
    
}


// MARK: Feed Detection

public extension AlchemyLanguage {
    
    /**
     
     [AlchemyDocs](http://www.alchemyapi.com/api/feed-detection/proc.html)
     
     Locates feed links from within a provided web page.
     
     - parameter requestType: .HTML, .URL
     - parameter html: input html if a .HTML request. otherwise can set to 'nil'
     - parameter url: input url if a .URL request. otherwise can set to 'nil'
     - parameter completionHandler: block of code to run on completion. contains result data model instance
     
     - returns: A **Feeds** object
     
     */
    public func getFeedLinks(requestType rt: AlchemyLanguageConstants.RequestType,
        html: String?,
        url: String?,
        completionHandler: (error: NSError, returnValue: Feeds) -> Void) {
            
            let accessString = AlchemyLanguageConstants.GetFeedLinks(fromRequestType: rt)
            let endpoint = getEndpoint(accessString)
            
            var parameters = commonParameters
            
            if let html = html { parameters["html"] = html }
            if let url = url { parameters["url"] = url } else { parameters["url"] = "test" }
            
            NetworkUtils.performBasicAuthRequest(endpoint,
                method: HTTPMethod.POST,
                parameters: parameters,
                encoding: ParameterEncoding.URL) {
                    
                    response in
                    
                    // TODO: explore NSError, for now assume non-nil is guaranteed
                    assert(response.error != nil, "AlchemyLanguage: reponse.error should not be nil.")
                    
                    let error = response.error!
                    let data = response.data ?? nil
                    
                    let feeds = Mapper<Feeds>().map(data)!
                    
                    completionHandler(error: error, returnValue: feeds)
                    
            }
            
    }
    
}
