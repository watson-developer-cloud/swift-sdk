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
public struct Parameters: JSONDecodable,JSONEncodable {
    public let text: String?
    public let html: String?
    public let url: String?
    public let features: Features
    public let clean: Bool?
    /// XPath query for targeting nodes in HTML
    public let xpath: String?
    /// Whether to use raw HTML content if text cleaning fails
    public let fallbackToRaw: Bool?
    public let returnAnalyzedText: Bool?
    /// ISO 639-1 code indicating the language to use in the analysis
    public let language: String?

    /**
     Initialize a `Parameters` with required member variables.

     - returns: An initialized `Parameters`.
    */
    public init(features: Features) {
        self.features = features
        self.text = nil
        self.html = nil
        self.url = nil
        self.clean = nil
        self.xpath = nil
        self.fallbackToRaw = nil
        self.returnAnalyzedText = nil
        self.language = nil
    }

    /**
    Initialize a `Parameters` with all member variables.

     - parameter text: 
     - parameter html: 
     - parameter url: 
     - parameter features: 
     - parameter clean: 
     - parameter xpath: XPath query for targeting nodes in HTML
     - parameter fallbackToRaw: Whether to use raw HTML content if text cleaning fails
     - parameter returnAnalyzedText: 
     - parameter language: ISO 639-1 code indicating the language to use in the analysis

    - returns: An initialized `Parameters`.
    */
    public init(text: String, html: String, url: String, features: Features, clean: Bool, xpath: String, fallbackToRaw: Bool, returnAnalyzedText: Bool, language: String) {
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

    // MARK: JSONDecodable
    /// Used internally to initialize a `Parameters` model from JSON.
    public init(json: JSON) throws {
        text = try? json.getString(at: "text")
        html = try? json.getString(at: "html")
        url = try? json.getString(at: "url")
        features = try json.getJSON(at: "features") as! Features
        clean = try? json.getBool(at: "clean")
        xpath = try? json.getString(at: "xpath")
        fallbackToRaw = try? json.getBool(at: "fallback_to_raw")
        returnAnalyzedText = try? json.getBool(at: "return_analyzed_text")
        language = try? json.getString(at: "language")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `Parameters` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["features"] = features
        if let text = text { json["text"] = text }
        if let html = html { json["html"] = html }
        if let url = url { json["url"] = url }
        if let clean = clean { json["clean"] = clean }
        if let xpath = xpath { json["xpath"] = xpath }
        if let fallbackToRaw = fallbackToRaw { json["fallback_to_raw"] = fallbackToRaw }
        if let returnAnalyzedText = returnAnalyzedText { json["return_analyzed_text"] = returnAnalyzedText }
        if let language = language { json["language"] = language }
        return json
    }
}
