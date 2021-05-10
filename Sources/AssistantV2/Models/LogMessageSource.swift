/**
 * (C) Copyright IBM Corp. 2021.
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
 An object that identifies the dialog element that generated the error message.
 */
public enum LogMessageSource: Codable, Equatable {

    case dialogNode(LogMessageSourceDialogNode)
    case action(LogMessageSourceAction)
    case step(LogMessageSourceStep)
    case handler(LogMessageSourceHandler)

    private struct GenericLogMessageSource: Codable, Equatable {

        var type: String

        private enum CodingKeys: String, CodingKey {
            case type = "type"
        }

    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let genericInstance = try? container.decode(GenericLogMessageSource.self) {
            switch genericInstance.type {
            case "dialog_node":
                if let val = try? container.decode(LogMessageSourceDialogNode.self) {
                    self = .dialogNode(val)
                    return
                }
            case "action":
                if let val = try? container.decode(LogMessageSourceAction.self) {
                    self = .action(val)
                    return
                }
            case "step":
                if let val = try? container.decode(LogMessageSourceStep.self) {
                    self = .step(val)
                    return
                }
            case "handler":
                if let val = try? container.decode(LogMessageSourceHandler.self) {
                    self = .handler(val)
                    return
                }
            default:
                // falling through to throw decoding error
                break
            }
        }

        throw DecodingError.typeMismatch(LogMessageSource.self,
                                         DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Decoding failed for all associated types"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .dialogNode(let dialog_node):
            try container.encode(dialog_node)
        case .action(let action):
            try container.encode(action)
        case .step(let step):
            try container.encode(step)
        case .handler(let handler):
            try container.encode(handler)
        }
    }
}
