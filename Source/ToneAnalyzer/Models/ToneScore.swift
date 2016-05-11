/**
 * Copyright IBM Corporation 2015
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
import Freddy

extension ToneAnalyzerV3 {
    /**
     *
     * Object representing scoring of a single Tone (of any category) on our responses. It contains the
     * Tone ID, a score, and optionally a list of evidences.
     */
    public struct ToneScore: JSONDecodable {
        /// Unique ID of the tone.
        public let id: String
        /// The name of the tone
        public let name: String
        /// The score of the tone.
        public let score: Double
        
        public init(json: JSON) throws {
            id = try json.string("tone_id")
            name = try json.string("tone_name")
            score = try json.double("score")
        }
    }
}