//
//  School_BusTests.swift
//  School BusTests
//
//  Created by Yuto on 2024/08/12.
//

import XCTest
@testable import SIT_Bus

final class SIT_BusTests: XCTestCase {

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    func testFetch() {
        let testBundle = Bundle(for: SIT_BusTests.self)
        do {
            let data = try Data(contentsOf: URL(filePath: testBundle.path(forResource: "bus_data", ofType: "json")!))
            let result = try JSONDecoder().decode(SBReferenceData.self, from: data)
            print(result.getTimesheet(for: .now))
        } catch {
            print(error)
            XCTFail()
        }
    }
    
    func testFetchForOperationDate() {
        let testBundle = Bundle(for: SIT_BusTests.self)
        do {
            let data = try Data(contentsOf: URL(filePath: testBundle.path(forResource: "bus_data", ofType: "json")!))
            let result = try JSONDecoder().decode(SBReferenceData.self, from: data)
            
            let testDate = Date.createDate(year: 2024, month: 8, day: 5)!
            let timesheet = result.getTimesheet(for: testDate)
            
            let expectation = expectation(description: "Operation Date")
            if timesheet != nil {
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 5)
        } catch {
            print(error)
            XCTFail()
        }
    }
    
    func testFetchForNonOperationDate() {
        let testBundle = Bundle(for: SIT_BusTests.self)
        do {
            let data = try Data(contentsOf: URL(filePath: testBundle.path(forResource: "bus_data", ofType: "json")!))
            let result = try JSONDecoder().decode(SBReferenceData.self, from: data)
            
            let testDate = Date.createDate(year: 2024, month: 8, day: 12)!
            let timesheet = result.getTimesheet(for: testDate)
            
            let expectation = expectation(description: "Non Operation Date")
            if timesheet == nil {
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 5)
        } catch {
            print(error)
            XCTFail()
        }
    }

}
