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

extension SpeechToText {

    internal struct Constants {

        static let serviceURL = "https://stream.watsonplatform.net/speech-to-text/api"
        static let tokenURL = "https://stream.watsonplatform.net/authorization/api/v1/token"
        static let websocketsURL = "wss://stream.watsonplatform.net/speech-to-text/api/v1/recognize"
        static let errorDomain = "com.watsonplatform.speechtotext"

        static func websocketsURL(model: String? = nil, learningOptOut: Bool? = nil) -> String {
            var url = websocketsURL
            if let model = model {
                url = url + "?model=" + model
            }
            if learningOptOut == true {
                url = url + "?x-watson-learning-opt-out=" + "true"
            }
            return url
        }
    }
}
