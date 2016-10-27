//
//  Emotions.swift
//  WatsonDeveloperCloud
//
//  Created by Harrison Saylor on 5/26/16.
//  Copyright © 2016 Glenn R. Fisher. All rights reserved.
//

import Foundation
import RestKit

/**
 Emotions and their prevalence extracted from a document
 */
public struct Emotions: JSONDecodable {
    /** amount of anger extracted */
    public let anger: Double?
    /** amount of disgust extracted */
    public let disgust: Double?
    /** amount of fear extracted */
    public let fear: Double?
    /** amount of joy extracted */
    public let joy: Double?
    /** amount of sadness extracted */
    public let sadness: Double?
    
    /// Used internally to initialize a Emotions object
    public init(json: JSON) throws {
        if let angerString = try? json.getString(at: "anger") {
            anger = Double(angerString)
        } else {
            anger = nil
        }
        if let disgustString = try? json.getString(at: "disgust") {
            disgust = Double(disgustString)
        } else {
            disgust = nil
        }
        if let fearString = try? json.getString(at: "fear") {
            fear = Double(fearString)
        } else {
            fear = nil
        }
        if let joyString = try? json.getString(at: "joy") {
            joy = Double(joyString)
        } else {
            joy = nil
        }
        if let sadnessString = try? json.getString(at: "sadness") {
            sadness = Double(sadnessString)
        } else {
            sadness = nil
        }
    }
}
