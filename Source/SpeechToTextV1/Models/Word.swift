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

/** A custom word that has been added to a custom language model. */
public struct Word: JSONDecodable {
    
    /// A custom word from the custom model. The spelling of the word is used to train the model.
    public let word: String
    
    /// An array of pronunciations for the custom word.
    public let soundsLike: [String]
    
    /// The spelling of the custom word that the service uses to display the word in a transcript.
    /// If no display-as value is provided for the word, an empty string is stored here and the word 
    /// is displayed as it is spelled.
    public let displayAs: String
    
    /// A sum of the number of times the word is found across all corpora. For example, if the word 
    /// occurs five times in one corpus and seven times in another, its count is 12.
    public let count: Int
    
    /// An array of sources that describes how the word was added to the custom model's words resource.
    public let source: [String]
    
    /// An object describing problems with the custom word.
    public let error: [WordError]?
    
    /// Used internally to initialize a `Word` model from JSON.
    public init(json: JSON) throws {
        word = try json.getString(at: "word")
        soundsLike = try json.decodedArray(at: "sounds_like", type: Swift.String.self)
        displayAs = try json.getString(at: "display_as")
        count = try json.getInt(at: "count")
        source = try json.decodedArray(at: "source", type: Swift.String.self)
        error = try? json.decodedArray(at: "error", type: WordError.self)
    }
}

/** A new word to add to the custom language model. */
public struct NewWord: JSONEncodable {
    
    /// A custom word from the custom model. The spelling of the word is used to train the model.
    public let word: String?
    
    /// An array of pronunciations for the custom word. You can specify a maximum of five sounds-like 
    /// pronunciations for each word. For pronunciation rules, refer to the following link:
    /// http://www.ibm.com/watson/developercloud/doc/speech-to-text/custom.shtml#soundsLike
    public let soundsLike: [String]?
    
    /// The spelling of the custom word that the service uses to display the word in a transcript.
    /// If no display-as value is provided for the word, an empty string is stored here and the word
    /// is displayed as it is spelled.
    public let displayAs: String?
    
    /**
     Create a `NewWord`.
     
     - parameter word: The word that is to be added to the custom model. Do not include spaces in
        the word, use a dash or underscore.
     - parameter soundsLike: Specify pronunciation for words that are difficult to pronounce, 
        foreign words, and acronyms. Omit this parameter
     - parameter displayAs: An alternative spelling for the custom word when it appears in a transcript.
     */
    public init(
        word: String? = nil,
        soundsLike: [String]? = nil,
        displayAs: String? = nil)
    {
        self.word = word
        self.soundsLike = soundsLike
        self.displayAs = displayAs
    }
    
    /// Used internally to serialize a `NewWord` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let word = word {
            json["word"] = word
        }
        if let soundsLike = soundsLike {
            json["sounds_like"] = soundsLike
        }
        if let displayAs = displayAs {
            json["display_as"] = displayAs
        }
        return json
    }

}

/** An object describing problems with the custom word. */
public struct WordError: JSONDecodable {
    
    /// A key-value pair that describes an error associated with the word's definition in the 
    /// format "element": "message", where element is the aspect of the definition that caused the 
    /// problem and message describes the problem.
    /// You must correct the error before you can train the model.
    public let json: [String: Any]
    
    /// Used internally to intialize a `WordError` model from JSON.
    public init(json: JSON) throws {
        self.json = try json.getDictionaryObject()
    }
}

/** Enum describing the types of words to be added to the custom language model. */
public enum WordTypeToAdd: String {
    
    /// List all words.
    case all = "all"
    
    /// Show only custom words that were added or modified by the user.
    case user = "user"
}

/** Enum describing the types of words to be listed. */
public enum WordTypesToList: String {
    
    /// List all words.
    case all = "all"
    
    /// Show only custom words that were added or modified by the user.
    case user = "user"
    
    /// Show only out of vocabulary words that were extracted from the corpora.
    case corpora = "corpora"
}

/** The order that the words should be listed in. */
public enum WordSort: String {
    
    /// List words alphabetically. By default, words are listed in ascending alphabetical order.
    case alphabetical = "alphabetical"
    
    /// List words by count value. Values with the same count are not ordered.
    case count = "count"
}

/** Sort words in ascending or descending order. */
public enum WordSortDirection: String {
    
    /// List words in ascending order.
    case ascending = "+"
    
    /// List words in descending order.
    case descending = "-"
}
