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
	@StateObject var viewModel: MenuListViewModel

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
				.foregroundStyle(.secondary)
			ForEach(viewModel.venue.menuItems) { item in
				MenuItemView(menuItem: item)
			}
		}
		.listStyle(.plain)
	}

	private var map: some View {
		Group {
			if let mapRegion = viewModel.mapRegion {
				Map(
					coordinateRegion: .constant(mapRegion),
					interactionModes: [],
					annotationItems: [
						MapAnnotation(id: viewModel.venue.id, coordinate: mapRegion.center)
					]
				) { pin in
					MapMarker(coordinate: pin.coordinate, tint: .red)
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
		MenuListView(viewModel: .init(venue: Venue.stubFilled))
	}
}

#Preview("Empty") {
	NavigationStack {
		MenuListView(viewModel: .init(venue: Venue.stubEmpty))
	}
}
