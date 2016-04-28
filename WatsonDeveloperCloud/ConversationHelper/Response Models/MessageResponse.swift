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

// Struct for a response
public struct MessageResponse : WEARequestModel {
    
    var tags: [String]?
    var context: [String: String]?
    var output: [String: AnyObject]?
    
    init(data: NSData) {
        do {
        let myVar = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        self.output = myVar["output"] as? [String: AnyObject]
        self.context = myVar["context"] as? [String: String]
        self.tags = myVar["tags"] as? [String]
        } catch let error {
            print(error)
        }
        
    }
    
    /** Represent the object as a dictionary */
    func toDictionary() -> [String : AnyObject] {
        var map = [String: AnyObject]()
        map["tags"] = tags
        map["context"] = context
        map["output"] = output
        return map
    }
    
}