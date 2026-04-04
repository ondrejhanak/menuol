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

struct HTTPClientTests {
	@Test func success() async throws {
		let data = Data("hello".utf8)
		let session = MockURLProtocol.makeSession { _ in
			let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
			return (response, data)
		}
		let result = try await HTTPClient(session: session).get(url: URL(string: "localhost")!)
		#expect(result == "hello")
	}

	@Test func failure() async {
		let session = MockURLProtocol.makeSession(error: NSError(domain: "test", code: 1))
		await #expect(throws: (any Error).self) {
			_ = try await HTTPClient(session: session).get(url: URL(string: "localhost")!)
		}
	}
}
