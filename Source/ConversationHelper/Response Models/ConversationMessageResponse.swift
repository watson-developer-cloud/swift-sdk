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
import ObjectMapper

import Foundation

// Struct for a response
public struct ConversationMessageResponse : ConversationRequest {

    var tags: [String]?
    var context: [String: String]?
    var output: [String: AnyObject]?

    init(data: NSData) {
        do {
            let myVar = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            self.output = myVar["output"] as? [String: AnyObject]
            self.context = myVar["context"] as? [String: String]
            self.tags = myVar["tags"] as? [String]
        } catch let error {
            print(error)
        }

    }

    /** Represent the object as a dictionary */
    func toDictionary() -> [String : AnyObject] {
        var map = [String: AnyObject]()
        map["tags"] = tags
        map["context"] = context
        map["output"] = output
        return map
    }

}
