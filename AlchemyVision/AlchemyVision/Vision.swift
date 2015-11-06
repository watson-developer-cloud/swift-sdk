//
//  Vision.swift
//  Alchemy
//
//  Created by Vincent Herrin on 9/30/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import WatsonCore
import Foundation
import ObjectMapper


public enum ImageInputType: String {
  case HTML = "html"
  case URL = "url"
}

/// Implementation of Alchemy Vision Service
public class VisionImpl: Service {
  

  init() {
    super.init(type:ServiceType.Alchemy, serviceURL:VisionConstants.visionServiceURL)
  }
  
  convenience init(apiKey:String) {
    self.init()
    _apiKey = apiKey
  }
  
  public func getImageLink(inputType: ImageInputType, inputString: String, completionHandler: (returnValue: ImageLink) ->() ) {
  
    var endPoint = VisionConstants.ImageLinkExtraction.HTMLGetImage.rawValue
    var visionUrl = ""
    
    switch(inputType) {
    case ImageInputType.URL:
      
      endPoint = VisionConstants.ImageLinkExtraction.URLGetImage.rawValue
      visionUrl = getEndpoint(VisionConstants.VisionPrefix.URL.rawValue + endPoint)
      var params = buildCommonParams()
      params.updateValue(inputString, forKey: ImageInputType.URL.rawValue)
      NetworkUtils.performRequest(visionUrl, method: HTTPMethod.POST, parameters: params, completionHandler: {response in
        let imageLink = Mapper<ImageLink>().map(response.data)!
        completionHandler(returnValue: imageLink)
      })
      
      break
    case ImageInputType.HTML:

      endPoint = VisionConstants.ImageLinkExtraction.HTMLGetImage.rawValue
      visionUrl = getEndpoint(VisionConstants.VisionPrefix.HTML.rawValue + endPoint)
      var params = buildCommonParams()
      params.updateValue(inputString, forKey: ImageInputType.HTML.rawValue)
      params.updateValue(_apiKey, forKey: "apikey")
      NetworkUtils.performBasicAuthRequest(visionUrl, method: HTTPMethod.POST, parameters: params, encoding: ParameterEncoding.URL, completionHandler: {response in
        let imageLink = Mapper<ImageLink>().map(response.data)!
        completionHandler(returnValue: imageLink)
      })
        break
    }
  }
  
  /**
   The URLGetRankedImageKeywords call is used to tag an image in a given web page. AlchemyAPI will download the requested URL, extracting the primary image
   from the HTML document structure and perform image tagging.
   
   - parameter url:             http url (must be uri-argument encoded)            REQUIRED
   - parameter forceShowAll:    Includes lower confidence tags
   - parameter knowledgeGraph:  Possible values: 0 (default), 1
   - parameter callback:        Callback with ImageKeyWords through the completion handler
   */
  public func urlGetRankedImageKeywords(url: String, forceShowAll: Bool = false, knowledgeGraph: Int8 = 0, completionHandler: (returnValue: ImageKeyWords) ->() ) {
    
    let visionUrl = getEndpoint(VisionConstants.VisionPrefix.URL.rawValue + VisionConstants.ImageTagging.URLGetRankedImageKeywords.rawValue)
    var params = buildCommonParams(forceShowAll, knowledgeGraph: knowledgeGraph)
    params.updateValue(url, forKey: VisionConstants.WatsonURI.URL.rawValue)
    
    NetworkUtils.performRequest(visionUrl, method: HTTPMethod.POST, parameters: params, completionHandler: {response in
      var imageKeywords = ImageKeyWords()
      if case let data as Dictionary<String,AnyObject> = response.data {
        imageKeywords = Mapper<ImageKeyWords>().map(data)!
      }
      completionHandler(returnValue: imageKeywords)
    })
  }
  
  /**
   <#Description#>
   
   - parameter url:               <#url description#>
   - parameter forceShowAll:    Includes lower confidence tags
   - parameter knowledgeGraph:  Possible values: 0 (default), 1
   - parameter callback:        Callback with ImageKeyWords through the completion handler
   */
  public func urlGetRankedImageFaceTags(url: String, forceShowAll: Bool = false, knowledgeGraph: Int8 = 0, completionHandler: (returnValue: ImageFaceTags) ->() ) {
    
    let visionUrl = getEndpoint(VisionConstants.VisionPrefix.URL.rawValue + VisionConstants.FaceDetection.URLGetRankedImageFaceTags.rawValue)
    var params = buildCommonParams(forceShowAll, knowledgeGraph: knowledgeGraph)
    params.updateValue(url, forKey: VisionConstants.WatsonURI.URL.rawValue)
    
    NetworkUtils.performRequest(visionUrl, method: .POST, parameters: params, completionHandler: {response in
      let imageFaceTags = ImageFaceTags(anyObject: response.data)
      completionHandler(returnValue: imageFaceTags)
    })
  }
  
  /**
   <#Description#>
   
   - parameter fileURL:           <#fileURL description#>
   - parameter forceShowAll:    Includes lower confidence tags
   - parameter knowledgeGraph:  Possible values: 0 (default), 1
   - parameter callback:        Callback with ImageKeyWords through the completion handler
   */
  public func imageGetRankedImageKeywords(fileURL: NSURL, forceShowAll: Bool = false, knowledgeGraph: Int8 = 0, completionHandler: (returnValue: ImageKeyWords) ->() ) {
    
    let visionUrl = getEndpoint(VisionConstants.VisionPrefix.Image.rawValue + VisionConstants.ImageTagging.ImageGetRankedImageKeywords.rawValue)
    var params = buildCommonParams(forceShowAll, knowledgeGraph: knowledgeGraph)
    params.updateValue(VisionConstants.ImagePostMode.Raw.rawValue, forKey: VisionConstants.VisionURI.ImagePostMode.rawValue)
    
    NetworkUtils.performBasicAuthFileUpload(visionUrl, fileURL: fileURL, parameters: params, completionHandler: {response in
      var imageKeywords = ImageKeyWords()
      if case let data as Dictionary<String,AnyObject> = response.data {
        imageKeywords = Mapper<ImageKeyWords>().map(data)!
      }
      completionHandler(returnValue: imageKeywords)
    })
  }
  
  /**
   <#Description#>
   
   - parameter fileURL:           <#fileURL description#>
   - parameter forceShowAll:    Includes lower confidence tags
   - parameter knowledgeGraph:  Possible values: 0 (default), 1
   - parameter callback:        Callback with ImageKeyWords through the completion handler
   */
  public func imageGetRankedImageFaceTags(fileURL: NSURL, forceShowAll: Bool = false, knowledgeGraph: Int8 = 0, completionHandler: (returnValue: ImageFaceTags) ->() ) {
    
    let visionUrl = getEndpoint(VisionConstants.VisionPrefix.Image.rawValue + VisionConstants.FaceDetection.ImageGetRankedImageFaceTags.rawValue)
    var params = buildCommonParams(forceShowAll, knowledgeGraph: knowledgeGraph)
    params.updateValue(VisionConstants.ImagePostMode.Raw.rawValue, forKey: VisionConstants.VisionURI.ImagePostMode.rawValue)
    
    NetworkUtils.performBasicAuthFileUpload(visionUrl, fileURL: fileURL, parameters: params, completionHandler: {response in
      let imageFaceTags = ImageFaceTags(anyObject: response.data)
      //        TODO: Once object mapper is fixed or a different way is established to get StringPointer info then the commented
      //              code will be enabled
      //          var imageFaceTags = ImageFaceTags()
      //
      //          if case let data as Dictionary<String,AnyObject> = response.data {
      //              imageFaceTags = Mapper<ImageFaceTags>().map(data)!
      //          }
      completionHandler(returnValue: imageFaceTags)
    })
  }
  
  /**
   Constructs a dictionary of parameters used in all Alchemy Vision API calls
   
   - parameter forceShowAll:   Includes lower confidence tags
   - parameter knowledgeGraph: Include knowledge graph information in the the results
   
   - returns: Dictionary of parameters common to all Alchemy Vision API calls
   */
  private func buildCommonParams(forceShowAll:Bool = false, knowledgeGraph:Int8 = 0)->Dictionary<String, AnyObject> {
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