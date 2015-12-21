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
import ObjectMapper

/// AlchemyVision employs deep learning innovations to understand a picture's content and context
public class AlchemyVision: AlchemyService {
    
    // The authentication strategy to obtain authorization tokens.
    var authStrategy: AuthenticationStrategy
    
    // The non-expiring Alchemy API key returned by the authentication strategy.
    // TODO: this can be removed after migrating to WatsonGateway
    private var _apiKey: String! {
        return authStrategy.token
    }
    
    public required init(var authStrategy: AuthenticationStrategy) {
        self.authStrategy = authStrategy
        
        // refresh to obtain the API key
        // TODO: this can be removed after migrating to WatsonGateway
        authStrategy.refreshToken { error in
            guard error != nil else {
                return
            }
        }
    }
    
    public convenience required init(apiKey: String) {
        let authStrategy = APIKeyAuthenticationStrategy(apiKey: apiKey)
        self.init(authStrategy: authStrategy)
    }
    
    /**
     This function will invoke the GetImage API call for both URL and for HTML depending on the parameters passed in
     
     - parameter inputType:         Input type for either HTML or URL
     - parameter inputString:       The string that contains the URL or the HTML text
     - parameter completionHandler: ImageLink object is returned in the completionHandler
     */
    public func getImageLink(inputType: VisionConstants.ImageLinkType, inputString: String, completionHandler: (ImageLink?, NSError?) -> Void) {
        
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
                completionHandler(imageLink, response.error)
            })
        case VisionConstants.ImageLinkType.HTML:
            endPoint = VisionConstants.ImageLinkExtraction.HTMLGetImage.rawValue
            visionUrl = getEndpoint(VisionConstants.VisionPrefix.HTML.rawValue + endPoint)
            var params = buildCommonParams()
            params.updateValue(inputString, forKey: VisionConstants.ImageLinkType.HTML.rawValue)
            params.updateValue(_apiKey, forKey: "apikey")
            NetworkUtils.performBasicAuthRequest(visionUrl, method: HTTPMethod.POST, parameters: params, encoding: ParameterEncoding.URL, completionHandler: {response in
                let imageLink = Mapper<ImageLink>().map(response.data)!
                completionHandler(imageLink, response.error)
            })
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
    public func getImageKeywords(inputType: VisionConstants.ImageKeywordType, stringURL: String? = nil, image: UIImage? = nil, forceShowAll: Bool = false, knowledgeGraph: Int8 = 0, completionHandler: (ImageKeyWords?, NSError?) -> Void) {
        
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
                    completionHandler(imageKeywords, response.error)
                }
                else {
                    completionHandler(nil, NSError.createWatsonError(400, description: "No valid data returned"))
                }
            })
        case VisionConstants.ImageKeywordType.UIImage:
            endPoint = VisionConstants.ImageTagging.ImageGetRankedImageKeywords.rawValue
            visionUrl = getEndpoint(VisionConstants.VisionPrefix.Image.rawValue + endPoint)
            var params = buildCommonParams(forceShowAll, knowledgeGraph: knowledgeGraph)
            params.updateValue(VisionConstants.ImagePostMode.Raw.rawValue, forKey: VisionConstants.VisionURI.ImagePostMode.rawValue)
            
            guard let image = image else {
                let error = NSError.createWatsonError(400, description: "Cannot receive image keywords without a valid input image")
                completionHandler(nil, error)
                return
            }
            
            let urlObject = getImageURL(image)
            
            guard urlObject.1 == nil else {
                completionHandler(nil, urlObject.1)
                return
            }
            
            NetworkUtils.performBasicAuthFileUpload(visionUrl, fileURL: urlObject.0!.url!, parameters: params, completionHandler: {response in
                var error:NSError?
                let fileManager = NSFileManager.defaultManager()
                do {
                    try fileManager.removeItemAtPath(urlObject.0!.path)
                }
                catch let catchError as NSError {
                    error = catchError
                    Log.sharedLogger.error("\(error)")
                }
                
                var imageKeywords = ImageKeyWords()
                if case let data as Dictionary<String,AnyObject> = response.data {
                    imageKeywords = Mapper<ImageKeyWords>().map(data)!
                    completionHandler(imageKeywords, response.error)
                } else {
                    completionHandler(nil, NSError.createWatsonError(400, description: "No valid data returned"))
                }
            })
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
    public func recognizeFaces(inputType: VisionConstants.ImageFacesType, stringURL: String? = nil, image: UIImage? = nil, forceShowAll: Bool = false, knowledgeGraph: Int8 = 0, completionHandler: (ImageFaceTags?, NSError?) -> Void) {
        
        var endPoint = VisionConstants.ImageLinkExtraction.HTMLGetImage.rawValue
        var visionUrl = ""
        
        switch(inputType) {
        case VisionConstants.ImageFacesType.URL:
            endPoint = VisionConstants.FaceDetection.URLGetRankedImageFaceTags.rawValue
            visionUrl = getEndpoint(VisionConstants.VisionPrefix.URL.rawValue + endPoint)
            
            var params = buildCommonParams(forceShowAll, knowledgeGraph: knowledgeGraph)
            params.updateValue(stringURL!, forKey: VisionConstants.WatsonURI.URL.rawValue)
            NetworkUtils.performRequest(visionUrl, method: HTTPMethod.POST, parameters: params, completionHandler: {response in
                if case let data as Dictionary<String,AnyObject> = response.data {
                    let imageFaceTags = Mapper<ImageFaceTags>().map(data)
                    completionHandler(imageFaceTags, response.error)
                } else {
                    completionHandler(nil, NSError.createWatsonError(400, description: "No valid data returned"))
                }
                
            })
        case VisionConstants.ImageFacesType.UIImage:
            endPoint = VisionConstants.FaceDetection.ImageGetRankedImageFaceTags.rawValue
            visionUrl = getEndpoint(VisionConstants.VisionPrefix.Image.rawValue + endPoint)
            var params = buildCommonParams(forceShowAll, knowledgeGraph: knowledgeGraph)
            params.updateValue(VisionConstants.ImagePostMode.Raw.rawValue, forKey: VisionConstants.VisionURI.ImagePostMode.rawValue)
            
            guard let image = image else {
                let error = NSError.createWatsonError(404,
                    description: "Cannot receive image keywords without a valid input image")
                completionHandler(nil, error)
                return
            }
            
            let urlObject = getImageURL(image)
            
            guard urlObject.1 == nil else {
                completionHandler(nil, urlObject.1)
                return
            }
            
            NetworkUtils.performBasicAuthFileUpload(visionUrl, fileURL: urlObject.0!.url!, parameters: params, completionHandler: {response in
                var error:NSError?
                let fileManager = NSFileManager.defaultManager()
                
                // delete temp file from documents directory
                do {
                    Log.sharedLogger.error(urlObject.0!.path)
                    try fileManager.removeItemAtPath(urlObject.0!.path)
                }
                catch let catchError as NSError {
                    error = catchError
                    Log.sharedLogger.error("\(error)")
                }
                
                if case let data as Dictionary<String,AnyObject> = response.data {
                    let imageFaceTags = Mapper<ImageFaceTags>().map(data)
                    completionHandler(imageFaceTags, response.error)
                }
                else {
                    completionHandler(nil, NSError.createWatsonError(400, description: "No valid data returned"))
                }
            })
        }
    }
    
    /**
     Returns the ImageURL which contains an NSURL and path to the image
     
     - parameter image: image to create a reference
     
     - returns: ImageURL, NSError
     */
    private func getImageURL(image: UIImage) ->(ImageURL?,NSError?) {
        var error:NSError?
        
        let data = UIImagePNGRepresentation(image);
        
        guard data != nil else {
            error = NSError.createWatsonError(404,
                description: "Error creating data object from imput image")
            return (nil, error)
        }
        
        let filePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] + "/" + NSUUID().UUIDString
        
        guard (!filePath.isEmpty) else {
            return (nil, NSError.createWatsonError(400, description: "Error creating file path from input image"))
        }
        
        data?.writeToFile(filePath, atomically: true)
        let url = NSURL(fileURLWithPath: filePath)
        return (ImageURL(path: filePath, url: url), nil)        
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