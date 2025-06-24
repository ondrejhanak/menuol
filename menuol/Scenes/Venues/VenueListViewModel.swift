//
//  VenueManager.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation
import Factory
import Combine
import UIKit

@MainActor
final class VenueListViewModel: ObservableObject {
	@Injected(\.httpClient) private var httpClient
	@Injected(\.htmlParser) private var htmlParser
	@Injected(\.favoriteSlugsStorage) private var favoriteVenueSlugs
	@Injected(\.appCoordinator) private var appCoordinator
	private var cancellables: Set<AnyCancellable> = []
	@Published private var parsedVenues: [Venue] = []
	@Published var searchPhrase = ""
	@Published var visibleVenues: [Venue] = []
	@Published var isLoading = false

	// MARK: - Init

	init() {
		Publishers.CombineLatest(
			$parsedVenues,
			$searchPhrase
				.debounce(for: .seconds(0.3), scheduler: RunLoop.main)
		)
		.sink { [weak self] venues, phrase in
			self?.updateVisibleVenues(phrase: phrase)
		}
		.store(in: &cancellables)

		NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
			.sink { _ in
				Task { [weak self] in
					try? await self?.fetchVenues()
				}
			}
			.store(in: &cancellables)
	}

	// MARK: - Public

	func showMenu(ofVenue venue: Venue) {
		appCoordinator.showMenu(ofVenue: venue)
	}

	/// Fetches list of venues along with menu.
	func fetchVenues() async throws {
		isLoading = true
		defer {
			isLoading = false
		}
		let url = URL(string: "https://www.olomouc.cz/poledni-menu")!
		let html = try await httpClient.get(url: url)
		parsedVenues = htmlParser.venuesWithMenuItems(from: html)
	}

	/// Toggles favorite state of given venue.
	func toggleFavorite(_ venue: Venue) {
		if isFavorited(venue) {
			favoriteVenueSlugs.remove(venue.slug)
		} else {
			favoriteVenueSlugs.save(venue.slug)
		}
		updateVisibleVenues(phrase: searchPhrase)
	}

	// MARK: - Private

	private func isFavorited(_ venue: Venue) -> Bool {
		favoriteVenueSlugs.contains(venue.slug)
	}

	private func updateVisibleVenues(phrase: String) {
		let filteredVenues = parsedVenues.filter { venue in
			phrase.isEmpty || venue.name.localizedStandardContains(phrase)
		}
		let processedVenues = filteredVenues.map { venue in
			var newVenue = venue
			newVenue.isFavorited = isFavorited(venue)
			return newVenue
		}
		let sortedVenues = processedVenues.sorted { v1, v2 in
			if v1.isFavorited == v2.isFavorited {
				return v1.name < v2.name
			}
			return v1.isFavorited
		}
		visibleVenues = sortedVenues
	}
}
