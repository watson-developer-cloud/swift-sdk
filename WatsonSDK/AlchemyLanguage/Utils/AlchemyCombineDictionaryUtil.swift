//
//  AlchemyCombineDictionaryUtil.swift
//  WatsonSDK
//
//  Created by Ruslan Ardashev on 11/18/15.
//  Copyright © 2015 IBM Watson Developer Cloud. All rights reserved.
//

import Foundation

/** Utility to combine to dictionaries */
final public class AlchemyCombineDictionaryUtil {
    
    public static func combineParameterDictionary(first: [String : String],
        withDictionary second: [String : String]
        ) -> [String : String] {

            var returnDictionary = first

            for (key, value) in second {

                returnDictionary.updateValue(value, forKey: key)

            }

            return returnDictionary

    }


    private init(){}

}
