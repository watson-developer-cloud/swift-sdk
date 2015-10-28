//
//  Vision.swift
//  Alchemy
//
//  Created by Vincent Herrin on 9/30/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import WatsonCore
import Foundation


// TODO: Need to move this into the correct location

// this will be be moved to the correct file once I get things up and running
// API Contract
public protocol VisionService
{
    func urlGetRankedImageKeywords(url: String, forceShowAll: Bool, knowledgeGraph: Int8, completionHandler: (returnValue: ImageKeyWords) ->() )
    
    func imageGetRankedImageKeywords(fileURL: NSURL, forceShowAll: Bool, knowledgeGraph: Int8, completionHandler: (returnValue: ImageKeyWords) ->() )
    
    func urlGetRankedImageFaceTags(url: String, forceShowAll: Bool, knowledgeGraph: Int8, completionHandler: (returnValue: ImageFaceTags) ->() )
}

public class VisionImpl: Service, VisionService {
    
    public init() {
        super.init(type:ServiceType.Alchemy, serviceURL:VisionConstants.visionServiceURL)
    }
    
    public convenience init(apiKey:String) {
        self.init()
        _apiKey = apiKey
    }
    
    /**
    The URLGetRankedImageKeywords call is used to tag an image in a given web page. AlchemyAPI will download the requested URL, extracting the primary image from the HTML document structure and perform image tagging.
    
    - parameter url:             http url (must be uri-argument encoded)            REQUIRED
    - parameter forceShowAll:    Includes lower confidence tags
    - parameter knowledgeGraph:  Possible values: 0 (default), 1
    - parameter callback:        Callback with ImageKeyWords
    */
    public func urlGetRankedImageKeywords(url: String, forceShowAll: Bool = false, knowledgeGraph: Int8 = 0, completionHandler: (returnValue: ImageKeyWords) ->() ) {
        
        let visionUrl = getEndpoint(VisionConstants.VisionPrefix.URL.rawValue + VisionConstants.ImageTagging.URLGetRankedImageKeywords.rawValue)
        
        var params = buildCommonParams(forceShowAll, knowledgeGraph: knowledgeGraph)
        params.updateValue(url, forKey: VisionConstants.WatsonURI.URL.rawValue)
        
        NetworkUtils.performRequest(visionUrl, method: HTTPMethod.POST, parameters: params, completionHandler: {response in
            let imageKeyWords = ImageKeyWords(anyObject: response.data)
            completionHandler(returnValue: imageKeyWords)
        })
    }
    
    public func urlGetRankedImageFaceTags(url: String, forceShowAll: Bool = false, knowledgeGraph: Int8 = 0, completionHandler: (returnValue: ImageFaceTags) ->() ) {
        
        let visionUrl = getEndpoint(VisionConstants.VisionPrefix.URL.rawValue + VisionConstants.FaceDetection.URLGetRankedImageFaceTags.rawValue)
        
        var params = buildCommonParams(forceShowAll, knowledgeGraph: knowledgeGraph)
        params.updateValue(url, forKey: VisionConstants.WatsonURI.URL.rawValue)
        
        NetworkUtils.performRequest(visionUrl, method: .POST, parameters: params, completionHandler: {response in
            let imageFaceTags = ImageFaceTags(anyObject: response.data)
            completionHandler(returnValue: imageFaceTags)
        })
    }
    
    public func imageGetRankedImageKeywords(fileURL: NSURL, forceShowAll: Bool = false, knowledgeGraph: Int8 = 0, completionHandler: (returnValue: ImageKeyWords) ->() ) {
        
        let visionUrl = getEndpoint(VisionConstants.VisionPrefix.Image.rawValue + VisionConstants.ImageTagging.ImageGetRankedImageKeywords.rawValue)
        
        var params = buildCommonParams(forceShowAll, knowledgeGraph: knowledgeGraph)
        params.updateValue(VisionConstants.ImagePostMode.Raw.rawValue, forKey: VisionConstants.VisionURI.ImagePostMode.rawValue)
        
        NetworkUtils.performBasicAuthFileUpload(visionUrl, fileURL: fileURL, parameters: params, apiKey: _apiKey, completionHandler: {response in
            
            let imageKeyWords = ImageKeyWords(anyObject: response.data)
            completionHandler(returnValue: imageKeyWords)
        })
    }
    
    public func imageGetRankedImageFaceTags(fileURL: NSURL, forceShowAll: Bool = false, knowledgeGraph: Int8 = 0, completionHandler: (returnValue: ImageFaceTags) ->() ) {
        
        let visionUrl = getEndpoint(VisionConstants.VisionPrefix.Image.rawValue + VisionConstants.FaceDetection.ImageGetRankedImageFaceTags.rawValue)
        
        var params = buildCommonParams(forceShowAll, knowledgeGraph: knowledgeGraph)
        params.updateValue(VisionConstants.ImagePostMode.Raw.rawValue, forKey: VisionConstants.VisionURI.ImagePostMode.rawValue)
        
        NetworkUtils.performBasicAuthFileUpload(visionUrl, fileURL: fileURL, parameters: params, apiKey: _apiKey, completionHandler: {response in
            let imageFaceTags = ImageFaceTags(anyObject: response.data)
            completionHandler(returnValue: imageFaceTags)
        })
    }
    
    /**
    Constructs a dictionary of parameters used in all Alchemy Vision API calls
    
    - parameter forceShowAll:   Includes lower confidence tags
    - parameter knowledgeGraph: Include knowledge graph information in the the results
    
    - returns: Dictionary of parameters common to all Alchemy Vision API calls
    */
    private func buildCommonParams(forceShowAll:Bool, knowledgeGraph:Int8)->Dictionary<String, AnyObject> {
        var params = Dictionary<String, AnyObject>()
        params.updateValue(_apiKey, forKey: VisionConstants.WatsonURI.APIKey.rawValue)
        params.updateValue(VisionConstants.OutputMode.JSON.rawValue, forKey: VisionConstants.VisionURI.OutputMode.rawValue)
        
        if(forceShowAll == true) {
            params.updateValue(forceShowAll.hashValue.description, forKey: VisionConstants.VisionURI.ForceShowAll.rawValue)
        }
        
        if(knowledgeGraph > 0) {
            params.updateValue(knowledgeGraph.description, forKey: VisionConstants.VisionURI.ForceShowAll.rawValue)
        }
        
        return params
    }
}