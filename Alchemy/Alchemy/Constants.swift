//
//  Constants.swift
//  AlchemyVision
//
//  Created by Vincent Herrin on 9/26/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation


// ADD COMMENTS

public class Constants : NSObject
{

    static let Host = "gateway-a.watsonplatform.net"
    static let Base = "/calls"
    
    // Image Link Extraction
    enum ImageLinkExtraction { case URLGetImage, HTMLGetImage }
    
    // Image Tagging API
    enum ImageTagging { case URLGetRankedImageKeywords, ImageGetRankedImageKeywords }
    
    // Face Detection
    enum FaceDetection { case URLGetRankedImageFaceTags, ImageGetRankedImageFaceTags }
    
    public enum OutputMode { case JSON, HTML, XML, RDF}
    
    public enum ImagePostMode { case Raw, Not_Raw}
    
    public enum ForceShowAll { case True, False}
    
    public enum KnowledgeGraph { case True, False}
    
    public enum Status { case ERROR, SUCCESS}
    
}
