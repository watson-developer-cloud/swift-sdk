/**
 * Copyright IBM Corporation 2015
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

 **DisambiguatedLinks**

 Disambiguate detected entities

 */

public struct DisambiguatedLinks: JSONDecodable {

    /** detected language */
    public let language: String?

    /** content URL */
    public let url: String?

    /**
     sameAs link to the US Census for this concept tag
     Note: Provided only for entities that exist in this linked data-set
     */
    public let census: String?

    /**
     sameAs link to the CIA World Factbook for this concept tag
     Note: Provided only for entities that exist in this linked data-set
     */
    public let ciaFactbook: String?

    /**
     website link to CrunchBase for this concept tag.
     Note: Provided only for entities that exist in CrunchBase.
     */
    public let crunchbase: String?

    /**
     sameAs link to DBpedia for this concept tag
     Note: Provided only for entities that exist in this linked data-set
     */
    public let dbpedia: String?

    /**
     sameAs link to Freebase for this concept tag.
     Note: Provided only for entities that exist in this linked data-set
     */
    public let freebase: String?

    /** latitude longitude - the geographic coordinates associated with this concept tag */
    public let geo: String?

    /**
     sameAs link to Geonames for this concept tag
     Note: Provided only for entities that exist in this linked data-set
     */
    public let geonames: String?

    /**
     * The music link to MusicBrainz for the disambiguated entity. Note: Provided only for
     * entities that exist in this linked data-set.
     */
    public let musicBrainz: String?

    /** The entity name. */
    public let name: String?

    /**
     * The link to OpenCyc for the disambiguated entity. Note: Provided only for entities
     * that exist in this linked data-set.
     */
    public let opencyc: String?

    /**  The disambiguated entity subType. */
    public let subType: [String]?

    /**
     * The link to UMBEL for the disambiguated entity. Note: Provided only for entities
     * that exist in this linked data-set.
     */
    public let umbel: String?

    /** The website. */
    public let website: String?

    /**
     * The link to YAGO for the disambiguated entity. Note: Provided only for entities
     * that exist in this linked data-set.
     */
    public let yago: String?

    /// Used internally to initialize a DisambiguatedLinks object
    public init(json: JSONWrapper) throws {
        language = try? json.getString(at: "language")
        url = try? json.getString(at: "url")
        census = try? json.getString(at: "census")
        ciaFactbook = try? json.getString(at: "ciaFactbook")
        crunchbase = try? json.getString(at: "crunchbase")
        dbpedia = try? json.getString(at: "dbpedia")
        freebase = try? json.getString(at: "freebase")
        geo = try? json.getString(at: "geo")
        geonames = try? json.getString(at: "geonames")
        musicBrainz = try? json.getString(at: "musicBrainz")
        name = try? json.getString(at: "name")
        opencyc = try? json.getString(at: "opencyc")
        subType = try? json.decodedArray(at: "subType", type: Swift.String.self)
        umbel = try? json.getString(at: "umbel")
        website = try? json.getString(at: "website")
        yago = try? json.getString(at: "yago")
    }
}

