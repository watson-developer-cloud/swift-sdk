import XCTest
//@testable import WatsonDeveloperCloudTests
@testable import AlchemyDataNewsV1Tests
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
    testCase(PersonalityInsightsTests.allTests),
    testCase(RelationshipExtractionTests.allTests),
    testCase(RetrieveAndRankTests.allTests),
    testCase(SpeechToTextTests.allTests),
    testCase(TextToSpeechTests.allTests),
    testCase(ToneAnalyzerTests.allTests),
    testCase(TradeoffAnalyticsTests.allTests),
    testCase(VisualRecognitionTests.allTests)
])
