//
//  Service.swift
//  Alchemy
//
//  Created by Vincent Herrin on 9/27/15.
//  Copyright © 2015 MIL. All rights reserved.
//


import Foundation
import SwiftyJSON
import Alamofire

public enum Method: String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

/// TODO: move this to core
public class AlchemyCoreImpl {
    
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
    }
    
    public func analyze(url: String, method: Alamofire.Method, parameters: Dictionary<String,String>, completionHandler: (returnValue: CoreResponse) -> ()) {
        Alamofire.request(method, url, parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    Log.sharedLogger.info("Validation Successful")
                    let coreResponse = CoreResponse(anyObject: data, statusCode: response.response!.statusCode)
                    completionHandler(returnValue: coreResponse)
                case .Failure(let error):
                    let coreResponse =  CoreResponse.init(anyObject: error, statusCode: response.response!.statusCode)
                    completionHandler(returnValue: coreResponse)
                } }
    }
    
    public func getEndpoints() -> JSON {
        
        var jsonObj: JSON = JSON.null
        if let path = NSBundle.mainBundle().pathForResource("alchemy_endpoints", ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                jsonObj = JSON(data)
                if jsonObj == JSON.null {
                    print("could not get json from file, make sure that file contains valid json.")
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        return jsonObj
    }
}
