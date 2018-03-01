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

/** A model containing information about a specific Solr cluster. */
public struct SolrCluster: JSONDecodable {

    /// The unique identifier for this cluster.
    public let solrClusterID: String

    /// The name that identifies this cluster.
    public let solrClusterName: String

    /// The size of the cluster. Ranges from 1 to 7.
    public let solrClusterSize: Int?

    /// The state of the cluster.
    public let solrClusterStatus: SolrClusterStatus

    /// Used internally to initialize a `SolrCluster` model from JSON.
    public init(json: JSONWrapper) throws {
        solrClusterID = try json.getString(at: "solr_cluster_id")
        solrClusterName = try json.getString(at: "cluster_name")
        solrClusterSize = try Int(json.getString(at: "cluster_size"))

        guard let status = SolrClusterStatus(rawValue: try json.getString(at: "solr_cluster_status")) else {
            throw JSONWrapper.Error.valueNotConvertible(value: json, to: SolrCluster.self)
        }
        solrClusterStatus = status
    }
}

/** An enum describing the current state of the cluster. */
public enum SolrClusterStatus: String {

    /// The cluster is ready.
    case ready = "READY"

    /// The cluster is not available.
    case notAvailable = "NOT_AVAILABLE"
}
