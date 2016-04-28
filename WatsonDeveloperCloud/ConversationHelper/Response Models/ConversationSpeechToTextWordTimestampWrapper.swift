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
 An Objective-C compliant wrapper for the timestamp of a word in a Speech to Text transcription.
 */
public class ConversationSpeechToTextWordTimestampWrapper : NSObject {
    
    /// A particular word from the transcription.
    public var word: String = ""
    
    /// The start time, in seconds, of the given word in the audio input.
    public var startTime: Double = 0.0
    
    /// The end time, in seconds, of the given word in the audio input.
    public var endTime: Double = 0.0
    
    public init(sttWordTimestamp: SpeechToTextWordTimestamp) {
        self.word = sttWordTimestamp.word
        self.startTime = sttWordTimestamp.startTime
        self.endTime = sttWordTimestamp.endTime
    }
    
}