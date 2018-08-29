//
//  HTMLFetcherTests.swift
//  unit tests
//
//  Created by Ondřej Hanák on 09. 08. 2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

import XCTest
@testable import menuol

private let kNetworkTimeout = 10.0

final class HTMLFetcherTests: XCTestCase {

	func testFetchHTMLFailure() {
		let expectation = XCTestExpectation(description: "HTML fetching")
		let fetcher = HTMLFetcher()
		let url = URL(string: "https://some.hopefully.non.existing.url.com")!
		fetcher.fetchHTML(url: url) { result in
			switch result {
			case .success:
				XCTFail("HTML fetching unexpectedly succeeded.")
			case .failure:
				expectation.fulfill()
			}
		}
		self.wait(for: [expectation], timeout: kNetworkTimeout)
	}

	func testFetchVenueHTML() {
		let expectation = XCTestExpectation(description: "Fetching venue HTML")
		let fetcher = HTMLFetcher()
		fetcher.fetchVenueHTML(for: Date()) { (result) in
			switch result {
			case .success:
				expectation.fulfill()
			case .failure:
				XCTFail("Venue HTML fetching unexpectedly failed.")
			}
		}
		self.wait(for: [expectation], timeout: kNetworkTimeout)
	}

	func testMenuVenueHTML() {
		let expectation = XCTestExpectation(description: "Fetching menu HTML")
		let fetcher = HTMLFetcher()
		fetcher.fetchMenuHTML(slug: "JAZZ-TIBET-CLUB-id38") { (result) in
			switch result {
			case .success:
				expectation.fulfill()
			case .failure:
				XCTFail("Menu HTML fetching unexpectedly failed.")
			}
		}
		self.wait(for: [expectation], timeout: kNetworkTimeout)
	}

}
