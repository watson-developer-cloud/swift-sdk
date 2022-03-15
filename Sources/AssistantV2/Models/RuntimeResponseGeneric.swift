/**
 * (C) Copyright IBM Corp. 2018, 2022.
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
import IBMSwiftSDKCore

/**
 RuntimeResponseGeneric.
 */
public enum RuntimeResponseGeneric: Codable, Equatable {

    case audio(RuntimeResponseGenericRuntimeResponseTypeAudio)
    case channelTransfer(RuntimeResponseGenericRuntimeResponseTypeChannelTransfer)
    case connectToAgent(RuntimeResponseGenericRuntimeResponseTypeConnectToAgent)
    case iframe(RuntimeResponseGenericRuntimeResponseTypeIframe)
    case image(RuntimeResponseGenericRuntimeResponseTypeImage)
    case option(RuntimeResponseGenericRuntimeResponseTypeOption)
    case suggestion(RuntimeResponseGenericRuntimeResponseTypeSuggestion)
    case pause(RuntimeResponseGenericRuntimeResponseTypePause)
    case search(RuntimeResponseGenericRuntimeResponseTypeSearch)
    case text(RuntimeResponseGenericRuntimeResponseTypeText)
    case userDefined(RuntimeResponseGenericRuntimeResponseTypeUserDefined)
    case video(RuntimeResponseGenericRuntimeResponseTypeVideo)

    private struct GenericRuntimeResponseGeneric: Codable, Equatable {

        var responseType: String

        private enum CodingKeys: String, CodingKey {
            case responseType = "response_type"
        }

    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let genericInstance = try? container.decode(GenericRuntimeResponseGeneric.self) {
            switch genericInstance.responseType {
            case "audio":
                if let val = try? container.decode(RuntimeResponseGenericRuntimeResponseTypeAudio.self) {
                    self = .audio(val)
                    return
                }
            case "channel_transfer":
                if let val = try? container.decode(RuntimeResponseGenericRuntimeResponseTypeChannelTransfer.self) {
                    self = .channelTransfer(val)
                    return
                }
            case "connect_to_agent":
                if let val = try? container.decode(RuntimeResponseGenericRuntimeResponseTypeConnectToAgent.self) {
                    self = .connectToAgent(val)
                    return
                }
            case "iframe":
                if let val = try? container.decode(RuntimeResponseGenericRuntimeResponseTypeIframe.self) {
                    self = .iframe(val)
                    return
                }
            case "image":
                if let val = try? container.decode(RuntimeResponseGenericRuntimeResponseTypeImage.self) {
                    self = .image(val)
                    return
                }
            case "option":
                if let val = try? container.decode(RuntimeResponseGenericRuntimeResponseTypeOption.self) {
                    self = .option(val)
                    return
                }
            case "suggestion":
                if let val = try? container.decode(RuntimeResponseGenericRuntimeResponseTypeSuggestion.self) {
                    self = .suggestion(val)
                    return
                }
            case "pause":
                if let val = try? container.decode(RuntimeResponseGenericRuntimeResponseTypePause.self) {
                    self = .pause(val)
                    return
                }
            case "search":
                if let val = try? container.decode(RuntimeResponseGenericRuntimeResponseTypeSearch.self) {
                    self = .search(val)
                    return
                }
            case "text":
                if let val = try? container.decode(RuntimeResponseGenericRuntimeResponseTypeText.self) {
                    self = .text(val)
                    return
                }
            case "user_defined":
                if let val = try? container.decode(RuntimeResponseGenericRuntimeResponseTypeUserDefined.self) {
                    self = .userDefined(val)
                    return
                }
            case "video":
                if let val = try? container.decode(RuntimeResponseGenericRuntimeResponseTypeVideo.self) {
                    self = .video(val)
                    return
                }
            default:
                // falling through to throw decoding error
                break
            }
        }

        throw DecodingError.typeMismatch(RuntimeResponseGeneric.self,
                                         DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Decoding failed for all associated types"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .audio(let audio):
            try container.encode(audio)
        case .channelTransfer(let channel_transfer):
            try container.encode(channel_transfer)
        case .connectToAgent(let connect_to_agent):
            try container.encode(connect_to_agent)
        case .iframe(let iframe):
            try container.encode(iframe)
        case .image(let image):
            try container.encode(image)
        case .option(let option):
            try container.encode(option)
        case .suggestion(let suggestion):
            try container.encode(suggestion)
        case .pause(let pause):
            try container.encode(pause)
        case .search(let search):
            try container.encode(search)
        case .text(let text):
            try container.encode(text)
        case .userDefined(let user_defined):
            try container.encode(user_defined)
        case .video(let video):
            try container.encode(video)
        }
    }
}
