//
//  VenueManager.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation
import UIKit

@Observable
@MainActor
final class VenueListViewModel {
	private let venueRepository: VenueRepository
	private let favoriteSlugsStorage: FavoritesStorageType
	private let onShowMenu: (Venue) -> Void
	@ObservationIgnored nonisolated(unsafe) private var foregroundTask: Task<Void, Never>?
	var searchPhrase = ""
	var showSpinner = false

	var venues: [Venue] {
		venueRepository.venues
			.filter { searchPhrase.isEmpty || $0.name.localizedStandardContains(searchPhrase) }
			.sorted { lhs, rhs in
				let lhsIsFavorited = favoriteSlugsStorage.contains(lhs.slug)
				let rhsIsFavorited = favoriteSlugsStorage.contains(rhs.slug)
				if lhsIsFavorited == rhsIsFavorited {
					return lhs.name < rhs.name
				}
				return lhsIsFavorited
			}
	}

	// MARK: - Init

	init(venueRepository: VenueRepository, favoriteSlugsStorage: FavoritesStorageType, onShowMenu: @escaping (Venue) -> Void) {
		self.venueRepository = venueRepository
		self.favoriteSlugsStorage = favoriteSlugsStorage
		self.onShowMenu = onShowMenu
		foregroundTask = Task { [weak self] in
			for await _ in NotificationCenter.default.notifications(named: UIApplication.didBecomeActiveNotification) {
				try? await self?.fetchVenues()
			}
		}
	}

	deinit {
		foregroundTask?.cancel()
	}

	// MARK: - Public

	func isFavorited(_ venue: Venue) -> Bool {
		favoriteSlugsStorage.contains(venue.slug)
	}

	func showMenu(ofVenue venue: Venue) {
		onShowMenu(venue)
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
