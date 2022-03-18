import XCTest

@testable import AssistantV1Tests
@testable import AssistantV2Tests
@testable import DiscoveryV1Tests
@testable import LanguageTranslatorV3Tests
@testable import NaturalLanguageUnderstandingV1Tests

// the following tests are currently disabled becuase
// their dependencies do not build with Swift Package Manager
// @testable import TextToSpeechV1Tests
// @testable import SpeechToTextV1Tests

XCTMain([
    testCase(AssistantTests.allTests),
    testCase(AssistantV1UnitTests.allTests),
    testCase(AssistantV2Tests.allTests),
    testCase(DiscoveryTests.allTests),
    testCase(DiscoveryUnitTests.allTests),
    testCase(LanguageTranslatorTests.allTests),
    testCase(NaturalLanguageUnderstandingTests.allTests),

    // the following tests are currently disabled because their
    // dependencies do not build with Swift Package Manager
    // testCase(TextToSpeechTests.allTests)
    // testCase(SpeechToTextTests.allTests)
])
