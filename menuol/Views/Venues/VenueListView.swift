//
//  VenueListView.swift
//  menuol
//
//  Created by Ondřej Hanák on 30.07.2022.
//  Copyright © 2022 Ondrej Hanak. All rights reserved.
//

import SwiftUI

struct VenueListView: View {
	@ObservedObject var manager = VenueManager()
	@Environment(\.scenePhase) var scenePhase

	var body: some View {
		ZStack {
			NavigationView {
				List(manager.visibleVenues) { venue in
					NavigationLink(destination: MenuListView(venue: venue)) {
						VenueItemView(venue: venue) { venue in
							toggleFavourite(venue)
						}
					}
				}
				.listStyle(.grouped)
				.navigationTitle("Polední menu")
			}
			if manager.isLoading {
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
	}

	// MARK: - Private

	private func toggleFavourite(_ venue: Venue) {
		manager.toggleFavorite(venue)
	}

	private func fetchData() {
		Task {
			try? await manager.fetchVenues()
		}
	}
}

struct VenueListView_Previews: PreviewProvider {
	static var previews: some View {
		VenueListView()
	}
}
