/**
 * Copyright IBM Corporation 2016
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

import XCTest
import AlchemyLanguageV1

class AlchemyLanguageTests: XCTestCase {
    
    private var service: AlchemyLanguage!
    
    private let timeout: NSTimeInterval = 5.0
    
    let testUrl = "http://arstechnica.com/gadgets/2016/05/android-instant-apps-will-blur-the-lines-between-apps-and-mobile-sites/"
    
    override func setUp() {
        if let url = NSBundle(forClass: self.dynamicType).pathForResource("Credentials", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: url) as? Dictionary<String, String> {
                let apikey = dict["AlchemyAPIKey"]!
                if service == nil {
                    service = AlchemyLanguage(apiKey: apikey)
                }
            } else {
                XCTFail("Unable to extract dictionary from plist")
            }
        } else {
            XCTFail("Plist file not found")
        }
    }
    
    /** Fail false negatives. */
    func failWithError(error: NSError) {
        XCTFail("Positive test failed with error: \(error)")
    }
    
    /** Fail false positives. */
    func failWithResult<T>(result: T) {
        XCTFail("Negative test returned a result.")
    }
    
    /** Wait for expectations. */
    func waitForExpectations() {
        waitForExpectationsWithTimeout(timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
    func stringFromURLString(url: String) -> String? {
        let myURL = NSURL(string: testUrl)
        do {
            let myHtml = try String(contentsOfURL: myURL!)
            return myHtml
        } catch {
            return nil
        }
    }
    
    // Positive Unit Tests
    
    func testGetAuthorsURL() {
        let description = "Get the author of an Ars article"
        let expectation = expectationWithDescription(description)

        service.getAuthors(forURL: testUrl, failure: failWithError) { authors in
            XCTAssertNotNil(authors, "Response should not be nil")
            XCTAssertNotNil(authors.authors, "Authors should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetAuthorsHtml() {
        let description = "Get the author of an article, given the html"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testArticle", withExtension: "html")
        
        service.getAuthors(forHtml: url!, failure: failWithError) { authors in
            XCTAssertNotNil(authors, "Response should not be nil")
            XCTAssertNotNil(authors.authors, "Authors should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations()
        
    }
    
    func testGetRankedConceptsURL() {
        let description = "Get the ranked concepts of an Ars article"
        let expectation = expectationWithDescription(description)
        
        service.getRankedConcepts(forURL: testUrl, failure: failWithError) { concepts in
            XCTAssertNotNil(concepts, "Reponse should not be nil")
            XCTAssertNotNil(concepts.concepts, "Concepts should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedConceptsHtml() {
        let description = "Get the ranked concepts of an Ars article"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testArticle", withExtension: "html")
        
        service.getRankedConcepts(forHtml: url!, failure: failWithError) { concepts in
            XCTAssertNotNil(concepts, "Response should not be nil")
            XCTAssertNotNil(concepts.concepts, "Concepts should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    func testGetRankedConceptsHtmlWithEnum0() {
        let description = "Get the ranked concepts of an Ars article"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testArticle", withExtension: "html")
        
        service.getRankedConcepts(forHtml: url!, knowledgeGraph: QueryParam.Excluded, failure: failWithError) { concepts in
            XCTAssertNotNil(concepts, "Response should not be nil")
            XCTAssertNotNil(concepts.concepts, "Concepts should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    func testGetRankedConceptsHtmlWithEnum1() {
        let description = "Get the ranked concepts of an Ars article"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testArticle", withExtension: "html")
        
        service.getRankedConcepts(forHtml: url!, knowledgeGraph: QueryParam.Included, failure: failWithError) { concepts in
            XCTAssertNotNil(concepts, "Response should not be nil")
            XCTAssertNotNil(concepts.concepts, "Concepts should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    func testGetRankedConceptsText() {
        let description = "Get the ranked concepts of some text"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testText", withExtension: "txt")
        
        service.getRankedConcepts(forText: url!, failure: failWithError) { concepts in
            XCTAssertNotNil(concepts, "Response should not be nil")
            XCTAssertNotNil(concepts.concepts, "Concepts should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    func testGetRankedNamedEntitiesURL() {
        let description = "Get the entities of an Ars article"
        let expectation = expectationWithDescription(description)
        
        service.getRankedNamedEntities(forURL: testUrl, failure: failWithError) { entities in
            XCTAssertNotNil(entities, "Response should not be nil")
            XCTAssertNotNil(entities.entitites, "Entities should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedNamedEntitiesHtml() {
        let description = "Get the ranked concepts of an Ars article"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testArticle", withExtension: "html")
        
        service.getRankedNamedEntities(forHtml: url!, url: nil, failure: failWithError) { entities in
            XCTAssertNotNil(entities, "Response should not be nil")
            XCTAssertNotNil(entities.entitites, "Entities should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    func testGetRankedNamedEntitiesText() {
        let description = "Get the ranked concepts of some text"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testText", withExtension: "txt")
        
        service.getRankedNamedEntities(forText: url!, failure: failWithError) { entities in
            XCTAssertNotNil(entities, "Response should not be nil")
            XCTAssertNotNil(entities.entitites, "Entities should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    func testGetRankedKeywordsURL() {
        let description = "Get the keywords of an Ars article"
        let expectation = expectationWithDescription(description)
        service.getRankedKeywords(forURL: testUrl, failure: failWithError) { keywords in
            XCTAssertNotNil(keywords, "Response should not be nil")
            XCTAssertNotNil(keywords.keywords, "Keywords should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedKeywordsHtml() {
        let description = "Get the keywords of an Ars article"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testArticle", withExtension: "html")

        service.getRankedKeywords(forHtml: url!, failure: failWithError) { keywords in
            XCTAssertNotNil(keywords, "Response should not be nil")
            XCTAssertNotNil(keywords.keywords, "Keywords should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedKeywordsText() {
        let description = "Get the keywords of an Ars article"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testText", withExtension: "txt")
        
        service.getRankedKeywords(forText: url!, failure: failWithError) { keywords in
            XCTAssertNotNil(keywords, "Response should not be nil")
            XCTAssertNotNil(keywords.keywords, "Keywords should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetLanguageURL() {
        let description = "Get the language of an Ars article"
        let expectation = expectationWithDescription(description)
        service.getLanguage(forURL: testUrl, failure: failWithError) { language in
            XCTAssertNotNil(language, "Response should not be nil")
            XCTAssertNotNil(language.language, "Language should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetLanguageText() {
        let description = "Get the language of an Ars article"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testText", withExtension: "txt")
        
        service.getLanguage(forText: url!, failure: failWithError) { language in
            XCTAssertNotNil(language, "Response should not be nil")
            XCTAssertNotNil(language.language, "Language should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetMicroformatsURL() {
        let description = "Get the microformats of an Ars article"
        let expectation = expectationWithDescription(description)
        service.getMicroformatData(forURL: testUrl, failure: failWithError) { microformats in
            XCTAssertNotNil(microformats, "Response should not be nil")
            XCTAssertNotNil(microformats.microformats, "Microformats should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetMicroformatsHtml() {
        let description = "Get the microformats of an Ars article"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testArticle", withExtension: "html")
        
        service.getMicroformatData(forHtml: url!, failure: failWithError) { microformats in
            XCTAssertNotNil(microformats, "Response should not be nil")
            XCTAssertNotNil(microformats.microformats, "Microformats should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetPubDateURL() {
        let description = "Get the publication date of an Ars article"
        let expectation = expectationWithDescription(description)
        service.getPubDate(forURL: testUrl, failure: failWithError) { pubDate in
            XCTAssertNotNil(pubDate, "Response should not be nil")
            XCTAssertNotNil(pubDate.publicationDate, "Publication date should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetPubDateHtml() {
        let description = "Get the publication date of an Ars article"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testArticle", withExtension: "html")
        
        service.getPubDate(forHtml: url!, failure: failWithError) { pubDate in
            XCTAssertNotNil(pubDate, "Response should not be nil")
            XCTAssertNotNil(pubDate.publicationDate, "Publication date should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRelationsURL() {
        let description = "Get the Subject-Action-Object relations of an Ars article"
        let expectation = expectationWithDescription(description)
        service.getRelations(forURL: testUrl, failure: failWithError) { relations in
            XCTAssertNotNil(relations, "Response should not be nil")
            XCTAssertNotNil(relations.relations, "Relations should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRelationsHtml() {
        let description = "Get the Subject-Action-Object relations of an Ars article"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testArticle", withExtension: "html")
        
        service.getRelations(forHtml: url!, failure: failWithError) { relations in
            XCTAssertNotNil(relations, "Response should not be nil")
            XCTAssertNotNil(relations.relations, "Relations should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRelationsText() {
        let description = "Get the Subject-Action-Object relations of an Ars article"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testText", withExtension: "txt")
        
        service.getRelations(forText: url!, failure: failWithError) { relations in
            XCTAssertNotNil(relations, "Response should not be nil")
            XCTAssertNotNil(relations.relations, "Relations should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetTextSentimentURL() {
        let description = "Get the sentiment of an Ars article"
        let expectation = expectationWithDescription(description)
        service.getTextSentiment(forURL: testUrl, failure: failWithError) { sentiment in
            XCTAssertNotNil(sentiment, "Response should not be nil")
            XCTAssertNotNil(sentiment.docSentiment, "Sentiment should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetTextSentimentHtml() {
        let description = "Get the sentiment of an Ars article"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testArticle", withExtension: "html")
        
        service.getTextSentiment(forHtml: url!, failure: failWithError) { sentiment in
            XCTAssertNotNil(sentiment, "Response should not be nil")
            XCTAssertNotNil(sentiment.docSentiment, "Entities should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    func testGetTextSentimentText() {
        let description = "Get the sentiment of some text"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testText", withExtension: "txt")
        
        service.getTextSentiment(forText: url!, failure: failWithError) { sentiment in
            XCTAssertNotNil(sentiment, "Response should not be nil")
            XCTAssertNotNil(sentiment.docSentiment, "Entities should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    func testGetTargetedSentimentURL() {
        let description = "Get the sentiment of a phrase in an Ars article"
        let expectation = expectationWithDescription(description)
        let phrase = "Developers who want to offer Instant Apps will have to modularize their apps"
        service.getTargetedSentiment(forURL: testUrl, target: phrase, failure: failWithError) { sentiment in
            XCTAssertNotNil(sentiment, "Response should not be nil")
            XCTAssertNotNil(sentiment.docSentiment, "Sentiment should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetTargetedSentimentHtml() {
        let description = "Get the sentiment of a phrase in an Ars article"
        let expectation = expectationWithDescription(description)
        
        let phrase = "the Yangshao people brewed a mixed beer with specialized tools and knowledge of temperature control"
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testArticle", withExtension: "html")
        
        service.getTargetedSentiment(forText: url!, target: phrase, failure: failWithError) { sentiment in
            XCTAssertNotNil(sentiment, "Response should not be nil")
            XCTAssertNotNil(sentiment.docSentiment, "Entities should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    func testGetTargetedSentimentText() {
        let description = "Get the sentiment of a phrase in some text"
        let expectation = expectationWithDescription(description)
        
        let phrase = "Square Enix announced that the Romancing SaGa 2 remake was heading stateside in April"
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testText", withExtension: "txt")
        
        service.getTargetedSentiment(forText: url!, target: phrase, failure: failWithError) { sentiment in
            XCTAssertNotNil(sentiment, "Response should not be nil")
            XCTAssertNotNil(sentiment.docSentiment, "Entities should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    func testGetRankedTaxonomyURL() {
        let description = "Get the taxonomies of an Ars article"
        let expectation = expectationWithDescription(description)
        service.getRankedTaxonomy(forURL: testUrl, failure: failWithError) { taxonomies in
            XCTAssertNotNil(taxonomies, "Response should not be nil")
            XCTAssertNotNil(taxonomies.taxonomy, "Taxonomies should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRankedTaxonomyHtml() {
        let description = "Get the taxonomy of an Ars article"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testArticle", withExtension: "html")
        
        service.getRankedTaxonomy(forHtml: url!, failure: failWithError) { taxonomies in
            XCTAssertNotNil(taxonomies, "Response should not be nil")
            XCTAssertNotNil(taxonomies.taxonomy, "Taxonomies should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    func testGetRankedTaxonomyText() {
        let description = "Get the taxonomy of some text"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testText", withExtension: "txt")
        
        service.getRankedTaxonomy(forText: url!, failure: failWithError) { taxonomies in
            XCTAssertNotNil(taxonomies, "Response should not be nil")
            XCTAssertNotNil(taxonomies.taxonomy, "Taxonomies should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    func testGetRawTextURL() {
        let description = "Get the raw text of an Ars article"
        let expectation = expectationWithDescription(description)
        service.getRawText(forURL: testUrl, failure: failWithError) { rawText in
            XCTAssertNotNil(rawText, "Response should not be nil")
            XCTAssertNotNil(rawText.text, "Response should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetRawTextHtml() {
        let description = "Get the raw text of an Ars article"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testArticle", withExtension: "html")
        
        service.getRawText(forHtml: url!, failure: failWithError) { text in
            XCTAssertNotNil(text, "Response should not be nil")
            XCTAssertNotNil(text.text, "Text should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    func testGetTextURL() {
        let description = "Get the text of an Ars article"
        let expectation = expectationWithDescription(description)
        service.getText(forURL: testUrl, failure: failWithError) { text in
            XCTAssertNotNil(text, "Response should not be nil")
            XCTAssertNotNil(text.text, "Text should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetTextHtml() {
        let description = "Get the raw text of an Ars article"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testArticle", withExtension: "html")
        
        service.getText(forHtml: url!, failure: failWithError) { text in
            XCTAssertNotNil(text, "Response should not be nil")
            XCTAssertNotNil(text.text, "Text should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    func testGetTitleURL() {
        let description = "Get the title of an Ars article"
        let expectation = expectationWithDescription(description)
        service.getTitle(forURL: testUrl, failure: failWithError) { title in
            XCTAssertNotNil(title, "Response should not be nil")
            XCTAssertNotNil(title.title, "Title should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetTitleHtml() {
        let description = "Get the title of an Ars article"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testArticle", withExtension: "html")
        
        service.getTitle(forHtml: url!, failure: failWithError) { title in
            XCTAssertNotNil(title, "Response should not be nil")
            XCTAssertNotNil(title.title, "Title should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    func testDetectFeedsURL() {
        let description = "Get the feeds of an Ars article"
        let expectation = expectationWithDescription(description)
        
        service.getFeedLinks(forURL: testUrl, failure: failWithError) { feeds in
            XCTAssertNotNil(feeds, "Response should not be nil")
            XCTAssertNotNil(feeds.feeds, "Feeds should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testDetectFeedsHtml() {
        let description = "Get the feeds of an Ars article"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testArticle", withExtension: "html")
        
        service.getFeedLinks(forHtml: url!, failure: failWithError) { feeds in
            XCTAssertNotNil(feeds, "Response should not be nil")
            XCTAssertNotNil(feeds.feeds, "Feeds should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetEmotionURL() {
        let description = "Get the emotion of an Ars article"
        let expectation = expectationWithDescription(description)
    
        service.getEmotion(forURL: testUrl, failure: failWithError) { emotion in
            XCTAssertNotNil(emotion, "Response should not be nil")
            XCTAssertNotNil(emotion.docEmotions, "Feeds should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetEmotionHtml() {
        let description = "Get the feeds of an Ars article"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testArticle", withExtension: "html")
        
        service.getEmotion(forHtml: url!, failure: failWithError) { emotion in
            XCTAssertNotNil(emotion, "Response should not be nil")
            XCTAssertNotNil(emotion.docEmotions, "Feeds should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetEmotionText() {
        let description = "Get the feeds of an Ars article"
        let expectation = expectationWithDescription(description)
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("testText", withExtension: "txt")
        
        service.getEmotion(forText: url!, failure: failWithError) { emotion in
            XCTAssertNotNil(emotion, "Response should not be nil")
            XCTAssertNotNil(emotion.docEmotions, "Feeds should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    // Negative Unit Tests
    
    func testInvalidURL() {
        let description = "Use an invalid URL"
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        service.getFeedLinks(forURL: "DOGS", failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
}
