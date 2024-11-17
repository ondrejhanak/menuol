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

	var body: some View {
		List(venueManager.visibleVenues) { venue in
			NavigationLink(destination: MenuListView(venue: venue)) {
				VenueItemView(venue: venue) { venue in
					toggleFavourite(venue)
				}
			}
		}
		.listStyle(.grouped)
		.navigationTitle("Polední menu")
		.overlay {
			if venueManager.isLoading {
				LoadingView()
			}
		}
		.onChange(of: scenePhase) { newPhase in
			if newPhase == .active {
				fetchData()
			}
		}
		.animation(.easeInOut(duration: 0.2), value: venueManager.visibleVenues)
		.searchable(text: $venueManager.searchPhrase)
	}

	// MARK: - Private

	private func toggleFavourite(_ venue: Venue) {
		venueManager.toggleFavorite(venue)
	}

	private func fetchData() {
		Task {
			try? await venueManager.fetchVenues()
		}
	}
}

#Preview {
	NavigationStack {
		VenueListView(venueManager: VenueManager())
	}
}
