//
//  TranslationModelStatus.swift
//  WatsonDeveloperCloud
//
//  Created by Glenn Fisher on 4/7/16.
//  Copyright © 2016 Glenn R. Fisher. All rights reserved.
//

import Foundation

/** The status of a translation model. */
public enum TrainingStatus: String {

    /// Training has completed and this translation model is
    /// ready for use with the Language Translation service.
    case Available = "available"

    /// Training is still in progress.
    case Training = "training"

    /// Training did not complete because of an error.
    case Error = "error"
}
