/**
 * Copyright 2015 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import ObjectMapper

/**
 
 **DisambiguatedLinks**
 
 Returned by the AlchemyLanguage service.
 
 */
public struct DisambiguatedLinks: AlchemyLanguageGenericModel, Mappable {

    // MARK: AlchemyGenericModel
    public var totalTransactions: Int?
    
    // MARK: AlchemyLanguageGenericModel
    public var language: String?
    public var url: String?
    
    // MARK: DisambiguatedLinks
    /**
    * The link to the US Census for the disambiguated entity. Note: Provided only for
    * entities that exist in this linked data-set.
    */
    public var census: String?
    
    /**
    * The cia link to the CIA World Factbook for the disambiguated entity. Note: Provided
    * only for entities that exist in this linked data-set.
    */
    public var ciaFactbook: String?
    
    /**
    * The link to CrunchBase for the disambiguated entity. Note: Provided only for
    * entities that exist in CrunchBase.
    */
    public var crunchbase: String?
    
    /**
    * The link to DBpedia for the disambiguated entity. Note: Provided only for entities
    * that exist in this linked data-set.
    */
    public var dbpedia: String?
    
    /**
    * The link to Freebase for the disambiguated entity. Note: Provided only for entities
    * that exist in this linked data-set.
    */
    public var freebase: String?
    
    /** The geographic coordinates. */
    public var geo: String?
    
    /**
    * The link to Geonames for the disambiguated entity. Note: Provided only for entities
    * that exist in this linked data-set.
    */
    public var geonames: String?

    /**
    * The music link to MusicBrainz for the disambiguated entity. Note: Provided only for
    * entities that exist in this linked data-set.
    */
    public var musicBrainz: String?
    
    /** The entity name. */
    public var name: String?
    
    /**
    * The link to OpenCyc for the disambiguated entity. Note: Provided only for entities
    * that exist in this linked data-set.
    */
    public var opencyc: String?
    
    /**  The disambiguated entity subType. */
    public var subType: [String]?
    
    /**
    * The link to UMBEL for the disambiguated entity. Note: Provided only for entities
    * that exist in this linked data-set.
    */
    public var umbel: String?
    
    /** The website. */
    public var website: String?
    
    /**
    * The link to YAGO for the disambiguated entity. Note: Provided only for entities
    * that exist in this linked data-set.
    */
    public var yago: String?
    
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        
        // alchemyGenericModel
        totalTransactions <- (map["totalTransactions"], Transformation.stringToInt)
        
        // alchemyLanguageGenericModel
        language <- map["language"]
        url <- map["url"]
        
        // disambiguatedLinks
        census <- map["census"]
        ciaFactbook <- map["ciaFactbook"]
        crunchbase <- map["crunchbase"]
        dbpedia <- map["dbpedia"]
        freebase <- map["freebase"]
        geo <- map["geo"]
        geonames <- map["geonames"]
        musicBrainz <- map["musicBrainz"]
        name <- map["name"]
        opencyc <- map["opencyc"]
        subType <- map["subType"]
        umbel <- map["umbel"]
        website <- map["website"]
        yago <- map["yago"]
        
    }

}
