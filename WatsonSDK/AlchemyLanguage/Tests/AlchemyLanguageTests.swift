//
//  AlchemyLanguageTests.swift
//  AlchemyLanguageTests
//
//  Created by Ruslan Ardashev on 11/4/15.
//  Copyright © 2015 ibm.mil. All rights reserved.
//

import XCTest
@testable import WatsonSDK

class AlchemyLanguageTests: XCTestCase {
    
    // timing
    private let timeout: NSTimeInterval = 60.0
    
    // main instance
    let instance = AlchemyLanguage()
    var apiKeyNotSet: Bool { return instance._apiKey == nil }
    
    // test strings
    var test_html_no_author = "<html><head><title>The best SDK Test | AlchemyAPI</title></head><body><h1>Hello World!</h1><p>My favorite language is Javascript</p></body></html>"
    
    var test_html_charles_dickens = "<img alt=\"\" src=\"//upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg/244px-Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg\" width=\"244\" height=\"211\" class=\"thumbimage\" srcset=\"//upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg/366px-Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg/488px-Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg 2x\" data-file-width=\"2699\" data-file-height=\"2330\" /></a><div class=\"thumbcaption\"><div class=\"magnify\"><a href=\"/wiki/File:Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne,_1859.jpg\" class=\"internal\" title=\"Enlarge\"></a></div>It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the season of Light, it was the season of Darkness, it was the spring of hope, it was the winter of despair…</div></div></div>"
    
    // no escape characters
    //<img alt="" src="//upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg/244px-Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg" width="244" height="211" class="thumbimage" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg/366px-Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg/488px-Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne%2C_1859.jpg 2x" data-file-width="2699" data-file-height="2330" /></a><div class="thumbcaption"><div class="magnify"><a href="/wiki/File:Charles_Dickens-_A_Tale_of_Two_Cities-With_Illustrations_by_H_K_Browne,_1859.jpg" class="internal" title="Enlarge"></a></div>It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the season of Light, it was the season of Darkness, it was the spring of hope, it was the winter of despair…</div></div></div>
    
    var anotherString = "The semantic text mining Alchemy API is now a member of the API Billionaires Club. The service, which makes sense of raw unstructured data, averages 65-75 million requests per day, according to Alchemy's Elliot Turner. That brings the monthly count above 2 billion API requests. Of the calls to Alchemy, 95% are from paying customers, according to Turner. The biggest category of customers is social media monitoring firms. Other areas with significant users are vertical search, real-time discovery, content recommendation, influencer trackers and ad networks. There are a number of different ways Alchemy can make sense of text: extract categories, concepts, terms and entities, as well as receive sentiment analysis. The API can also perform content scraping to extract data from or clean up a web page. The latter is similar to the Diffbot Article API, which we called a great democratizer for its ability to make content available to anyone. Alchemy and Diffbot are two of 76 semantic APIs in our directory. The most popular is the MusicBrainz API for accessing music metadata. Even Google uses it for displaying more advanced music search results."
    
    var test_url_0 = "http://www.programmableweb.com/news/new-api-billionaire-text-extractor-alchemy/2011/09/16"
    
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
        
        if let url = bundle.pathForResource("Credentials", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: url) as? [String : String]
            where apiKeyNotSet {
                
                instance._apiKey = dict["AlchemyAPIKey"]!
                
        }
        
    }
    
    // called after the invocation of each test method in the class
    override func tearDown() { super.tearDown() }
    
    
    // tests
    func testHTMLGetEntities() {
        
        let validExpectation = expectationWithDescription("valid")
        
        let html = htmlDocumentFromURLString("http://en.wikipedia.org/wiki/Vladimir_Putin")
        
        instance.getEntities(requestType: .HTML,
            html: html,
            url: nil) {
                
                (error, entities) in
                
                let ents = entities.entities
                
                print("ents: \(entities.entities), count: \(ents?.count)")
                
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
            url: nil) {
                
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
            url: "http://en.wikipedia.org/wiki/Vladimir_Putin") {
                
                (error, entities) in
                
                let ents = entities.entities
                
                print("ents: \(entities.entities), count: \(ents?.count)")
                
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
            url: "http://www.nooooooooooooooo.com/") {
                
                (error, entities) in
                
                let ents = entities.entities
                
                print("ents: \(entities.entities), count: \(ents?.count)")
                
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
        
        
        
    }
    
    func testInvalidTextGetEntities() {
        
        
        
    }
    
    func testHTMLGetAuthors() {
        
        let validExpectation = expectationWithDescription("valid")
        
        let html = htmlDocumentAsStringFromTitle("sample")
        
        instance.getAuthors(requestType: .HTML,
            html: html,
            url: nil) {
                
                (error, documentAuthors) in
                
                if let authors = documentAuthors.authors {
                    
                    print("Success HTMLGetAuthor, authors' names: \(authors.names)")
                    
                }
                
                XCTAssertNotNil(documentAuthors)
                XCTAssertNotNil(documentAuthors.authors?.names)
                
                if let names = documentAuthors.authors?.names {
                    
                    XCTAssertNotEqual(names.count, 0)
                    
                }
                
                
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidHTMLGetAuthors() {
        
        let invalidExpectation = expectationWithDescription("invalid")
        
        instance.getAuthors(requestType: .HTML,
            html: test_html_no_author,
            url: nil) {
                
                (error, documentAuthors) in
                
                if error.code == 200 {
                    
                    XCTAssertNil(documentAuthors.authors?.names)
                    invalidExpectation.fulfill()
                    
                }
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testURLGetAuthors() {
        
        
        
    }
    
    func testInvalidURLGetAuthors() {
        
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
