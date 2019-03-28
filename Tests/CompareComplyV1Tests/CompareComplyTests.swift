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

    var contractAFile: Data!
    var contractBFile: Data!
    var testTableFile: Data!

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
            ("testClassifyElements", testClassifyElements),
            ("testExtractTables", testExtractTables),
            ("testCompareDocuments", testCompareDocuments),
            ("testFeedbackOperations", testFeedbackOperations),
            ("testBatchOperations", testBatchOperations),
        ]
    }

    /** Instantiate CompareComply. */
    func instantiateCompareComply() {
        let version = "2018-11-15"
        compareComply = CompareComply(version: version, apiKey: WatsonCredentials.CompareComplyV1APIKey)
        if let url = WatsonCredentials.CompareComplyURL {
            compareComply.serviceURL = url
        }
        compareComply.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        compareComply.defaultHeaders["X-Watson-Test"] = "true"
        compareComply.defaultHeaders["x-watson-metadata"] = "customer_id=sdk-test-customer-id"
    }

    func loadDocument(name: String, ext: String) -> Data? {
        #if os(Linux)
        let url = URL(fileURLWithPath: "Tests/CompareComplyV1Tests/Resources/" + name + "." + ext)
        #else
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: name, withExtension: ext) else { return nil }
        #endif
        let data = try? Data(contentsOf: url)
        return data
    }

    func waitForExpectations(timeout: TimeInterval = 20.0) {
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

        compareComply.convertToHTML(
            file: file,
            filename: "contract_A.pdf") {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let result = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }

                XCTAssertNotNil(result.numPages)
                if let numPages = result.numPages,
                    let numberOfPages = Int(numPages) {
                    XCTAssert(numberOfPages == 4)
                }
                XCTAssertNotNil(result.title)
                if let title = result.title {
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
            fileContentType: "application/pdf") {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let result = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }

                XCTAssertNotNil(result.contractAmounts)
                XCTAssertNotNil(result.document)
                XCTAssertNotNil(result.document?.title)
                XCTAssertNotNil(result.documentStructure)
                XCTAssertNotNil(result.elements)
                XCTAssertNotNil(result.modelID)
                XCTAssertNotNil(result.modelVersion)
                XCTAssertNotNil(result.parties)

                if let title = result.document?.title {
                    XCTAssert(title.contains("contract_A"))
                }
                if let modelID = result.modelID {
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
            fileContentType: "application/pdf") {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let result = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }

                XCTAssertNotNil(result.document)
                XCTAssertNotNil(result.modelID)
                XCTAssertNotNil(result.tables)

                if let tableCells = result.tables?[0].bodyCells {
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
            file1ContentType: "application/pdf",
            file2ContentType: "application/pdf",
            file1Label: "contract_a",
            file2Label: "contract_b") {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let result = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }

                XCTAssertNotNil(result.alignedElements)
                XCTAssertNotNil(result.unalignedElements)
                XCTAssertNotNil(result.documents)
                XCTAssertNotNil(result.modelID)

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
            provenanceIDs: ["85f5981a-ba91-44f5-9efa-0bd22e64b7bc", "ce0480a1-5ef1-4c3e-9861-3743b5610795"]
        )
        let originalType2 = TypeLabel(
            label: Label(nature: "Exclusion", party: "End User"),
            provenanceIDs: ["85f5981a-ba91-44f5-9efa-0bd22e64b7bc", "ce0480a1-5ef1-4c3e-9861-3743b5610795"]
        )
        let originalCategory1 = CompareComplyV1.Category(
            label: "Responsibilities",
            provenanceIDs: []
        )
        let originalCategory2 = CompareComplyV1.Category(
            label: "Amendments",
            provenanceIDs: []
        )
        let originalLabels = OriginalLabelsIn(types: [originalType1, originalType2], categories: [originalCategory1, originalCategory2])

        let updatedType1 = TypeLabel(
            label: Label(nature: "Obligation", party: "IBM"),
            provenanceIDs: nil
        )
        let updatedType2 = TypeLabel(
            label: Label(nature: "Disclaimer", party: "Buyer"),
            provenanceIDs: nil
        )
        let updatedCategory1 = CompareComplyV1.Category(
            label: "Responsibilities",
            provenanceIDs: nil
        )
        let updatedCategory2 = CompareComplyV1.Category(
            label: "Audits",
            provenanceIDs: nil
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

        var newFeedbackID: String!
        let userID = "Anthony"
        let myComment = "Compare and Comply is the best!"
        compareComply.addFeedback(
            feedbackData: feedbackDataInput,
            userID: userID,
            comment: myComment) {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let result = response?.result, let feedbackID = result.feedbackID else {
                    XCTFail(missingResultMessage)
                    return
                }

                XCTAssertEqual(result.comment, myComment)
                XCTAssertEqual(result.userID, userID)

                newFeedbackID = feedbackID

                expectation1.fulfill()
        }
        waitForExpectations()


        let expectation2 = self.expectation(description: "Get feedback")
        compareComply.getFeedback(
            feedbackID: newFeedbackID) {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let result = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }

                XCTAssertEqual(result.comment, myComment)

                expectation2.fulfill()
        }
        waitForExpectations()


        let expectation3 = self.expectation(description: "List feedback")
        compareComply.listFeedback() {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            guard let result = response?.result, let feedback = result.feedback else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssert(feedback.count > 0)

            expectation3.fulfill()
        }
        waitForExpectations()


        let expectation4 = self.expectation(description: "Delete feedback")
        compareComply.deleteFeedback(
            feedbackID: newFeedbackID) {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let result = response?.result, let status = result.status else {
                    XCTFail(missingResultMessage)
                    return
                }

                XCTAssertEqual(status, 200)

                expectation4.fulfill()
        }
        waitForExpectations()
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
            outputBucketName: "compare-comply-integration-test-bucket-output") {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let batch = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }

                XCTAssertNotNil(batch.batchID)
                batchID = batch.batchID
                expectation1.fulfill()
        }

        waitForExpectations()

        let expectation2 = self.expectation(description: "Get batch")

        var firstUpdated: Date!
        compareComply.getBatch(batchID: batchID) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let batch = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertNotNil(batch.batchID)
            guard let updated = batch.updated else {
                XCTFail("Unknown last updated date for batch \(String(describing: batchID))")
                return
            }
            firstUpdated = updated

            expectation2.fulfill()
        }

        waitForExpectations()

        let expectation3 = self.expectation(description: "Update batch")

        compareComply.updateBatch(
            batchID: batchID,
            action: "rescan") {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let batch = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }

                guard let lastUpdated = batch.updated else {
                    XCTFail("Unknown last updated date for batch \(String(describing: batchID))")
                    return
                }
                XCTAssert(lastUpdated.compare(firstUpdated) == ComparisonResult.orderedDescending)

                expectation3.fulfill()
        }

        waitForExpectations()

        let expectation4 = self.expectation(description: "List batches")

        compareComply.listBatches() {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let response = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

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
