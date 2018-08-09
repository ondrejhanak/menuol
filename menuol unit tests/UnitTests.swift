//
//  UnitTests.swift
//  menuol unit tests
//
//  Created by Ondřej Hanák on 09. 08. 2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

import XCTest
@testable import menuol

final class unitTests: XCTestCase {

	override func setUp() {
		super.setUp()
	}

	override func tearDown() {
		super.tearDown()
	}

	func testFetchHTMLSuccess() {
		let expectation = XCTestExpectation(description: "HTML fetching")
		let fetcher = HTMLFetcher()
		let url = URL(string: "https://example.org")!
		fetcher.fetchHTML(url: url) { result in
			switch result {
			case .success:
				expectation.fulfill()
			case .failure:
				XCTFail("HTML fetching unexpectedly failed.")
			}
		}
		self.wait(for: [expectation], timeout: 10)
	}

	func testFetchHTMLFailure() {
		let expectation = XCTestExpectation(description: "HTML fetching")
		let fetcher = HTMLFetcher()
		let url = URL(string: "https://asdfasdf.asdfasdfasd.fasdfasdf.com")!
		fetcher.fetchHTML(url: url) { result in
			switch result {
			case .success:
				XCTFail("HTML fetching unexpectedly succeeded.")
			case .failure:
				expectation.fulfill()
			}
		}
		self.wait(for: [expectation], timeout: 10)
	}

}
