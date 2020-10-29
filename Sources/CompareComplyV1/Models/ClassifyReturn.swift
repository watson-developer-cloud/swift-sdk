/**
 * (C) Copyright IBM Corp. 2018, 2019.
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
 The analysis of objects returned by the **Element classification** method.
 */
public struct ClassifyReturn: Codable, Equatable {

    /**
     Basic information about the input document.
     */
    public var document: Document?

    /**
     The analysis model used to classify the input document. For the **Element classification** method, the only valid
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
     The date or dates on which the document becomes effective.
     */
    public var effectiveDates: [EffectiveDates]?

    /**
     The monetary amounts that identify the total amount of the contract that needs to be paid from one party to
     another.
     */
    public var contractAmounts: [ContractAmts]?

    /**
     The dates on which the document is to be terminated.
     */
    public var terminationDates: [TerminationDates]?

    /**
     The contract type as declared in the document.
     */
    public var contractTypes: [ContractTypes]?

    /**
     The durations of the contract.
     */
    public var contractTerms: [ContractTerms]?

    /**
     The document's payment durations.
     */
    public var paymentTerms: [PaymentTerms]?

    /**
     The contract currencies as declared in the document.
     */
    public var contractCurrencies: [ContractCurrencies]?

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

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case document = "document"
        case modelID = "model_id"
        case modelVersion = "model_version"
        case elements = "elements"
        case effectiveDates = "effective_dates"
        case contractAmounts = "contract_amounts"
        case terminationDates = "termination_dates"
        case contractTypes = "contract_types"
        case contractTerms = "contract_terms"
        case paymentTerms = "payment_terms"
        case contractCurrencies = "contract_currencies"
        case tables = "tables"
        case documentStructure = "document_structure"
        case parties = "parties"
    }

}
