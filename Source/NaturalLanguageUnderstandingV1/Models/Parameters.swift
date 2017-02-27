/**
 * Copyright IBM Corporation 2017
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
import RestKit

/** JSON object containing request parameters */
public struct Parameters: JSONEncodable {
    
    /// The plain text to analyze.
    public let text: String?
    
    /// The HTML file to analyze.
    public let html: URL?
    
    /// The web page to analyze.
    public let url: String?
    
    /// Specific features to analyze the document for.
    public let features: Features
    
    /// Remove website elements, such as links, ads, etc.
    public let clean: Bool?
    
    /// XPath query for targeting nodes in HTML.
    public let xpath: String?
    
    /// Whether to use raw HTML content if text cleaning fails.
    public let fallbackToRaw: Bool?
    
    /// Whether or not to return the analyzed text.
    public let returnAnalyzedText: Bool?
    
    /// ISO 639-1 code indicating the language to use in the analysis
    public let language: String?
    
    /// Error domain for when errors are thrown.
    private let errorDomain = "com.watsonplatform.naturalLanguageUnderstanding"

    /**
    Initialize a `Parameters` with all member variables. It is required to have either the text, 
     html, or url parameter.

     - parameter text: The plain text to analyze.
     - parameter html: The HTML file to analyze.
     - parameter url: The web page to analyze.
     - parameter features: Specific features to analyze the document for.
     - parameter clean: Remove website elements, such as links, ads, etc.
     - parameter xpath: XPath query for targeting nodes in HTML.
     - parameter fallbackToRaw: Whether to use raw HTML content if text cleaning fails.
     - parameter returnAnalyzedText: Whether or not to return the analyzed text.
     - parameter language: ISO 639-1 code indicating the language to use in the analysis.

    - returns: An initialized `Parameters`.
    */
    public init(
        features: Features,
        text: String? = nil,
        html: URL? = nil,
        url: String? = nil,
        clean: Bool? = nil,
        xpath: String? = nil,
        fallbackToRaw: Bool? = nil,
        returnAnalyzedText: Bool? = nil,
        language: String? = nil)
    {
        self.text = text
        self.html = html
        self.url = url
        self.features = features
        self.clean = clean
        self.xpath = xpath
        self.fallbackToRaw = fallbackToRaw
        self.returnAnalyzedText = returnAnalyzedText
        self.language = language
    }

    /// Used internally to serialize a `Parameters` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["features"] = features.toJSONObject()
        if let text = text { json["text"] = text }
        if let html = html {
            let htmlAsString = try? docAsString(document: html)
            json["html"] = htmlAsString
        }
        if let url = url { json["url"] = url }
        if let clean = clean { json["clean"] = clean }
        if let xpath = xpath { json["xpath"] = xpath }
        if let fallbackToRaw = fallbackToRaw { json["fallback_to_raw"] = fallbackToRaw }
        if let returnAnalyzedText = returnAnalyzedText { json["return_analyzed_text"] = returnAnalyzedText }
        if let language = language { json["language"] = language }
        return json
    }
    
    /// Build HTML as string.
    private func docAsString(document: URL) throws -> String {
        
        guard let docAsString = try? String(contentsOfFile: document.relativePath, encoding:.utf8) else {
            let failureReason = "Unable to convert document to string."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: errorDomain, code: 0, userInfo: userInfo)
            throw error
        }
        return docAsString
    }
}
