import XCTest

@testable import AlchemyDataNewsV1Tests
@testable import ConversationV1Tests
@testable import DiscoveryV1Tests
@testable import DocumentConversionV1Tests
@testable import LanguageTranslatorV2Tests
@testable import NaturalLanguageClassifierV1Tests
@testable import NaturalLanguageUnderstandingV1Tests
@testable import PersonalityInsightsV3Tests
@testable import RelationshipExtractionV1BetaTests
@testable import RetrieveAndRankV1Tests
@testable import ToneAnalyzerV3Tests
@testable import TradeoffAnalyticsV1Tests
@testable import VisualRecognitionV3Tests

// the following tests are currently disabled becuase
// their dependencies do not build with Swift Package Manager
// @testable import TextToSpeechV1Tests
// @testable import SpeechToTextV1Tests

// the following tests are currently disabled because
// the services are deprecated and will be removed soon
// @testable import AlchemyLanguageV1Tests
// @testable import AlchemyVisionV1Tests
// @testable import DialogV1Tests
// @testable import PersonalityInsightsV2Tests

XCTMain([
    testCase(AlchemyDataNewsTests.allTests),
    testCase(ConversationTests.allTests),
    testCase(DiscoveryTests.allTests),
    testCase(DocumentConversionTests.allTests),
    testCase(LanguageTranslatorTests.allTests),
    testCase(NaturalLanguageClassifierTests.allTests),
    testCase(NaturalLanguageUnderstandingTests.allTests),
    testCase(PersonalityInsightsTests.allTests),
    testCase(RelationshipExtractionTests.allTests),
    testCase(RetrieveAndRankTests.allTests),
    testCase(ToneAnalyzerTests.allTests),
    testCase(TradeoffAnalyticsTests.allTests),
    testCase(VisualRecognitionTests.allTests),

    // the following tests are currently disabled because their
    // dependencies do not build with Swift Package Manager
    // testCase(TextToSpeechTests.allTests)
    // testCase(SpeechToTextTests.allTests)

    // the following tests are currently disabled because
    // the services are deprecated and will be removed soon
    // testCase(AlchemyLanguageTests.allTests),
    // testCase(AlchemyVisionTests.allTests),
    // testCase(DialogV1Tests.allTests),
    // testCase(PersonalityInsightsTests.allTests)
])
