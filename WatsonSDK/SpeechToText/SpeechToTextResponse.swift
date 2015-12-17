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

extension SpeechToText {
    
    public struct SpeechToTextResponse: Mappable
    {
        /// Contains a list of transcription results.
        public var results: [SpeechToTextResult]?
        
        /**
        Contains the state of the service
        
        - listening
        */
        public var state: String?
        
        public init?(_ map: Map) {}
        
        public mutating func mapping(map: Map) {
            results         <- map["results"]
            state           <- map["state"]
        }
        
        /**
        * The transcription property helps return a simple String result for a transcription
        */
        public func transcription () -> String {
            
            if let results = results {
                
                if results.count > 0 {
                    
                    let result = results[0]
                    
                    if let alternatives = result.alternatives {
                        
                        if alternatives.count > 0 {
                            
                            
                            return alternatives[0].transcript!
                            
                        }
                    }
                    
                }
                
            }
            return ""
        }
    }
}