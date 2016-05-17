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

/** An Objective-C compliant wrapper for a result from a Speech to Text recognition request. */
public class ConversationSpeechToTextResultWrapper: NSObject {
    
    /// If `true`, then the transcription result for this
    /// utterance is final and will not be updated further.
    public var final: Bool = false
    
    /// Alternative transcription results.
    public var alternatives: NSMutableArray = []
    
    /// A dictionary of spotted keywords and their associated matches. A keyword will have
    /// no associated matches if it was not found within the audio input or the threshold
    /// was set too high.
    public var keywordResults: NSMutableDictionary = [:]
    
    /// A list of acoustically similar alternatives for words of the input audio.
    public var wordAlternatives: NSArray = []
    
}