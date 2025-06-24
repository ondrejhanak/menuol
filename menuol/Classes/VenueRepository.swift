//
//  VenueRepository.swift
//  menuol
//
//  Created by Ondrej Hanak on 24.06.2025.
//  Copyright © 2025 Ondrej Hanak. All rights reserved.
//

import Combine
import Factory
import Foundation

final class VenueRepository {
	@Injected(\.httpClient) private var httpClient
	@Injected(\.htmlParser) private var htmlParser
	private var cancellables: Set<AnyCancellable> = []
	@Published private(set) var venues: [Venue] = []

	func fetch() async throws {
		let url = URL(string: "https://www.olomouc.cz/poledni-menu")!
		let html = try await httpClient.get(url: url)
		venues = htmlParser.venuesWithMenuItems(from: html)
	}
}
