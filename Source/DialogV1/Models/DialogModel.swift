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
    
/** A dialog associated with a particular service instance. */
public struct DialogModel: JSONDecodable {
    
    /// The dialog application identifier.
    public let dialogID: DialogID
    
    /// The name of the dialog application.
    public let name: String

    /// Used internally to initialize a `DialogModel` model from JSON.
    public init(json: JSON) throws {
        dialogID = try json.getString(at: "dialog_id")
        name = try json.getString(at: "name")
    }
}
