/**
 * Copyright IBM Corporation 2018
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

/** SpeechRecognitionResultsAccumulator. */
public struct SpeechRecognitionResultsAccumulator {

    /// All accumulated recognition results.
    public var results = [SpeechRecognitionResult]()

    /// All accumulated speaker labels.
    public var speakerLabels = [SpeakerLabelsResult]()

    /// A concatenation of transcripts with the greatest confidence.
    public var bestTranscript: String {
        let transcripts = results.map { $0.alternatives.first?.transcript ?? "" }
        return transcripts.joined(separator: " ")
    }

    /// Initialize a `SpeechRecognitionResultsAccumulator` to accumulate recognition results.
    public init() { }

    /// Add recognition results to be accumulated.
    mutating public func add(results: SpeechRecognitionResults) {
        if let index = results.resultIndex, let updates = results.results {
            add(index: index, updates: updates)
        }
        if let speakerLabels = results.speakerLabels {
            add(speakerLabels: speakerLabels)
        }
    }

    mutating private func add(index: Int, updates: [SpeechRecognitionResult]) {
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

    mutating private func add(speakerLabels: [SpeakerLabelsResult]) {
        for speakerLabel in speakerLabels {
            self.speakerLabels.append(speakerLabel)
        }
    }
}
