//
//  NLCConstants.swift
//  NaturalLanguageClassifier
//
//  Created by Vincent Herrin on 11/9/15.
//  Copyright © 2015 IBM. All rights reserved.
//

import Foundation

public class NLCConstants {
  
  static let serviceURL = "/natural-language-classifier/api"
  
  static let text = "text"
  static let classifiers = "classifiers"
  static let classifier = "classifier"
  static let v1ClassifiersURI = "/v1/classifiers"
  
  public enum TrainerProperty: String {
    case Language     = "language"
    case Name         = "name"
    case TrainingMeta = "training_metadata"
    case TrainingData = "training_data"
  }
  
}

