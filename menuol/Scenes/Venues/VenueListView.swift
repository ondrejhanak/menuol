//
//  VenueListView.swift
//  menuol
//
//  Created by Ondřej Hanák on 30.07.2022.
//  Copyright © 2022 Ondrej Hanak. All rights reserved.
//

import SwiftUI

struct VenueListView: View {
	@StateObject var viewModel: VenueListViewModel
	@Environment(\.scenePhase) var scenePhase

	var body: some View {
		List(viewModel.visibleVenues) { venue in
			NavigationLink(destination: MenuListView(venue: venue)) {
				VenueItemView(venue: venue) { venue in
					toggleFavorite(venue)
				}
			}
		}
		.listStyle(.grouped)
		.navigationTitle("Polední menu")
		.overlay {
			if viewModel.isLoading {
				LoadingView()
			}
		}
		.onChange(of: scenePhase) { newPhase in
			if newPhase == .active {
				fetchData()
			}
		}
		.animation(.easeInOut(duration: 0.2), value: viewModel.visibleVenues)
		.searchable(text: $viewModel.searchPhrase)
	}

	// MARK: - Private

	private func toggleFavorite(_ venue: Venue) {
		viewModel.toggleFavorite(venue)
	}

	private func fetchData() {
		Task {
			try? await viewModel.fetchVenues()
		}
	}
}

#Preview {
	NavigationStack {
		VenueListView(viewModel: .init())
	}
}
