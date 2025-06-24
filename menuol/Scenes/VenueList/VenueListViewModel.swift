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
	@Injected(\.venueRepository) private var venueRepository
	@Injected(\.favoriteSlugsStorage) private var favoriteSlugsStorage
	@Injected(\.appCoordinator) private var appCoordinator
	private var cancellables: Set<AnyCancellable> = []
	@Published var searchPhrase = ""
	@Published var venues: [Venue] = []
	@Published var showSpinner = false

	// MARK: - Init

	init() {
		Publishers.CombineLatest(
			venueRepository.$venues,
			$searchPhrase
				.debounce(for: .seconds(0.3), scheduler: RunLoop.main)
		)
		.map { venues, searchPhrase in
			// search filter
			venues.filter { venue in
				searchPhrase.isEmpty || venue.name.localizedStandardContains(searchPhrase)
			}
		}
		.combineLatest(favoriteSlugsStorage.$values)
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
		.receive(on: RunLoop.main)
		.assign(to: &$venues)

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
		favoriteSlugsStorage.contains(venue.slug)
	}

	func showMenu(ofVenue venue: Venue) {
		appCoordinator.showMenu(ofVenue: venue)
	}

	/// Fetches list of venues along with menu.
	func fetchVenues() async throws {
		showSpinner = venues.isEmpty
		defer {
			showSpinner = false
		}
		try await venueRepository.fetch()
	}

	/// Toggles favorite state of given venue.
	func toggleFavorite(_ venue: Venue) {
		if favoriteSlugsStorage.contains(venue.slug) {
			favoriteSlugsStorage.remove(venue.slug)
		} else {
			favoriteSlugsStorage.save(venue.slug)
		}
	}
}
