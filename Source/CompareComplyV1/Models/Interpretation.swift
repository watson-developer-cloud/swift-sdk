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
 The details of the normalized text, if applicable. This element is optional; it is returned only if normalized text
 exists.
 */
public struct Interpretation: Codable, Equatable {

    /**
     The value that was located in the normalized text.
     */
    public var value: String?

    /**
     An integer or float expressing the numeric value of the `value` key.
     */
    public var numericValue: Double?

    /**
     A string listing the unit of the value that was found in the normalized text.
     **Note:** The value of `unit` is the [ISO-4217 currency code](https://www.iso.org/iso-4217-currency-codes.html)
     identified for the currency amount (for example, `USD` or `EUR`). If the service cannot disambiguate a currency
     symbol (for example, `$` or `£`), the value of `unit` contains the ambiguous symbol as-is.
     */
    public var unit: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case value = "value"
        case numericValue = "numeric_value"
        case unit = "unit"
    }

}
