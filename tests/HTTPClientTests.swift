//
//  HTTPClientTests.swift
//  unittests
//
//  Created by Ondřej Hanák on 04. 02. 2020.
//  Copyright © 2020 Ondrej Hanak. All rights reserved.
//

@testable import menuol
import XCTest

class URLSessionDataTaskMock: URLSessionDataTask {
	private let closure: () -> Void

	init(closure: @escaping () -> Void) {
		self.closure = closure
	}

	override func resume() {
		closure()
	}
}

class URLSessionMock: URLSession {
	typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

	var data: Data?
	var error: Error?

	override func dataTask(with url: URL, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
		URLSessionDataTaskMock { completionHandler(self.data, nil, self.error) }
	}
}

final class HTTPClientTests: XCTestCase {
	func testSuccess() {
		let string = "hello"
		let data = string.data(using: .utf8)!
		let session = URLSessionMock()
		session.data = data
		let client = HTTPClient(session: session)
		let url = URL(string: "localhost")!
		let expectation = XCTestExpectation(description: "")
		var r: HTTPClient.HTTPResult?
		client.get(url: url) { result in
			r = result
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 1)
		XCTAssertEqual(r, HTTPClient.HTTPResult.success(string))
	}

	func testFailure() {
		let session = URLSessionMock()
		session.data = nil
		let client = HTTPClient(session: session)
		let url = URL(string: "localhost")!
		let expectation = XCTestExpectation(description: "")
		var r: HTTPClient.HTTPResult?
		client.get(url: url) { result in
			r = result
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 1)
		XCTAssertEqual(r, HTTPClient.HTTPResult.failure(HTTPClient.HTTPError()))
	}
}
