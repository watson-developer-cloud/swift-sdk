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

/**
 An object that implements the WatsonRequestModel protocol can
 represent itself as a dictionary, JSON Data, or JSON string.
 */
protocol WatsonRequestModel {

    /** Represent an object as a dictionary of key-value pairs. */
    func toDictionary() -> [String: AnyObject]
}

extension WatsonRequestModel {

    /**
     Represent an object as JSON data.
     
     - parameter failure: A function executed if an error occurs.
     */
    func toJSONData(failure: (NSError -> Void)?) -> NSData? {
        let map = self.toDictionary()
        let data = try? NSJSONSerialization.dataWithJSONObject(map, options: [])

        guard let json = data else {
            let description = "Could not serialize \(self.dynamicType)"
            let domain = "swift.\(self.dynamicType)"
            let error = createError(domain, description: description)
            failure?(error)
            return nil
        }

        return json
    }

    /**
     Represent an object as a JSON string.
     
     - parameter failure: A function executed if an error occurs.
     */
    func toJSONString(failure: (NSError -> Void)?) -> String? {
        guard let json = self.toJSONData(failure) else {
            return nil
        }

        let text = String(data: json, encoding: NSUTF8StringEncoding)
        return text
    }
}
