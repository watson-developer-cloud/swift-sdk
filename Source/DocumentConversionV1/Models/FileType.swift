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

/**
 Enum for supported file types
 */
public enum FileType: String {

    /// Constant for HTML file types
    case html = "text/html"

    /// Constant for XML file types
    case xml = "text/xhtml+xml"

    /// Constant for PDF file types
    case pdf = "application/pdf"

    /// Constant for MicrosoftWord documents
    case msWord = "application/msword"
}
