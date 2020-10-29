/**
 * (C) Copyright IBM Corp. 2019.
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
 A webhook that can be used by dialog nodes to make programmatic calls to an external function.
 **Note:** Currently, only a single webhook named `main_webhook` is supported.
 */
public struct Webhook: Codable, Equatable {

    /**
     The URL for the external service or application to which you want to send HTTP POST requests.
     */
    public var url: String

    /**
     The name of the webhook. Currently, `main_webhook` is the only supported value.
     */
    public var name: String

    /**
     An optional array of HTTP headers to pass with the HTTP request.
     */
    public var headers: [WebhookHeader]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case url = "url"
        case name = "name"
        case headers = "headers"
    }

    /**
      Initialize a `Webhook` with member variables.

      - parameter url: The URL for the external service or application to which you want to send HTTP POST requests.
      - parameter name: The name of the webhook. Currently, `main_webhook` is the only supported value.
      - parameter headers: An optional array of HTTP headers to pass with the HTTP request.

      - returns: An initialized `Webhook`.
     */
    public init(
        url: String,
        name: String,
        headers: [WebhookHeader]? = nil
    )
    {
        self.url = url
        self.name = name
        self.headers = headers
    }

}
