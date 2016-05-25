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
import Freddy

/**
 
 **DisambiguatedLinks**
 
 Returned by the AlchemyLanguage service.
 
 */

public struct DisambiguatedLinks: JSONDecodable {
    public let language: String?
    public let url: String?
    public let census: String?
    public let ciaFactbook: String?
    public let crunchbase: String?
    public let dbpedia: String?
    public let freebase: String?
    public let geo: String?
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
    
    public init(json: JSON) throws {
        language = try? json.string("language")
        url = try? json.string("url")
        census = try? json.string("census")
        ciaFactbook = try? json.string("ciaFactbook")
        crunchbase = try? json.string("crunchbase")
        dbpedia = try? json.string("dbpedia")
        freebase = try? json.string("freebase")
        geo = try? json.string("geo")
        geonames = try? json.string("geonames")
        musicBrainz = try? json.string("musicBrainz")
        name = try? json.string("name")
        opencyc = try? json.string("opencyc")
        subType = try? json.arrayOf("subType", type: Swift.String)
        umbel = try? json.string("umbel")
        website = try? json.string("website")
        yago = try? json.string("yago")
    }
}

