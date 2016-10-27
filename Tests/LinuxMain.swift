import XCTest
//@testable import WatsonDeveloperCloudTests
@testable import AlchemyDataNewsV1Tests
@testable import VisualRecognitionV3Tests

XCTMain([
     //testCase(WatsonDeveloperCloudTests.allTests),
    testCase(AlchemyDataNewsTests.allTests),
    testCase(VisualRecognitionTests.allTests)
])
