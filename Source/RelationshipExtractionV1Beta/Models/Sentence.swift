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

import Foundation
import Freddy

/** Contains the analysis of an input sentence. Produced by the Relationship Extraction service. */
public struct Sentence: JSONDecodable {
    
    /// The numeric identifier of the sentence.
    public let sentenceID: Int
    
    /// The index of the first token in the sentence.
    public let begin: Int
    
    /// The index of the last token in the sentence.
    public let end: Int
    
    /// The complete text of the analyzed sentence.
    public let text: String
    
    /// The serialized constituent parse tree for the sentence. See the following link for more
    /// information: http://en.wikipedia.org/wiki/Parse_tree
    public let parse: String
    
    /// The dependency parse tree for the sentence. See the following link for more information:
    /// http://www.cis.upenn.edu/~treebank/
    public let dependencyParse: String
    
    /// The universal Stanford dependency parse tree for the sentence. See the following link for
    /// more information: http://nlp.stanford.edu/software/stanford-dependencies.shtml
    public let usdDependencyParse: String
    
    /// A list of Token objects for each token in the sentence. Tokens are the individual words and
    /// punctuation in the sentence.
    public let tokens: [Token]
    
    /// Used internally to initialize a `Sentence` model from JSON.
    public init(json: JSON) throws {
        sentenceID = try json.int("sid")
        begin = try json.int("begin")
        end = try json.int("end")
        text = try json.string("text")
        parse = try json.string("parse", "text")
        dependencyParse = try json.string("dependency_parse")
        usdDependencyParse = try json.string("usd_dependency_parse")
        tokens = try json.arrayOf("tokens", "token", type: Token.self)
    }
}

/** A Token object provides more information about a specific token (word or punctuation) in the
 sentence. */
public struct Token: JSONDecodable {
    
    /// The beginning character offset of the token among all tokens of the input text.
    public let begin: Int
    
    /// The ending character offset of the token among all tokens of the input text.
    public let end: Int
    
    /// The token to which this object pertains.
    public let text: String
    
    /// The numeric identifier of the token.
    public let tokenID: Int
    
    /// Used internally to initialize a `Token` model from JSON.
    public init(json: JSON) throws {
        begin = try json.int("begin")
        end = try json.int("end")
        text = try json.string("text")
        tokenID = try json.int("tid")
    }
}


