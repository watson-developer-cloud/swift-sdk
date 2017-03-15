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

/** The results of a Speech to Text recognition request. */
public struct SpeechRecognitionResults {
    
    /// All recognition results from a recognition request.
    public var results = [SpeechRecognitionResult]()
 
    /// A concatenation of the transcripts with the greatest confidence.
    public var bestTranscript: String {
        var transcripts = [String]()
        for result in results {
            if let transcript = result.alternatives.first?.transcript {
                transcripts.append(transcript)
            }
        }
        return transcripts.reduce("") { $0 + " " + $1 }
    }
    
    /// All the speaker labels from the recognition request.
    public var speakerLabels = [SpeakerLabel]()
    
    /// Add the updates specified by a `SpeechRecognitionEvent`.
    mutating internal func addResults(wrapper: SpeechRecognitionEvent) {
        var resultsIndex = wrapper.resultIndex
        var wrapperIndex = 0
        while resultsIndex < results.count && wrapperIndex < wrapper.results.count {
            results[resultsIndex] = wrapper.results[wrapperIndex]
            resultsIndex += 1
            wrapperIndex += 1
        }
        while wrapperIndex < wrapper.results.count {
            results.append(wrapper.results[wrapperIndex])
            wrapperIndex += 1
        }
        // If we have parsed some speakerLabel objects, then store them here
        if (wrapper.speakerLabels != nil) {
            for speakerLabel in wrapper.speakerLabels! {
                speakerLabels.append(speakerLabel)
            }
        }
    }
}
