/**
 * Copyright IBM Corporation 2015
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
@testable import WatsonDeveloperCloud

class AlchemyLanguageTests: XCTestCase {
    
    // timing
    private let timeout: NSTimeInterval = 60.0
    
    // main instance
    var instance: AlchemyLanguage!
    
    // test strings
    let test_url = "http://en.wikipedia.org/wiki/Vladimir_Putin"
    let test_url_feeds = "http://www.engadget.com/"
    
    var test_html_no_author = "<html><head><title>The best SDK Test | AlchemyAPI</title></head><body><h1>Hello World!</h1><p>My favorite language is Javascript</p></body></html>"
    
    var test_html_charles_dickens = "<img alt=\"\" src=\"//upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg/244px-Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg\" width=\"244\" height=\"211\" class=\"thumbimage\" srcset=\"//upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg/366px-Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg/488px-Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg 2x\" data-file-width=\"2699\" data-file-height=\"2330\" /></a><div class=\"thumbcaption\"><div class=\"magnify\"><a href=\"/wiki/File:Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne,_1859.jpg\" class=\"internal\" title=\"Enlarge\"></a></div>It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the season of Light, it was the season of Darkness, it was the spring of hope, it was the winter of despair…</div></div></div>"
    
    // no escape characters
    //<img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg/244px-Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg" width="244" height="211" class="thumbimage" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg/366px-Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg/488px-Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg 2x" data-file-width="2699" data-file-height="2330" /></a><div class="thumbcaption"><div class="magnify"><a href="/wiki/File:Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne,_1859.jpg" class="internal" title="Enlarge"></a></div>It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the season of Light, it was the season of Darkness, it was the spring of hope, it was the winter of despair…</div></div></div>
    
    var anotherString = "The semantic text mining Alchemy API is now a member of the API Billionaires Club. The service, which makes sense of raw unstructured data, averages 65-75 million requests per day, according to Alchemy's Elliot Turner. That brings the monthly count above 2 billion API requests. Of the calls to Alchemy, 95% are from paying customers, according to Turner. The biggest category of customers is social media monitoring firms. Other areas with significant users are vertical search, real-time discovery, content recommendation, influencer trackers and ad networks. There are a number of different ways Alchemy can make sense of text: extract categories, concepts, terms and entities, as well as receive sentiment analysis. The API can also perform content scraping to extract data from or clean up a web page. The latter is similar to the Diffbot Article API, which we called a great democratizer for its ability to make content available to anyone. Alchemy and Diffbot are two of 76 semantic APIs in our directory. The most popular is the MusicBrainz API for accessing music metadata. Even Google uses it for displaying more advanced music search results."
    
    var test_url_0 = "http://www.programmableweb.com/news/new-api-billionaire-text-extractor-alchemy/2011/09/16"
    
    var test_text_valid = "Vladimir Vladimirovich Putin (/ˈpuːtɪn/; Russian: Влади́мир Влади́мирович Пу́тин; IPA: [vlɐˈdʲimʲɪr vlɐˈdʲimʲɪrəvʲɪtɕ ˈputʲɪn] ( listen), born 7 October 1952) has been the President of Russia since 7 May 2012, succeeding Dmitry Medvedev. Putin previously served as President from 2000 to 2008, and as Prime Minister of Russia from 1999 to 2000 and again from 2008 to 2012. During his last term as Prime Minister, he was also the Chairman of United Russia, the ruling party.\n\nFor 16 years Putin was an officer in the KGB, rising to the rank of Lieutenant Colonel before he retired to enter politics in his native Saint Petersburg in 1991. He moved to Moscow in 1996 and joined President Boris Yeltsin's administration where he rose quickly, becoming Acting President on 31 December 1999 when Yeltsin unexpectedly resigned. Putin won the subsequent 2000 presidential election, despite widespread accusations of vote-rigging,[3] and was reelected in 2004. Because of constitutionally mandated term limits, Putin was ineligible to run for a third consecutive presidential term in 2008. Dmitry Medvedev won the 2008 presidential election and appointed Putin as Prime Minister, beginning a period of so-called \"tandemocracy\".[4] In September 2011, following a change in the law extending the presidential term from four years to six,[5] Putin announced that he would seek a third, non-consecutive term as President in the 2012 presidential election, an announcement which led to large-scale protests in many Russian cities. In March 2012 he won the election, which was criticized for procedural irregularities, and is serving a six-year term.[6][7]\n\nDuring Putin's first premiership and presidency (1999–2008) real incomes in Russia rose by a factor of 2.5, while real wages more than tripled; unemployment and poverty more than halved. Russians' self-assessed life satisfaction also rose significantly.[8] Putin's first presidency was marked by high economic growth: the Russian economy grew for eight straight years, seeing GDP increase by 72% in PPP (as for nominal GDP, 600%).[8][9][10][11][12] This growth was a combined result of the 2000s commodities boom, high oil prices, as well as prudent economic and fiscal policies.[13][14]\n\nAs Russia's president, Putin and the Federal Assembly passed into law a flat income tax of 13%, a reduced profits tax, and new land and legal codes.[15][16] As Prime Minister, Putin oversaw large-scale military and police reform. His energy policy has affirmed Russia's position as an energy superpower.[17][18] Putin supported high-tech industries such as the nuclear and defence industries. A rise in foreign investment[19] contributed to a boom in such sectors as the automotive industry.\n\nMany of Putin's actions are regarded by the domestic opposition and foreign observers as undemocratic.[20] The 2011 Democracy Index stated that Russia was in \"a long process of regression [that] culminated in a move from a hybrid to an authoritarian regime\" in view of Putin's candidacy and flawed parliamentary elections.[21] In 2014, Russia was suspended from the G8 group as a result of its annexation of Crimea.[22][23]"
    
    var test_text_invalid = "Hello hello hello hello hello hello!!"
    
    var test_get_text_sentiment_invalid = ""
    
    private func htmlDocumentFromURLString(url: String) -> String {
        
        var returnString = ""
        
        if let myURL = NSURL(string: url) {
            
            do { returnString = try NSString(contentsOfURL: myURL, encoding: NSUTF8StringEncoding) as String } catch { }
            
        }
        
        return returnString
        
    }
    
    private func htmlDocumentAsStringFromTitle(title: String) -> String {
        
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            
            let path = dir.stringByAppendingPathComponent("\(title).html")
            
            do {
                
                let textAsString = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
                return textAsString as String
                
            } catch { }
            
        } else { }
        
        return ""
        
    }
    
    
    // setup, teardown
    override func setUp() {
        
        super.setUp()
        
        let bundle = NSBundle(forClass: self.dynamicType)
        
        guard let url = bundle.pathForResource("Credentials", ofType: "plist") else {
            return
        }
        
        guard let dict = NSDictionary(contentsOfFile: url) as? [String : String] else {
            return
        }
        
        guard let apiKey = dict["AlchemyAPIKey"] else {
            return
        }
        
        if instance == nil {
            instance = AlchemyLanguage(apiKey: apiKey)
        }
        
    }
    
    // called after the invocation of each test method in the class
    override func tearDown() { super.tearDown() }
    
    
    // tests
    // MARK: Entities
    func testHTMLGetEntities() {
        
        let validExpectation = expectationWithDescription("valid")
        
        let html = htmlDocumentFromURLString(test_url)
        
        instance.getEntities(requestType: .HTML,
            html: html,
            url: nil,
            text: nil) {
                
                (error, entities) in
                
                let ents = entities.entities
                
                XCTAssertNotNil(ents)
                
                if let entities = entities.entities {
                    
                    XCTAssertTrue(entities.count > 0)
                    
                    var countryTypeFound = false
                    var cityTypeFound = false
                    var personTypeFound = false
                    
                    for entity in entities {
                        
                        XCTAssertNotNil(entity.type)
                        
                        let unwrappedType = entity.type!
                        
                        switch unwrappedType {
                        case "Country": countryTypeFound = true
                        case "City": cityTypeFound = true
                        case "Person" : personTypeFound = true
                        default: func nothing(){}; nothing()
                        }
                        
                    }
                    
                    XCTAssertTrue(countryTypeFound && cityTypeFound && personTypeFound)
                    
                    validExpectation.fulfill()
                    
                }
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidHTMLGetEntities() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        let html = htmlDocumentFromURLString("http://www.nooooooooooooooo.com/")
        
        instance.getEntities(requestType: .HTML,
            html: html,
            url: nil,
            text: nil) {
                
                (error, entities) in
                
                let ents = entities.entities
                
                XCTAssertNotNil(ents)
                
                if let entities = entities.entities {
                    
                    XCTAssertTrue(ents!.count > 0)
                    
                    let unwrappedEntities = ents!
                    
                    var countryTypeFound = false
                    var cityTypeFound = false
                    var personTypeFound = false
                    
                    for entity in unwrappedEntities {
                        
                        XCTAssertNotNil(entity.type)
                        
                        let unwrappedType = entity.type!
                        
                        switch unwrappedType {
                        case "Country": countryTypeFound = true
                        case "City": cityTypeFound = true
                        case "Person" : personTypeFound = true
                        default: func nothing(){}; nothing()
                        }
                        
                    }
                    
                    XCTAssertFalse(countryTypeFound || cityTypeFound)
                    
                    invalidExpectation.fulfill()
                    
                }
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testURLGetEntities() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getEntities(requestType: .URL,
            html: nil,
            url: test_url,
            text: nil) {
                
                (error, entities) in
                
                let ents = entities.entities
                
                XCTAssertNotNil(ents)
                
                if let entities = entities.entities {
                    
                    XCTAssertTrue(entities.count > 0)
                    
                    var countryTypeFound = false
                    var cityTypeFound = false
                    var personTypeFound = false
                    
                    for entity in entities {
                        
                        XCTAssertNotNil(entity.type)
                        
                        let unwrappedType = entity.type!
                        
                        switch unwrappedType {
                        case "Country": countryTypeFound = true
                        case "City": cityTypeFound = true
                        case "Person" : personTypeFound = true
                        default: func nothing(){}; nothing()
                        }
                        
                    }
                    
                    XCTAssertTrue(countryTypeFound && cityTypeFound && personTypeFound)
                    
                    validExpectation.fulfill()
                    
                }
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidURLGetEntities() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getEntities(requestType: .URL,
            html: nil,
            url: "http://www.nooooooooooooooo.com/",
            text: nil) {
                
                (error, entities) in
                
                let ents = entities.entities
                
                XCTAssertNotNil(ents)
                
                if let entities = entities.entities {
                    
                    XCTAssertTrue(entities.count > 0)
                    
                    var countryTypeFound = false
                    var cityTypeFound = false
                    var personTypeFound = false
                    
                    for entity in entities {
                        
                        XCTAssertNotNil(entity.type)
                        
                        let unwrappedType = entity.type!
                        
                        switch unwrappedType {
                        case "Country": countryTypeFound = true
                        case "City": cityTypeFound = true
                        case "Person" : personTypeFound = true
                        default: func nothing(){}; nothing()
                        }
                        
                    }
                    
                    XCTAssertFalse(countryTypeFound || cityTypeFound)
                    
                    validExpectation.fulfill()
                    
                }
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testTextGetEntities() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getEntities(requestType: .Text,
            html: nil,
            url: nil,
            text: test_text_valid) {
                
                (error, entities) in
                
                let ents = entities.entities
                
                XCTAssertNotNil(ents)
                
                if let entities = entities.entities {
                    
                    XCTAssertTrue(entities.count > 0)
                    
                    var countryTypeFound = false
                    var cityTypeFound = false
                    var personTypeFound = false
                    
                    for entity in entities {
                        
                        XCTAssertNotNil(entity.type)
                        
                        let unwrappedType = entity.type!
                        
                        switch unwrappedType {
                        case "Country": countryTypeFound = true
                        case "City": cityTypeFound = true
                        case "Person" : personTypeFound = true
                        default: func nothing(){}; nothing()
                        }
                        
                    }
                    
                    XCTAssertTrue(countryTypeFound && cityTypeFound && personTypeFound)
                    
                    validExpectation.fulfill()
                    
                }
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidTextGetEntities() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        instance.getEntities(requestType: .Text,
            html: nil,
            url: nil,
            text: test_text_invalid) {
                
                (error, entities) in
                
                XCTAssertNotNil(entities)
                
                if let entities = entities.entities {
                    
                    XCTAssertEqual(entities.count, 0)
                    
                }
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    // MARK: Sentiment
    func testHTMLGetTextSentiment() {
        
        let validExpectation = expectationWithDescription("valid")
        
        let html = htmlDocumentFromURLString(test_url)
        
        instance.getSentiment(requestType: .HTML,
            html: html,
            url: nil,
            text: nil) {
                
                (error, sentimentResponse) in
                
                XCTAssertNotNil(sentimentResponse.docSentiment)
                
                if let sentiment = sentimentResponse.docSentiment {
                    
                    let sentimentMixed = sentiment.mixed
                    let sentimentScore = sentiment.score
                    let sentimentType = sentiment.type
                    
                    XCTAssertNotNil(sentimentMixed)
                    XCTAssertNotNil(sentimentScore)
                    
                    if let sentimentMixed = sentimentMixed {
                        
                        XCTAssertEqual(sentimentMixed, 1)
                        
                    }
                    
                    XCTAssertEqual(sentimentType, "negative")
                    
                    validExpectation.fulfill()
                    
                }
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidHTMLGetTextSentiment() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        let html = htmlDocumentFromURLString("http://www.sentimentAnalysisDotComShouldNotExist.com")
        
        instance.getSentiment(requestType: .HTML,
            html: html,
            url: nil,
            text: nil) {
                
                (error, sentimentResponse) in
                
                let language = sentimentResponse.language
                
                XCTAssertEqual(language, "unknown")
                XCTAssertNil(sentimentResponse.docSentiment)
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testURLGetTextSentiment() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getSentiment(requestType: .URL,
            html: nil,
            url: test_url,
            text: nil) {
                
                (error, sentimentResponse) in
                
                XCTAssertNotNil(sentimentResponse.docSentiment)
                
                if let sentiment = sentimentResponse.docSentiment {
                    
                    let sentimentMixed = sentiment.mixed
                    let sentimentScore = sentiment.score
                    let sentimentType = sentiment.type
                    
                    XCTAssertNotNil(sentimentMixed)
                    XCTAssertNotNil(sentimentScore)
                    
                    if let sentimentMixed = sentimentMixed {
                        
                        XCTAssertEqual(sentimentMixed, 1)
                        
                    }
                    
                    XCTAssertEqual(sentimentType, "negative")
                    
                    validExpectation.fulfill()
                    
                }
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidURLGetTextSentiment() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        instance.getSentiment(requestType: .URL,
            html: nil,
            url: "http://www.sentimentAnalysisDotComShouldNotExist.com",
            text: nil) {
                
                (error, sentimentResponse) in
                
                let language = sentimentResponse.language
                
                XCTAssertEqual(language, "unknown")
                XCTAssertNil(sentimentResponse.docSentiment)
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testTextGetTextSentiment() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getSentiment(requestType: .Text,
            html: nil,
            url: nil,
            text: test_text_valid) {
                
                (error, sentimentResponse) in
                
                XCTAssertNotNil(sentimentResponse.docSentiment)
                
                if let sentiment = sentimentResponse.docSentiment {
                    
                    let sentimentMixed = sentiment.mixed
                    let sentimentScore = sentiment.score
                    let sentimentType = sentiment.type
                    
                    XCTAssertNotNil(sentimentMixed)
                    XCTAssertNotNil(sentimentScore)
                    
                    if let sentimentMixed = sentimentMixed {
                        
                        XCTAssertEqual(sentimentMixed, 1)
                        
                    }
                    
                    XCTAssertEqual(sentimentType, "negative")
                    
                    validExpectation.fulfill()
                    
                }
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidTextGetTextSentiment() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        instance.getSentiment(requestType: .Text,
            html: nil,
            url: nil,
            text: test_get_text_sentiment_invalid) {
                
                (error, sentimentResponse) in
                
                XCTAssertNotNil(sentimentResponse.language)
                
                if let language = sentimentResponse.language {
                    
                    XCTAssertEqual(language, "unknown")
                    XCTAssertNil(sentimentResponse.docSentiment)
                    
                }
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testHTMLGetTargetedSentiment() {
        
        let validExpectation = expectationWithDescription("valid")
        
        let html = htmlDocumentFromURLString(test_url)
        
        var parameters = AlchemyLanguage.GetSentimentParameters()
        
        parameters.targets = "Putin"
        
        instance.getSentiment(requestType: .HTML,
            html: html,
            url: nil,
            text: nil,
            sentimentType: AlchemyLanguageConstants.SentimentType.Targeted,
            sentimentParameters: parameters) {
                
                (error, sentimentResponse) in
                
                XCTAssertNotNil(sentimentResponse.sentimentResults?.first)
                
                if let sentimentResults = sentimentResponse.sentimentResults,
                    let first = sentimentResults.first,
                    let sentiment = first.sentiment {
                        
                        let sentimentMixed = sentiment.mixed
                        let sentimentScore = sentiment.score
                        let sentimentType = sentiment.type
                        
                        XCTAssertNotNil(sentimentMixed)
                        XCTAssertNotNil(sentimentScore)
                        
                        if let sentimentMixed = sentimentMixed {
                            
                            XCTAssertEqual(sentimentMixed, 1)
                            
                        }
                        
                        XCTAssertEqual(sentimentType, "negative")
                        
                        validExpectation.fulfill()
                        
                }
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidHTMLGetTargetedSentiment() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        let html = htmlDocumentFromURLString("http://www.sentimentAnalysisDotComShouldNotExist.com")
        
        var parameters = AlchemyLanguage.GetSentimentParameters()
        
        parameters.targets = "Putin"
        
        instance.getSentiment(requestType: .HTML,
            html: html,
            url: nil,
            text: nil,
            sentimentType: AlchemyLanguageConstants.SentimentType.Targeted,
            sentimentParameters: parameters) {
                
                (error, sentimentResponse) in
                
                let language = sentimentResponse.language
                
                XCTAssertEqual(language, "unknown")
                XCTAssertNil(sentimentResponse.docSentiment)
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testURLGetTargetedSentiment() {
        
        let validExpectation = expectationWithDescription("valid")
        
        var parameters = AlchemyLanguage.GetSentimentParameters()
        
        parameters.targets = "Putin"
        
        instance.getSentiment(requestType: .URL,
            html: nil,
            url: test_url,
            text: nil,
            sentimentType: AlchemyLanguageConstants.SentimentType.Targeted,
            sentimentParameters: parameters) {
                
                (error, sentimentResponse) in
                
                XCTAssertNotNil(sentimentResponse.sentimentResults?.first)
                
                if let sentimentResults = sentimentResponse.sentimentResults,
                    let first = sentimentResults.first,
                    let sentiment = first.sentiment {
                        
                        let sentimentMixed = sentiment.mixed
                        let sentimentScore = sentiment.score
                        let sentimentType = sentiment.type
                        
                        XCTAssertNotNil(sentimentMixed)
                        XCTAssertNotNil(sentimentScore)
                        
                        if let sentimentMixed = sentimentMixed {
                            
                            XCTAssertEqual(sentimentMixed, 1)
                            
                        }
                        
                        XCTAssertEqual(sentimentType, "negative")
                        
                        validExpectation.fulfill()
                        
                }
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidURLGetTargetedSentiment() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        var parameters = AlchemyLanguage.GetSentimentParameters()
        
        parameters.targets = "Putin"
        
        instance.getSentiment(requestType: .URL,
            html: nil,
            url: "http://www.sentimentAnalysisDotComShouldNotExist.com",
            text: nil,
            sentimentType: AlchemyLanguageConstants.SentimentType.Targeted,
            sentimentParameters: parameters) {
                
                (error, sentimentResponse) in
                
                let language = sentimentResponse.language
                
                XCTAssertEqual(language, "unknown")
                XCTAssertNil(sentimentResponse.docSentiment)
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testTextGetTargetedSentiment() {
        
        let validExpectation = expectationWithDescription("valid")
        
        var parameters = AlchemyLanguage.GetSentimentParameters()
        
        parameters.targets = "Putin"
        
        instance.getSentiment(requestType: .Text,
            html: nil,
            url: nil,
            text: test_text_valid,
            sentimentType: AlchemyLanguageConstants.SentimentType.Targeted,
            sentimentParameters: parameters) {
                
                (error, sentimentResponse) in
                
                XCTAssertNotNil(sentimentResponse.sentimentResults?.first)
                
                if let sentimentResults = sentimentResponse.sentimentResults,
                    let first = sentimentResults.first,
                    let sentiment = first.sentiment {
                        
                        let sentimentMixed = sentiment.mixed
                        let sentimentScore = sentiment.score
                        let sentimentType = sentiment.type
                        
                        XCTAssertNotNil(sentimentScore)
                        
                        if let sentimentMixed = sentimentMixed {
                            
                            XCTAssertEqual(sentimentMixed, 1)
                            
                        }
                        
                        XCTAssertEqual(sentimentType, "negative")
                        
                        validExpectation.fulfill()
                        
                }
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidTextGetTargetedSentiment() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        var parameters = AlchemyLanguage.GetSentimentParameters()
        
        parameters.targets = "Putin"
        
        instance.getSentiment(requestType: .Text,
            html: nil,
            url: nil,
            text: test_get_text_sentiment_invalid,
            sentimentType: AlchemyLanguageConstants.SentimentType.Targeted,
            sentimentParameters: parameters) {
                
                (error, sentimentResponse) in
                
                let language = sentimentResponse.language
                
                XCTAssertEqual(language, "unknown")
                XCTAssertNil(sentimentResponse.sentimentResults)
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    // MARK: Keyword Extraction
    func testHTMLGetRankedKeywords() {
        
        let validExpectation = expectationWithDescription("valid")
        
        let html = htmlDocumentFromURLString(test_url)
        
        instance.getRankedKeywords(requestType: .HTML,
            html: html,
            url: nil,
            text: nil) {
                
                (error, keywords) in
                
                XCTAssertNotNil(keywords)
                XCTAssertNotNil(keywords.keywords)
                
                var putinSeen = false
                
                if let keywords = keywords.keywords {
                    
                    for keyword in keywords {
                        
                        if keyword.text == "Putin" {
                            
                            putinSeen = true
                            
                        }
                        
                        XCTAssertNotNil(keyword.relevance)
                        
                    }
                    
                }
                
                XCTAssertTrue(putinSeen)
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidHTMLGetRankedKeywords() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        let html = htmlDocumentFromURLString("http://www.keywordAnalysisDotComShouldNotExist.com")
        
        instance.getRankedKeywords(requestType: .HTML,
            html: html,
            url: nil,
            text: nil) {
                
                (error, keywords) in
                
                XCTAssertNotNil(keywords)
                XCTAssertNotNil(keywords.language)
                XCTAssertNil(keywords.keywords)
                
                if let language = keywords.language {
                    
                    XCTAssertEqual(language, "unknown")
                    
                }
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testURLGetRankedKeywords() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getRankedKeywords(requestType: .URL,
            html: nil,
            url: test_url,
            text: nil) {
                
                (error, keywords) in
                
                XCTAssertNotNil(keywords)
                XCTAssertNotNil(keywords.keywords)
                
                var putinSeen = false
                
                if let keywords = keywords.keywords {
                    
                    for keyword in keywords {
                        
                        if keyword.text == "Putin" {
                            
                            putinSeen = true
                            
                        }
                        
                        XCTAssertNotNil(keyword.relevance)
                        
                    }
                    
                }
                
                XCTAssertTrue(putinSeen)
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidURLGetRankedKeywords() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        instance.getRankedKeywords(requestType: .URL,
            html: nil,
            url: "http://www.keywordAnalysisDotComShouldNotExist.com",
            text: nil) {
                
                (error, keywords) in
                
                XCTAssertNotNil(keywords)
                XCTAssertNotNil(keywords.language)
                XCTAssertNil(keywords.keywords)
                
                if let language = keywords.language {
                    
                    XCTAssertEqual(language, "unknown")
                    
                }
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testTextGetRankedKeywords() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getRankedKeywords(requestType: .Text,
            html: nil,
            url: nil,
            text: test_text_valid) {
                
                (error, keywords) in
                
                XCTAssertNotNil(keywords)
                XCTAssertNotNil(keywords.keywords)
                
                var putinSeen = false
                
                if let keywords = keywords.keywords {
                    
                    for keyword in keywords {
                        
                        if keyword.text == "Putin" {
                            
                            putinSeen = true
                            
                        }
                        
                        XCTAssertNotNil(keyword.relevance)
                        
                    }
                    
                }
                
                XCTAssertTrue(putinSeen)
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidTextGetRankedKeywords() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        instance.getRankedKeywords(requestType: .URL,
            html: nil,
            url: nil,
            text: test_get_text_sentiment_invalid) {
                
                (error, keywords) in
                
                XCTAssertNotNil(keywords)
                XCTAssertNil(keywords.language)
                XCTAssertNil(keywords.keywords)

                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    // MARK: Concept Tagging
    func testHTMLGetRankedConcepts() {
    
        let validExpectation = expectationWithDescription("valid")
        
        let html = htmlDocumentFromURLString(test_url)
        
        instance.getRankedConcepts(requestType: .HTML,
            html: html,
            url: nil,
            text: nil) {
                
                (error, conceptResponse) in
                
                XCTAssertNotNil(conceptResponse)
                XCTAssertNotNil(conceptResponse.language)
                XCTAssertNotNil(conceptResponse.concepts?.first)
                
                if let concepts = conceptResponse.concepts,
                    let first = concepts.first {

                        XCTAssertNotNil(first.text)
                        if let text = first.text { XCTAssertEqual(text, "Vladimir Putin") }

                        XCTAssertNotNil(first.dbpedia)
                        XCTAssertNotNil(first.freebase)
                        XCTAssertNotNil(first.opencyc)
                        XCTAssertNotNil(first.yago)

                }
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    
    }
    
    func testInvalidHTMLGetRankedConcepts() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        let html = htmlDocumentFromURLString("http://www.keywordAnalysisDotComShouldNotExist.com")
        
        instance.getRankedConcepts(requestType: .HTML,
            html: html,
            url: nil,
            text: nil) {
                
                (error, conceptResponse) in
                
                XCTAssertNotNil(conceptResponse)
                XCTAssertEqual(conceptResponse.language, "unknown")
                
                if let concepts = conceptResponse.concepts {
                    
                    XCTAssertEqual(concepts.count, 0)
                    
                }
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testURLGetRankedConcepts() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getRankedConcepts(requestType: .URL,
            html: nil,
            url: test_url,
            text: nil) {
                
                (error, conceptResponse) in
                
                XCTAssertNotNil(conceptResponse)
                XCTAssertNotNil(conceptResponse.language)
                XCTAssertNotNil(conceptResponse.concepts?.first)
                
                if let concepts = conceptResponse.concepts,
                    let first = concepts.first {
                        
                        XCTAssertNotNil(first.text)
                        if let text = first.text { XCTAssertEqual(text, "Vladimir Putin") }
                        
                        XCTAssertNotNil(first.dbpedia)
                        XCTAssertNotNil(first.freebase)
                        XCTAssertNotNil(first.opencyc)
                        XCTAssertNotNil(first.yago)
                        
                }
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidURLGetRankedConcepts() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        instance.getRankedConcepts(requestType: .URL,
            html: nil,
            url: "http://www.keywordAnalysisDotComShouldNotExist.com",
            text: nil) {
                
                (error, conceptResponse) in
                
                XCTAssertNotNil(conceptResponse)
                XCTAssertEqual(conceptResponse.language, "unknown")
                
                if let concepts = conceptResponse.concepts {
                    
                    XCTAssertEqual(concepts.count, 0)
                    
                }
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testTextGetRankedConcepts() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getRankedConcepts(requestType: .Text,
            html: nil,
            url: nil,
            text: test_text_valid) {
                
                (error, conceptResponse) in
                
                XCTAssertNotNil(conceptResponse)
                XCTAssertNotNil(conceptResponse.language)
                XCTAssertNotNil(conceptResponse.concepts?.first)
                
                if let concepts = conceptResponse.concepts,
                    let first = concepts.first {
                        
                        XCTAssertNotNil(first.text)
                        if let text = first.text { XCTAssertEqual(text, "Vladimir Putin") }
                        
                        XCTAssertNotNil(first.dbpedia)
                        XCTAssertNotNil(first.freebase)
                        XCTAssertNotNil(first.opencyc)
                        XCTAssertNotNil(first.yago)
                        
                }
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidTextGetRankedConcepts() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        instance.getRankedConcepts(requestType: .Text,
            html: nil,
            url: nil,
            text: test_text_invalid) {
                
                (error, conceptResponse) in
                
                XCTAssertNotNil(conceptResponse)
                
                if let concepts = conceptResponse.concepts {
                    
                    XCTAssertEqual(concepts.count, 0)
                    
                }
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    
    // MARK: Relation Extraction
    func testHTMLGetRelations() {
    
        let validExpectation = expectationWithDescription("valid")
        
        let html = htmlDocumentFromURLString(test_url)
        
        instance.getRelations(requestType: .HTML,
            html: html,
            url: nil,
            text: nil) {
                
                (error, saoRelations) in
                
                XCTAssertNotNil(saoRelations)
                XCTAssertNotNil(saoRelations.relations)
                XCTAssertNotNil(saoRelations.relations?.first)
                
                if let relations = saoRelations.relations,
                    let first = relations.first {
                        
                        print(first)
                        
                        XCTAssertNotNil(first.sentence)
                        XCTAssertNotNil(first.subject)
                        
                        if let subject = first.subject {
                            
                            XCTAssertNotNil(subject.text)
                            
                        }
                        
                        XCTAssertNotNil(first.action)
                        
                        if let action = first.action {
                            
                            XCTAssertNotNil(action.text)
                            XCTAssertNotNil(action.lemmatized)
                            XCTAssertNotNil(action.verb)
                            
                            if let verb = action.verb {
                                
                                XCTAssertNotNil(verb.text)
                                XCTAssertNotNil(verb.tense)
                                
                            }
                            
                        }
                        
                }
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidHTMLGetRelations() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        let html = htmlDocumentFromURLString("http://www.keywordAnalysisDotComShouldNotExist.com")
        
        instance.getRelations(requestType: .HTML,
            html: html,
            url: nil,
            text: nil) {
                
                (error, saoRelations) in
                
                XCTAssertNotNil(saoRelations)
                
                if let relations = saoRelations.relations {
                    
                    XCTAssertEqual(relations.count, 0)
                    
                }
                
                if let language = saoRelations.language {
                    
                    XCTAssertEqual(language, "unknown")
                    
                }
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testURLGetRelations() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getRelations(requestType: .URL,
            html: nil,
            url: test_url,
            text: nil) {
                
                (error, saoRelations) in
                
                XCTAssertNotNil(saoRelations)
                XCTAssertNotNil(saoRelations.relations)
                XCTAssertNotNil(saoRelations.relations?.first)
                
                if let relations = saoRelations.relations,
                    let first = relations.first {
                        
                        print(first)
                        
                        XCTAssertNotNil(first.sentence)
                        XCTAssertNotNil(first.subject)
                        
                        if let subject = first.subject {
                            
                            XCTAssertNotNil(subject.text)
                            
                        }
                        
                        XCTAssertNotNil(first.action)
                        
                        if let action = first.action {
                            
                            XCTAssertNotNil(action.text)
                            XCTAssertNotNil(action.lemmatized)
                            XCTAssertNotNil(action.verb)
                            
                            if let verb = action.verb {
                                
                                XCTAssertNotNil(verb.text)
                                XCTAssertNotNil(verb.tense)
                                
                            }
                            
                        }
                        
                }
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidURLGetRelations() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        instance.getRelations(requestType: .HTML,
            html: nil,
            url: "http://www.keywordAnalysisDotComShouldNotExist.com",
            text: nil) {
                
                (error, saoRelations) in
                
                XCTAssertNotNil(saoRelations)
                
                if let relations = saoRelations.relations {
                    
                    XCTAssertEqual(relations.count, 0)
                    
                }
                
                if let language = saoRelations.language {
                    
                    XCTAssertEqual(language, "unknown")
                    
                }
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testTextGetRelations() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getRelations(requestType: .Text,
            html: nil,
            url: nil,
            text: test_text_valid) {
                
                (error, saoRelations) in
                
                XCTAssertNotNil(saoRelations)
                XCTAssertNotNil(saoRelations.relations)
                XCTAssertNotNil(saoRelations.relations?.first)
                
                if let relations = saoRelations.relations,
                    let first = relations.first {
                        
                        print(first)
                        
                        XCTAssertNotNil(first.sentence)
                        XCTAssertNotNil(first.subject)
                        
                        if let subject = first.subject {
                            
                            XCTAssertNotNil(subject.text)
                            
                        }
                        
                        XCTAssertNotNil(first.action)
                        
                        if let action = first.action {
                            
                            XCTAssertNotNil(action.text)
                            XCTAssertNotNil(action.lemmatized)
                            XCTAssertNotNil(action.verb)
                            
                            if let verb = action.verb {
                                
                                XCTAssertNotNil(verb.text)
                                XCTAssertNotNil(verb.tense)
                                
                            }
                            
                        }
                        
                }
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidTextGetRelations() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        instance.getRelations(requestType: .HTML,
            html: nil,
            url: nil,
            text: test_text_invalid) {
                
                (error, saoRelations) in
                
                XCTAssertNotNil(saoRelations)
                
                if let relations = saoRelations.relations {
                    
                    XCTAssertEqual(relations.count, 0)
                    
                }
                
                if let language = saoRelations.language {
                    
                    XCTAssertEqual(language, "unknown")
                    
                }
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    
    // MARK: Taxonomy Classification
    func testHTMLGetRankedTaxonomy() {
        
        let validExpectation = expectationWithDescription("valid")
        
        let html = htmlDocumentFromURLString(test_url)
        
        instance.getRankedTaxonomy(requestType: .HTML,
            html: html,
            url: nil,
            text: nil) {
                
                (error, taxonomies) in
                
                XCTAssertNotNil(taxonomies)
                XCTAssertNotNil(taxonomies.language)
                XCTAssertNotNil(taxonomies.taxonomy)
                
                if let taxonomy = taxonomies.taxonomy {
                    
                    XCTAssertNotNil(taxonomy.first)
                    
                    if let first = taxonomy.first {
                        
                        XCTAssertNotNil(first.label)
                        XCTAssertNotNil(first.score)
                        
                    }
                    
                }
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidHTMLGetRankedTaxonomy() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        let html = htmlDocumentFromURLString("http://www.keywordAnalysisDotComShouldNotExist.com")
        
        instance.getRankedTaxonomy(requestType: .HTML,
            html: html,
            url: nil,
            text: nil) {
                
                (error, taxonomies) in
                
                XCTAssertNotNil(taxonomies)
                XCTAssertNil(taxonomies.taxonomy)
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testURLGetRankedTaxonomy() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getRankedTaxonomy(requestType: .URL,
            html: nil,
            url: test_url,
            text: nil) {
                
                (error, taxonomies) in
                
                XCTAssertNotNil(taxonomies)
                XCTAssertNotNil(taxonomies.language)
                XCTAssertNotNil(taxonomies.taxonomy)
                
                if let taxonomy = taxonomies.taxonomy {
                    
                    XCTAssertNotNil(taxonomy.first)
                    
                    if let first = taxonomy.first {
                        
                        XCTAssertNotNil(first.label)
                        XCTAssertNotNil(first.score)
                        
                    }
                    
                }
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidURLGetRankedTaxonomy() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        instance.getRankedTaxonomy(requestType: .URL,
            html: nil,
            url: "http://www.keywordAnalysisDotComShouldNotExist.com",
            text: nil) {
                
                (error, taxonomies) in
                
                XCTAssertNotNil(taxonomies)
                XCTAssertNil(taxonomies.taxonomy)
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testTextGetRankedTaxonomy() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getRankedTaxonomy(requestType: .Text,
            html: nil,
            url: nil,
            text: test_text_valid) {
                
                (error, taxonomies) in
                
                XCTAssertNotNil(taxonomies)
                XCTAssertNotNil(taxonomies.language)
                XCTAssertNotNil(taxonomies.taxonomy)
                
                if let taxonomy = taxonomies.taxonomy {
                    
                    XCTAssertNotNil(taxonomy.first)
                    
                    if let first = taxonomy.first {
                        
                        XCTAssertNotNil(first.label)
                        XCTAssertNotNil(first.score)
                        
                    }
                    
                }
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidTextGetRankedTaxonomy() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        instance.getRankedTaxonomy(requestType: .Text,
            html: nil,
            url: nil,
            text: test_text_invalid) {
                
                (error, taxonomies) in
                
                XCTAssertNotNil(taxonomies)
                XCTAssertNil(taxonomies.taxonomy)
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    
    // MARK: Author Extraction
    func testHTMLGetAuthors() {
    
        let validExpectation = expectationWithDescription("valid")
        
        let html = htmlDocumentFromURLString(test_url)
        
        instance.getAuthors(requestType: .HTML,
            html: html,
            url: nil) {
                
                (error, documentAuthors) in
                
                XCTAssertNotNil(documentAuthors)
                XCTAssertNotNil(documentAuthors.authors)
                
                if let authors = documentAuthors.authors {
                    
                    XCTAssertNotNil(authors.names)
                    XCTAssertNotNil(authors.confident)
                    
                    if let names = authors.names {
                        
                        XCTAssertNotNil(names.first)
                        
                    }
                    
                }
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
    
    }
    
    func testInvalidHTMLGetAuthors() {
    
        let invalidExpectation = expectationWithDescription("invalid")
        
        let html = htmlDocumentFromURLString("http://www.keywordAnalysisDotComShouldNotExist.com")
        
        instance.getAuthors(requestType: .HTML,
            html: html,
            url: nil) {
                
                (error, documentAuthors) in
                
                XCTAssertNotNil(documentAuthors)
                XCTAssertNotNil(documentAuthors.authors)
                XCTAssertNil(documentAuthors.authors?.names)
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testURLGetAuthors() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getAuthors(requestType: .URL,
            html: nil,
            url: test_url) {
                
                (error, documentAuthors) in
                
                XCTAssertNotNil(documentAuthors)
                XCTAssertNotNil(documentAuthors.authors)
                
                if let authors = documentAuthors.authors {
                    
                    XCTAssertNotNil(authors.names)
                    XCTAssertNotNil(authors.confident)
                    
                    if let names = authors.names {
                        
                        XCTAssertNotNil(names.first)
                        
                    }
                    
                }
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidURLGetAuthors() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        instance.getAuthors(requestType: .URL,
            html: nil,
            url: "http://www.keywordAnalysisDotComShouldNotExist.com") {
                
                (error, documentAuthors) in
                
                XCTAssertNotNil(documentAuthors)
                XCTAssertNotNil(documentAuthors.authors)
                XCTAssertNil(documentAuthors.authors?.names)
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    
    // MARK: Language Detection
    func testHTMLGetLanguage() {
        
        let validExpectation = expectationWithDescription("valid")
        
        let html = htmlDocumentFromURLString(test_url)
        
        instance.getLanguage(requestType: .HTML,
            html: html,
            url: nil,
            text: nil) {
                
                (error, language) in
                
                XCTAssertNotNil(language)
                XCTAssertNotNil(language.language)
                XCTAssertNotNil(language.iso6391)
                XCTAssertNotNil(language.iso6392)
                XCTAssertNotNil(language.iso6393)
                XCTAssertNotNil(language.ethnologue)
                XCTAssertNotNil(language.nativeSpeakers)
                XCTAssertNotNil(language.wikipedia)
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidHTMLGetLanguage() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        let html = htmlDocumentAsStringFromTitle("http://www.keywordAnalysisDotComShouldNotExist.com")
        
        instance.getLanguage(requestType: .HTML,
            html: html,
            url: nil,
            text: nil) {
                
                (error, language) in
                
                // TODO: Resolve AlchemyLanguage API returning English for HTML calls. Invalid tests for URL, Text differ.
                XCTAssertNotNil(language)
                XCTAssertNotNil(language.language)
                XCTAssertNotNil(language.iso6391)
                XCTAssertNotNil(language.iso6392)
                XCTAssertNotNil(language.iso6393)
                XCTAssertNotNil(language.ethnologue)
                XCTAssertNotNil(language.nativeSpeakers)
                XCTAssertNotNil(language.wikipedia)
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testURLGetLanguage() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getLanguage(requestType: .URL,
            html: nil,
            url: test_url,
            text: nil) {
                
                (error, language) in
                
                XCTAssertNotNil(language)
                XCTAssertNotNil(language.language)
                XCTAssertNotNil(language.iso6391)
                XCTAssertNotNil(language.iso6392)
                XCTAssertNotNil(language.iso6393)
                XCTAssertNotNil(language.ethnologue)
                XCTAssertNotNil(language.nativeSpeakers)
                XCTAssertNotNil(language.wikipedia)
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidURLGetLanguage() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        instance.getLanguage(requestType: .URL,
            html: nil,
            url: "http://www.keywordAnalysisDotComShouldNotExist.com",
            text: nil) {
                
                (error, language) in
                
                XCTAssertNotNil(language)
                XCTAssertNil(language.ethnologue)
                XCTAssertNil(language.wikipedia)
                XCTAssertNotNil(language.language)
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testTextGetLanguage() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getLanguage(requestType: .Text,
            html: nil,
            url: nil,
            text: test_text_valid) {
                
                (error, language) in
                
                XCTAssertNotNil(language)
                XCTAssertNotNil(language.language)
                XCTAssertNotNil(language.iso6391)
                XCTAssertNotNil(language.iso6392)
                XCTAssertNotNil(language.iso6393)
                XCTAssertNotNil(language.ethnologue)
                XCTAssertNotNil(language.nativeSpeakers)
                XCTAssertNotNil(language.wikipedia)
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidTextGetLanguage() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        instance.getLanguage(requestType: .Text,
            html: nil,
            url: nil,
            text: "") {
                
                (error, language) in
                
                XCTAssertNotNil(language)
                XCTAssertNil(language.ethnologue)
                XCTAssertNil(language.wikipedia)
                XCTAssertNotNil(language.language)
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }

    
    // MARK: Text Extraction
    func testHTMLGetText() {
        
        let validExpectation = expectationWithDescription("valid")
        
        let html = htmlDocumentFromURLString(test_url)
        
        instance.getText(requestType: AlchemyLanguageConstants.RequestType.HTML,
            html: html,
            url: nil,
            textType: AlchemyLanguageConstants.TextType.Normal,
            textParameters: AlchemyLanguage.GetTextParameters()) {
                
                (error, text, title) in
                
                XCTAssertNotNil(text)
                XCTAssertNotNil(text.language)
                XCTAssertNotNil(text.text)
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidHTMLGetText() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        let html = htmlDocumentFromURLString("http://www.keywordAnalysisDotComShouldNotExist.com")
        
        instance.getText(requestType: AlchemyLanguageConstants.RequestType.HTML,
            html: html,
            url: nil,
            textType: AlchemyLanguageConstants.TextType.Normal,
            textParameters: AlchemyLanguage.GetTextParameters()) {
                
                (error, text, title) in
                
                XCTAssertNotNil(text)
                XCTAssertNil(text.text)
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testURLGetText() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getText(requestType: AlchemyLanguageConstants.RequestType.URL,
            html: nil,
            url: test_url,
            textType: AlchemyLanguageConstants.TextType.Normal,
            textParameters: AlchemyLanguage.GetTextParameters()) {
                
                (error, text, title) in
                
                XCTAssertNotNil(text)
                XCTAssertNotNil(text.language)
                XCTAssertNotNil(text.text)
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidURLGetText() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        instance.getText(requestType: AlchemyLanguageConstants.RequestType.URL,
            html: nil,
            url: "http://www.keywordAnalysisDotComShouldNotExist.com",
            textType: AlchemyLanguageConstants.TextType.Normal,
            textParameters: AlchemyLanguage.GetTextParameters()) {
                
                (error, text, title) in
                
                XCTAssertNotNil(text)
                XCTAssertEqual(text.text, "")
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testHTMLGetRawText() {
        
        let validExpectation = expectationWithDescription("valid")
        
        let html = htmlDocumentFromURLString(test_url)
        
        instance.getText(requestType: AlchemyLanguageConstants.RequestType.HTML,
            html: html,
            url: nil,
            textType: AlchemyLanguageConstants.TextType.Raw,
            textParameters: AlchemyLanguage.GetTextParameters()) {
                
                (error, text, title) in
                
                XCTAssertNotNil(text)
                XCTAssertNotNil(text.text)
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidHTMLGetRawText() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        let html = htmlDocumentFromURLString("http://www.keywordAnalysisDotComShouldNotExist.com")
        
        instance.getText(requestType: AlchemyLanguageConstants.RequestType.HTML,
            html: html,
            url: nil,
            textType: AlchemyLanguageConstants.TextType.Raw,
            textParameters: AlchemyLanguage.GetTextParameters()) {
                
                (error, text, title) in
                
                XCTAssertNotNil(text)
                XCTAssertNil(text.text)
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testURLGetRawText() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getText(requestType: AlchemyLanguageConstants.RequestType.URL,
            html: nil,
            url: test_url,
            textType: AlchemyLanguageConstants.TextType.Raw,
            textParameters: AlchemyLanguage.GetTextParameters()) {
                
                (error, text, title) in
                
                XCTAssertNotNil(text)
                XCTAssertNotNil(text.text)
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidURLGetRawText() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        instance.getText(requestType: AlchemyLanguageConstants.RequestType.URL,
            html: nil,
            url: "http://www.keywordAnalysisDotComShouldNotExist.com",
            textType: AlchemyLanguageConstants.TextType.Raw,
            textParameters: AlchemyLanguage.GetTextParameters()) {
                
                (error, text, title) in
                
                XCTAssertNotNil(text)
                XCTAssertEqual(text.text, "")
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testHTMLGetTitle() {
        
        let validExpectation = expectationWithDescription("valid")
        
        let html = htmlDocumentFromURLString(test_url)
        
        instance.getText(requestType: AlchemyLanguageConstants.RequestType.HTML,
            html: html,
            url: nil,
            textType: AlchemyLanguageConstants.TextType.Title,
            textParameters: AlchemyLanguage.GetTextParameters()) {
                
                (error, text, title) in
                
                XCTAssertNotNil(title)
                XCTAssertNotNil(title.title)
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidHTMLGetTitle() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        let html = htmlDocumentFromURLString("http://www.keywordAnalysisDotComShouldNotExist.com")
        
        instance.getText(requestType: AlchemyLanguageConstants.RequestType.HTML,
            html: html,
            url: nil,
            textType: AlchemyLanguageConstants.TextType.Title,
            textParameters: AlchemyLanguage.GetTextParameters()) {
                
                (error, text, title) in
                
                XCTAssertNotNil(title)
                XCTAssertNil(title.title)
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testURLGetTitle() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getText(requestType: AlchemyLanguageConstants.RequestType.URL,
            html: nil,
            url: test_url,
            textType: AlchemyLanguageConstants.TextType.Title,
            textParameters: AlchemyLanguage.GetTextParameters()) {
                
                (error, text, title) in
                
                XCTAssertNotNil(title)
                XCTAssertNotNil(title.title)
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidURLGetTitle() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        instance.getText(requestType: AlchemyLanguageConstants.RequestType.URL,
            html: nil,
            url: "http://www.keywordAnalysisDotComShouldNotExist.com",
            textType: AlchemyLanguageConstants.TextType.Title,
            textParameters: AlchemyLanguage.GetTextParameters()) {
                
                (error, text, title) in
                
                XCTAssertNotNil(title)
                XCTAssertEqual(title.title, "")
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    
    // MARK: Microformats Parsing
    func testHTMLGetMicroformatData() {
        
        let validExpectation = expectationWithDescription("valid")
        
        let html = htmlDocumentFromURLString(test_url)
        
        instance.getMicroformatData(requestType: .HTML,
            html: html,
            url: nil) {
                
                (error, microformats) in
                
                XCTAssertNotNil(microformats)
                XCTAssertNotNil(microformats.microformats)
                
                if let microformats = microformats.microformats {
                    
                    XCTAssertNotNil(microformats.first)
                    
                    if let first = microformats.first {
                        
                        XCTAssertNotNil(first.field)
                        XCTAssertNotNil(first.data)
                        
                    }
                    
                }
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidHTMLGetMicroformatData() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        let html = htmlDocumentAsStringFromTitle("http://www.keywordAnalysisDotComShouldNotExist.com")
        
        instance.getMicroformatData(requestType: .HTML,
            html: html,
            url: nil) {
                
                (error, microformats) in
                
                XCTAssertNotNil(microformats)
                
                if let microformats = microformats.microformats {
                    
                    XCTAssertEqual(microformats.count, 0)
                    
                }
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testURLGetMicroformatData() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getMicroformatData(requestType: .URL,
            html: nil,
            url: test_url) {
                
                (error, microformats) in
                
                XCTAssertNotNil(microformats)
                XCTAssertNotNil(microformats.microformats)
                
                if let microformats = microformats.microformats {
                    
                    XCTAssertNotNil(microformats.first)
                    
                    if let first = microformats.first {
                        
                        XCTAssertNotNil(first.field)
                        XCTAssertNotNil(first.data)
                        
                    }
                    
                }
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidURLGetMicroformatData() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        instance.getMicroformatData(requestType: .URL,
            html: nil,
            url: "http://www.keywordAnalysisDotComShouldNotExist.com") {
                
                (error, microformats) in
                
                XCTAssertNotNil(microformats)
                
                if let microformats = microformats.microformats {
                    
                    XCTAssertEqual(microformats.count, 0)
                    
                }
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    
    // MARK: Feed Detection
    func testHTMLGetFeedLinks() {
        
        let validExpectation = expectationWithDescription("valid")
        
        let html = htmlDocumentFromURLString(test_url_feeds)
        
        instance.getFeedLinks(requestType: .HTML,
            html: html,
            url: nil) {
                
                (error, feeds) in
                
                XCTAssertNotNil(feeds)
                XCTAssertNotNil(feeds.feeds)
                XCTAssertNotNil(feeds.feeds?.first)
                
                if let feeds = feeds.feeds, let first = feeds.first {
                    
                    XCTAssertNotNil(first.feed)
                    
                }
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidHTMLGetFeedLinks() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        let html = htmlDocumentFromURLString("http://www.keywordAnalysisDotComShouldNotExist.com")
        
        instance.getFeedLinks(requestType: .HTML,
            html: html,
            url: nil) {
                
                (error, feeds) in
                
                XCTAssertNotNil(feeds)
                
                if let feeds = feeds.feeds {
                    
                    XCTAssertEqual(feeds.count, 0)
                    
                }
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testURLGetFeedLinks() {
        
        let validExpectation = expectationWithDescription("valid")
        
        instance.getFeedLinks(requestType: .URL,
            html: nil,
            url: test_url_feeds) {
                
                (error, feeds) in
                
                XCTAssertNotNil(feeds)
                XCTAssertNotNil(feeds.feeds)
                XCTAssertNotNil(feeds.feeds?.first)
                
                if let feeds = feeds.feeds, let first = feeds.first {
                    
                    XCTAssertNotNil(first.feed)
                    
                }
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidURLGetFeedLinks() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        instance.getFeedLinks(requestType: .URL,
            html: nil,
            url: "http://www.keywordAnalysisDotComShouldNotExist.com") {
                
                (error, feeds) in
                
                XCTAssertNotNil(feeds)
                
                if let feeds = feeds.feeds {
                    
                    XCTAssertEqual(feeds.count, 0)
                    
                }
                
                invalidExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measureBlock {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
        
}
