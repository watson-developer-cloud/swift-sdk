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

public class VisionImpl: VisionService {
    
    private let TAG = "[VISION] "
    
    /// your private api key
    private  var apiKey : String
    
    /// Watson core instance
    private let utils: NetworkUtils
    
    public func setAPIKey(apiKey: String) {
        self.apiKey = apiKey
    }
    
    /**
    Initialization of the main Alchemy service class
    
    - parameter apiKey: your private api key
    
    */
    public init(apiKey: String) {
        
        self.apiKey = apiKey
        // TODO: investigate to see if this is really needed
        utils = NetworkUtils(type: ServiceType.Alchemy)
    }
    
    
    /**
    The URLGetRankedImageKeywords call is used to tag an image in a given web page. AlchemyAPI will download the requested URL, extracting the primary image from the HTML document structure and perform image tagging.
    
    - parameter url:             http url (must be uri-argument encoded)            REQUIRED
    - parameter forceShowAll:    Includes lower confidence tags
    - parameter knowledgeGraph:  Possible values: 0 (default), 1
    - parameter callback:        Callback with ImageKeyWords
    */
    public func urlGetRankedImageKeywords(url: String, forceShowAll: Bool = false, knowledgeGraph: Int8 = 0, completionHandler: (returnValue: ImageKeyWords) ->() ) {
        
        let visionUrl = buildVisionURL(AlchemyConstants.VisionPrefix.URL, endPoint: AlchemyConstants.ImageTagging.URLGetRankedImageKeywords.rawValue)
        var params = buildCommonParams()
        params.updateValue(url, forKey: AlchemyConstants.WatsonURI.URL.rawValue)
        
        if(forceShowAll == true) {
            params.updateValue(forceShowAll.hashValue.description, forKey: AlchemyConstants.VisionURI.ForceShowAll.rawValue)
        }
        
        if(knowledgeGraph > 0) {
            params.updateValue(knowledgeGraph.description, forKey: AlchemyConstants.VisionURI.ForceShowAll.rawValue)
        }
        
        utils.performRequest(visionUrl, method: HTTPMethod.POST, parameters: params, completionHandler: {response in
            let imageKeyWords = ImageKeyWords(anyObject: response.data)
            completionHandler(returnValue: imageKeyWords)
        })
    }
    
    public func imageGetRankedImageKeywords(fileURL: NSURL, forceShowAll: Bool = false, knowledgeGraph: Int8 = 0, completionHandler: (returnValue: ImageKeyWords) ->() ) {
        
        let visionUrl = buildVisionURL(AlchemyConstants.VisionPrefix.Image,  endPoint: AlchemyConstants.ImageTagging.ImageGetRankedImageKeywords.rawValue)
        var params = buildCommonParams()
        params.updateValue(AlchemyConstants.ImagePostMode.Raw.rawValue, forKey: AlchemyConstants.VisionURI.ImagePostMode.rawValue)
        
        if(forceShowAll == true) {
            params.updateValue(forceShowAll.hashValue.description, forKey: AlchemyConstants.VisionURI.ForceShowAll.rawValue)
        }
        
        if(knowledgeGraph > 0) {
            params.updateValue(knowledgeGraph.description, forKey: AlchemyConstants.VisionURI.ForceShowAll.rawValue)
        }
        
        utils.performBasicAuthFileUpload(visionUrl, fileURL: fileURL, parameters: params, completionHandler: {response in
            let imageKeyWords = ImageKeyWords(anyObject: response.data)
            completionHandler(returnValue: imageKeyWords)
        })
    }
    
    public func urlGetRankedImageFaceTags(url: String, forceShowAll: Bool = false, knowledgeGraph: Int8 = 0, completionHandler: (returnValue: ImageFaceTags) ->() ) {
        
        let visionUrl = buildVisionURL(AlchemyConstants.VisionPrefix.URL, endPoint: AlchemyConstants.FaceDetection.URLGetRankedImageFaceTags.rawValue)
        var params = buildCommonParams()
        params.updateValue(url, forKey: AlchemyConstants.WatsonURI.URL.rawValue)
        
        if(forceShowAll == true) {
            params.updateValue(forceShowAll.hashValue.description, forKey: AlchemyConstants.VisionURI.ForceShowAll.rawValue)
        }
        
        if(knowledgeGraph > 0) {
            params.updateValue(knowledgeGraph.description, forKey: AlchemyConstants.VisionURI.ForceShowAll.rawValue)
        }
        
        utils.performRequest(visionUrl, method: .POST, parameters: params, completionHandler: {response in
            let imageFaceTags = ImageFaceTags(anyObject: response.data)
            completionHandler(returnValue: imageFaceTags)
        })
    }
    
    internal func buildVisionURL(visionPrefix: AlchemyConstants.VisionPrefix, endPoint: String)->String {
        return (AlchemyConstants.Host + AlchemyConstants.Base + visionPrefix.rawValue + endPoint)
    }
    
    private func buildCommonParams()->Dictionary<String, AnyObject> {
        var params = Dictionary<String, AnyObject>()
        params.updateValue(apiKey, forKey: AlchemyConstants.WatsonURI.APIKey.rawValue)
        params.updateValue(AlchemyConstants.OutputMode.JSON.rawValue, forKey: AlchemyConstants.VisionURI.OutputMode.rawValue)
        return params
    }
    
}

