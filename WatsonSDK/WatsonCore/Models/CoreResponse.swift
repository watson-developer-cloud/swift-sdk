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

import ObjectMapper
import Foundation
import Alamofire

/**
*  The Main response back for Watson Core.  It will contain the status, status info
and the status code for the http response.
*/
public struct CoreResponse: Mappable, CustomStringConvertible {
    public var data:AnyObject?
    public var code:Int?
    public var info:String?
    public var help:String?
    
    //Alchemy
    public var totalTransactions:Int?
    public var usage:String?
    public var status:String?
    
    //Concept Expansion
    public var developer:String?
    
    //NSError
    public var domain:String?
    
    public var error:NSError? {
        let errDomain = domain == nil ? WatsonCoreConstants.defaultErrorDomain : domain!
        let errCode = code == nil ? 0 : code!
        let errUserInfo = info == nil ? [:] : [WatsonCoreConstants.descriptionKey:info!]

        return NSError(domain: errDomain, code: errCode, userInfo: errUserInfo)
    }
    
    public var description: String {
        var desc = ""
        if let code = code {
            desc += "\nCode: \(code)"
        }
        if let status = status {
            desc += "\nStatus: \(status)"
        }
        if let domain = domain {
            desc += "\nDomain: \(domain)"
        }
        if let info = info {
            desc += "\nInfo: \(info)"
        }
        if let developer = developer {
            desc += "\nDeveloper: \(developer)"
        }
        if let help = help {
            desc += "\nHelp: \(help)"
        }
        return desc
    }

    public init?(_ map: Map) {}

    public mutating func mapping(map: Map) {
        //Maps most verbose information last, so that it takes precedence in case of overlapping information

        //NSError
        code                <-  map["errorCode"]
        domain              <-  map["errorDomain"]
        info                <-  map["errorLocalizedDescription"]

        //NSURLHTTPResponse
        code                <-  map["responseStatusCode"]
        info                <-  map["responseInfo"]
        
        //Standard
        data                <-  map["data"]
        code                <- (map["data.code"], Transformation.stringToInt)
        info                <-  map["data.error"]
        info                <-  map["data.error_message"]
        
        //Personality Insights
        help                <-  map["data.help"]
        info                <-  map["data.description"]
        
        //Concept Expansion
        code                <-  map["data.error.error_code"]
        info                <-  map["data.message"]
        info                <-  map["data.error.user_message"]
        developer           <-  map["data.error.dev_message"]
        help                <-  map["data.error.doc"]

        //Alchemy
        totalTransactions   <- (map["data.totalTransactions"], Transformation.stringToInt)
        status              <-  map["data.status"]
        usage               <-  map["data.usage"]
        info                <-  map["data.statusInfo"]
    }
  
  /**
   Given an AlamoFire response object, returns a Watson response object (CoreResponse) with standardized fields for errors and info
   
   - parameter response: AlamoFire Response
   
   - returns: A Watson CoreResponse
   */
    static func getCoreResponse<T>(response: Response<T,NSError>)->CoreResponse {
    var coreResponseDictionary: Dictionary<String,AnyObject> = Dictionary()
    
    if let data = response.data where data.length > 0 {
      do {
        if let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as? [String: AnyObject] {
          coreResponseDictionary.updateValue(jsonData, forKey: "data")
        }
      } catch {
        
        Log.sharedLogger.info("Non-JSON payload received")
        
        // When binary data is received
        coreResponseDictionary.updateValue(data, forKey: "data")
      }
    }
    if let error = response.result.error {
      coreResponseDictionary.updateValue(error.code, forKey: "errorCode")
      coreResponseDictionary.updateValue(error.localizedDescription, forKey: "errorLocalizedDescription")
      coreResponseDictionary.updateValue(error.domain, forKey: "errorDomain")
    }
    if let response = response.response {
      coreResponseDictionary.updateValue(response.statusCode, forKey: "responseStatusCode")
      coreResponseDictionary.updateValue(NSHTTPURLResponse.localizedStringForStatusCode(response.statusCode), forKey: "responseInfo")
    }
    let coreResponse = Mapper<CoreResponse>().map(coreResponseDictionary)!
    Log.sharedLogger.debug("\(coreResponse)")
    return coreResponse
  }

}