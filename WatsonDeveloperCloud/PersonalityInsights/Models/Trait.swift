/**
 * Copyright IBM Corporation 2015
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
import ObjectMapper

extension PersonalityInsights {

    /// A recursive model that contains information about a personality trait.
    public struct Trait: Mappable {
        
        /// The id of the characteristic, globally unique
        public var ID:String?
        /// The user-displayable name of the characteristic
        public var name:String?
        /// The category of the characteristic: personality, needs, values, or behavior (for temporal data
        public var category:String?
        /// For personality, needs, and values characterisitics, the normalized percentile score for the characteristic, from 0-1. For temporal behavior characteristics, the percentage of timestamped data that occurred during that day or hour.
        public var percentage:Double?
        /// Indicates the sampling error of the percentage based on the number of words in the input, from 0-1. The number defines a 95% confidence interval around the percentage
        public var samplingError:Double?
        /// For personality, needs, and values characterisitics, the raw score for the characteristic. A positive or negative score indicates more or less of the characteristic; zero indicates neutrality or no evidence for a score. The raw score is computed based on the input and the service model; it is not normalized or compared with a sample population. The raw score enables comparison of the results against a different sampling population and with a custom normalization approach
        public var rawScore:Double?
        /// Indicates the sampling error of the raw score based on the number of words in the input; the practical range is 0-1. The number defines a 95% confidence interval around the raw score. For example, if the raw sampling error is 5% and the raw score is 65%, it is 95% likely that the actual raw score is between 60% and 70% if more words are given
        public var rawSamplingError:Double?
        /// Recursive array of characteristics inferred from the input text
        public var children:[Trait]?
        
        public init?(_ map: Map) {}
        
        public mutating func mapping(map: Map) {
            ID                  <- map["id"]
            name                <- map["name"]
            category            <- map["category"]
            percentage          <- map["percentage"]
            samplingError       <- map["sampling_error"]
            rawScore            <- map["raw_score"]
            rawSamplingError    <- map["raw_sampling_error"]
            children            <- map["children"]
        }
    }
}