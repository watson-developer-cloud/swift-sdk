/**
 * (C) Copyright IBM Corp. 2019.
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
 The contract currencies that are declared in the document.
 */
public struct ContractCurrencies: Codable, Equatable {

    /**
     The confidence level in the identification of the contract currency.
     */
    public enum ConfidenceLevel: String {
        case high = "High"
        case medium = "Medium"
        case low = "Low"
    }

    /**
     The confidence level in the identification of the contract currency.
     */
    public var confidenceLevel: String?

    /**
     The contract currency.
     */
    public var text: String?

    /**
     The normalized form of the contract currency, which is listed as a string in
     [ISO-4217](https://www.iso.org/iso-4217-currency-codes.html) format. This element is optional; it is returned only
     if normalized text exists.
     */
    public var textNormalized: String?

    /**
     Hashed values that you can send to IBM to provide feedback or receive support.
     */
    public var provenanceIDs: [String]?

    /**
     The numeric location of the identified element in the document, represented with two integers labeled `begin` and
     `end`.
     */
    public var location: Location?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case confidenceLevel = "confidence_level"
        case text = "text"
        case textNormalized = "text_normalized"
        case provenanceIDs = "provenance_ids"
        case location = "location"
    }

}
