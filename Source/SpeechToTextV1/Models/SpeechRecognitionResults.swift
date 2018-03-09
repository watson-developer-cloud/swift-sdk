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
    mutating internal func addResults(event: SpeechRecognitionEvent) {
        if let index = event.resultIndex, let updates = event.results {
            addResults(index: index, updates: updates)
        }
        if let speakerLabels = event.speakerLabels {
            addResults(speakerLabels: speakerLabels)
        }
    }

    mutating internal func addResults(index: Int, updates: [SpeechRecognitionResult]) {
        var resultsIndex = index // lowest index in self.results that has changed
        var updates = updates // changes to merge into self.results
        var updatesIndex = 0 // the change that is being merged

        // update existing recognition results that have changed
        while resultsIndex < results.count && updatesIndex < updates.count {
            results[resultsIndex] = updates[updatesIndex]
            resultsIndex += 1
            updatesIndex += 1
        }

        // append new recognition results
        while updatesIndex < updates.count {
            results.append(updates[updatesIndex])
            updatesIndex += 1
        }
    }

    mutating internal func addResults(speakerLabels: [SpeakerLabel]) {
        for speakerLabel in speakerLabels {
            self.speakerLabels.append(speakerLabel)
        }
    }
}
