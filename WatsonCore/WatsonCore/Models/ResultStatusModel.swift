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
    
    
    init(status: String, statusInfo: String, rawData: NSData) {
        
        self.status = status
        self.statusInfo = statusInfo
        super.init(rawData: rawData, modelError: "")
    }
    
    /**
    Helper method to create an instance of ResultStatusModel
    
    - parameter rawData: <#rawData description#>
    
    - returns: <#return value description#>
    */
    public static func getResultStatusModel(rawData: NSData)->ResultStatusModel {
        
        do {
            let xmlDoc = try AEXMLDocument(xmlData: rawData)
            
            #if DEBUG
                
                // prints the same XML structure as original
                print(xmlDoc.xmlString)
                
                for child in xmlDoc.root.children {
                    print(child.name)
                }
                
            #endif
            
            let resultModel = ResultStatusModel(status: xmlDoc.root["status"].stringValue, statusInfo: xmlDoc.root["statusInfo"].stringValue, rawData: rawData)
            
            if(resultModel.statusInfo.containsString("not found")) { resultModel.statusInfo = "" }
            
            return resultModel
        }
        catch{
            print("\(error)")
        }
        
        return ResultStatusModel(status: AlchemyConstants.Status.ERROR.rawValue, statusInfo: "failed to create result model", rawData: rawData)
    }
}

