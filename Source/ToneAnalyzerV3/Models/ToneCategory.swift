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
import RestKit
    
/** The tone analysis for a particular tone category (e.g. social, emotion, or writing). */
public struct ToneCategory: JSONDecodable {
    
    /// The name of this tone category (e.g. emotion, social, or language).
    public let name: String
    
    /// A unique number identifying this tone category, irrespective of language or localization.
    public let categoryID: String
    
    /// The individual tone results within this category.
    public let tones: [ToneScore]
    
    /// Used internally to initialize a `ToneCategory` model from JSON.
    public init(json: JSON) throws {
        name = try json.getString(at: "category_name")
        categoryID = try json.getString(at: "category_id")
        tones = try json.decodedArray(at: "tones", type: ToneScore.self)
    }
}
