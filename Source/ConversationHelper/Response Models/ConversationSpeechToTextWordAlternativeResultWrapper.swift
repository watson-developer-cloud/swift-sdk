/************************************************************************/
 /*                                                                      */
 /* IBM Confidential                                                     */
 /* OCO Source Materials                                                 */
 /*                                                                      */
 /* (C) Copyright IBM Corp. 2015, 2016                                   */
 /*                                                                      */
 /* The source code for this program is not published or otherwise       */
 /* divested of its trade secrets, irrespective of what has been         */
 /* deposited with the U.S. Copyright Office.                            */
 /*                                                                      */
 /************************************************************************/

import Foundation

/**
 An Objective-C compliant wrapper for alternative word hypotheses from Speech to Text for a word in the audio input.
*/
public class ConversationSpeechToTextWordAlternativeResultWrapper: NSObject {
    
    /// The confidence score of the alternative word hypothesis, between 0 and 1.
    public var confidence: Double = 0.0
    
    /// The alternative word hypothesis for a word in the audio input.
    public var word: String = ""
}