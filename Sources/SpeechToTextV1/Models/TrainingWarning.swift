/**
 * (C) Copyright IBM Corp. 2019.
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
 A warning from training of a custom language or custom acoustic model.
 */
public struct TrainingWarning: Codable, Equatable {

    /**
     An identifier for the type of invalid resources listed in the `description` field.
     */
    public enum Code: String {
        case invalidAudioFiles = "invalid_audio_files"
        case invalidCorpusFiles = "invalid_corpus_files"
        case invalidGrammarFiles = "invalid_grammar_files"
        case invalidWords = "invalid_words"
    }

    /**
     An identifier for the type of invalid resources listed in the `description` field.
     */
    public var code: String

    /**
     A warning message that lists the invalid resources that are excluded from the custom model's training. The message
     has the following format: `Analysis of the following {resource_type} has not completed successfully:
     [{resource_names}]. They will be excluded from custom {model_type} model training.`.
     */
    public var message: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
    }

}
