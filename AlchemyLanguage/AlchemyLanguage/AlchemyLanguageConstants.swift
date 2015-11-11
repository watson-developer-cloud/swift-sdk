/**
 * Copyright 2015 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import WatsonCore

public final class AlchemyLanguageConstants {
    
    // static methods
    static private func Calls() -> String { return "/calls" }

    // use this, it already uses Calls()
    static private func Prefix(fromRequestType requestType: AlchemyLanguage.RequestType) -> String {
        
        switch requestType {
            
        case .URL: return Calls() + "/url/URL"
        case .HTML: return Calls() + "/html/HTML"
        case .Text: return Calls() + "/text/Text"
            
        }
        
    }
    
    // instance methods - should not be called
    private init(){}
    
}

// MARK: Entity Extraction
public extension AlchemyLanguageConstants {

    public static func GetEntities(fromRequestType requestType: AlchemyLanguage.RequestType) -> String {
        
        return Prefix(fromRequestType: requestType) + "GetRankedNameEntities"
        
    }

}


// MARK: Sentiment Analysis
public extension AlchemyLanguageConstants {
    
    public static func GetTextSentiment(fromRequestType requestType: AlchemyLanguage.RequestType) -> String {
        
        return Prefix(fromRequestType: requestType) + "GetTextSentiment"
        
    }
    
    public static func GetTargetedSentiment(fromRequestType requestType: AlchemyLanguage.RequestType) -> String {
        
        return Prefix(fromRequestType: requestType) + "GetTargetedSentiment"
        
    }
    
}


// MARK: Keyword Extraction
public extension AlchemyLanguageConstants {
    
    public static func GetRankedKeywords(fromRequestType requestType: AlchemyLanguage.RequestType) -> String {
        
        return Prefix(fromRequestType: requestType) + "GetRankedKeywords"
        
    }
    
}


// MARK: Concept Tagging
public extension AlchemyLanguageConstants {
    
    public static func GetRankedConcepts(fromRequestType requestType: AlchemyLanguage.RequestType) -> String {
        
        return Prefix(fromRequestType: requestType) + "GetRankedConcepts"
        
    }
    
}


// MARK: Relation Extraction
public extension AlchemyLanguageConstants {
    
    public static func GetRelations(fromRequestType requestType: AlchemyLanguage.RequestType) -> String {
        
        return Prefix(fromRequestType: requestType) + "GetRelations"
        
    }
    
}


// MARK: Taxonomy Classification
public extension AlchemyLanguageConstants {
    
    public static func GetRankedTaxonomy(fromRequestType requestType: AlchemyLanguage.RequestType) -> String {
        
        return Prefix(fromRequestType: requestType) + "GetRankedTaxonomy"
        
    }
    
}


// MARK: Author Extraction
public extension AlchemyLanguageConstants {
    
    public static func GetAuthor(fromRequestType requestType: AlchemyLanguage.RequestType) -> String {
        
        guard requestType != AlchemyLanguage.RequestType.Text else {
            // TODO: XCLogger-print
            print("AlchemyLanguageConstants: GetAuthor: Text request is unsupported.")
            return ""
        }
        
        return Prefix(fromRequestType: requestType) + "GetAuthor"
        
    }
    
}


// MARK: Language Detection
public extension AlchemyLanguageConstants {
    
    public static func GetLanguage(fromRequestType requestType: AlchemyLanguage.RequestType) -> String {
        
        return Prefix(fromRequestType: requestType) + "GetLanguage"
        
    }
    
}


// MARK: Text Extraction
public extension AlchemyLanguageConstants {
    
    public static func GetText(fromRequestType requestType: AlchemyLanguage.RequestType) -> String {
        
        guard requestType != AlchemyLanguage.RequestType.Text else {
            // TODO: XCLogger-print
            print("AlchemyLanguageConstants: GetText: Text request is unsupported.")
            return ""
        }
        
        return Prefix(fromRequestType: requestType) + "GetText"
        
    }
    
    public static func GetRawText(fromRequestType requestType: AlchemyLanguage.RequestType) -> String {
        
        guard requestType != AlchemyLanguage.RequestType.Text else {
            // TODO: XCLogger-print
            print("AlchemyLanguageConstants: GetRawText: Text request is unsupported.")
            return ""
        }
        
        return Prefix(fromRequestType: requestType) + "GetRawText"
        
    }
    
    public static func GetTitle(fromRequestType requestType: AlchemyLanguage.RequestType) -> String {
        
        guard requestType != AlchemyLanguage.RequestType.Text else {
            // TODO: XCLogger-print
            print("AlchemyLanguageConstants: GetTitle: Text request is unsupported.")
            return ""
        }
        
        return Prefix(fromRequestType: requestType) + "GetTitle"
        
    }
    
}


// MARK: Microformats Parsing
public extension AlchemyLanguageConstants {
    
    public static func GetMicroformatData(fromRequestType requestType: AlchemyLanguage.RequestType) -> String {
        
        guard requestType != AlchemyLanguage.RequestType.Text else {
            // TODO: XCLogger-print
            print("AlchemyLanguageConstants: GetMicroformatData: Text request is unsupported.")
            return ""
        }
        
        return Prefix(fromRequestType: requestType) + "GetMicroformatData"
        
    }
    
}


// MARK: Feed Detection
public extension AlchemyLanguageConstants {
    
    public static func GetFeedLinks(fromRequestType requestType: AlchemyLanguage.RequestType) -> String {
        
        guard requestType != AlchemyLanguage.RequestType.Text else {
            // TODO: XCLogger-print
            print("AlchemyLanguageConstants: GetFeedLinks: Text request is unsupported.")
            return ""
        }
        
        return Prefix(fromRequestType: requestType) + "GetFeedLinks"
        
    }
    
}
