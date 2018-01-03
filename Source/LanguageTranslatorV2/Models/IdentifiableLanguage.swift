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

/** A language that can be identified by the Language Translator service. */
public struct IdentifiableLanguage: JSONDecodable {

    /// The code of the identifiable language.
    public let language: String

    /// The name of the identifiable language.
    public let name: String

    /// Used internally to initialize an `IdentifiableLanguage` model from JSON.
    public init(json: JSONWrapper) throws {
        language = try json.getString(at: "language")
        name = try json.getString(at: "name")
    }
}
