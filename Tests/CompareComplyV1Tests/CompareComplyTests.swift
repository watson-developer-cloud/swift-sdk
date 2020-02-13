/**
 * (C) Copyright IBM Corp. 2018, 2020.
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

class CompareComplyTests: XCTestCase {

    private var compareComply: CompareComply!

    var contractAPDFFile: Data!
    var contractAPNGFile: Data!
    var contractAJPGFile: Data!
    var contractABMPFile: Data!
    var contractAGIFFile: Data!
    var contractATIFFFile: Data!
    var contractADOCXFile: Data!
    var contractADOCFile: Data!
    var contractBFile: Data!
    var testTablePNGFile: Data!
    var testTablePDFFile: Data!
    var testTableJPGFile: Data!
    var testTableBMPFile: Data!
    var testTableGIFFile: Data!
    var testTableTIFFFile: Data!
    var testTableDOCXFile: Data!
    var testTableDOCFile: Data!

    // MARK: - Test Configuration

    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateCompareComply()

        contractAPDFFile = loadDocument(name: "Contract_A", ext: "pdf")
        contractAPNGFile = loadDocument(name: "Contract_A", ext: "png")
        contractAJPGFile = loadDocument(name: "Contract_A", ext: "jpg")
        contractABMPFile = loadDocument(name: "Contract_A", ext: "bmp")
        contractAGIFFile = loadDocument(name: "Contract_A", ext: "gif")
        contractATIFFFile = loadDocument(name: "Contract_A", ext: "tiff")
        contractADOCXFile = loadDocument(name: "Contract_A", ext: "docx")
        contractADOCFile = loadDocument(name: "Contract_A", ext: "doc")
        contractBFile = loadDocument(name: "contract_B", ext: "pdf")
        testTablePNGFile = loadDocument(name: "TableTestV3", ext: "png")
        testTableJPGFile = loadDocument(name: "TableTestV3", ext: "jpg")
        testTableBMPFile = loadDocument(name: "TableTestV3", ext: "bmp")
        testTableGIFFile = loadDocument(name: "TableTestV3", ext: "gif")
        testTableTIFFFile = loadDocument(name: "TableTestV3", ext: "tiff")
        testTablePDFFile = loadDocument(name: "TableTestV3", ext: "pdf")
        testTableDOCXFile = loadDocument(name: "TableTestV3", ext: "docx")
        testTableDOCFile = loadDocument(name: "TableTestV3", ext: "doc")
    }

    static var allTests: [(String, (CompareComplyTests) -> () throws -> Void)] {
        return [
            ("testConvertToHtmlUsingPDF", testConvertToHtmlUsingPDF),
            ("testConvertToHtmlUsingPNG", testConvertToHtmlUsingPNG),
            ("testConvertToHtmlUsingJPG", testConvertToHtmlUsingJPG),
            ("testConvertToHtmlUsingBMP", testConvertToHtmlUsingBMP),
            ("testConvertToHtmlUsingGIF", testConvertToHtmlUsingGIF),
            ("testConvertToHtmlUsingTIFF", testConvertToHtmlUsingTIFF),
            ("testConvertToHtmlUsingDOCX", testConvertToHtmlUsingDOCX),
            ("testConvertToHtmlUsingDOC", testConvertToHtmlUsingDOC),
            ("testClassifyElementsUsingPDF", testClassifyElementsUsingPDF),
            ("testClassifyElementsUsingPNG", testClassifyElementsUsingPNG),
            ("testClassifyElementsUsingJPG", testClassifyElementsUsingJPG),
            ("testClassifyElementsUsingBMP", testClassifyElementsUsingBMP),
            ("testClassifyElementsUsingGIF", testClassifyElementsUsingTIFF),
            ("testClassifyElementsUsingTIFF", testClassifyElementsUsingTIFF),
            ("testClassifyElementsUsingDOCX", testClassifyElementsUsingDOCX),
            ("testClassifyElementsUsingDOC", testClassifyElementsUsingDOC),
            ("testExtractTablesUsingPNG", testExtractTablesUsingPNG),
            ("testExtractTablesUsingJPG", testExtractTablesUsingJPG),
            ("testExtractTablesUsingBMP", testExtractTablesUsingBMP),
            ("testExtractTablesUsingGIF", testExtractTablesUsingGIF),
            ("testExtractTablesUsingTIFF", testExtractTablesUsingTIFF),
            ("testExtractTablesUsingPDF", testExtractTablesUsingPDF),
            ("testExtractTablesUsingDOCX", testExtractTablesUsingDOCX),
            ("testExtractTablesUsingDOC", testExtractTablesUsingDOC),
            ("testCompareDocuments", testCompareDocuments),
            ("testFeedbackOperations", testFeedbackOperations),
            ("testBatchOperations", testBatchOperations),
        ]
    }

    /** Instantiate CompareComply. */
    func instantiateCompareComply() {
        let version = "2018-11-15"
        let authenticator = WatsonIAMAuthenticator.init(apiKey: WatsonCredentials.CompareComplyV1APIKey)
        compareComply = CompareComply(version: version, authenticator: authenticator)
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

    func waitForExpectations(timeout: TimeInterval = 40.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: HTML Conversion tests

    func testConvertToHtmlUsingPDF() {
        let expectation = self.expectation(description: "convert PDF document to HTML")

        guard let file = loadDocument(name: "Contract_A", ext: "pdf") else {
            XCTFail("Failed to load test file")
            return
        }

        compareComply.convertToHTML(file: file, fileContentType: "application/pdf") {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let result = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }

                XCTAssertNotNil(result.html)

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

    func testConvertToHtmlUsingPNG() {
        let expectation = self.expectation(description: "convert PDF document to HTML")

        compareComply.convertToHTML(file: contractAPNGFile, fileContentType: "image/png") {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let result = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }

                XCTAssertNotNil(result.html)

                XCTAssertNotNil(result.numPages)
                if let numPages = result.numPages,
                    let numberOfPages = Int(numPages) {
                    XCTAssert(numberOfPages == 1)
                }

                XCTAssertNotNil(result.title)
                if let title = result.title {
                    XCTAssert(title.contains("no title"))
                }
                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testConvertToHtmlUsingJPG() {
        let expectation = self.expectation(description: "convert PDF document to HTML")

        compareComply.convertToHTML(file: contractAJPGFile, fileContentType: "image/jpg") {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let result = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }

                XCTAssertNotNil(result.html)

                XCTAssertNotNil(result.numPages)
                if let numPages = result.numPages,
                    let numberOfPages = Int(numPages) {
                    XCTAssert(numberOfPages == 1)
                }

                XCTAssertNotNil(result.title)
                if let title = result.title {
                    XCTAssert(title.contains("no title"))
                }
                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testConvertToHtmlUsingBMP() {
        let expectation = self.expectation(description: "convert PDF document to HTML")

        compareComply.convertToHTML(file: contractABMPFile, fileContentType: "image/bmp") {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let result = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }

                XCTAssertNotNil(result.html)

                XCTAssertNotNil(result.numPages)
                if let numPages = result.numPages,
                    let numberOfPages = Int(numPages) {
                    XCTAssert(numberOfPages == 1)
                }

                XCTAssertNotNil(result.title)
                if let title = result.title {
                    XCTAssert(title.contains("no title"))
                }
                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testConvertToHtmlUsingGIF() {
        let expectation = self.expectation(description: "convert PDF document to HTML")

        compareComply.convertToHTML(file: contractAGIFFile, fileContentType: "image/gif") {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let result = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }

                XCTAssertNotNil(result.html)

                XCTAssertNotNil(result.numPages)
                if let numPages = result.numPages,
                    let numberOfPages = Int(numPages) {
                    XCTAssert(numberOfPages == 1)
                }

                XCTAssertNotNil(result.title)
                if let title = result.title {
                    XCTAssert(title.contains("no title"))
                }
                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testConvertToHtmlUsingTIFF() {
        let expectation = self.expectation(description: "convert PDF document to HTML")

        compareComply.convertToHTML(file: contractATIFFFile, fileContentType: "image/tiff") {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let result = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }

                XCTAssertNotNil(result.html)

                XCTAssertNotNil(result.numPages)
                if let numPages = result.numPages,
                    let numberOfPages = Int(numPages) {
                    XCTAssert(numberOfPages == 1)
                }

                XCTAssertNotNil(result.title)
                if let title = result.title {
                    XCTAssert(title.contains("no title"))
                }
                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testConvertToHtmlUsingDOCX() {
        let expectation = self.expectation(description: "convert PDF document to HTML")

        compareComply.convertToHTML(file: contractADOCXFile, fileContentType: "application/vnd.openxmlformats-officedocument.wordprocessingml.document") {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let result = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }

                XCTAssertNotNil(result.html)

                XCTAssertNotNil(result.numPages)
                if let numPages = result.numPages,
                    let numberOfPages = Int(numPages) {
                    XCTAssert(numberOfPages == 4)
                }

                XCTAssertNotNil(result.title)
                if let title = result.title {
                    XCTAssert(title.contains("no title"))
                }
                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testConvertToHtmlUsingDOC() {
        let expectation = self.expectation(description: "convert PDF document to HTML")

        compareComply.convertToHTML(file: contractADOCFile, fileContentType: "application/msword") {
                response, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let result = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }

                XCTAssertNotNil(result.html)

                XCTAssertNotNil(result.numPages)
                if let numPages = result.numPages,
                    let numberOfPages = Int(numPages) {
                    XCTAssert(numberOfPages == 4)
                }

                XCTAssertNotNil(result.title)
                if let title = result.title {
                    XCTAssert(title.contains("no title"))
                }
                expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: Classify Elements tests

    func testClassifyElementsUsingPDF() {
        let expectation = self.expectation(description: "Classify elements")

        compareComply.classifyElements(
            file: contractAPDFFile,
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

    func testClassifyElementsUsingPNG() {
        let expectation = self.expectation(description: "Classify elements")

        compareComply.classifyElements(
            file: contractAPNGFile,
            fileContentType: "image/png") {
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
                    XCTAssert(title.contains("no title"))
                }
                if let modelID = result.modelID {
                    XCTAssertEqual(modelID, "contracts")
                }

                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testClassifyElementsUsingJPG() {
        let expectation = self.expectation(description: "Classify elements")

        compareComply.classifyElements(
            file: contractAJPGFile,
            fileContentType: "image/jpg") {
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
                    XCTAssert(title.contains("no title"))
                }
                if let modelID = result.modelID {
                    XCTAssertEqual(modelID, "contracts")
                }

                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testClassifyElementsUsingBMP() {
        let expectation = self.expectation(description: "Classify elements")

        compareComply.classifyElements(
            file: contractABMPFile,
            fileContentType: "image/bmp") {
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
                    XCTAssert(title.contains("no title"))
                }
                if let modelID = result.modelID {
                    XCTAssertEqual(modelID, "contracts")
                }

                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testClassifyElementsUsingGIF() {
        let expectation = self.expectation(description: "Classify elements")

        compareComply.classifyElements(
            file: contractAGIFFile,
            fileContentType: "image/gif") {
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
                    XCTAssert(title.contains("no title"))
                }
                if let modelID = result.modelID {
                    XCTAssertEqual(modelID, "contracts")
                }

                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testClassifyElementsUsingTIFF() {
        let expectation = self.expectation(description: "Classify elements")

        compareComply.classifyElements(
            file: contractATIFFFile,
            fileContentType: "image/tiff") {
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
                    XCTAssert(title.contains("no title"))
                }
                if let modelID = result.modelID {
                    XCTAssertEqual(modelID, "contracts")
                }

                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testClassifyElementsUsingDOCX() {
        let expectation = self.expectation(description: "Classify elements")

        compareComply.classifyElements(
            file: contractADOCXFile,
            fileContentType: "application/vnd.openxmlformats-officedocument.wordprocessingml.document") {
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
                    XCTAssert(title.contains("no title"))
                }
                if let modelID = result.modelID {
                    XCTAssertEqual(modelID, "contracts")
                }

                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testClassifyElementsUsingDOC() {
        let expectation = self.expectation(description: "Classify elements")

        compareComply.classifyElements(
            file: contractADOCFile,
            fileContentType: "application/msword") {
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
                    XCTAssert(title.contains("no title"))
                }
                if let modelID = result.modelID {
                    XCTAssertEqual(modelID, "contracts")
                }

                expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: Table Extraction tests

    func testExtractTablesUsingPNG() {
        let expectation = self.expectation(description: "Extract tables")

        compareComply.extractTables(
            file: testTablePNGFile,
            fileContentType: "image/png") {
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

                if let table = result.tables?[0] {
                    XCTAssertEqual(table.rowHeaders?.count, 5)
                    XCTAssertEqual(table.columnHeaders?.count, 5)
                    XCTAssertEqual(table.bodyCells?.count, 20)
                }

                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testExtractTablesUsingJPG() {
        let expectation = self.expectation(description: "Extract tables")

        compareComply.extractTables(
            file: testTableJPGFile,
            fileContentType: "image/jpg") {
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

                if let table = result.tables?[0] {
                    XCTAssertEqual(table.rowHeaders?.count, 5)
                    XCTAssertEqual(table.columnHeaders?.count, 5)
                    XCTAssertEqual(table.bodyCells?.count, 20)
                }

                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testExtractTablesUsingBMP() {
        let expectation = self.expectation(description: "Extract tables")

        compareComply.extractTables(
            file: testTableBMPFile,
            fileContentType: "image/bmp") {
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

                if let table = result.tables?[0] {
                    XCTAssertEqual(table.rowHeaders?.count, 5)
                    XCTAssertEqual(table.columnHeaders?.count, 5)
                    XCTAssertEqual(table.bodyCells?.count, 20)
                }

                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testExtractTablesUsingGIF() {
        let expectation = self.expectation(description: "Extract tables")

        compareComply.extractTables(
            file: testTableGIFFile,
            fileContentType: "image/gif") {
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

                if let table = result.tables?[0] {
                    XCTAssertEqual(table.rowHeaders?.count, 5)
                    XCTAssertEqual(table.columnHeaders?.count, 5)
                    XCTAssertEqual(table.bodyCells?.count, 20)
                }

                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testExtractTablesUsingTIFF() {
        let expectation = self.expectation(description: "Extract tables")

        compareComply.extractTables(
            file: testTableTIFFFile,
            fileContentType: "image/tiff") {
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

                if let table = result.tables?[0] {
                    XCTAssertEqual(table.rowHeaders?.count, 5)
                    XCTAssertEqual(table.columnHeaders?.count, 5)
                    XCTAssertEqual(table.bodyCells?.count, 20)
                }

                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testExtractTablesUsingPDF() {
        let expectation = self.expectation(description: "Extract tables")

        compareComply.extractTables(
            file: testTablePDFFile,
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

                if let table = result.tables?[0] {
                    XCTAssertEqual(table.rowHeaders?.count, 4)
                    XCTAssertEqual(table.columnHeaders?.count, 8)
                    XCTAssertEqual(table.bodyCells?.count, 16)
                }

                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testExtractTablesUsingDOCX() {
        let expectation = self.expectation(description: "Extract tables")

        compareComply.extractTables(
            file: testTableDOCXFile,
            fileContentType: "application/vnd.openxmlformats-officedocument.wordprocessingml.document") {
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

                if let table = result.tables?[0] {
                    XCTAssertEqual(table.rowHeaders?.count, 4)
                    XCTAssertEqual(table.columnHeaders?.count, 8)
                    XCTAssertEqual(table.bodyCells?.count, 16)
                }

                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testExtractTablesUsingDOC() {
        let expectation = self.expectation(description: "Extract tables")

        compareComply.extractTables(
            file: testTableDOCFile,
            fileContentType: "application/msword") {
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

                if let table = result.tables?[0] {
                    XCTAssertEqual(table.rowHeaders?.count, 0)
                    XCTAssertEqual(table.columnHeaders?.count, 7)
                    XCTAssertEqual(table.bodyCells?.count, 21)
                }

                expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: Document Comparison tests

    func testCompareDocuments() {
        let expectation = self.expectation(description: "Compare documents")

        compareComply.compareDocuments(
            file1: contractAPDFFile,
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

    // MARK: Add Feedback tests

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
                // Bug 11478
                // XCTAssertEqual(result.userID, userID)

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

                // Bug 11500
                // XCTAssertEqual(result.comment, myComment)
                XCTAssertNotNil(result.comment)

                expectation2.fulfill()
        }
        waitForExpectations()

        let expectation3 = self.expectation(description: "List feedback")
        compareComply.listFeedback {
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

    #if !os(Linux)  // Linux does not support teardown blocks
    func testBug11478() {
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
        // Add a teardown block to delete the Feedback entry
        addTeardownBlock {
            if newFeedbackID != nil {
                self.compareComply.deleteFeedback(feedbackID: newFeedbackID) {_, _ in }
            }
        }
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
                guard let result = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }
                newFeedbackID = result.feedbackID

                XCTAssertEqual(result.comment, myComment)
                // Bug opened with CnC team: #11478
                XCTAssertEqual(result.userID, userID)

                expectation1.fulfill()
        }
        waitForExpectations()
    }

    func testBug11500() {
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
        // Add a teardown block to delete the Feedback entry
        addTeardownBlock {
            if newFeedbackID != nil {
                self.compareComply.deleteFeedback(feedbackID: newFeedbackID) {_, _ in }
            }
        }
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
                guard let result = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }
                newFeedbackID = result.feedbackID

                XCTAssertEqual(result.comment, myComment)

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

            // Bug opened with CnC team: #11500
            XCTAssertEqual(result.comment, myComment)

            expectation2.fulfill()
        }
        waitForExpectations()
    }
    #endif

    // MARK: Batch Operations tests

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

        compareComply.listBatches {
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
