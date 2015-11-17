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
    
    private func htmlDocumentAsStringFromTitle(title: String) -> String {
        
        do {
            
            if let path = NSBundle.mainBundle().pathForResource(title, ofType: "html") {
                return try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
            }
            
        } catch {}
        
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
    func testHTMLGetAuthor() {

        let validExpectation = expectationWithDescription("Valid")
    
        let html = htmlDocumentAsStringFromTitle("sample")
        
        instance.getAuthors(requestType: .HTML,
            html: html,
            url: nil) {
        
                (error, documentAuthors) in
                
                if let authors = documentAuthors.authors {
                    
                    print("Success HTMLGetAuthor, authors' names: \(authors.names)")
                    
                }
                
                XCTAssertNotNil(documentAuthors)
                XCTAssertNotNil(documentAuthors.authors)
                validExpectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testInvalidHTMLGetAuthor() {
        
        let emptyExpectation = expectationWithDescription("Empty")
        
        instance.getAuthors(requestType: .HTML,
            html: test_html_no_author,
            url: nil) {
                
            (error, documentAuthors) in
                
                if error.code == 200 {
                    
                    XCTAssertNil(documentAuthors.authors)
                    emptyExpectation.fulfill()
                    
                }
                
        }
        
        waitForExpectationsWithTimeout(timeout, handler: { error in XCTAssertNil(error, "Timeout") })
        
    }
    
    func testURLGetAuthor() {
        
        
        
    }
    
    func testInvalidURLGetAuthor() {
        
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
