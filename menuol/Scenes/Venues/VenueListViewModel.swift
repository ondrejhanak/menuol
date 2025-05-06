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

@MainActor
final class VenueListViewModel: ObservableObject {
	@Injected(\.httpClient) private var httpClient
	@Injected(\.htmlParser) private var htmlParser
	@Injected(\.favoriteSlugsStorage) private var favoriteVenueSlugs
	private var searchDebouncer = Debouncer<String>(initialValue: "", delay: 0.2)
	private var parsedVenues: [Venue] = []
	private var bag: Set<AnyCancellable> = []
	@Published var searchPhrase = ""
	@Published var visibleVenues: [Venue] = []
	@Published var isLoading = false

	// MARK: - Init

	init() {
		$searchPhrase
			.assign(to: &searchDebouncer.$value)
		searchDebouncer.$debouncedValue
			.sink { [weak self] phrase in
				self?.updateVisibleVenues(phrase: phrase)
			}
			.store(in: &bag)
	}

	// MARK: - Public

	/// Fetches list of venues along with menu.
	func fetchVenues() async throws {
		isLoading = true
		defer {
			isLoading = false
		}
		let url = URL(string: "https://www.olomouc.cz/poledni-menu")!
		let html = try await httpClient.get(url: url)
		parsedVenues = htmlParser.venuesWithMenuItems(from: html)
		updateVisibleVenues(phrase: searchDebouncer.debouncedValue)
	}

	/// Toggles favorite state of given venue.
	func toggleFavorite(_ venue: Venue) {
		if isFavorited(venue) {
			favoriteVenueSlugs.remove(venue.slug)
		} else {
			favoriteVenueSlugs.save(venue.slug)
		}
		updateVisibleVenues(phrase: searchDebouncer.debouncedValue)
	}

	// MARK: - Private

	private func isFavorited(_ venue: Venue) -> Bool {
		favoriteVenueSlugs.contains(venue.slug)
	}

	private func updateVisibleVenues(phrase: String?) {
		let search = phrase ?? searchPhrase
		let filteredVenues = parsedVenues.filter { venue in
			searchPhrase.isEmpty || venue.name.localizedStandardContains(search)
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
