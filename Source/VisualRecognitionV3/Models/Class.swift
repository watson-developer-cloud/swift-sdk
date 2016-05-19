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

/** A class that shall be recognized by a classifier. */
public struct ClassWithExamples {
    
    /// The name of the class
    internal let name: String
    
    /// A compressed (.zip) file of images that prominently
    /// depict the visual subject of the given class.
    internal let examples: NSURL
    
    /**
     Define a class that shall be recognized by a classifier.

     - parameter name: The name of the class.
     - parameter examples: A compressed (.zip) file of images that prominently depict the visual
            subject of the given class.
     */
    public init(name: String, examples: NSURL) {
        self.name = name
        self.examples = examples
    }
}