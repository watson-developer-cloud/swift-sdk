/**
 * Copyright IBM Corporation 2017
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

/** LogCollection. */
public struct LogCollection {

    /// An array of log events.
    public var logs: [LogExport]

    /// An object defining the pagination data for the returned objects.
    public var pagination: LogPagination

    /**
     Initialize a `LogCollection` with member variables.

     - parameter logs: An array of log events.
     - parameter pagination: An object defining the pagination data for the returned objects.

     - returns: An initialized `LogCollection`.
    */
    public init(logs: [LogExport], pagination: LogPagination) {
        self.logs = logs
        self.pagination = pagination
    }
}

extension LogCollection: Codable {

    private enum CodingKeys: String, CodingKey {
        case logs = "logs"
        case pagination = "pagination"
        static let allValues = [logs, pagination]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        logs = try container.decode([LogExport].self, forKey: .logs)
        pagination = try container.decode(LogPagination.self, forKey: .pagination)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(logs, forKey: .logs)
        try container.encode(pagination, forKey: .pagination)
    }

}
