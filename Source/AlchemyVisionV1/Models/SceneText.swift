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
import RestKit

/** The text of an image detected by the Alchemy Vision service. */
public struct SceneText: JSONDecodable {

    /// The status of the request.
    public let status: String

    /// The URL of the requested image being analyzed.
    public let url: String?

    /// The number of transactions charged for this request.
    public let totalTransactions: Int

    /// The aggregate of all identified lines of text in the image.
    public let sceneText: String

    /// The individual lines of text identified in the image.
    public let sceneTextLines: [SceneTextLine]

    /// Used internally to initialize a `SceneText` model from JSON.
    public init(json: JSON) throws {
        status = try json.getString(at: "status")
        guard status == "OK" else {
            throw JSON.Error.valueNotConvertible(value: json, to: SceneText.self)
        }
        
        url = try? json.getString(at: "url")
        totalTransactions = try Int(json.getString(at: "totalTransactions"))!
        sceneText = try json.getString(at: "sceneText")
        sceneTextLines = try json.decodedArray(at: "sceneTextLines", type: SceneTextLine.self)
    }
}

/** The individual lines of text identified in the image. */
public struct SceneTextLine: JSONDecodable {

    /// The likelihood that the identified text is correct.
    public let confidence: Double

    /// The region of the image that contains the identified text.
    public let region: Region

    /// The identified line of text.
    public let text: String

    /// The words of the identified line of text.
    public let words: [Word]

    /// Used internally to initialize a `SceneTextLine` model from JSON.
    public init(json: JSON) throws {
        confidence = try json.getDouble(at: "confidence")
        region = try json.decode(at: "region")
        text = try json.getString(at: "text")
        words = try json.decodedArray(at: "words", type: Word.self)
    }
}

/** The region of the image that contains the identified text. */
public struct Region: JSONDecodable {

    /// The height, in pixels, of the detected face.
    public let height: Int

    /// The width, in pixels, of the detected face.
    public let width: Int

    /// The coordinate of the left-most pixel of the detected face.
    public let x: Int

    /// The coordinate of the right-most pixel of the detected face.
    public let y: Int

    /// Used internally to initialize a `Region` model from JSON.
    public init(json: JSON) throws {
        height = try json.getInt(at: "height")
        width = try json.getInt(at: "width")
        x = try json.getInt(at: "x")
        y = try json.getInt(at: "y")
    }
}

/** A word of the identified line of text. */
public struct Word: JSONDecodable {

    /// The likelihood that the identified word is correct.
    public let confidence: Double

    /// The region of the image that contains the identified word.
    public let region: Region

    /// The word of the identified line of text.
    public let text: String

    /// Used internally to initialize a `Word` model from JSON.
    public init(json: JSON) throws {
        confidence = try json.getDouble(at: "confidence")
        region = try json.decode(at: "region")
        text = try json.getString(at: "text")
    }
}
