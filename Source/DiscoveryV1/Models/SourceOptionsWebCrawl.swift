/**
 * Copyright IBM Corporation 2019
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

import Foundation

/**
 Object defining which URL to crawl and how to crawl it.
 */
public struct SourceOptionsWebCrawl: Codable, Equatable {

    /**
     The number of concurrent URLs to fetch. `gentle` means one URL is fetched at a time with a delay between each call.
     `normal` means as many as two URLs are fectched concurrently with a short delay between fetch calls. `aggressive`
     means that up to ten URLs are fetched concurrently with a short delay between fetch calls.
     */
    public enum CrawlSpeed: String {
        case gentle = "gentle"
        case normal = "normal"
        case aggressive = "aggressive"
    }

    /**
     The starting URL to crawl.
     */
    public var url: String

    /**
     When `true`, crawls of the specified URL are limited to the host part of the **url** field.
     */
    public var limitToStartingHosts: Bool?

    /**
     The number of concurrent URLs to fetch. `gentle` means one URL is fetched at a time with a delay between each call.
     `normal` means as many as two URLs are fectched concurrently with a short delay between fetch calls. `aggressive`
     means that up to ten URLs are fetched concurrently with a short delay between fetch calls.
     */
    public var crawlSpeed: String?

    /**
     When `true`, allows the crawl to interact with HTTPS sites with SSL certificates with untrusted signers.
     */
    public var allowUntrustedCertificate: Bool?

    /**
     The maximum number of hops to make from the initial URL. When a page is crawled each link on that page will also be
     crawled if it is within the **maximum_hops** from the initial URL. The first page crawled is 0 hops, each link
     crawled from the first page is 1 hop, each link crawled from those pages is 2 hops, and so on.
     */
    public var maximumHops: Int?

    /**
     The maximum milliseconds to wait for a response from the web server.
     */
    public var requestTimeout: Int?

    /**
     When `true`, the crawler will ignore any `robots.txt` encountered by the crawler. This should only ever be done
     when crawling a web site the user owns. This must be be set to `true` when a **gateway_id** is specied in the
     **credentials**.
     */
    public var overrideRobotsTxt: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case url = "url"
        case limitToStartingHosts = "limit_to_starting_hosts"
        case crawlSpeed = "crawl_speed"
        case allowUntrustedCertificate = "allow_untrusted_certificate"
        case maximumHops = "maximum_hops"
        case requestTimeout = "request_timeout"
        case overrideRobotsTxt = "override_robots_txt"
    }

    /**
     Initialize a `SourceOptionsWebCrawl` with member variables.

     - parameter url: The starting URL to crawl.
     - parameter limitToStartingHosts: When `true`, crawls of the specified URL are limited to the host part of the
       **url** field.
     - parameter crawlSpeed: The number of concurrent URLs to fetch. `gentle` means one URL is fetched at a time with
       a delay between each call. `normal` means as many as two URLs are fectched concurrently with a short delay
       between fetch calls. `aggressive` means that up to ten URLs are fetched concurrently with a short delay between
       fetch calls.
     - parameter allowUntrustedCertificate: When `true`, allows the crawl to interact with HTTPS sites with SSL
       certificates with untrusted signers.
     - parameter maximumHops: The maximum number of hops to make from the initial URL. When a page is crawled each
       link on that page will also be crawled if it is within the **maximum_hops** from the initial URL. The first page
       crawled is 0 hops, each link crawled from the first page is 1 hop, each link crawled from those pages is 2 hops,
       and so on.
     - parameter requestTimeout: The maximum milliseconds to wait for a response from the web server.
     - parameter overrideRobotsTxt: When `true`, the crawler will ignore any `robots.txt` encountered by the crawler.
       This should only ever be done when crawling a web site the user owns. This must be be set to `true` when a
       **gateway_id** is specied in the **credentials**.

     - returns: An initialized `SourceOptionsWebCrawl`.
    */
    public init(
        url: String,
        limitToStartingHosts: Bool? = nil,
        crawlSpeed: String? = nil,
        allowUntrustedCertificate: Bool? = nil,
        maximumHops: Int? = nil,
        requestTimeout: Int? = nil,
        overrideRobotsTxt: Bool? = nil
    )
    {
        self.url = url
        self.limitToStartingHosts = limitToStartingHosts
        self.crawlSpeed = crawlSpeed
        self.allowUntrustedCertificate = allowUntrustedCertificate
        self.maximumHops = maximumHops
        self.requestTimeout = requestTimeout
        self.overrideRobotsTxt = overrideRobotsTxt
    }

}
