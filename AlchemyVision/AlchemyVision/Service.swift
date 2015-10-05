//
//  Service.swift
//  Alchemy
//
//  Created by Vincent Herrin on 9/27/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation
import WatsonCore

/// TODO: move this to core
public class AlchemyServiceImpl : NSObject {
    
    private let TAG = "[Alchemy] "
    private let utils:NetworkUtils = NetworkUtils(type: ServiceType.Alchemy)
    
    /// your private api key
    let _apiKey : String
    
    
    /**
    Initialization of the main Alchemy service class
    
    - parameter apiKey: your private api key
    
    */
    public required init(apiKey: String) {
        
        _apiKey = apiKey
        //utils = NetworkUtils(type: ServiceType.Alchemy)
    }
    
    
    /**
    This method will be used to call the Alchemy service.
    
    - parameter path:      The specific path for the incoming call.  This will be append to the Host for the full patth to be created
    - parameter body:      value that contains the params for the specific call
    - parameter callback:  Callback with Result and Error if present
    */
    public func analyze(path: String, body: NSData, callback:(ResultStatusModel!, NSError!)->()) {
        
        let fullPath = Constants.Base + path
        
        self.utils.setUsernameAndPassword("", password: "")
        
        let request = utils.buildRequest(fullPath, method: HTTPMethod.POST, body: body )
        
        utils.performRequest(request!, callback: {response, error in
            if let error_message = response["error_message"] as? String
            {
                WatsonLog("analyze(): " + error_message)
                callback(nil, error)
            }
            else {
                if let rawData = response["rawData"] as! NSData? {
                    
                    if let _ = NSString(data: rawData, encoding: NSUTF8StringEncoding) as String?
                    {
                        let resultStatusModel = ResultStatusModel.getResultStatusModel(rawData)
                        callback(resultStatusModel,nil)
                    }
                }
                    //       else if(response is Dictionary) {
                    //           let resultStatusModel = ResultStatusModel.getResultStatusModel(response)
                    //           callback(resultStatusModel,nil)
                    //       }
                else {
                    callback(nil,nil)
                }
            }
        })
    }
}
