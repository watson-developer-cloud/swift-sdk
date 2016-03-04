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
import ObjectMapper

/** A generic response from Speech to Text. */
enum SpeechToTextGenericResponse {
    case State(SpeechToTextState)
    case Results(SpeechToTextResultWrapper)
    case Error(SpeechToTextError)

    /**
     Parse a text response from the Speech to Text service.

     - parameter text: A JSON text response from the Speech to Text service.

     - returns: An object mapped from the JSON text, or nil if the response could not be parsed.
     */
    static func parseResponse(text: String) -> SpeechToTextGenericResponse? {
        guard let data = text.dataUsingEncoding(NSUTF8StringEncoding) else {
            return nil
        }

        let object = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        guard let response = object as? NSDictionary else {
            return nil
        }

        if response["state"] != nil {
            guard let state = Mapper<SpeechToTextState>().mapData(data) else {
                return nil
            }
            return .State(state)
        }

        if response["results"] != nil {
            guard let results = Mapper<SpeechToTextResultWrapper>().mapData(data) else {
                return nil
            }
            return .Results(results)
        }

        if response["error"] != nil {
            guard let error = Mapper<SpeechToTextError>().mapData(data) else {
                return nil
            }
            return .Error(error)
        }
        
        return nil
    }
}
