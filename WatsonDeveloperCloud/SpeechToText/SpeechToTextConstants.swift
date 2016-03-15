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

struct SpeechToTextConstants {

    static let serviceURL = "https://stream.watsonplatform.net/speech-to-text/api"
    static let tokenURL = "https://stream.watsonplatform.net/authorization/api/v1/token"
    static let websocketsURL = "wss://stream.watsonplatform.net/speech-to-text/api/v1/recognize"
    static let domain = "swift.SpeechToText"

    static func websocketsURL(settings: SpeechToTextSettings) -> NSURL? {
        guard let urlComponents = NSURLComponents(string: websocketsURL) else {
            return nil
        }

        var urlParams = [NSURLQueryItem]()
        if let model = settings.model {
            urlParams.append(NSURLQueryItem(name: "model", value: model))
        }
        if settings.learningOptOut == true {
            urlParams.append(NSURLQueryItem(name: "x-watson-learning-opt-out", value: "true"))
        }
        
        urlComponents.queryItems = urlParams
        guard let url = urlComponents.URL else {
            return nil
        }

        return url
    }
}
