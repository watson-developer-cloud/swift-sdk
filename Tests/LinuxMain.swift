import XCTest
//@testable import WatsonDeveloperCloudTests
@testable import AlchemyDataNewsV1Tests
@testable import AlchemyLanguageV1
@testable import AlchemyVisionV1
@testable import ConversationV1
@testable import DialogV1
@testable import DocumentConversionV1
@testable import LanguageTranslatorV2
@testable import NaturalLanguageClassifierV1
@testable import PersonalityInsightsV2Tests
@testable import RelationshipExtractionV1BetaTests
@testable import RetrieveAndRankV1Tests
@testable import SpeechToTextV1Tests
@testable import TextToSpeechV1Tests
@testable import ToneAnalyzerV3Tests
@testable import TradeoffAnalyticsV1Tests
@testable import VisualRecognitionV3Tests

XCTMain([
     //testCase(WatsonDeveloperCloudTests.allTests),
    testCase(AlchemyDataNewsTests.allTests),
    testCase(AlchemyLanguageTests.allTests),
    testCase(AlchemyVisionTests.allTests),
    testCase(ConversationTests.allTests),
    testCase(DialogTests.allTests),
    testCase(DocumentConversionTests.allTests),
    testCase(LanguageTranslatorTests.allTests),
    testCase(NaturalLanguageClassifierTests.allTests),
    testCase(PersonalityInsightsTests.allTests),
    testCase(RelationshipExtractionTests.allTests),
    testCase(RetrieveAndRankTests.allTests),
    testCase(SpeechToTextTests.allTests),
    testCase(TextToSpeechTests.allTests),
    testCase(ToneAnalyzerTests.allTests),
    testCase(TradeoffAnalyticsTests.allTests),
    testCase(VisualRecognitionTests.allTests)
])
