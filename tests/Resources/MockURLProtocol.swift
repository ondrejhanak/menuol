//
//  MockURLProtocol.swift
//  tests
//
//  Created by Ondřej Hanák on 04.02.2024.
//

import Foundation

final class MockURLProtocol: URLProtocol {
	private static let lock = NSLock()
	private static var registry: [String: (URLRequest) throws -> (HTTPURLResponse, Data)] = [:]
	private static let sessionIDHeader = "X-Mock-Session-ID"

	static func makeSession(handler: @escaping (URLRequest) throws -> (HTTPURLResponse, Data)) -> URLSession {
		let id = UUID().uuidString
		lock.withLock { registry[id] = handler }
		let config = URLSessionConfiguration.ephemeral
		config.protocolClasses = [MockURLProtocol.self]
		config.httpAdditionalHeaders = [sessionIDHeader: id]
		return URLSession(configuration: config)
	}

	static func makeSession(error: Error) -> URLSession {
		makeSession { _ in throw error }
	}

	override static func canInit(with request: URLRequest) -> Bool { true }
	override static func canonicalRequest(for request: URLRequest) -> URLRequest { request }

	override func startLoading() {
		guard
			let id = request.value(forHTTPHeaderField: Self.sessionIDHeader),
			let handler = Self.lock.withLock({ Self.registry[id] })
		else {
			client?.urlProtocol(self, didFailWithError: URLError(.unknown))
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
