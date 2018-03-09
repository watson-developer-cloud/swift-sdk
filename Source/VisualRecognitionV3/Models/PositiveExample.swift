/**
 * Copyright IBM Corporation 2016
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

/** A class associated with a Visual Recognition classifier. */
public struct PositiveExample {

    /// The name of the class.
    public let name: String

    /// A compressed (.zip) file of images that prominently
    /// depict the visual subject of the given class.
    public let examples: URL

    /**
     Define a set of positive examples that shall be recognized by a classifier.

     - parameter name: The name of the class.
     - parameter examples: A compressed (.zip) file of images that prominently depict the visual
        subject of the given class.
     */
    public init(name: String, examples: URL) {
        self.name = name
        self.examples = examples
    }
}
