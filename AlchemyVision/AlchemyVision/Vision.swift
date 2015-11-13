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


/// Implementation of Alchemy Vision Service
public class VisionImpl: Service {
  

  init() {
    super.init(type:ServiceType.Alchemy, serviceURL:VisionConstants.visionServiceURL)
  }
  
  convenience init(apiKey:String) {
    self.init()
    _apiKey = apiKey
  }
  
  /**
   This function will invoke the GetImage API call for both URL and for HTML depending on the parameters passed in
   
   - parameter inputType:         Input type for either HTML or URL
   - parameter inputString:       The string that contains the URL or the HTML text
   - parameter completionHandler: ImageLink object is returned in the completionHandler
   */
  public func getImageLink(inputType: VisionConstants.ImageLinkType, inputString: String, completionHandler: (returnValue: ImageLink) ->() ) {
  
    var endPoint = VisionConstants.ImageLinkExtraction.HTMLGetImage.rawValue
    var visionUrl = ""
    
    switch(inputType) {
    case VisionConstants.ImageLinkType.URL:
      endPoint = VisionConstants.ImageLinkExtraction.URLGetImage.rawValue
      visionUrl = getEndpoint(VisionConstants.VisionPrefix.URL.rawValue + endPoint)
      var params = buildCommonParams()
      params.updateValue(inputString, forKey: VisionConstants.ImageLinkType.URL.rawValue)
      NetworkUtils.performRequest(visionUrl, method: HTTPMethod.POST, parameters: params, completionHandler: {response in
        let imageLink = Mapper<ImageLink>().map(response.data)!
        completionHandler(returnValue: imageLink)
      })
      
      break
    case VisionConstants.ImageLinkType.HTML:
      endPoint = VisionConstants.ImageLinkExtraction.HTMLGetImage.rawValue
      visionUrl = getEndpoint(VisionConstants.VisionPrefix.HTML.rawValue + endPoint)
      var params = buildCommonParams()
      params.updateValue(inputString, forKey: VisionConstants.ImageLinkType.HTML.rawValue)
      params.updateValue(_apiKey, forKey: "apikey")
      NetworkUtils.performBasicAuthRequest(visionUrl, method: HTTPMethod.POST, parameters: params, encoding: ParameterEncoding.URL, completionHandler: {response in
        let imageLink = Mapper<ImageLink>().map(response.data)!
        completionHandler(returnValue: imageLink)
      })
        break
    }
  }
  
  /**
   The getImageKeywords call is used to tag an image in a given web page or file. AlchemyAPI will extracting the primary image and perform image tagging.
   
   - parameter inputType:         Input type for either NSURL image file or URL string
   - parameter stringURL:         The string URL to extract primary image
   - parameter fileURL:           Image file to perform image tagging
   - parameter forceShowAll:      Includes lower confidence tags
   - parameter knowledgeGraph:    Possible values: 0 (default), 1
   - parameter callback:          Callback with ImageKeyWords through the completion handler
   */
  public func getImageKeywords(inputType: VisionConstants.ImageKeywordType, stringURL: String? = nil, fileURL: NSURL? = nil, forceShowAll: Bool = false, knowledgeGraph: Int8 = 0, completionHandler: (returnValue: ImageKeyWords) ->() ) {
    
    var endPoint = VisionConstants.ImageTagging.URLGetRankedImageKeywords.rawValue
    var visionUrl = ""
    
    switch(inputType) {
    case VisionConstants.ImageKeywordType.URL:
      endPoint = VisionConstants.ImageTagging.URLGetRankedImageKeywords.rawValue
      visionUrl = getEndpoint(VisionConstants.VisionPrefix.URL.rawValue + endPoint)
      var params = buildCommonParams(forceShowAll, knowledgeGraph: knowledgeGraph)
      params.updateValue(stringURL!, forKey: VisionConstants.WatsonURI.URL.rawValue)
      NetworkUtils.performRequest(visionUrl, method: HTTPMethod.POST, parameters: params, completionHandler: {response in
        var imageKeywords = ImageKeyWords()
        if case let data as Dictionary<String,AnyObject> = response.data {
          imageKeywords = Mapper<ImageKeyWords>().map(data)!
        }
        completionHandler(returnValue: imageKeywords)
      })
      
      break
    case VisionConstants.ImageKeywordType.FILE:
      endPoint = VisionConstants.ImageTagging.ImageGetRankedImageKeywords.rawValue
      visionUrl = getEndpoint(VisionConstants.VisionPrefix.Image.rawValue + endPoint)
      var params = buildCommonParams(forceShowAll, knowledgeGraph: knowledgeGraph)
      params.updateValue(VisionConstants.ImagePostMode.Raw.rawValue, forKey: VisionConstants.VisionURI.ImagePostMode.rawValue)
      NetworkUtils.performBasicAuthFileUpload(visionUrl, fileURL: fileURL!, parameters: params, completionHandler: {response in
        var imageKeywords = ImageKeyWords()
        if case let data as Dictionary<String,AnyObject> = response.data {
          imageKeywords = Mapper<ImageKeyWords>().map(data)!
        }
        completionHandler(returnValue: imageKeywords)
      })
      break
    }
  }
  
  /**
  The recognizeFaces call is used to recognize faces in a given web page or file. AlchemyAPI will extracting the primary image and perform face recognition.
   
   - parameter inputType:       Input type for either NSURL image file or URL string
   - parameter stringURL:       The string URL to perform face tagging
   - parameter fileURL:         Image file to perform face tagging
   - parameter forceShowAll:    Includes lower confidence tags
   - parameter knowledgeGraph:  Possible values: 0 (default), 1
   - parameter callback:        Callback with ImageKeyWords through the completion handler
   */
  public func recognizeFaces(inputType: VisionConstants.ImageFacesType, stringURL: String? = nil, fileURL: NSURL? = nil, forceShowAll: Bool = false, knowledgeGraph: Int8 = 0, completionHandler: (returnValue: ImageFaceTags) ->() ) {
  
    var endPoint = VisionConstants.ImageLinkExtraction.HTMLGetImage.rawValue
    var visionUrl = ""
    
    switch(inputType) {
    case VisionConstants.ImageFacesType.URL:
      endPoint = VisionConstants.FaceDetection.URLGetRankedImageFaceTags.rawValue
      visionUrl = getEndpoint(VisionConstants.VisionPrefix.URL.rawValue + endPoint)

      var params = buildCommonParams(forceShowAll, knowledgeGraph: knowledgeGraph)
      params.updateValue(stringURL!, forKey: VisionConstants.WatsonURI.URL.rawValue)
      NetworkUtils.performRequest(visionUrl, method: HTTPMethod.POST, parameters: params, completionHandler: {response in
        var imageFaceTags = ImageFaceTags()
        if case let data as Dictionary<String,AnyObject> = response.data {
          imageFaceTags = ImageFaceTags(anyObject: data)
        }
        completionHandler(returnValue: imageFaceTags)
      })
      
      break
    case VisionConstants.ImageFacesType.FILE:
      endPoint = VisionConstants.FaceDetection.ImageGetRankedImageFaceTags.rawValue
      visionUrl = getEndpoint(VisionConstants.VisionPrefix.Image.rawValue + endPoint)
      var params = buildCommonParams(forceShowAll, knowledgeGraph: knowledgeGraph)
      params.updateValue(VisionConstants.ImagePostMode.Raw.rawValue, forKey: VisionConstants.VisionURI.ImagePostMode.rawValue)
      NetworkUtils.performBasicAuthFileUpload(visionUrl, fileURL: fileURL!, parameters: params, completionHandler: {response in
        var imageFaceTags = ImageFaceTags()
        if case let data as Dictionary<String,AnyObject> = response.data {
          imageFaceTags = ImageFaceTags(anyObject: data)
        }
        completionHandler(returnValue: imageFaceTags)
      })
      break
    }
  
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