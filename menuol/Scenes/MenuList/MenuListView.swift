//
//  MenuListView.swift
//  menuol
//
//  Created by Ondřej Hanák on 21.07.2022.
//  Copyright © 2022 Ondrej Hanak. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit

struct MenuListView: View {
	let viewModel: MenuListViewModel

	var body: some View {
		Group {
			if viewModel.venue.menuItems.isEmpty {
				noDetailsView
			} else {
				listView
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.navigationTitle(viewModel.venue.name)
		.navigationBarTitleDisplayMode(.inline)
		.background(Color(UIColor.systemGroupedBackground))
		.task {
			await viewModel.loadMapRegion()
		}
	}

	@ViewBuilder
	private var listView: some View {
		List {
			map
				.listRowSeparator(.hidden)
				.listRowInsets(EdgeInsets())
			Text(viewModel.venue.address)
				.font(.footnote)
				.foregroundStyle(.secondary)
			if viewModel.venue.note.isEmpty == false {
				Text(viewModel.venue.note)
					.font(.footnote)
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.horizontal, 20)
					.padding(.vertical, 12)
					.background(.accentBackground)
					.listRowSeparator(.hidden)
					.listRowInsets(EdgeInsets())
			}
			ForEach(viewModel.venue.menuItems) { item in
				MenuItemView(menuItem: item)
			}
		}
		.listStyle(.plain)
	}

	private var map: some View {
		Group {
			if let mapRegion = viewModel.mapRegion {
				Map(position: .constant(.region(mapRegion)), interactionModes: []) {
					Marker(viewModel.venue.name, coordinate: mapRegion.center)
						.tint(.red)
				}
			} else if viewModel.mapError != nil {
				Text("Unable to load map.")
					.foregroundColor(.secondary)
			} else {
				ProgressView("načítám mapu")
			}
		}
		.frame(maxWidth: .infinity, alignment: .center)
		.frame(height: 220)
	}

	private var noDetailsView: some View {
		Text("Restaurace nedodala aktuální údaje.")
	}
}

#Preview("Items") {
	NavigationStack {
		MenuListView(viewModel: MenuListViewModel(venue: Venue.stubFilled, geocoder: Preview.MockGeocoder()))
	}
}

#Preview("Empty") {
	NavigationStack {
		MenuListView(viewModel: MenuListViewModel(venue: Venue.stubEmpty, geocoder: Preview.MockGeocoder()))
	}
}
