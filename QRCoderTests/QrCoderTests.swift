//
//  QrCoderTests.swift
//  QrCoderTests
//
//  Created by Frank Cheng on 2019/5/30.
//  Copyright © 2019 Frank Cheng. All rights reserved.
//

import XCTest
@testable import QRCoder

class QrCoderTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let e = expectation(description: "parse favicon")
        URL(string: "https://www.cnbeta.com")?.parseFavIcon(complete: { (image) in
            e.fulfill()
        })
        wait(for: [e], timeout: 5)
    }
}
