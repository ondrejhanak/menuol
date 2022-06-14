//
//  PageFetcherTests.swift
//  unit tests
//
//  Created by Ondřej Hanák on 09. 08. 2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

@testable import menuol
import XCTest

private let kNetworkTimeout = 10.0

final class PageFetcherTests: XCTestCase {
	func testFetchVenueHTML() {
		let expectation = XCTestExpectation(description: "Fetching venue HTML")
		let fetcher = PageFetcher()
		fetcher.fetchVenuePage { result in
			switch result {
			case .success:
				expectation.fulfill()
			case .failure:
				XCTFail("Venue HTML fetching unexpectedly failed.")
			}
		}
		wait(for: [expectation], timeout: kNetworkTimeout)
	}
}
