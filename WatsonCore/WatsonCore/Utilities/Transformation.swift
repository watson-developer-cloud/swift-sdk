//
//  Transformation.swift
//  WatsonCore
//
//  Created by Karl Weinmeister on 10/29/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation
import ObjectMapper
public class Transformation {
  
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
}