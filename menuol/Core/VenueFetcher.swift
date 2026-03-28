//
//  VenueFetcher.swift
//  menuol
//
//  Created by Ondrej Hanak on 24.06.2025.
//  Copyright © 2025 Ondrej Hanak. All rights reserved.
//

import Foundation

struct VenueFetcher: Sendable {
	private let httpClient: HTTPClientType
	private let htmlParser: HTMLParserType

	init(httpClient: HTTPClientType, htmlParser: HTMLParserType) {
		self.httpClient = httpClient
		self.htmlParser = htmlParser
	}

	func fetch() async throws -> [Venue] {
		let url = URL(string: "https://www.olomouc.cz/poledni-menu")!
		let html = try await httpClient.get(url: url)
		return htmlParser.venuesWithMenuItems(from: html)
	}
}
