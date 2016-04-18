//
//  TrainingStatus.swift
//  WatsonDeveloperCloud
//
//  Created by Glenn Fisher on 4/7/16.
//  Copyright © 2016 Glenn R. Fisher. All rights reserved.
//

import Foundation
import Freddy

extension LanguageTranslationV2 {

    /** The training status of a translation model. */
    public struct MonitorTraining: JSONDecodable {

        /// The status of training (available, training, or error).
        public let status: TrainingStatus

        /// The base model that this translation model was trained on.
        public let baseModelID: String

        public init(json: JSON) throws {
            guard let status = TrainingStatus(rawValue: try json.string("status")) else {
                let type = TrainingStatus.Available.dynamicType
                throw JSON.Error.ValueNotConvertible(value: json, to: type)
            }
            self.status = status
            self.baseModelID = try json.string("base_model_id")
        }
    }
}
