import XCTest
//@testable import WatsonDeveloperCloudTests
@testable import AlchemyDataNewsV1Tests
//@testable import AlchemyLanguageV1Tests
//@testable import AlchemyVisionV1Tests   /SwiftSDK/Tests/LinuxMain.swift:5:18: error: no such module 'AlchemyVisionV1Tests'
@testable import ConversationV1Tests
//@testable import DialogV1Tests        /SwiftSDK/Tests/LinuxMain.swift:7:18: error: no such module 'DialogV1Tests'
@testable import DocumentConversionV1Tests
@testable import LanguageTranslatorV2Tests
@testable import NaturalLanguageClassifierV1Tests
//@testable import PersonalityInsightsV2Tests   Fatal error: init(for:) is not yet implemented: file Foundation/Bundle.swift, line 56
@testable import RelationshipExtractionV1BetaTests
//@testable import RetrieveAndRankV1Tests  Fatal error: init(for:) is not yet implemented: file Foundation/Bundle.swift, line 56
//@testable import TextToSpeechV1Tests    /SwiftSDK/Tests/LinuxMain.swift:14:18: error: no such module 'TextToSpeechV1Tests'
@testable import ToneAnalyzerV3Tests
@testable import TradeoffAnalyticsV1Tests
@testable import VisualRecognitionV3Tests

XCTMain([
     //testCase(WatsonDeveloperCloudTests.allTests),
    testCase(AlchemyDataNewsTests.allTests),
//    testCase(AlchemyLanguageTests.allTests),
//    testCase(AlchemyVisionTests.allTests),
    testCase(ConversationTests.allTests),
//    testCase(DialogTests.allTests),
    testCase(DocumentConversionTests.allTests),
    testCase(LanguageTranslatorTests.allTests),
    testCase(NaturalLanguageClassifierTests.allTests),
//    testCase(PersonalityInsightsTests.allTests),
    testCase(RelationshipExtractionTests.allTests),
//    testCase(RetrieveAndRankTests.allTests),   Fatal error: init(for:) is not yet implemented: file Foundation/Bundle.swift, line 56
//    testCase(TextToSpeechTests.allTests),
    testCase(ToneAnalyzerTests.allTests),
    testCase(TradeoffAnalyticsTests.allTests),
//    testCase(VisualRecognitionTests.allTests),
])
