//
//  ObjectMapperExtension.swift
//  WatsonSDK
//
//  Created by Glenn Fisher on 11/20/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation
import ObjectMapper

extension Mapper {
    
    /// Maps an Object to a JSON string with the given header
    func toJSONString(object: N, header: String) -> String? {
        let json = toJSONString(object)
        if let json = json {
            return "{ \"\(header)\": \(json) }"
        } else {
            return nil
        }
    }
    
    /// Maps an array of Objects to a JSON string with the given header
    func toJSONString(objects: [N], header: String) -> String? {
        let json = toJSONString(objects)
        if let json = json {
            return "{ \"\(header)\": \(json) }"
        } else {
            return nil
        }
    }
    
    /// Maps an Object to a JSON string and represents it as NSData
    func toJSONData(object: N) -> NSData? {
        let json = toJSONString(object)
        return json?.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    /// Maps an array of Objects to a JSON string and represents it as NSData
    func toJSONData(objects: [N]) -> NSData? {
        let json = toJSONString(objects)
        return json?.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    /// Maps an Object to a JSON string with the given header and represents it as NSData
    func toJSONData(object: N, header: String) -> NSData? {
        let json = toJSONString(object, header: header)
        return json?.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    /// Maps an array of Objects to a JSON string with the given header and represents it as NSData
    func toJSONData(objects: [N], header: String) -> NSData? {
        let json = toJSONString(objects, header: header)
        return json?.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
}