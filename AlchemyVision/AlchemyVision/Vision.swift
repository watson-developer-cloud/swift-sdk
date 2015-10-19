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
    
    // I will add this back in once it url is finished
    func imageGetRankedImageKeywords(fileURL: NSURL, forceShowAll: Bool, knowledgeGraph: Int8, completionHandler: (returnValue: ImageKeyWords) ->() )
}

public class VisionImpl: VisionService {
    
    private let TAG = "[VISION] "
    
    /// your private api key
    let _apiKey : String
    
    private let utils: NetworkUtils
    
    /**
    Initialization of the main Alchemy service class
    
    - parameter apiKey: your private api key
    
    */
    public init(apiKey: String) {
        
        _apiKey = apiKey
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
        
        Log.sharedLogger.debug("Entered urlGetRankedImageKeywords")
        
        let visionUrl = buildVisionURL(AlchemyConstants.VisionPrefix.URL, endPoint: AlchemyConstants.ImageTagging.URLGetRankedImageKeywords.rawValue)
        
        var params = Dictionary<String,String>()
        params.updateValue(_apiKey, forKey: AlchemyConstants.WatsonURI.APIKey.rawValue)
        params.updateValue(AlchemyConstants.OutputMode.JSON.rawValue, forKey: AlchemyConstants.VisionURI.OutputMode.rawValue)
        params.updateValue(url, forKey: AlchemyConstants.WatsonURI.URL.rawValue)
        
        if(forceShowAll == true) {
            params.updateValue(forceShowAll.hashValue.description, forKey: AlchemyConstants.VisionURI.ForceShowAll.rawValue)
        }
        
        if(knowledgeGraph > 0) {
            params.updateValue(knowledgeGraph.description, forKey: AlchemyConstants.VisionURI.ForceShowAll.rawValue)
        }
        
        utils.performRequest(visionUrl, method: .POST, parameters: params, completionHandler: {response in
            Log.sharedLogger.debug("Entered urlGetRankedImageKeywords.callback")
            let imageKeyWords = ImageKeyWords(anyObject: response.data)
            completionHandler(returnValue: imageKeyWords)
        })
    }
    
    public func imageGetRankedImageKeywords(fileURL: NSURL, forceShowAll: Bool = false, knowledgeGraph: Int8 = 0, completionHandler: (returnValue: ImageKeyWords) ->() ) {
        
        Log.sharedLogger.debug("Entered imageGetRankedImageKeywords")
        
        let visionUrl = buildVisionURL(AlchemyConstants.VisionPrefix.Image,  endPoint: AlchemyConstants.ImageTagging.ImageGetRankedImageKeywords.rawValue)
        
        var params = Dictionary<String,String>()
        params.updateValue(_apiKey, forKey: AlchemyConstants.WatsonURI.APIKey.rawValue)
        params.updateValue(AlchemyConstants.OutputMode.JSON.rawValue, forKey: AlchemyConstants.VisionURI.OutputMode.rawValue)
        params.updateValue(AlchemyConstants.ImagePostMode.Raw.rawValue, forKey: AlchemyConstants.VisionURI.ImagePostMode.rawValue)
        
       // params.updateValue(url, forKey: AlchemyConstants.WatsonURI.URL.rawValue)
        
        if(forceShowAll == true) {
            params.updateValue(forceShowAll.hashValue.description, forKey: AlchemyConstants.VisionURI.ForceShowAll.rawValue)
        }
        
        if(knowledgeGraph > 0) {
            params.updateValue(knowledgeGraph.description, forKey: AlchemyConstants.VisionURI.ForceShowAll.rawValue)
        }
        
        utils.performBasicAuthFileUploadMultiPart(visionUrl, fileURLKey: "image", fileURL: fileURL, parameters: params, completionHandler: {response in
            Log.sharedLogger.debug("Entered imageGetRankedImageKeywords.callback")
            let imageKeyWords = ImageKeyWords(anyObject: response.data)
            completionHandler(returnValue: imageKeyWords)
        })
    }
    
    internal func buildVisionURL(visionPrefix: AlchemyConstants.VisionPrefix, endPoint: String)->String {
        return (AlchemyConstants.Host + AlchemyConstants.Base + visionPrefix.rawValue + endPoint)
    }
    
}

