import XCTest
@testable import AlchemyDataNewsV1Tests
@testable import ConversationV1Tests
@testable import DiscoveryV1Tests
@testable import DocumentConversionV1Tests
@testable import LanguageTranslatorV2Tests
@testable import NaturalLanguageClassifierV1Tests
@testable import PersonalityInsightsV3Tests
@testable import RelationshipExtractionV1BetaTests
@testable import RetrieveAndRankV1Tests
@testable import ToneAnalyzerV3Tests
@testable import TradeoffAnalyticsV1Tests
@testable import VisualRecognitionV3Tests

XCTMain([
    testCase(AlchemyDataNewsTests.allTests),
    testCase(ConversationTests.allTests),
    testCase(DiscoveryTests.allTests),
    testCase(DocumentConversionTests.allTests),
    testCase(LanguageTranslatorTests.allTests),
    testCase(NaturalLanguageClassifierTests.allTests),
    testCase(PersonalityInsightsTests.allTests),
    testCase(RelationshipExtractionTests.allTests),
    testCase(RetrieveAndRankTests.allTests),
    testCase(ToneAnalyzerTests.allTests),
    testCase(TradeoffAnalyticsTests.allTests),
    testCase(VisualRecognitionTests.allTests),
])
