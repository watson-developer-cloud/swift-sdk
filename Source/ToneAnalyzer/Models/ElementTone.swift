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

extension ToneAnalyzer {
    
    /**
     * This object represents the results of Tone analysis on an element; which 
     * may be a document or a sentence. Its structure is a 2-level tree, with 
     * tone categories in the top level and the individual tones (and their scores) in leaves.
     */
    public struct ElementTone: JSONDecodable {
        
        /// The tone analysis categories. Possible tone categories are emotion, writing, and social.
        public var tones:[ToneCategory] = []
        
        public init(json: JSON) throws {
            //tones = try json.array("tone_categories").map(ToneCategory.init)
            tones = try json.arrayOf("tone_categories", type: ToneCategory.self)
        }
    }
}
