//
//  ResultStatusModel.swift
//  Alchemy
//
//  Created by Vincent Herrin on 9/30/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation

/**
*  This model displays the status return value and the status info.  It will vare a quick indication of the status SUCCESS or ERROR based
on what the Alchemy service gives out.
*/
public class ResultStatusModel : BaseModel {
    
    /// TODO: Why in the world does this need to be public??  INVESTIGATE
    public var status: String = ""
    public var statusInfo: String = ""
    
    
    init(status: String, statusInfo: String, rawData: AnyObject) {
        
        self.status = status
        self.statusInfo = statusInfo
        super.init(rawData: rawData, modelError: "")
    }
    
    public static func createResultStatusModel()->ResultStatusModel {
        
        return ResultStatusModel(status: "",statusInfo: "", rawData: NSData())
    }
    
    /**
    Helper method to create an instance of ResultStatusModel
    
    - parameter rawData: <#rawData description#>
    
    - returns: <#return value description#>
    */
    public static func getResultStatusModel(rawData: AnyObject)->ResultStatusModel {
        
        let resultModel = createResultStatusModel()
        resultModel.rawData = rawData
        
        do {
            if(rawData is NSDictionary) {
                
                for (key, value) in (rawData as! NSDictionary) {
                    
                    switch key as! String  {
                    case "status":
                        resultModel.status = value as! String
                    case "statusInfo":
                        resultModel.status = value as! String
                    default: break
                    }
                }
            }
            else if (rawData is NSData) {
                let xmlDoc = try AEXMLDocument(xmlData: rawData as! NSData)
                
                #if DEBUG
                    // prints the same XML structure as original
                    print(xmlDoc.xmlString)
                    
                    for child in xmlDoc.root.children {
                        print(child.name)
                    }
                #endif
                
                resultModel.status = xmlDoc.root["status"].stringValue
                resultModel.statusInfo = xmlDoc.root["statusInfo"].stringValue
                
                if(resultModel.statusInfo.containsString("not found")) { resultModel.statusInfo = "" }
            }
            
            return resultModel
        }
        catch{
            print("\(error)")
        }
        
        return ResultStatusModel(status: AlchemyConstants.Status.ERROR.rawValue, statusInfo: "failed to create result model", rawData: rawData)
    }
}

