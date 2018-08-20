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
import RestKit

/**
 A maximum of 20 MB of content to analyze, though the service requires much less text; for more information, see
 [Providing sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). For
 JSON input, provide an object of type `Content`.
 */
public enum ProfileContent {

    case content(Content)
    case html(String)
    case text(String)

    internal var contentType: String {
        switch self {
        case .content: return "application/json"
        case .html: return "text/html"
        case .text: return "text/plain"
        }
    }

    internal var content: Data? {
        switch self {
        case .content(let content): return try? JSONEncoder().encode(content)
        case .html(let html): return html.data(using: .utf8)
        case .text(let text): return text.data(using: .utf8)
        }
    }

}
