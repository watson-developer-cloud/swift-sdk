//
//  Files.swift
//  WatsonCore
//
//  Created by Vincent Herrin on 10/14/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation

public class Files {
    
    /**
    This method supports reading properties files which provide information such as username and password strings.
    */
    public static func readProperties(filename: String) -> NSDictionary? {
        var myDict: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        else {
            Log.sharedLogger.info("Cannot read plist file: \(filename)")
        }
        return myDict
    }
}