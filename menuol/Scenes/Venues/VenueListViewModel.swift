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
	@Injected(\.favoriteSlugsStorage) private var favoriteSlugsStorage
	@Injected(\.appCoordinator) private var appCoordinator
	private var cancellables: Set<AnyCancellable> = []
	@Published private var parsedVenues: [Venue] = []
	@Published var searchPhrase = ""
	@Published var visibleVenues: [Venue] = []
	@Published var showSpinner = false
	@Published var favoriteSlugs: Set<String> = []

	// MARK: - Init

	init() {
		favoriteSlugs = Set(favoriteSlugsStorage.values)

		Publishers.CombineLatest(
			$parsedVenues,
			$searchPhrase
				.debounce(for: .seconds(0.3), scheduler: RunLoop.main)
		)
		.map { venues, searchPhrase in
			// search filter
			venues.filter { venue in
				searchPhrase.isEmpty || venue.name.localizedStandardContains(searchPhrase)
			}
		}
		.combineLatest($favoriteSlugs)
		.map { venues, favorites in
			// favorites first
			venues.sorted { lhs, rhs in
				let lhsIsFavorited = favorites.contains(lhs.slug)
				let rhsIsFavorited = favorites.contains(rhs.slug)
				if lhsIsFavorited == rhsIsFavorited {
					return lhs.name < rhs.name
				}
				return lhsIsFavorited
			}
		}
		.assign(to: &$visibleVenues)

		NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
			.sink { _ in
				Task { [weak self] in
					try? await self?.fetchVenues()
				}
			}
			.store(in: &cancellables)
	}

	// MARK: - Public

	func isFavorited(_ venue: Venue) -> Bool {
		favoriteSlugs.contains(venue.slug)
	}

	func showMenu(ofVenue venue: Venue) {
		appCoordinator.showMenu(ofVenue: venue)
	}

	/// Fetches list of venues along with menu.
	func fetchVenues() async throws {
		showSpinner = parsedVenues.isEmpty
		defer {
			showSpinner = false
		}
		let url = URL(string: "https://www.olomouc.cz/poledni-menu")!
		let html = try await httpClient.get(url: url)
		parsedVenues = htmlParser.venuesWithMenuItems(from: html)
	}

	/// Toggles favorite state of given venue.
	func toggleFavorite(_ venue: Venue) {
		if favoriteSlugs.contains(venue.slug) {
			favoriteSlugs.remove(venue.slug)
		} else {
			favoriteSlugs.insert(venue.slug)
		}
		favoriteSlugsStorage.values = Array(favoriteSlugs)
	}
}
