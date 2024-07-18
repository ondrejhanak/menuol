//
//  VenueListView.swift
//  menuol
//
//  Created by Ondřej Hanák on 30.07.2022.
//  Copyright © 2022 Ondrej Hanak. All rights reserved.
//

import SwiftUI

struct VenueListView: View {
	@ObservedObject var venueManager: VenueManager
	@Environment(\.scenePhase) var scenePhase
	@StateObject var searchDebouncer = Debouncer<String>(initialValue: "", delay: 0.2)

	var body: some View {
		ZStack {
			NavigationView {
				List(venueManager.visibleVenues) { venue in
					NavigationLink(destination: MenuListView(venue: venue)) {
						VenueItemView(venue: venue) { venue in
							toggleFavourite(venue)
						}
					}
				}
				.listStyle(.grouped)
				.navigationTitle("Polední menu")
			}
			if venueManager.isLoading {
				ProgressView()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.background(Color.white)
			}
		}
		.onChange(of: scenePhase) { newPhase in
			if newPhase == .active {
				fetchData()
			}
		}
		.animation(.easeInOut(duration: 0.2), value: venueManager.visibleVenues)
		.searchable(text: $searchDebouncer.value)
		.onChange(of: searchDebouncer.debouncedValue) { phrase in
			searchVenues(phrase: phrase)
		}
	}

	// MARK: - Private

	private func toggleFavourite(_ venue: Venue) {
		venueManager.toggleFavorite(venue)
	}

	private func searchVenues(phrase: String) {
		venueManager.applySearchPhrase(phrase)
	}

	private func fetchData() {
		Task {
			try? await venueManager.fetchVenues()
		}
	}
}

#Preview {
	VenueListView(venueManager: VenueManager(httpClient: HTTPClient(), htmlParser: HTMLParser()))
}
