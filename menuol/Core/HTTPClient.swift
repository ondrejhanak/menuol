//
//  HTTPClient.swift
//  menuol
//
//  Created by Ondřej Hanák on 04. 02. 2020.
//  Copyright © 2020 Ondrej Hanak. All rights reserved.
//

import Foundation

protocol HTTPClientType: Sendable {
	func get(url: URL) async throws -> String
}

struct HTTPClient: HTTPClientType {
	private let session: URLSession

	// MARK: - Lifecycle

	init(session: URLSession = URLSession.shared) {
		self.session = session
	}

	// MARK: - Public

	func get(url: URL) async throws -> String {
		let (data, _) = try await session.data(from: url)
		let html = String(bytes: data, encoding: .utf8) ?? ""
		return html
	}
}
