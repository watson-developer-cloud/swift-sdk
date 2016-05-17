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
 An Objective-C compliant wrapper for the confidence of a word in a Speech to Text transcription.
 */
public class ConversationSpeechToTextWordConfidenceWrapper : NSObject {
    
    /// A particular word from the transcription.
    public var word: String = ""
    
    /// The confidence of the given word, between 0 and 1.
    public var confidence: Double = 0.0
    
    public init(sttWordConfidence : SpeechToTextWordConfidence) {
        self.word = sttWordConfidence.word
        self.confidence = sttWordConfidence.confidence
    }
}
