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
 *  Valid response from Watson Engagement Advisor (WEA).
 */
public class WEAResponse: NSObject  {
    
    /// The response from the dialog service
    //let dialogResponse: MessageResponse?
    let dialogResponse: MessageResponse?
    
    init(dialogResponse: MessageResponse) {
        self.dialogResponse = dialogResponse
    }

    /// The 'output' field from response.
    public var output: NSDictionary?   {
        return (dialogResponse?.output)
    }
    
    /// The 'context' field from response.
    public var context: NSDictionary? {
        return dialogResponse?.context
    }
}
