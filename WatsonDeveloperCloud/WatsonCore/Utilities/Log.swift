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
import XCGLogger

/// Singleton Log Helper which uses XCGLogger as its core functionality
/// To change the log level from defaults then update the swift compiler options with -DDEBUG to turn on verbose logging
/// You can temporarily update the otherLogFileLocation to place the log file at your discretion but please do not check it in
public class Log {
    
    // privates
    internal static var fileName = "IBMWatsonLog.txt"
    internal static var consoleLogLevel = XCGLogger.LogLevel.Info
    internal static var fileLogLevel = XCGLogger.LogLevel.Error
    internal static var otherLogFileLocation = ""

    //plist keys
    private static let logfileNameKey = "Logfile name"
    private static let consoleLogLevelKey = "Console log level"
    private static let fileLogLevelKey = "File log level"
    private static let logfileLocationKey = "Logfile location"
    
    /// a shared singleton logger
    public static let sharedLogger: XCGLogger = {
        let instance = XCGLogger()
        instance.xcodeColorsEnabled = true
        instance.xcodeColors = [
            .Verbose: .lightGrey,
            .Debug: .darkGrey,
            .Info: .darkGreen,
            .Warning: .orange,
            .Error: XCGLogger.XcodeColor(fg: UIColor.redColor(), bg: UIColor.whiteColor()),
            .Severe: XCGLogger.XcodeColor(fg: UIColor.whiteColor(), bg: UIColor.redColor())
        ]
        #if Debug
            Log.consoleLogLevel = XCGLogger.LogLevel.Verbose
            Log.fileLogLevel = XCGLogger.LogLevel.Verbose
        #endif

        #if USE_NSLOG // Set via Build Settings, under Other Swift Flags
            instance.removeLogDestination(XCGLogger.constants.baseConsoleLogDestinationIdentifier)
            instance.addLogDestination(XCGNSLogDestination(owner: instance, identifier: XCGLogger.constants.nslogDestinationIdentifier))
            instance.logAppDetails()
        #else
            let docURL = NSURL(fileURLWithPath: Log.fileName, relativeToURL: Log.getLogDirectory())
            instance.setup(Log.consoleLogLevel,
                showThreadName: true,
                showLogLevel: true,
                showFileNames: true,
                showLineNumbers: true,
                writeToFile: docURL,
                fileLogLevel: Log.fileLogLevel)
        #endif
        
        return instance
    }()
    
    
    /**
    Gets the log document directory or uses the user defined log path.  It will append log to either of the locations
    
    - returns: NSURL
    */
    private static func getLogDirectory() -> NSURL {
        
        var logsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
        if(otherLogFileLocation.characters.count > 0) {
            logsPath = NSURL(fileURLWithPath: otherLogFileLocation)
        }
        
        logsPath = logsPath.URLByAppendingPathComponent("logs")
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(logsPath.path!, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        
        return logsPath
    }
}
