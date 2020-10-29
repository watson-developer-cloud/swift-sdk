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
 A bin with defined boundaries that indicates the number of values in a range of signal characteristics for a histogram.
 The first and last bins of a histogram are the boundary bins. They cover the intervals between negative infinity and
 the first boundary, and between the last boundary and positive infinity, respectively.
 */
public struct AudioMetricsHistogramBin: Codable, Equatable {

    /**
     The lower boundary of the bin in the histogram.
     */
    public var begin: Double

    /**
     The upper boundary of the bin in the histogram.
     */
    public var end: Double

    /**
     The number of values in the bin of the histogram.
     */
    public var count: Int

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case begin = "begin"
        case end = "end"
        case count = "count"
    }

}
