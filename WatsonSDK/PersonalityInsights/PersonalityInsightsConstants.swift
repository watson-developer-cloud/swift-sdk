//
//  LanguageTranslationConstants.swift
//  LanguageTranslation
//
//  Created by Karl Weinmeister on 10/5/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import Foundation

/**
 *  Constants used by the PersonalityInsights service
 */
public struct PersonalityInsightsConstants {

    //Defaults
    static let defaultLanguage = "en"
    static let defaultAcceptLanguage = "en"

    //Request parameters
    static let language = "language"
    static let acceptLanguage = "acceptLanguage"
    static let includeRaw = "include_raw"
    static let text = "text"
    static let contentItems = "contentItems"
}