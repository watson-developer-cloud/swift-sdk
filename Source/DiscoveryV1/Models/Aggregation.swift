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

/** An aggregation produced by the Discovery service to analyze the input provided. */
public struct Aggregation: JSONDecodable {
    
    /// Type of aggregation.
    public let type: String?
    
    /// The path along the given document structure parsed by the Watson service.
    public let path: String?
    
    /// Number of matching results
    public let matchingResults: Int?
    
    /// Aggregations returned by the Discovery service.
    public let aggregations: [Aggregation]?
    
    public let field: String?
    

    
    public let match: String?
    
    
    /// Results returned by the Discovery service.
    public let results: [Result]?
    

    
    public let value: Int?
    
    public let key: String?
    
    public let interval: String?
    
    
    /// Used internally to initialize a `Notice` model from JSON.
    public init(json: JSON) throws {
        matchingResults = try? json.getInt(at: "matching_results")
        results = try? json.decodedArray(at: "results", type: Result.self)
        aggregations = try? json.decodedArray(at: "aggregations", type: Aggregation.self)
    }
}
