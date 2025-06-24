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

	var body: some View {
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
	let _ = Container.shared.htmlParser.register { HTMLParserMock() }
	let _ = Container.shared.httpClient.register { HTTPClientMock() }
	NavigationStack {
		VenueListView(viewModel: .init())
	}
}
