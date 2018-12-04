/**
 * Copyright IBM Corporation 2018
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import XCTest
import Foundation
import CompareComplyV1
import RestKit

class CompareComplyTests: XCTestCase {

    private var compareComply: CompareComply!

    var contractAFile: URL!
    var contractBFile: URL!
    var testTableFile: URL!

    // MARK: - Test Configuration

    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateCompareComply()

        contractAFile = loadDocument(name: "contract_A", ext: "pdf")
        contractBFile = loadDocument(name: "contract_B", ext: "pdf")
        testTableFile = loadDocument(name: "TestTable", ext: "pdf")
    }

    static var allTests: [(String, (CompareComplyTests) -> () throws -> Void)] {
        return [
            ("testConvertToHtml", testConvertToHtml),
        ]
    }

    /** Instantiate CompareComply. */
    func instantiateCompareComply() {
        let version = "2018-11-15"
//        compareComply = CompareComply(version: version, apiKey: WatsonCredentials.CompareComplyV1APIKey, iamUrl: "https://iam.stage1.bluemix.net/identity/token")
        compareComply = CompareComply(version: version, apiKey: WatsonCredentials.CompareComplyV1APIKey)
        if let url = WatsonCredentials.CompareComplyURL {
            compareComply.serviceURL = url
        }
        compareComply.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        compareComply.defaultHeaders["X-Watson-Test"] = "true"
    }

    func loadDocument(name: String, ext: String) -> URL? {
        #if os(Linux)
        let url = URL(fileURLWithPath: "Tests/CompareComplyV1Tests/" + name + "." + ext)
        #else
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: name, withExtension: ext) else { return nil }
        #endif
        return url
    }

    /** Fail false negatives. */
    func failWithError(error: Error) {
        XCTFail("Positive test failed with error: \(error)")
    }

    /** Fail false positives. */
    func failWithResult<T>(result: T) {
        XCTFail("Negative test returned a result.")
    }

    /** Fail false positives. */
    func failWithResult() {
        XCTFail("Negative test returned a result.")
    }

    /** Wait for expectations. */
    func waitForExpectations(timeout: TimeInterval = 30.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    func testConvertToHtml() {
        let expectation = self.expectation(description: "convert PDF document to HTML")

        guard let file = loadDocument(name: "contract_A", ext: "pdf") else {
            XCTFail("Failed to load test file")
            return
        }

        compareComply.convertToHtml(
            file: file,
            modelID: nil,
            fileContentType: nil,
            failure: failWithError) {
                response in

                XCTAssertNotNil(response.numPages)
                if let numPages = response.numPages,
                    let numberOfPages = Int(numPages) {
                    XCTAssert(numberOfPages == 4)
                }
                XCTAssertNotNil(response.title)
                if let title = response.title {
                    XCTAssert(title.contains("contract_A"))
                }
                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testClassifyElements() {
        let expectation = self.expectation(description: "Classify elements")

        compareComply.classifyElements(
            file: contractAFile,
            modelID: nil,
            failure: failWithError) {
                response in

                XCTAssertNotNil(response.contractAmounts)
                XCTAssertNotNil(response.document)
                XCTAssertNotNil(response.document?.title)
                XCTAssertNotNil(response.documentStructure)
                XCTAssertNotNil(response.elements)
                XCTAssertNotNil(response.modelID)
                XCTAssertNotNil(response.modelVersion)
                XCTAssertNotNil(response.parties)

                if let title = response.document?.title {
                    XCTAssert(title.contains("contract_A"))
                }
                if let modelID = response.modelID {
                    XCTAssertEqual(modelID, "contracts")
                }

                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testExtractTables() {
        let expectation = self.expectation(description: "Extract tables")

        compareComply.extractTables(
            file: testTableFile,
            modelID: nil,
            fileContentType: "application/pdf",
            failure: failWithError) {
                response in

                XCTAssertNotNil(response.document)
                XCTAssertNotNil(response.modelID)
                XCTAssertNotNil(response.tables)

                if let tableCells = response.tables?[0].bodyCells {
                    XCTAssertEqual(tableCells.count, 28)
                }

                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testCompareDocuments() {
        let expectation = self.expectation(description: "Compare documents")

        compareComply.compareDocuments(
            file1: contractAFile,
            file2: contractBFile,
            file1Label: "contract_a",
            file2Label: "contract_b",
            modelID: nil,
            file1ContentType: "application/pdf",
            file2ContentType: "application/pdf",
            failure: failWithError) {
                response in

                XCTAssertNotNil(response.alignedElements)
                XCTAssertNotNil(response.unalignedElements)
                XCTAssertNotNil(response.documents)
                XCTAssertNotNil(response.modelID)

                if let alignedElements = response.alignedElements {
                    XCTAssertEqual(alignedElements.count, 34)
                }
                if let unalignedElements = response.unalignedElements {
                    XCTAssertEqual(unalignedElements.count, 34)
                }

                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListFeedback() {
        let expectation = self.expectation(description: "List feedback")

        compareComply.listFeedback(failure: failWithError) {
            response in

            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testFeedbackOperations() {
        let expectation1 = self.expectation(description: "Add feedback")

        let location = Location(begin: 0, end: 1)
        let text = """
                    1. IBM will provide a Senior Managing Consultant / expert resource, for up to 80 hours, to assist
                    Florida Power & Light (FPL) with the creation of an IT infrastructure unit cost model for existing
                    infrastructure."
                    """

        let originalType1 = TypeLabel(
            label: Label(nature: "Obligation", party: "IBM"),
            provenanceIds: ["85f5981a-ba91-44f5-9efa-0bd22e64b7bc", "ce0480a1-5ef1-4c3e-9861-3743b5610795"]
        )
        let originalType2 = TypeLabel(
            label: Label(nature: "Exclusion", party: "End User"),
            provenanceIds: ["85f5981a-ba91-44f5-9efa-0bd22e64b7bc", "ce0480a1-5ef1-4c3e-9861-3743b5610795"]
        )
        let originalCategory1 = CompareComplyV1.Category(
            label: "Responsibilities",
            provenanceIds: []
        )
        let originalCategory2 = CompareComplyV1.Category(
            label: "Amendments",
            provenanceIds: []
        )
        let originalLabels = OriginalLabelsIn(types: [originalType1, originalType2], categories: [originalCategory1, originalCategory2])

        let updatedType1 = TypeLabel(
            label: Label(nature: "Obligation", party: "IBM"),
            provenanceIds: nil
        )
        let updatedType2 = TypeLabel(
            label: Label(nature: "Disclaimer", party: "Buyer"),
            provenanceIds: nil
        )
        let updatedCategory1 = CompareComplyV1.Category(
            label: "Responsibilities",
            provenanceIds: nil
        )
        let updatedCategory2 = CompareComplyV1.Category(
            label: "Audits",
            provenanceIds: nil
        )
        let updatedLabels = UpdatedLabelsIn(types: [updatedType1, updatedType2], categories: [updatedCategory1, updatedCategory2])

        let document = ShortDoc(title: "Super important document", hash: nil)
        let modelID = "contracts"
        let modelVersion = "11.00"

        let feedbackDataInput = FeedbackDataInput(
            feedbackType: "element_classification",
            location: location,
            text: text,
            originalLabels: originalLabels,
            updatedLabels: updatedLabels,
            document: document,
            modelID: modelID,
            modelVersion: modelVersion)

        compareComply.addFeedback(
            feedbackData: feedbackDataInput,
            userID: "Anthony",
            comment: "Compare and Comply is the best!",
            failure: failWithError) {
                response in

                expectation1.fulfill()
        }

        waitForExpectations()

//        let expectation2 = self.expectation(description: "Get feedback")
//
//        compareComply.getFeedback(
//            feedbackID: <#T##String#>,
//            modelID: modelID,
//            failure: failWithError) {
//                response in
//
//                expectation2.fulfill()
//        }
//
//        waitForExpectations()
//
//        let expectation3 = self.expectation(description: "Delete feedback")
//
//        compareComply.deleteFeedback(
//            feedbackID: <#T##String#>,
//            modelID: modelID,
//            failure: failWithError) {
//                response in
//
//                expectation3.fulfill()
//        }
//
//        waitForExpectations()
    }

    func testBatchOperations() {
        guard let credentialsInput = loadDocument(name: "cloud-object-storage-credentials-input", ext: "json"),
            let credentialsOutput = loadDocument(name: "cloud-object-storage-credentials-output", ext: "json") else {
                XCTFail("Failed to load Cloud Object Storage credentials")
                return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let expectation1 = self.expectation(description: "Create batch")

        var batchID: String!
        let bucketLocation = "us-south"
        compareComply.createBatch(
            function: BatchStatus.Function.elementClassification.rawValue,
            inputCredentialsFile: credentialsInput,
            inputBucketLocation: bucketLocation,
            inputBucketName: "compare-comply-integration-test-bucket-input",
            outputCredentialsFile: credentialsOutput,
            outputBucketLocation: bucketLocation,
            outputBucketName: "compare-comply-integration-test-bucket-output",
            failure: failWithError) {
                response in

                XCTAssertNotNil(response.batchID)
                batchID = response.batchID
                expectation1.fulfill()
        }

        waitForExpectations()

        let expectation2 = self.expectation(description: "Get batch")

        var firstUpdated: Date!
        compareComply.getBatch(batchID: batchID, failure: failWithError) {
            response in

            XCTAssertNotNil(response.batchID)
            guard let updated = response.updated else {
                XCTFail("Unknown last updated date for batch \(String(describing: batchID))")
                return
            }
            firstUpdated = dateFormatter.date(from: updated)

            expectation2.fulfill()
        }

        waitForExpectations()

        let expectation3 = self.expectation(description: "Update batch")

        compareComply.updateBatch(
            batchID: batchID,
            action: "rescan",
            failure: failWithError) {
                response in

                guard let updated = response.updated else {
                    XCTFail("Unknown last updated date for batch \(String(describing: batchID))")
                    return
                }
                let lastUpdated = dateFormatter.date(from: updated)
                XCTAssert(lastUpdated?.compare(firstUpdated) == ComparisonResult.orderedDescending)

                expectation3.fulfill()
        }

        waitForExpectations()

        let expectation4 = self.expectation(description: "List batches")

        compareComply.listBatches(failure: failWithError) {
            response in

            guard let batches = response.batches else {
                XCTFail("Failed to get list of batches")
                return
            }
            XCTAssert(batches.count > 0)
            let originalBatch = batches.first(where: {
                batchStatus in

                batchStatus.batchID == batchID
            })
            XCTAssertNotNil(originalBatch)

            expectation4.fulfill()
        }

        waitForExpectations()

    }
}
