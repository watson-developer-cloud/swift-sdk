/**
 * Copyright IBM Corporation 2016
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
import TradeoffAnalyticsV1

class TradeoffAnalyticsTests: XCTestCase {

    private var tradeoffAnalytics: TradeoffAnalytics!
    private let timeout: TimeInterval = 5.0
    
    static var allTests : [(String, (TradeoffAnalyticsTests) -> () throws -> Void)] {
        return [
            ("testGetDilemma1", testGetDilemma1),
            ("testGetDilemma2", testGetDilemma2),
            ("testGetDilemmaMalformedProblem", testGetDilemmaMalformedProblem)
        ]
    }
    
    // MARK: - Test Configuration
    
    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateTradeoffAnalytics()
    }
    
    /** Instantiate Tradeoff Analytics. */
    func instantiateTradeoffAnalytics() {
        let username = Credentials.TradeoffAnalyticsUsername
        let password = Credentials.TradeoffAnalyticsPassword
        tradeoffAnalytics = TradeoffAnalytics(username: username, password: password)
        tradeoffAnalytics.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        tradeoffAnalytics.defaultHeaders["X-Watson-Test"] = "true"
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
    func waitForExpectations() {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
    // MARK: - Positive Tests
    
    func testGetDilemma1() {
        let description = "Create and resolve a sample problem."
        let expectation = self.expectation(description: description)
        
        // define columns
        let price = Column(
            key: "price",
            type: .numeric,
            goal: .minimize,
            isObjective: true
        )
        let ram = Column(
            key: "ram",
            type: .numeric,
            goal: .maximize,
            isObjective: true
        )
        let screen = Column(
            key: "screen",
            type: .numeric,
            goal: .maximize,
            isObjective: true
        )
        let os = Column(
            key: "os",
            type: .categorical,
            goal: .minimize,
            isObjective: true,
            range: Range.categoricalRange(categories: ["android", "windows-phone", "blackberry", "ios"]),
            preference: ["android", "ios"]
        )
        
        // define options
        let galaxy = Option(
            key: "galaxy",
            values: ["price": .int(50), "ram": .int(45), "screen": .int(5), "os": .string("android")],
            name: "Galaxy S4"
        )
        let iphone = Option(
            key: "iphone",
            values: ["price": .int(99), "ram": .int(40), "screen": .int(4), "os": .string("ios")],
            name: "iPhone 5"
        )
        let optimus = Option(
            key: "optimus",
            values: ["price": .int(10), "ram": .int(300), "screen": .int(5), "os": .string("android")],
            name: "LG Optimus G"
        )

        // define problem
        let problem = Problem(
            columns: [price, ram, screen, os],
            options: [galaxy, iphone, optimus],
            subject: "Phone"
        )
        
        tradeoffAnalytics.getDilemma(for: problem, failure: failWithError) {
            dilemma in
            
            // verify problem
            XCTAssertEqual(dilemma.problem.columns.count, 4)
            XCTAssertEqual(dilemma.problem.subject, "Phone")
            XCTAssertEqual(dilemma.problem.options.count, 3)
            
            // verify problem columns
            let columns = dilemma.problem.columns
            XCTAssertEqual(columns[0].type, ColumnType.numeric)
            XCTAssertEqual(columns[0].key, "price")
            XCTAssertEqual(columns[0].goal, Goal.minimize)
            XCTAssertEqual(columns[0].isObjective, true)
            XCTAssertEqual(columns[1].type, ColumnType.numeric)
            XCTAssertEqual(columns[1].key, "ram")
            XCTAssertEqual(columns[1].goal, Goal.maximize)
            XCTAssertEqual(columns[1].isObjective, true)
            XCTAssertEqual(columns[2].type, ColumnType.numeric)
            XCTAssertEqual(columns[2].key, "screen")
            XCTAssertEqual(columns[2].goal, Goal.maximize)
            XCTAssertEqual(columns[2].isObjective, true)
            XCTAssertEqual(columns[3].type, ColumnType.categorical)
            XCTAssertEqual(columns[3].key, "os")
            XCTAssertNotNil(columns[3].range)
            XCTAssertEqual(columns[3].goal, Goal.minimize)
            XCTAssertNotNil(columns[3].preference)
            XCTAssertEqual(columns[3].isObjective, true)

            // verify problem options
            let options = dilemma.problem.options
            XCTAssertEqual(options[0].key, "optimus")
            XCTAssertEqual(options[0].name, "LG Optimus G")
            XCTAssertNotNil(options[0].values["price"])
            XCTAssertNotNil(options[0].values["os"])
            XCTAssertNotNil(options[0].values["ram"])
            XCTAssertNotNil(options[0].values["screen"])
            XCTAssertEqual(options[1].key, "galaxy")
            XCTAssertEqual(options[1].name, "Galaxy S4")
            XCTAssertNotNil(options[1].values["price"])
            XCTAssertNotNil(options[1].values["os"])
            XCTAssertNotNil(options[1].values["ram"])
            XCTAssertNotNil(options[1].values["screen"])
            XCTAssertEqual(options[2].key, "iphone")
            XCTAssertEqual(options[2].name, "iPhone 5")
            XCTAssertNotNil(options[2].values["price"])
            XCTAssertNotNil(options[2].values["os"])
            XCTAssertNotNil(options[2].values["ram"])
            XCTAssertNotNil(options[2].values["screen"])
            
            // verify solutions
            let solutions = dilemma.resolution.solutions
            XCTAssertNil(solutions[0].shadowMe)
            XCTAssertNil(solutions[0].shadows)
            XCTAssertEqual(solutions[0].solutionRef, "optimus")
            XCTAssertEqual(solutions[0].status, SolutionStatus.front)
            XCTAssertNil(solutions[0].statusCause)
            XCTAssertNil(solutions[1].shadowMe)
            XCTAssertNil(solutions[1].shadows)
            XCTAssertEqual(solutions[1].solutionRef, "galaxy")
            XCTAssertEqual(solutions[1].status, SolutionStatus.excluded)
            XCTAssertNil(solutions[1].statusCause)
            XCTAssertNil(solutions[2].shadowMe)
            XCTAssertNil(solutions[2].shadows)
            XCTAssertEqual(solutions[2].solutionRef, "iphone")
            XCTAssertEqual(solutions[2].status, SolutionStatus.excluded)
            XCTAssertNil(solutions[2].statusCause)
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetDilemma2() {
        let description = "Create and resolve a sample problem."
        let expectation = self.expectation(description: description)
        
        // define columns
        let categorical = Column(
            key: "categorical",
            type: .categorical,
            isObjective: true,
            range: .categoricalRange(categories: ["cat1", "cat2", "cat3"]),
            preference: ["cat1", "cat2"],
            fullName: "Categorical Column",
            description: "This column tests the categorical column type."
        )
        let date = Column(
            key: "date",
            type: .dateTime,
            goal: .maximize,
            isObjective: true,
            range: .dateRange(low: Date(timeIntervalSinceNow: -360), high: Date()),
            format: "date:'MMM dd, yyyy'",
            fullName: "DateTime Column",
            description: "This column tests the date/time column type."
        )
        let numericInt = Column(
            key: "numeric-int",
            type: .numeric,
            goal: .minimize,
            isObjective: true,
            range: .numericRange(low: 0, high: 100),
            significantGain: 0.7,
            significantLoss: 0.3,
            insignificantLoss: 0.5,
            format: "number:3",
            fullName: "Numeric Int Column",
            description: "This column tests the numeric column type with integers."
        )
        let numericDouble = Column(
            key: "numeric-double",
            type: .numeric,
            goal: .minimize,
            isObjective: true,
            range: .numericRange(low: 0.0, high: 1.0),
            significantGain: 0.7,
            significantLoss: 0.3,
            insignificantLoss: 0.5,
            format: "number:2",
            fullName: "Numeric Double Column",
            description: "This column tests the numeric column type with doubles."
        )
        let text = Column(
            key: "text",
            type: .text,
            isObjective: false,
            fullName: "Text Column",
            description: "This column tests the text column type."
        )
        
        // define options
        let option1 = Option(
            key: "option1",
            values: [
                "categorical": .string("cat1"),
                "date": .date(Date()),
                "numeric-int": .int(0),
                "numeric-double": .double(0.0),
                "text": .string("This option should be preferred.")
            ],
            name: "Option 1",
            descriptionHTML: "<b>Option</b> 1"
        )
        let option2 = Option(
            key: "option2",
            values: [
                "categorical": .string("cat1"),
                "date": .date(Date()),
                "numeric-int": .int(100),
                "numeric-double": .double(1.0),
                "text": .string("This option should be a shadow.")
            ],
            name: "Option 2",
            descriptionHTML: "<b>Option</b> 1"
        )
        let option3 = Option(
            key: "option3",
            values: [
                "categorical": .string("cat3"),
                "date": .date(Date(timeIntervalSinceNow: -60)),
                "numeric-int": .int(100),
                "numeric-double": .double(1.0),
                "text": .string("This option should not meet preference.")
            ],
            name: "Option 3",
            descriptionHTML: "<b>Option</b> 1"
        )
        let option4 = Option(
            key: "option4",
            values: [
                "categorical": .string("cate3"),
                "date": .date(Date(timeIntervalSinceNow: -60)),
                "numeric-int": .int(100),
                "numeric-double": .double(1.0),
                "text": .string("This option should be incomplete.")
            ],
            name: "Option 4",
            descriptionHTML: "<b>Option</b> 1"
        )
        
        // define problem
        let problem = Problem(
            columns: [categorical, date, numericInt, numericDouble, text],
            options: [option1, option2, option3, option4],
            subject: "TestProblem"
        )
        
        tradeoffAnalytics.getDilemma(for: problem, failure: failWithError) {
            dilemma in
            
            // verify problem
            XCTAssertEqual(dilemma.problem.columns.count, 5)
            XCTAssertEqual(dilemma.problem.subject, "TestProblem")
            XCTAssertEqual(dilemma.problem.options.count, 4)
            
            // verify problem columns
            let columns = dilemma.problem.columns
            XCTAssertEqual(columns[0].type, ColumnType.categorical)
            XCTAssertEqual(columns[0].key, "categorical")
            XCTAssertEqual(columns[0].fullName, "Categorical Column")
            XCTAssertNotNil(columns[0].range)
            XCTAssertNotNil(columns[0].description)
            XCTAssertEqual(columns[0].goal, Goal.maximize)
            XCTAssertNotNil(columns[0].preference)
            XCTAssert(columns[0].isObjective == true)
            XCTAssertEqual(columns[1].type, ColumnType.dateTime)
            XCTAssertEqual(columns[1].key, "date")
            XCTAssertEqual(columns[1].fullName, "DateTime Column")
            XCTAssertNotNil(columns[1].range)
            XCTAssertNotNil(columns[1].description)
            XCTAssertEqual(columns[1].goal, Goal.maximize)
            XCTAssert(columns[1].isObjective == true)
            XCTAssertEqual(columns[2].type, ColumnType.numeric)
            XCTAssertEqual(columns[2].key, "numeric-int")
            XCTAssertEqual(columns[2].fullName, "Numeric Int Column")
            XCTAssertNotNil(columns[2].range)
            XCTAssertNotNil(columns[2].format)
            XCTAssertNotNil(columns[2].description)
            XCTAssertEqual(columns[2].goal, Goal.minimize)
            XCTAssert(columns[2].isObjective == true)
            XCTAssert(columns[2].insignificantLoss! >= 0.0)
            XCTAssert(columns[2].insignificantLoss! <= 1.0)
            XCTAssert(columns[2].significantGain! >= 0.0)
            XCTAssert(columns[2].significantGain! <= 1.0)
            XCTAssert(columns[2].significantLoss! >= 0.0)
            XCTAssert(columns[2].significantLoss! <= 1.0)
            XCTAssertEqual(columns[3].type, ColumnType.numeric)
            XCTAssertEqual(columns[3].key, "numeric-double")
            XCTAssertEqual(columns[3].fullName, "Numeric Double Column")
            XCTAssertNotNil(columns[3].range)
            XCTAssertNotNil(columns[3].format)
            XCTAssertNotNil(columns[3].description)
            XCTAssertEqual(columns[3].goal, Goal.minimize)
            XCTAssert(columns[3].isObjective == true)
            XCTAssert(columns[3].insignificantLoss! >= 0.0)
            XCTAssert(columns[3].insignificantLoss! <= 1.0)
            XCTAssert(columns[3].significantGain! >= 0.0)
            XCTAssert(columns[3].significantGain! <= 1.0)
            XCTAssert(columns[3].significantLoss! >= 0.0)
            XCTAssert(columns[3].significantLoss! <= 1.0)
            XCTAssertEqual(columns[4].type, ColumnType.text)
            XCTAssertEqual(columns[4].key, "text")
            XCTAssertEqual(columns[4].fullName, "Text Column")
            XCTAssertNotNil(columns[4].description)
            XCTAssertEqual(columns[4].goal, Goal.maximize)
            XCTAssert(columns[4].isObjective == false)
            
            // verify problem options
            let options = dilemma.problem.options
            XCTAssertEqual(options[0].key, "option3")
            XCTAssertEqual(options[0].name, "Option 3")
            XCTAssertNotNil(options[0].values["date"])
            XCTAssertNotNil(options[0].values["categorical"])
            XCTAssertNotNil(options[0].values["text"])
            XCTAssertNotNil(options[0].values["numeric-int"])
            XCTAssertNotNil(options[0].values["numeric-double"])
            XCTAssertNotNil(options[0].descriptionHTML)
            XCTAssertEqual(options[1].key, "option4")
            XCTAssertEqual(options[1].name, "Option 4")
            XCTAssertNotNil(options[1].values["date"])
            XCTAssertNotNil(options[1].values["categorical"])
            XCTAssertNotNil(options[1].values["text"])
            XCTAssertNotNil(options[1].values["numeric-int"])
            XCTAssertNotNil(options[1].values["numeric-double"])
            XCTAssertNotNil(options[1].descriptionHTML)
            XCTAssertEqual(options[2].key, "option1")
            XCTAssertEqual(options[2].name, "Option 1")
            XCTAssertNotNil(options[2].values["date"])
            XCTAssertNotNil(options[2].values["categorical"])
            XCTAssertNotNil(options[2].values["text"])
            XCTAssertNotNil(options[2].values["numeric-int"])
            XCTAssertNotNil(options[2].values["numeric-double"])
            XCTAssertNotNil(options[2].descriptionHTML)
            XCTAssertEqual(options[3].key, "option2")
            XCTAssertEqual(options[3].name, "Option 2")
            XCTAssertNotNil(options[3].values["date"])
            XCTAssertNotNil(options[3].values["categorical"])
            XCTAssertNotNil(options[3].values["text"])
            XCTAssertNotNil(options[3].values["numeric-int"])
            XCTAssertNotNil(options[3].values["numeric-double"])
            XCTAssertNotNil(options[3].descriptionHTML)
            
            // verify solutions
            let solutions = dilemma.resolution.solutions
            XCTAssertNil(solutions[0].shadowMe)
            XCTAssertNil(solutions[0].shadows)
            XCTAssertEqual(solutions[0].solutionRef, "option4")
            XCTAssertEqual(solutions[0].status, SolutionStatus.incomplete)
            XCTAssertNotNil(solutions[0].statusCause)
            XCTAssertNil(solutions[1].shadowMe)
            XCTAssertNil(solutions[1].shadows)
            XCTAssertEqual(solutions[1].solutionRef, "option2")
            XCTAssertEqual(solutions[1].status, SolutionStatus.excluded)
            XCTAssertNil(solutions[1].statusCause)
            XCTAssertNil(solutions[2].shadowMe)
            XCTAssertNil(solutions[2].shadows)
            XCTAssertEqual(solutions[2].solutionRef, "option3")
            XCTAssertEqual(solutions[2].status, SolutionStatus.doesNotMeetPreference)
            XCTAssertNotNil(solutions[2].statusCause)
            XCTAssertNil(solutions[3].shadowMe)
            XCTAssertNil(solutions[3].shadows)
            XCTAssertEqual(solutions[3].solutionRef, "option1")
            XCTAssertEqual(solutions[3].status, SolutionStatus.front)
            XCTAssertNil(solutions[3].statusCause)
            
            expectation.fulfill()
            
        }
        waitForExpectations()
    }
    
    // MARK: - Negative Tests
    
    func testGetDilemmaMalformedProblem() {
        let description = "Try to resolve a malformed problem."
        let expectation = self.expectation(description: description)
        
        let problem = Problem(
            columns: [],
            options: [],
            subject: "TestProblem"
        )
        
        let failure = { (error: Error) in
            expectation.fulfill()
        }
        
        tradeoffAnalytics.getDilemma(for: problem, failure: failure, success: failWithResult)
        waitForExpectations()
    }
}
