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
 An Objective-C compliant wrapper for a transcription alternative produced by Speech to Text.
*/
public class ConversationSpeechToTextTranscriptionWrapper : NSObject {
    
    /// A transcript of the utterance.
    public var transcript: String = ""
    
    /// The confidence score of the transcript, between 0 and 1. Available only for the best
    /// alternative and only in results marked as final.
    public var confidence: Double = 0.0
    
    /// Timestamps for each word of the transcript.
    public var timestamps: NSMutableArray = []
    
    /// Confidence scores for each word of the transcript, between 0 and 1. Available only
    /// for the best alternative and only in results marked as final.
    public var wordConfidence: NSMutableArray = []
    
    init(sttTranscription: SpeechToTextTranscription) {
        self.transcript = sttTranscription.transcript
        
        if let confidence = sttTranscription.confidence {
            self.confidence = confidence
        }
        
        if let timestamps = sttTranscription.timestamps {
            for i in timestamps {
                self.timestamps.addObject( ConversationSpeechToTextWordTimestampWrapper(sttWordTimestamp: i) )
            }
        }
        
        if let wordConfidence = sttTranscription.wordConfidence {
            for j in wordConfidence {
                self.wordConfidence.addObject( ConversationSpeechToTextWordConfidenceWrapper(sttWordConfidence: j) )
            }
        }
        
    }
    
}