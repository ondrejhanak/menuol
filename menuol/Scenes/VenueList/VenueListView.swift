//
//  VenueListView.swift
//  menuol
//
//  Created by Ondřej Hanák on 30.07.2022.
//  Copyright © 2022 Ondrej Hanak. All rights reserved.
//

import SwiftUI

struct VenueListView: View {
	@State private var viewModel: VenueListViewModel

	init(viewModel: VenueListViewModel) {
		_viewModel = State(initialValue: viewModel)
	}

	var body: some View {
		@Bindable var viewModel = viewModel
		List(viewModel.venues) { venue in
			Button {
				viewModel.showMenu(ofVenue: venue)
			} label: {
				VenueItemView(venue: venue, isFavorited: viewModel.isFavorited(venue)) { venue in
					viewModel.toggleFavorite(venue)
				}
			}
		}
		.listStyle(.grouped)
		.navigationTitle("Polední menu")
		.overlay {
			if viewModel.showSpinner {
				LoadingView()
			}
		}
		.animation(.easeInOut(duration: 0.2), value: viewModel.venues)
		.searchable(text: $viewModel.searchPhrase)
		.task {
			try? await viewModel.fetchVenues()
		}
	}
}

#Preview {
	NavigationStack {
		VenueListView(viewModel: VenueListViewModel(
			venueFetcher: VenueFetcher(httpClient: Preview.MockHTTPClient(), htmlParser: Preview.MockHTMLParser()),
			favoriteSlugsStorage: FavoritesStorage(userDefaults: Preview.MockUserDefaults())
		) { _ in })
	}
}
