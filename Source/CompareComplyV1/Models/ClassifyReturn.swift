/**
 * Copyright IBM Corporation 2018
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
 The analysis of objects returned by the `/v1/element_classification` method.
 */
public struct ClassifyReturn: Codable, Equatable {

    /**
     Basic information about the input document.
     */
    public var document: Document?

    /**
     The analysis model used to classify the input document. For the `/v1/element_classification` method, the only valid
     value is `contracts`.
     */
    public var modelID: String?

    /**
     The version of the analysis model identified by the value of the `model_id` key.
     */
    public var modelVersion: String?

    /**
     Document elements identified by the service.
     */
    public var elements: [Element]?

    /**
     Definition of tables identified in the input document.
     */
    public var tables: [Tables]?

    /**
     The structure of the input document.
     */
    public var documentStructure: DocStructure?

    /**
     Definitions of the parties identified in the input document.
     */
    public var parties: [Parties]?

    /**
     The effective dates of the input document.
     */
    public var effectiveDates: [EffectiveDates]?

    /**
     The monetary amounts identified in the input document.
     */
    public var contractAmounts: [ContractAmts]?

    /**
     The input document's termination dates.
     */
    public var terminationDates: [TerminationDates]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case document = "document"
        case modelID = "model_id"
        case modelVersion = "model_version"
        case elements = "elements"
        case tables = "tables"
        case documentStructure = "document_structure"
        case parties = "parties"
        case effectiveDates = "effective_dates"
        case contractAmounts = "contract_amounts"
        case terminationDates = "termination_dates"
    }

}
