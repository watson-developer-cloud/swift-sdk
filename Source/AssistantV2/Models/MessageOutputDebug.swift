/**
 * Copyright IBM Corporation 2019
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
 Additional detailed information about a message response and how it was generated.
 */
public struct MessageOutputDebug: Codable, Equatable {

    /**
     When `branch_exited` is set to `true` by the Assistant, the `branch_exited_reason` specifies whether the dialog
     completed by itself or got interrupted.
     */
    public enum BranchExitedReason: String {
        case completed = "completed"
        case fallback = "fallback"
    }

    /**
     An array of objects containing detailed diagnostic information about the nodes that were triggered during
     processing of the input message.
     */
    public var nodesVisited: [DialogNodesVisited]?

    /**
     An array of up to 50 messages logged with the request.
     */
    public var logMessages: [DialogLogMessage]?

    /**
     Assistant sets this to true when this message response concludes or interrupts a dialog.
     */
    public var branchExited: Bool?

    /**
     When `branch_exited` is set to `true` by the Assistant, the `branch_exited_reason` specifies whether the dialog
     completed by itself or got interrupted.
     */
    public var branchExitedReason: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case nodesVisited = "nodes_visited"
        case logMessages = "log_messages"
        case branchExited = "branch_exited"
        case branchExitedReason = "branch_exited_reason"
    }

}
