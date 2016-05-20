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

/** The results from recognizing text in one or more images. */
public struct ImagesWithWords: JSONDecodable {
    
    /// The number of images processed.
    public let imagesProcessed: Int
    
    /// The images that were processed.
    public let images: [ImageWithWords]
    
    /// Any warnings produced during processing.
    public let warnings: [WarningInfo]?
    
    /// Used internally to initialize an `ImagesWithWords` model from JSON.
    public init(json: JSON) throws {
        imagesProcessed = try json.int("images_processed")
        images = try json.arrayOf("images", type: ImageWithWords.self)
        warnings = try? json.arrayOf("warnings", type: WarningInfo.self)
    }
}

/** An image with detected words. */
public struct ImageWithWords: JSONDecodable {
    
    /// The source URL of the images that was processed.
    public let sourceURL: String?
    
    /// The resolved URL of the images that was processed.
    public let resolvedURL: String?
    
    /// The filename of the image that was classified.
    public let image: String?
    
    /// Information about an error that occurred while processing the given image.
    public let error: ErrorInfo?
    
    /// The text recognized in the image, including recognized formatting (e.g. newlines).
    public let text: String
    
    /// The words recognized in the image.
    public let words: [Word]
    
    /// Used internally to initialize an `ImageWithWords` model from JSON.
    public init(json: JSON) throws {
        sourceURL = try? json.string("source_url")
        resolvedURL = try? json.string("resolved_url")
        image = try? json.string("image")
        error = try? json.decode("error")
        text = try json.string("text")
        words = try json.arrayOf("words", type: Word.self)
    }
}

/** A word detected in a given image. */
public struct Word: JSONDecodable {
    
    /// The word recognized in the image.
    public let word: String
    
    /// The location of the recognized word in the given image.
    public let location: WordLocation
    
    /// The confidence score of the given word recognition.
    public let score: Double
    
    /// The line number that the recognized word is on.
    public let lineNumber: Int
    
    /// Used internally to initialize a `Word` model from JSON.
    public init(json: JSON) throws {
        word = try json.string("word")
        location = try json.decode("location")
        score = try json.double("score")
        lineNumber = try json.int("line_number")
    }
}

/** The location of a detected word. */
public struct WordLocation: JSONDecodable {
    
    /// The width in pixels of the word region.
    public let width: Int
    
    /// The height in pixels of the word region.
    public let height: Int
    
    /// The x-position of the top-left pixel of the word region.
    public let left: Int
    
    /// The y-position of the top-left pixel of the word region.
    public let top: Int
    
    /// Used internally to initialize a `WordLocation` model from JSON.
    public init(json: JSON) throws {
        width = try json.int("width")
        height = try json.int("height")
        left = try json.int("left")
        top = try json.int("top")
    }
}
