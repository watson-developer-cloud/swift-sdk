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

/// Object Mapper transformations
public class Transformation {
    
    /// Transforms String to Int
    public static let stringToInt = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        // transform value from String? to Int?
        if let x = value {
            return Int(x)
        }
        return nil
        }, toJSON: { (value: Int?) -> String? in
            // transform value from Int? to String?
            if let value = value {
                return String(value)
            }
            return nil
    })
    
    /// Transforms String to Double
    public static let stringToDouble = TransformOf<Double, String>(fromJSON: { (value: String?) -> Double? in
        // transform value from String? to Double?
        if let x = value {
            return Double(x)
        }
        return nil
        }, toJSON: { (value: Double?) -> String? in
            // transform value from Double? to String?
            if let value = value {
                return String(value)
            }
            return nil
    })
    
    /// Transforms AnyObject to Int
    public static let anyObjectToInt = TransformOf<Int, AnyObject>(fromJSON: { (value: AnyObject?) -> Int? in
        // transform value from AnyObject? to Int?
        if let x = value {
            return Int(x as! String)
        }
        return nil
        }, toJSON: { (value: Int?) -> AnyObject? in
            // transform value from Double? to String?
            if let value = value {
                let any:AnyObject = value
                return any
            }
            return nil
    })
}