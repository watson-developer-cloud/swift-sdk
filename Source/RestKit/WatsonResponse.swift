/**
 * Copyright IBM Corporation 2018
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

// MARK: - WatsonResponse

public struct WatsonResponse<T> {

    /**
     The HTTP status code.
     */
    public var statusCode: Int

    /**
     A dictionary containing the HTTP response headers.
     */
    public var headers: [String: String]

    /**
     The result.
     */
    public var result: T?

    internal init(response: HTTPURLResponse) {
        self.statusCode = response.statusCode
        self.headers = [:]
        for (key, value) in response.allHeaderFields {
            if let key = key as? String,
                let value = value as? String {
                self.headers[key] = value
            }
        }
    }

}
