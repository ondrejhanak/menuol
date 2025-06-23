//
//  VenueListView.swift
//  menuol
//
//  Created by Ondřej Hanák on 30.07.2022.
//  Copyright © 2022 Ondrej Hanak. All rights reserved.
//

import SwiftUI
import Factory

struct VenueListView: View {
	@StateObject var viewModel: VenueListViewModel
	@Environment(\.scenePhase) var scenePhase

	var body: some View {
		List(viewModel.visibleVenues) { venue in
			Button {
				viewModel.showMenu(ofVenue: venue)
			} label: {
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
		.onChange(of: scenePhase) { new in
			if new == .active {
				fetchData()
			}
		}
		.animation(.easeInOut(duration: 0.2), value: viewModel.visibleVenues)
		.searchable(text: $viewModel.searchPhrase)
		.task {
			fetchData()
		}
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
	let _ = Container.shared.htmlParser.register { HTMLParserMock() }
	let _ = Container.shared.httpClient.register { HTTPClientMock() }
	NavigationStack {
		VenueListView(viewModel: .init())
	}
}
