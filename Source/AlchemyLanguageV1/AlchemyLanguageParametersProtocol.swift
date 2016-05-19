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

protocol AlchemyLanguageParameters {}

extension AlchemyLanguageParameters {
    
    func asDictionary() -> [String : String] {
        
        var returnDictionary = [String : String]()
        
        let mirror = Mirror(reflecting: self)
        
        for property in mirror.children {
            
            if let label = property.label {
                
                let value = property.value
                let unwrappedValueAsString = "\(unwrap(value))"
                
                if unwrappedValueAsString != "" {
                    
                    returnDictionary.updateValue("\(unwrappedValueAsString)", forKey: label)
                    
                }
                
            }
            
        }
        
        return returnDictionary
        
    }
    
    // Reference [1]
    func unwrap(any:Any) -> Any {
        
        let mi = Mirror(reflecting: any)
        if mi.displayStyle != .Optional {
            return any
        }
        
        if mi.children.count == 0 { return NSNull() }
        let (_, some) = mi.children.first!
        return some
        
    }
    
}

// REFERENCES
// [1] http://stackoverflow.com/questions/27989094/how-to-unwrap-an-optional-value-from-any-type
