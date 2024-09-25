//
//  MockURLProtocol.swift
//  tests
//
//  Created by Ondřej Hanák on 04.02.2024.
//

import Foundation

final class MockURLProtocol: URLProtocol {
	static var error: Error?
	static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

	override static func canInit(with request: URLRequest) -> Bool {
		return true
	}

	override static func canonicalRequest(for request: URLRequest) -> URLRequest {
		return request
	}

	override func startLoading() {
		if let error = MockURLProtocol.error {
			client?.urlProtocol(self, didFailWithError: error)
			return
		}

		guard let handler = MockURLProtocol.requestHandler else {
			assertionFailure("Unexpected state with no handler or error set.")
			return
		}

		do {
			let (response, data) = try handler(request)
			client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
			client?.urlProtocol(self, didLoad: data)
			client?.urlProtocolDidFinishLoading(self)
		} catch {
			client?.urlProtocol(self, didFailWithError: error)
		}
	}

	override func stopLoading() {}
}
