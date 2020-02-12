/**
 * (C) Copyright IBM Corp. 2019.
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

// swiftlint:disable function_body_length force_try force_unwrapping file_length

import XCTest
import Foundation
// Do not import @testable to ensure only public interface is exposed
import VisualRecognitionV4

class VisualRecognitionV4Tests: XCTestCase {

    private static let timeout: TimeInterval = 45.0

    private var visualRecognition: VisualRecognition!
    private let collectionID = WatsonCredentials.VisualRecognitionV4CollectionID
    private let giraffeCollectionID = WatsonCredentials.VisualRecognitionV4GiraffeCollectionID
    private let trainingDummyCollectionID = WatsonCredentials.VisualRecognitionV4TrainingDummyCollectionID
    private let trainingDummyImageID = "pexels-photo-802112_54cb1e9f79ebad77276fddf92c139f95"
    private let giraffeImageURL = giraffeURL

    static var allTests: [(String, (VisualRecognitionV4Tests) -> () throws -> Void)] {
        let tests: [(String, (VisualRecognitionV4Tests) -> () throws -> Void)] = [
            ("testMultipleClassifierIDsWithURL", testMultipleClassifierIDsWithURL),
            ("testAnalyzeIndividualImageByURL", testAnalyzeIndividualImageByURL),
            ("testAnalyzeIndividualImageByURL", testAnalyzeIndividualImageByURL),
            ("testAnalyzeIndividualImageByFile", testAnalyzeIndividualImageByFile),
            ("testAnalyzeMultipleImageByFile", testAnalyzeMultipleImageByFile),
            ("testAnalyzeMultipleImageByFile", testAnalyzeMultipleImageByFile),
            ("testImageManagementCRUD", testImageManagementCRUD),
            ("testTrainCollection", testTrainCollection),
            ("testTrainCollection", testTrainCollection),
        ]
        return tests
    }

    // MARK: - Test Configuration

    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateVisualRecognition()
    }

    /** Instantiate Visual Recognition. */
    func instantiateVisualRecognition() {
        let authenticator = WatsonIAMAuthenticator.init(apiKey: WatsonCredentials.VisualRecognitionV4APIKey)
        visualRecognition = VisualRecognition(version: versionDate, authenticator: authenticator)
        if let url = WatsonCredentials.VisualRecognitionURL {
            visualRecognition.serviceURL = url
        }
        visualRecognition.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        visualRecognition.defaultHeaders["X-Watson-Test"] = "true"

        // Test only
        // visualRecognition.serviceURL = "http://localhost:8008"
    }

    /** Wait for expectations. */
    func waitForExpectations(timeout: TimeInterval = timeout) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: - Analyzing Images
    func testMultipleClassifierIDsWithURL() {
        let expectation = self.expectation(description: "Analyze an individual image by URL with multiple classifier IDs")

        visualRecognition.analyze(
            collectionIDs: [collectionID, giraffeCollectionID],
            features: ["objects"],
            imageURL: [giraffeImageURL],
            threshold: 0.16
        ) {
            response, error in

            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            // make sure there is actually a result
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(result.images.count, 1)
            XCTAssertEqual(result.images.first?.source.sourceURL, self.giraffeImageURL)

            expectation.fulfill()
        }

        waitForExpectations()
    }

    func testAnalyzeIndividualImageByURL() {
        let expectation = self.expectation(description: "Analyze an individual image by URL")

        visualRecognition.analyze(
            collectionIDs: [collectionID],
            features: ["objects"],
            imageURL: [giraffeImageURL],
            threshold: 0.16
        ) {
            response, error in

            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            // make sure there is actually a result
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(result.images.count, 1)
            XCTAssertEqual(result.images.first?.source.sourceURL, self.giraffeImageURL)

            expectation.fulfill()
        }

        waitForExpectations()
    }

    func testAnalyzeMultipleImageByURL() {
        let expectation = self.expectation(description: "Analyze multiple images by their URLs")

        let testImages = [giraffeImageURL, obamaURL, carURL]

        visualRecognition.analyze(
            collectionIDs: [collectionID],
            features: ["objects"],
            imageURL: testImages,
            threshold: 0.16
        ) {
            response, error in

            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            // make sure there is actually a result
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(result.images.count, 3)

            // make sure all source images were analyzed
            var sourceImagesFound: [String: Bool] = [
                "giraffe": false,
                "obama": false,
                "car": false,
            ]

            for analyzedImage in result.images {
                guard let sourceURL = analyzedImage.source.sourceURL else {
                    XCTFail("image has no source URL")
                    return
                }

                if sourceURL == testImages[0] {
                    sourceImagesFound["giraffe"] = true
                } else if sourceURL == testImages[1] {
                    sourceImagesFound["obama"] = true
                } else if sourceURL == testImages[2] {
                    sourceImagesFound["car"] = true
                } else {
                    XCTFail("unexpected source URL returned")
                    return
                }

            }

            for (image, wasFound) in sourceImagesFound {
                if wasFound != true {
                    XCTFail("\(image) was not found in source URLs")
                    return
                }
            }

            expectation.fulfill()
        }

        waitForExpectations()
    }

    func testAnalyzeIndividualImageByFile() {
        let expectation = self.expectation(description: "Analyze an individual image file")

        let testFile = FileWithMetadata(data: obama, filename: "obama.jpg", contentType: "image/jpg")

        visualRecognition.analyze(
            collectionIDs: [collectionID],
            features: ["objects"],
            imagesFile: [testFile],
            threshold: 0.16
        ) {
            response, error in

            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            // make sure there is actually a result
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(result.images.count, 1)
            XCTAssertEqual(result.images.first?.source.type, "file")
            XCTAssertEqual(result.images.first?.source.filename, "obama.jpg")

            expectation.fulfill()
        }

        waitForExpectations()
    }

    func testAnalyzeMultipleImageByFile() {
        let expectation = self.expectation(description: "Analyze multiple image files")

        let obamaFile = FileWithMetadata(data: obama, filename: "obama.jpg", contentType: "image/jpg")
        let personFile = FileWithMetadata(data: face1, filename: "person.jpg", contentType: "image/jpg")
        let signFile = FileWithMetadata(data: sign, filename: "sign.jpg", contentType: "image/jpg")

        visualRecognition.analyze(
            collectionIDs: [collectionID],
            features: ["objects"],
            imagesFile: [obamaFile, personFile, signFile],
            threshold: 0.16
        ) {
            response, error in

            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            // make sure there is actually a result
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(result.images.count, 3)

            // make sure all source images were analyzed
            var sourceImagesFound: [String: Bool] = [
                "obama": false,
                "person": false,
                "sign": false,
            ]

            for analyzedImage in result.images {
                guard let sourceURL = analyzedImage.source.filename else {
                    XCTFail("image has no source URL")
                    return
                }

                if sourceURL == "obama.jpg" {
                    sourceImagesFound["obama"] = true
                } else if sourceURL == "person.jpg" {
                    sourceImagesFound["person"] = true
                } else if sourceURL == "sign.jpg" {
                    sourceImagesFound["sign"] = true
                } else {
                    XCTFail("unexpected source URL returned")
                    return
                }

            }

            for (image, wasFound) in sourceImagesFound {
                if wasFound != true {
                    XCTFail("\(image) was not found in source URLs")
                    return
                }
            }

            expectation.fulfill()
        }

        waitForExpectations()
    }

    // MARK: - Managing Collections

    /** CRUD operations for a user-trained collection. */
    func testCollectionsCRUD() {
        let crudTestCollectionName = "swift-test-collection-1"
        var testCollectionID: String?

        // Create Collection test
        let createCollectionExpectation = self.expectation(description: "Create an image collection.")

        visualRecognition.createCollection(
            name: crudTestCollectionName,
            description: "Used for swift SDK integration tests",
            headers: nil
        ) {
            response, error in

            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            // make sure there is actually a result
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            // make sure result has details we provided
            XCTAssertNotNil(result.collectionID)
            XCTAssertEqual(result.name, crudTestCollectionName)
            XCTAssertEqual(result.description, "Used for swift SDK integration tests")

            // set collection ID for future CRUD tests
            testCollectionID = result.collectionID

            // mark the test as passed
            createCollectionExpectation.fulfill()
        }

        waitForExpectations()

        // List collections test
        let listCollectionsExpectation = self.expectation(description: "Retrieve a list of user-trained collections.")

        visualRecognition.listCollections { response, error in
            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            // make sure there are collections in the result
            guard let collections = response?.result?.collections else {
                XCTFail(missingResultMessage)
                return
            }

            // make sure one of the collections returned has the ID of our test collection
            for collection in collections where collection.collectionID == testCollectionID! {
                listCollectionsExpectation.fulfill()
                return
            }

            XCTFail("Could not retrieve the trained collection.")
        }

        waitForExpectations()

        // Get collection details test
        let getCollectionExpectation = self.expectation(description: "Retrieve details about a user-trained collection.")

        visualRecognition.getCollection(collectionID: testCollectionID!) { response, error in
            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            // make sure there are collections in the result
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            // make sure we have the correct collection
            XCTAssertEqual(result.collectionID, testCollectionID)
            XCTAssertEqual(result.name, crudTestCollectionName)

            getCollectionExpectation.fulfill()
        }

        waitForExpectations()

        // Update collection details test
        let updateCollectionDetailsExpectation = self.expectation(description: "Update details about a user-trained collection.")

        visualRecognition.updateCollection(
            collectionID: testCollectionID!,
            name: crudTestCollectionName,
            description: "modified",
            headers: nil
        ) {
            response, error in

            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            // make sure there are collections in the result
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            // make sure the collection description was updated
            XCTAssertEqual(result.collectionID, testCollectionID)
            XCTAssertEqual(result.name, "swift-test-collection-1")
            XCTAssertEqual(result.description, "modified")

            updateCollectionDetailsExpectation.fulfill()
        }

        waitForExpectations()

        // Delete collection test
        let deleteCollectionExpectation = self.expectation(description: "Delete a user-defined collection.")

        visualRecognition.deleteCollection(collectionID: testCollectionID!) { response, error in
            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            // make sure we got a response
            XCTAssertNotNil(response)

            deleteCollectionExpectation.fulfill()
        }

        waitForExpectations()
    }

    // MARK: - Managing images in a collection

    func testImageManagementCRUD() {
        var testImageID: String!

        /** Add image test **/
        let addImageExpectation = self.expectation(description: "add an image to a collection.")

        let testFile = FileWithMetadata(data: obama, filename: "obama.jpg", contentType: "image/jpg")

        visualRecognition.addImages(collectionID: collectionID, imagesFile: [testFile]) {
            response, error in

            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            // make sure there are collections in the result
            guard let collectionImages = response?.result?.images else {
                XCTFail(missingResultMessage)
                return
            }

            // make sure that our added image is in the collection
            let matchingImages = collectionImages.filter { $0.source.filename == "obama.jpg" }

            guard let matchingImage = matchingImages.first else {
                XCTFail("no matching images found")
                return
            }

            // save the ID of our test image for the rest of the CRUD tests
            testImageID = matchingImage.imageID

            addImageExpectation.fulfill()
        }

        waitForExpectations()

        /** List images test **/
        let listImageExpectation = self.expectation(description: "list images in a collection.")

        visualRecognition.listImages(collectionID: collectionID) { response, error in
            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            // make sure there are collections in the result
            guard let collectionImages = response?.result?.images else {
                XCTFail(missingResultMessage)
                return
            }

            // make sure that there are images in the collection
            XCTAssertGreaterThan(collectionImages.count, 0)

            listImageExpectation.fulfill()
        }

        waitForExpectations()

        /** Get Image Details test **/
        let getImageDetailsExpectation = self.expectation(description: "Get details about an image.")

        visualRecognition.getImageDetails(collectionID: collectionID, imageID: testImageID) { response, error in
            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            // make sure there are collections in the result
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(result.imageID, testImageID)
            XCTAssertEqual(result.source.filename, "obama.jpg")

            getImageDetailsExpectation.fulfill()
        }

        waitForExpectations()

        /** Get a JPG representation of an Image test **/
        let jpgRepresentationExpectation = self.expectation(description: "Get a JPG representation of an image in a collection.")

        visualRecognition.getJpegImage(collectionID: collectionID, imageID: testImageID) { response, error in
            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            XCTAssertNotNil(response?.result)
            jpgRepresentationExpectation.fulfill()
        }

        waitForExpectations()

        /** Get Image Details test **/
        let deleteImageExpectation = self.expectation(description: "Delete an image from a collection.")

        visualRecognition.deleteImage(collectionID: collectionID, imageID: testImageID) { _, error in
            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            deleteImageExpectation.fulfill()
        }

        waitForExpectations()
    }

    // MARK: - Test Training a Collection

    func testTrainCollection() {
        let addDataExpectation = self.expectation(description: "add data")

        let location = Location(top: 15, left: 15, width: 20, height: 10)
        let testBaseObject = TrainingDataObject(object: "test", location: location)

        visualRecognition.addImageTrainingData(collectionID: trainingDummyCollectionID, imageID: trainingDummyImageID, objects: [testBaseObject]) {
            response, error in

            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            // make sure there are collections in the result
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(result.objects?.first?.location, location)
            XCTAssertEqual(result.objects?.first?.object, "test")

            addDataExpectation.fulfill()
        }

        waitForExpectations()
        
        let expectation = self.expectation(description: "Train a collection")

        visualRecognition.train(collectionID: trainingDummyCollectionID) { response, error in
            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            // make sure there are collections in the result
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(result.collectionID, self.trainingDummyCollectionID)

            expectation.fulfill()
        }

        waitForExpectations()
    }

    func testAddTrainingDataToImage() {
        let expectation = self.expectation(description: "Train a collection")

        let location = Location(top: 15, left: 15, width: 20, height: 10)
        let testBaseObject = TrainingDataObject(object: "test", location: location)

        visualRecognition.addImageTrainingData(collectionID: trainingDummyCollectionID, imageID: trainingDummyImageID, objects: [testBaseObject]) {
            response, error in

            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            // make sure there are collections in the result
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(result.objects?.first?.location, location)
            XCTAssertEqual(result.objects?.first?.object, "test")

            expectation.fulfill()
        }

        waitForExpectations()
    }
    
    func testObjectMetadataCRUD() {
        var testObject: String!
        
        let expectation = self.expectation(description: "Train a collection")

        let location = Location(top: 15, left: 15, width: 20, height: 10)
        let testBaseObject = TrainingDataObject(object: "test", location: location)

        visualRecognition.addImageTrainingData(collectionID: trainingDummyCollectionID, imageID: trainingDummyImageID, objects: [testBaseObject]) {
            response, error in

            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            // make sure there are collections in the result
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(result.objects?.first?.location, location)
            XCTAssertEqual(result.objects?.first?.object, "test")
            
            testObject = "test"

            expectation.fulfill()
        }

        waitForExpectations()
        
        let listExpectation = self.expectation(description: "list object metadata")

        visualRecognition.listObjectMetadata(collectionID: trainingDummyCollectionID) {
            response, error in

            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            // make sure there are collections in the result
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            
            XCTAssertNotNil(result.objects?.first)
            
            testObject = result.objects?.first?.object
            
            listExpectation.fulfill()
        }
        
        waitForExpectations()
        
        let updateExpectation = self.expectation(description: "update object metadata")
        
        visualRecognition.updateObjectMetadata(collectionID: trainingDummyCollectionID, object: testObject, newObject: "updated") {
            response, error in
            
            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            // make sure there are collections in the result
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            
            XCTAssertEqual(result.object, "updated")
            
            testObject = result.object
            
            updateExpectation.fulfill()
        }
        
        waitForExpectations()
        
        let getExpectation = self.expectation(description: "get object metadata")
        
        visualRecognition.getObjectMetadata(collectionID: trainingDummyCollectionID, object: testObject) {
            response, error in
            
            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            // make sure there are collections in the result
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            
            XCTAssertEqual(result.object, testObject)
            
            getExpectation.fulfill()
        }
        
        waitForExpectations()
        
        let deleteExpectation = self.expectation(description: "delete object metadata")
        
        visualRecognition.deleteObject(collectionID: trainingDummyCollectionID, object: testObject) {
            response, error in
            
            // make sure we didn't get an error
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            
            deleteExpectation.fulfill()
        }
        
        waitForExpectations()
    }
}
