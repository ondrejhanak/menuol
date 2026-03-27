//
//  VenueRepository.swift
//  menuol
//
//  Created by Ondrej Hanak on 24.06.2025.
//  Copyright © 2025 Ondrej Hanak. All rights reserved.
//

import Combine
import Foundation

final class VenueRepository: ObservableObject {
	private let httpClient: HTTPClientType
	private let htmlParser: HTMLParserType
	@Published private(set) var venues: [Venue] = []

	init(httpClient: HTTPClientType, htmlParser: HTMLParserType) {
		self.httpClient = httpClient
		self.htmlParser = htmlParser
	}

	func fetch() async throws {
		let url = URL(string: "https://www.olomouc.cz/poledni-menu")!
		let html = try await httpClient.get(url: url)
		venues = htmlParser.venuesWithMenuItems(from: html)
	}
}
