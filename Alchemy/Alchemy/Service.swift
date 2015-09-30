//
//  Service.swift
//  Alchemy
//
//  Created by Vincent Herrin on 9/27/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation
import WatsonCore

// this will be be moved to the correct file once I get things up and running
// API Contract
public protocol AlchemyService
{
    init(apiKey: String)
    
    func urlGetRankedImageKeywords(url: String, outputMode: Constants.OutputMode, imagePostMode: Constants.ImagePostMode?, forceShowAll: Bool?, knowledgeGraph: Int8?, callback: (ResultModel!, NSError!)->())
    
    // I will add this back in once it url is finished
    //func imageGetRankedImageKeywords(base64Image: String, mode: Constants.OutputMode)
}


public class AlchemyServiceImpl : NSObject, AlchemyService {
    
    private let TAG = "[Alchemy] "
    private let utils = WatsonNetworkUtils()
    
    /// your private api key
    private let _apiKey : String

    
    /**
    Initialization of the main Alchemy service class
    
    - parameter apiKey: your private api key
    
    */
    public required init(apiKey: String) {
        
        _apiKey = apiKey
    }

    /**
     The URLGetRankedImageKeywords call is used to tag an image in a given web page. AlchemyAPI will download the requested URL, extracting the primary image from the HTML document structure and perform image tagging.
    
    - parameter url:             http url (must be uri-argument encoded)  REQUIRED
    - parameter outputMode:      Desired API output format  (optional parameter)
    
                                 Possible values:
                                 xml (default), json, rdf
    - parameter imagePostMode:   Mode for Core Watson
    - parameter forceShowAll:    Includes lower confidence tags
    - parameter knowledgeGraph:  Possible values: 0 (default), 1
    - parameter callback:        Callback with Result and Error if present
    */
    // TODO Need to move this into the correct location
    public func urlGetRankedImageKeywords(url: String, outputMode: Constants.OutputMode, imagePostMode: Constants.ImagePostMode?, forceShowAll: Bool?, knowledgeGraph: Int8?, callback:(ResultModel!, NSError!)->()) {

        let paramsData: NSData = NSData()
        
        // need to change this can remove methods and use Dictionary for the params
        var params = addOrUpdateQueryStringParameter("",key: "apikey",value: _apiKey)
        params = addOrUpdateQueryStringParameter(params, key: "url", value: url)
        
        self.analyze("/url/" + "\(Constants.ImageTagging.URLGetRankedImageKeywords)" + params, body: paramsData, callback: {response, error in callback(response, error)})
    }
    
    /**
    This method will be used to call the Alchemy service.
    
    - parameter path:      The specific path for the incoming call.  This will be append to the Host for the full patth to be created
    - parameter body:      value that contains the params for the specific call
    - parameter callback:  Callback with Result and Error if present
    */
    public func analyze(path: String, body: NSData, callback:(ResultModel!, NSError!)->()) {
        
        let fullPath = Constants.Base + path

        self.utils.configureHost(WatsonServiceType.Standard, host: Constants.Host)
        self.utils.setUsernameAndPassword("", password: "")
        
        let request = utils.buildRequest(fullPath, method: WatsonHTTPMethod.POST.rawValue, body: body)
        
        utils.performRequest(request, callback: {response, error in
            if let error_message = response["error_message"] as? String
            {
                self.utils.printDebug("analyze(): " + error_message)
                callback(nil, error)
            }
            else {
                if let rawData = response["rawData"] as! NSData? {
                    if let returnVal = NSString(data: rawData, encoding: NSUTF8StringEncoding) as String?
                    {
                        do {
                            let xmlDoc = try AEXMLDocument(xmlData: rawData)
                            if (xmlDoc.root["status"].stringValue == "\(Constants.Status.ERROR)") {
                                let resultModel = ResultModel(status: xmlDoc.root["status"].stringValue, statusInfo: xmlDoc.root["statusInfo"].stringValue, data: returnVal)
                                callback (resultModel, nil)
                            }
                        }
                        catch{
                            print("\(error)")
                        }
                    }
                }
            }
        })
    }
}
