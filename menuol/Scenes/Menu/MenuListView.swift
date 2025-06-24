//
//  MenuListView.swift
//  menuol
//
//  Created by Ondřej Hanák on 21.07.2022.
//  Copyright © 2022 Ondrej Hanak. All rights reserved.
//

import SwiftUI

struct MenuListView: View {
	var venue: Venue

	var body: some View {
		Group {
			if venue.menuItems.isEmpty {
				noDetailsView
			} else {
				listView
			}
		}
		.listStyle(.grouped)
		.navigationTitle(venue.name)
		.navigationBarTitleDisplayMode(.inline)
	}

	private var listView: some View {
		List {
			ForEach(venue.menuItems) { item in
				MenuItemView(menuItem: item)
			}
		}
	}

	private var noDetailsView: some View {
		Text("Restaurace nedodala aktuální údaje.")
	}
}

#Preview("Items") {
	NavigationStack {
		MenuListView(venue: .init(slug: "", name: "Populated menu", menuItems: MenuItem.demoItems))
	}
}

#Preview("Empty") {
	NavigationStack {
		MenuListView(venue: .init(slug: "", name: "Empty menu", menuItems: []))
	}
}
