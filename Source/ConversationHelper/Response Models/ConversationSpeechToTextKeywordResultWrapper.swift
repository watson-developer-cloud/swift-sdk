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
 An Objective-C compliant wrapper for a keyword identified by Speech to Text.
 */
public class ConversationSpeechToTextKeywordResultWrapper: NSObject {
    /// The specified keyword normalized to the spoken phrase that matched in the audio input.
    public var normalizedText: String = ""
    /// The start time, in seconds, of the keyword match.
    public var startTime: Double = 0.0
    /// The end time, in seconds, of the keyword match.
    public var endTime: Double = 0.0
    /// The confidence score of the keyword match, between 0 and 1. The confidence must be at
    /// least as great as the specified threshold to be included in the results.
    public var confidence: Double = 0.0
}
