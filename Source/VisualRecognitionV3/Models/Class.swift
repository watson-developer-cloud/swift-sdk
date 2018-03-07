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

/** A category within a classifier. */
public struct Class {

    /// The name of the class.
    public var className: String

    /**
     Initialize a `Class` with member variables.

     - parameter className: The name of the class.

     - returns: An initialized `Class`.
    */
    public init(className: String) {
        self.className = className
    }
}

extension Class: Codable {

    private enum CodingKeys: String, CodingKey {
        case className = "class"
        static let allValues = [className]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        className = try container.decode(String.self, forKey: .className)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(className, forKey: .className)
    }

}
