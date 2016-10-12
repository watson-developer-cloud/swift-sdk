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

/** A set of faces identified in an image by the Alchemy Vision service. */
public struct FaceTags: JSONDecodable {

    /// The status of the request.
    public let status: String

    /// The URL of the requested image being tagged.
    public let url: String?

    /// The number of transactions charged for this request.
    public let totalTransactions: Int

    /// The faces recognized in the requested image.
    public let imageFaces: [ImageFace]

    /// Used internally to initialize a `FaceTags` model from JSON.
    public init(json: JSON) throws {
        status = try json.string("status")
        url = try? json.string("url")
        totalTransactions = try Int(json.string("totalTransactions"))!
        imageFaces = try json.arrayOf("imageFaces", type: ImageFace.self)
    }
}

/** A face recognized in the requested image. */
public struct ImageFace: JSONDecodable {

    /// The coordinate of the left-most pixel of the detected face.
    public let positionX: Int

    /// The coordinate of the top-most pixel of the detected face.
    public let positionY: Int

    /// The width, in pixels, of the detected face.
    public let width: Int

    /// The height, in pixels, of the detected face.
    public let height: Int

    /// The gender of the detected face.
    public let gender: Gender

    /// The age of the detected face.
    public let age: Age

    /// The identity of the detected face, if the face is identified as a known celebrity.
    public let identity: Identity?

    /// Used internally to initialize an `ImageFace` model from JSON.
    public init(json: JSON) throws {
        positionX = try Int(json.string("positionX"))!
        positionY = try Int(json.string("positionY"))!
        width = try Int(json.string("width"))!
        height = try Int(json.string("height"))!
        gender = try json.decode("gender")
        age = try json.decode("age")
        identity = try? json.decode("identity")
    }
}

/** The gender of a detected face. */
public struct Gender: JSONDecodable {

    /// The gender of the detected face.
    public let gender: String

    /// The likelihood that this gender corresponds to the detected face.
    public let score: Double

    /// Used internally to initialize a `Gender` model from JSON.
    public init(json: JSON) throws {
        gender = try json.string("gender")
        score = try Double(json.string("score"))!
    }
}

/** The age of a detected face. */
public struct Age: JSONDecodable {

    /// The age range of the detected face.
    public let ageRange: String

    /// The likelihood that this age range corresponds to the detected face.
    public let score: Double

    /// Used internally to initialize an `Age` model from JSON.
    public init(json: JSON) throws {
        ageRange = try json.string("ageRange")
        score = try Double(json.string("score"))!
    }
}

/** The identity of a detected face. */
public struct Identity: JSONDecodable {

    /// The name of the detected celebrity face.
    public let name: String

    /// The likelihood that this name corresponds to the detected face.
    public let score: Double
    
    /// Information to disambiguate the identity of the detected face.
    public let disambiguated: Disambiguated

    /// Metadata derived from the Alchemy knowledge graph.
    public let knowledgeGraph: KnowledgeGraph?

    /// Used internally to initialize an `Identity` model from JSON.
    public init(json: JSON) throws {
        name = try json.string("name")
        score = try Double(json.string("score"))!
        disambiguated = try json.decode("disambiguated")
        knowledgeGraph = try? json.decode("knowledgeGraph")
    }
}

/** Information to disambiguate the detected face. */
public struct Disambiguated: JSONDecodable {

    /// The disambiguated entity name.
    public let name: String

    /// The disambiguated entity sub-type. Sub-types expose additional ontological mappings for a
    /// detected entity, such as identification of a person as a politician or athlete.
    public let subType: [String]?

    /// The disambiguated entity website.
    public let website: String?

    /// SameAs link to DBpedia for the disambiguated entity.
    public let dbpedia: String?

    /// SameAs link to YAGO for the disambiguated entity.
    public let yago: String?

    /// SameAs link to OpenCyc for the disambiguated entity.
    public let opencyc: String?

    /// SameAs link to UMBEL for the disambiguated entity.
    public let umbel: String?

    /// SameAs link to Freebase for the disambiguated entity.
    public let freebase: String?

    /// SameAs link to MusicBrainz for the disambiguated entity.
    public let crunchbase: String?

    /// Used internally to initialize a `Disambiguated` model from JSON.
    public init(json: JSON) throws {
        name = try json.string("name")
        subType = try? json.arrayOf("subType", type: String.self)
        website = try? json.string("website")
        dbpedia = try? json.string("dbpedia")
        yago = try? json.string("yago")
        opencyc = try? json.string("opencyc")
        umbel = try? json.string("umbel")
        freebase = try? json.string("freebase")
        crunchbase = try? json.string("crunchbase")
    }
}
