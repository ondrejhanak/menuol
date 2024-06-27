//
//  HTTPClientTests.swift
//  tests
//
//  Created by Ondřej Hanák on 04. 02. 2020.
//  Copyright © 2020 Ondrej Hanak. All rights reserved.
//

@testable import menuol
import XCTest

final class HTTPClientTests: XCTestCase {
	private var testingURLSession: URLSession {
		let config: URLSessionConfiguration = .ephemeral
		config.protocolClasses = [MockURLProtocol.self]
		let session = URLSession(configuration: config)
		return session
	}

	func testSuccess() async {
		let string = "hello"
		let data = string.data(using: .utf8)!
		MockURLProtocol.error = nil
		MockURLProtocol.requestHandler = { request in
			let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
			return (response, data)
		}
		let client = HTTPClient(session: testingURLSession)
		let url = URL(string: "localhost")!
		do {
			let result = try await client.get(url: url)
			XCTAssertEqual(result, string)
		} catch {
			XCTFail("Should have not throw.")
		}
	}

	func testFailure() async {
		MockURLProtocol.error = NSError(domain: "test", code: 1)
		let client = HTTPClient(session: testingURLSession)
		let url = URL(string: "localhost")!
		do {
			_ = try await client.get(url: url)
			XCTFail("Should have thrown.")
		} catch {
		}
	}
}
