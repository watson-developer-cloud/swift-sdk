/**
 * (C) Copyright IBM Corp. 2022.
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
 An object that contains information about a trained document classifier model.
 */
public struct ClassifierModelEvaluation: Codable, Equatable {

    /**
     A micro-average aggregates the contributions of all classes to compute the average metric. Classes refers to the
     classification labels that are specified in the `answer_field`.
     */
    public var microAverage: ModelEvaluationMicroAverage

    /**
     A macro-average computes metric independently for each class and then takes the average. Class refers to the
     classification label that is specified in the `answer_field`.
     */
    public var macroAverage: ModelEvaluationMacroAverage

    /**
     An array of evaluation metrics, one set of metrics for each class, where class refers to the classification label
     that is specified in the `answer_field`.
     */
    public var perClass: [PerClassModelEvaluation]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case microAverage = "micro_average"
        case macroAverage = "macro_average"
        case perClass = "per_class"
    }

}
