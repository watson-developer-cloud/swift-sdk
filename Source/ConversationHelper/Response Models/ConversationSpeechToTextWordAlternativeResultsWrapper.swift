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
 An Objective-C compliant wrapper for the alternatives produced by Speech to Text.
 */
public class ConversationSpeechToTextWordAlternativeResultsWrapper: NSObject {
    /// The time, in seconds, at which the word with alternative
    /// word hypotheses starts in the audio input.
    public var startTime: Double = 0.0
    /// The time, in seconds, at which the word with alternative
    /// word hypotheses ends in the audio input.
    public var endTime: Double = 0.0
    /// A list of alternative word hypotheses for a word in the audio input.
    public var alternatives: NSArray = []
}
