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

/**
 
 **Language**
 
 Returned by the AlchemyLanguage service.
 
 */
extension AlchemyLanguageV1 {
    public struct Language: JSONDecodable {
        public let language: String?
        public let url: String?
        public let ethnologue: String?
        public let iso6391: String?
        public let iso6392: String?
        public let iso6393: String?
        public let nativeSpeakers: String?
        public let wikipedia: String?
        
        public init(json: JSON) throws {
            language = try? json.string("language")
            url = try? json.string("url")
            ethnologue = try? json.string("ethnologue")
            iso6391 = try? json.string("iso-639-1")
            iso6392 = try? json.string("iso-639-2")
            iso6393 = try? json.string("iso-639-3")
            nativeSpeakers = try? json.string("native-speakers")
            wikipedia = try? json.string("wikipedia")
        }
    }
}
