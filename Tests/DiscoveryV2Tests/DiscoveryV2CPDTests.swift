import XCTest
import Foundation
// Do not import @testable to ensure only public interface is exposed
import DiscoveryV2

class DiscoveryCPDTests: XCTestCase {
    private var discovery: Discovery!
    private var projectID: String!
    private var collectionID: String!
    private let timeout: TimeInterval = 30.0

    // MARK: - Test Configuration

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateDiscovery()
    }

    func instantiateDiscovery() {
        let authenticator = WatsonCloudPakForDataAuthenticator(username: WatsonCredentials.DiscoveryV2CPDUsername, password: WatsonCredentials.DiscoveryV2CPDPassword, url: WatsonCredentials.DiscoveryV2CPDURL)

        authenticator.disableSSLVerification()

        discovery = Discovery(version: "2020-08-12", authenticator: authenticator)

        discovery.serviceURL = WatsonCredentials.DiscoveryV2CPDServiceURL

        discovery.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        discovery.defaultHeaders["X-Watson-Test"] = "true"

        discovery.disableSSLVerification()

        projectID = WatsonCredentials.DiscoveryV2CPDTestProjectID
        collectionID = WatsonCredentials.DiscoveryV2CPDTestCollectionID
    }

    func loadDocument(name: String, ext: String) -> Data? {
        #if os(Linux)
        let url = URL(fileURLWithPath: "Tests/DiscoveryV2Tests/Resources/" + name + "." + ext)
        #else
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: name, withExtension: ext) else { return nil }
        #endif
        let data = try? Data(contentsOf: url)
        return data
    }

    func testAnalyzeDocument() {
            let expectation = self.expectation(description: "analyzeDocument")
            let testDocument = loadDocument(name: "analyzeDocument", ext: "json")

        discovery.analyzeDocument(projectID: projectID, collectionID: collectionID, file: testDocument, filename: "analyzeDocument.json", fileContentType: "application/json"){
                response, error in

                if let error = error {
                    debugPrint(error.localizedDescription)
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }

                guard let result = response?.result else {
                    XCTFail("No response")
                    return
                }

                expectation.fulfill()
            }

            waitForExpectations(timeout: timeout)
        }
}
