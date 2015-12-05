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

/// The constants needed for the input keys and parameters
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
