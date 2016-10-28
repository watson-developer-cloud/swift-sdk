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

XCTMain([
     //testCase(WatsonDeveloperCloudTests.allTests),
    testCase(AlchemyDataNewsTests.allTests),
    testCase(AlchemyLanguageTests.allTests),
    testCase(AlchemyVisionTests.allTests),
    testCase(ConversationTests.allTests),
    testCase(DialogTests.allTests),
    testCase(DocumentConversionTests.allTests),
    testCase(LanguageTranslatorTests.allTests),
    testCase(NaturalLanguageClassifierTests.allTests)
    ])
