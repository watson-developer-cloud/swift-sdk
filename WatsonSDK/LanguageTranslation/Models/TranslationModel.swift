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

public struct TranslationModel : Mappable
{
    var baseModelID: String?
    var customizable: Bool?
    var defaultModel: Bool?
    var domain: String?
    var modelID: String?
    var name: String?
    var owner: String?
    var source: String?
    var status: String?
    var target: String?
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        baseModelID     <- map["base_model_id"]
        customizable    <- map["customizable"]
        defaultModel    <- map["default_model"]
        domain          <- map["domain"]
        modelID         <- map["model_id"]
        name            <- map["name"]
        owner           <- map["owner"]
        status          <- map["status"]
        target          <- map["target"]
    }
}