//
//  MultipartFormData.swift
//  WatsonDeveloperCloud
//
//  Created by Glenn Fisher on 10/31/16.
//  Copyright © 2016 Glenn R. Fisher. All rights reserved.
//

import Foundation


public class MultipartFormData {
    
    public var contentType: String { return "multipart/form-data; boundary=\(boundary)" }
    // add contentLength?
    
    private let boundary: String
    private var bodyParts = [BodyPart]()
    
    private var initialBoundary: Data {
        let boundary = "--\(self.boundary)\r\n"
        return boundary.data(using: .utf8, allowLossyConversion: false)!
    }
    
    private var encapsulatedBoundary: Data {
        let boundary = "\r\n--\(self.boundary)\r\n"
        return boundary.data(using: .utf8, allowLossyConversion: false)!
    }
    
    private var finalBoundary: Data {
        let boundary = "\r\n--\(self.boundary)--\r\n"
        return boundary.data(using: .utf8, allowLossyConversion: false)!
    }
    
    public init() {
        self.boundary = "watson-apis.boundary.bd0b4c6e3b9c2126"
    }
    
    public func append(_ data: Data, withName: String, mimeType: String? = nil, fileName: String? = nil) {
        let bodyPart = BodyPart(key: withName, data: data, mimeType: mimeType, fileName: fileName)
        bodyParts.append(bodyPart)
    }
    
    public func append(_ fileURL: URL, withName: String, mimeType: String? = nil) {
        if let data = try? Data.init(contentsOf: fileURL) {
            let bodyPart = BodyPart(key: withName, data: data, mimeType: mimeType, fileName: fileURL.lastPathComponent)
            bodyParts.append(bodyPart)
        }
    }
    
    public func toData() throws -> Data {
        var data = Data()
        for (index, bodyPart) in bodyParts.enumerated() {
            let bodyBoundary: Data
            if index == 0 {
                bodyBoundary = initialBoundary
            } else if index != 0 {
                bodyBoundary = encapsulatedBoundary
            } else {
                throw RestError.encodingError
            }
            
            data.append(bodyBoundary)
            data.append(try bodyPart.content())
        }
        
        data.append(finalBoundary)
        
        return data
    }
}

public struct BodyPart {
    
    private(set) var key: String
    private(set) var data: Data
    private(set) var mimeType: String?
    private(set) var fileName: String?
    
    public init?(key: String, value: Any) {
        let string = String(describing: value)
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        
        self.key = key
        self.data = data
    }
    
    public init(key: String, data: Data, mimeType: String? = nil, fileName: String? = nil) {
        self.key = key
        self.data = data
        self.mimeType = mimeType
        self.fileName = fileName
    }
    
    private var header: String {
        var header = "Content-Disposition: form-data; name=\"\(key)\""
        if let fileName = fileName {
            header += "; filename=\"\(fileName)\""
        }
        if let mimeType = mimeType {
            header += "\r\nContent-Type: \(mimeType)"
        }
        header += "\r\n\r\n"
        return header
    }
    
    public func content() throws -> Data {
        var result = Data()
        let headerString = header
        guard let header = headerString.data(using: .utf8) else {
            throw RestError.encodingError
        }
        result.append(header)
        result.append(data)
        return result
    }
}
