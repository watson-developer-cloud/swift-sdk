//
//  Constants.swift
//  AlchemyVision
//
//  Created by Vincent Herrin on 9/26/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation



/// The Constants needed for the input keys for the parameters
public class AlchemyConstants
{

    static let Hosts = "https://gateway-a.watsonplatform.net"
    static let Base = "/calls"
    static let VisionPrefixURL = "/url/"
    
    // Image Link Extraction
    enum ImageLinkExtraction: String {
        case URLGetImage = "URLGetImage"
        case HTMLGetImage = "HTMLGetImage"
    }
    
    // Image Tagging API
    public enum ImageTagging: String {
        case URLGetRankedImageKeywords = "URLGetRankedImageKeywords"
        case ImageGetRankedImageKeywords = "ImageGetRankedImageKeywords"
    }
    
    // Face Detection
    enum FaceDetection: String {
        case URLGetRankedImageFaceTags = "URLGetRankedImageFaceTags"
        case ImageGetRankedImageFaceTags = "ImageGetRankedImageFaceTags"
    }
    
    
    /**
    Input Parameter Keys
    */
    public enum OutputMode: String {
        case JSON = "json"
        case HTML = "html"
        case XML = "xml"
        case RDF = "rdf"
    }
    
    public enum ImagePostMode: String {
        case Raw = "raw"
        case Not_Raw = "not-raw"
    }
    
    public enum ForceShowAll: String {
        case True = "1"
        case False = "0"
    }
    
    public enum KnowledgeGraph: String {
        case True = "1'"
        case False = "0"
    }
    
    public enum Status: String {
        case ERROR = "ERROR"
        case OK = "OK"
    }
    
    
    /**
    This enum is used to build the base URL information for each call
    */
    public enum WatsonURI: String {
        case URL = "url"
        case APIKey = "apikey"
    }
    
    /**
    This enum is used to build the full URL
    */
    public enum VisionURI: String {
        case OutputMode = "outputMode"
        case ForceShowAll = "forceShowAll"
        case KnowledgeGraph = "knowledgeGraph"
    }
}
