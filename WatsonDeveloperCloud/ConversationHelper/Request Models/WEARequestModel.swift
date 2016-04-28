/************************************************************************/
 /*                                                                      */
 /* IBM Confidential                                                     */
 /* OCO Source Materials                                                 */
 /*                                                                      */
 /* (C) Copyright IBM Corp. 2001, 2016                                   */
 /*                                                                      */
 /* The source code for this program is not published or otherwise       */
 /* divested of its trade secrets, irrespective of what has been         */
 /* deposited with the U.S. Copyright Office.                            */
 /*                                                                      */
 /************************************************************************/

import Foundation

/**
 An object that implements the WEARequestModel protocol can
 represent itself as a dictionary, JSON Data, or JSON string.
 */
protocol WEARequestModel {
    
    /** Represent an object as a dictionary of key-value pairs. */
    func toDictionary() -> [String: AnyObject]
}

extension WEARequestModel {
    
    /**
     Represent an object as JSON data.
     
     - parameter failure: A function executed if an error occurs.
     */
    func toJSONData(failure: (NSError -> Void)?) -> NSData? {
        let map = self.toDictionary()
        let data = try? NSJSONSerialization.dataWithJSONObject(map, options: [])
        
        guard let json = data else {
            let description = "Could not serialize \(self.dynamicType)"
            let domain = "swift.\(self.dynamicType)"
            let error = NSError(domain: domain, code: -1, userInfo: [NSLocalizedDescriptionKey: description])
            failure?(error)
            return nil
        }
        
        return json
    }
    
    /**
     Represent an object as JSON string.
     
     - parameter failure: A function executed if an error occurs.
     */
    func toJSONString(failure: (NSError -> Void)?) -> String? {
        guard let json = self.toJSONData(failure) else {
            return nil
        }
        
        let text = String(data: json, endcoding: NSUTF8StringEncoding)
        return text
    }
    
}