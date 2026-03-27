//
//  HTTPClientTests.swift
//  tests
//
//  Created by Ondřej Hanák on 04. 02. 2020.
//  Copyright © 2020 Ondrej Hanak. All rights reserved.
//

import Foundation
@testable import menuol
import Testing

@Suite(.serialized)
struct HTTPClientTests {
	private var testingURLSession: URLSession {
		let config: URLSessionConfiguration = .ephemeral
		config.protocolClasses = [MockURLProtocol.self]
		let session = URLSession(configuration: config)
		return session
	}

	@Test func success() async throws {
		let string = "hello"
		let data = string.data(using: .utf8)!
		MockURLProtocol.error = nil
		MockURLProtocol.requestHandler = { request in
			let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
			return (response, data)
		}
		let client = HTTPClient(session: testingURLSession)
		let url = URL(string: "localhost")!
		let result = try await client.get(url: url)
		#expect(result == string)
	}

	@Test func failure() async {
		MockURLProtocol.error = NSError(domain: "test", code: 1)
		let client = HTTPClient(session: testingURLSession)
		let url = URL(string: "localhost")!
		await #expect(throws: (any Error).self) {
			_ = try await client.get(url: url)
		}
	}
}
