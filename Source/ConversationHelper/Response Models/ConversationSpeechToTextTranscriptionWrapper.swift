/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

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
