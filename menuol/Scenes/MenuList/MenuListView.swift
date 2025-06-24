//
//  MenuListView.swift
//  menuol
//
//  Created by Ondřej Hanák on 21.07.2022.
//  Copyright © 2022 Ondrej Hanak. All rights reserved.
//

import SwiftUI
import UIKit

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
	}

	@ViewBuilder
	private var listView: some View {
		List {
			Text(viewModel.venue.address)
				.padding(.vertical)
				.foregroundStyle(.secondary)
			ForEach(viewModel.venue.menuItems) { item in
				MenuItemView(menuItem: item)
			}
		}
		.listStyle(.plain)
	}

	private var noDetailsView: some View {
		Text("Restaurace nedodala aktuální údaje.")
	}
}

#Preview("Items") {
	NavigationStack {
		MenuListView(viewModel: .init(venue: .init(slug: "", name: "Populated menu", address: "Some Nice place", menuItems: MenuItem.demoItems)))
	}
}

#Preview("Empty") {
	NavigationStack {
		MenuListView(viewModel: .init(venue: .init(slug: "", name: "Empty menu", address: "", menuItems: [])))
	}
}
