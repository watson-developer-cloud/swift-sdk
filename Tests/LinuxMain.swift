import XCTest

@testable import AssistantV1Tests
@testable import AssistantV2Tests
@testable import ConversationV1Tests
@testable import DiscoveryV1Tests
@testable import LanguageTranslatorV3Tests
@testable import NaturalLanguageClassifierV1Tests
@testable import NaturalLanguageUnderstandingV1Tests
@testable import PersonalityInsightsV3Tests
@testable import ToneAnalyzerV3Tests
@testable import VisualRecognitionV3Tests

// the following tests are currently disabled becuase
// their dependencies do not build with Swift Package Manager
// @testable import TextToSpeechV1Tests
// @testable import SpeechToTextV1Tests

XCTMain([
    testCase(AssistantTests.allTests),
    testCase(AssistantV2Tests.allTests),
    testCase(ConversationTests.allTests),
    testCase(DiscoveryTests.allTests),
    testCase(LanguageTranslatorTests.allTests),
    testCase(NaturalLanguageClassifierTests.allTests),
    testCase(NaturalLanguageUnderstandingTests.allTests),
    testCase(PersonalityInsightsTests.allTests),
    testCase(ToneAnalyzerTests.allTests),
    testCase(VisualRecognitionTests.allTests),

    // the following tests are currently disabled because their
    // dependencies do not build with Swift Package Manager
    // testCase(TextToSpeechTests.allTests)
    // testCase(SpeechToTextTests.allTests)
])
