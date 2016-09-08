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
    
    public var bestTranscript: String? {
        var bestTranscript = ""
        for result in results {
            if !result.final {
                // non-final results have only one alternative
                assert(result.alternatives.count <= 1) // TODO: debugging
                bestTranscript += result.alternatives.first?.transcript ?? ""
            } else {
                // final results report a confidence for the top alternative
                for alternative in result.alternatives {
                    if (alternative.confidence != nil) {
                        bestTranscript += alternative.transcript
                    }
                }
            }
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