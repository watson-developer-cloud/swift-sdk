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
    
    public var results = [SpeechRecognitionResult]()
    
    public func bestTranscript(combine: ((String, String) -> String)? = nil) -> String {
        // construct array of transcript strings
        var transcripts = [String]()
        for result in results {
            if let transcript = result.alternatives.first?.transcript {
                transcripts.append(transcript)
            }
        }
        
        // combine transcript strings for best transcript
        var bestTranscript = ""
        if let combine = combine {
            bestTranscript = transcripts.reduce("", combine: combine)
        } else {
            bestTranscript = transcripts.reduce("") { $0 + " " + $1 }
        }
        return bestTranscript
    }
    
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
    }
}