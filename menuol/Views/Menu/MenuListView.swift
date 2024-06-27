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
		List {
			if venue.menuItems.isEmpty {
				Text("Restaurace nedodala aktuální údaje.")
			} else {
				ForEach(venue.menuItems) { item in
					MenuItemView(menuItem: item)
				}
			}
		}
		.listStyle(.grouped)
		.navigationTitle(venue.name)
		.navigationBarTitleDisplayMode(.inline)
	}
}

struct MenuListView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			NavigationView {
				MenuListView(venue: Venue(name: "Menu items", menuItems: MenuItem.demoItems))
			}
			NavigationView {
				MenuListView(venue: Venue(name: "Empty menu", menuItems: []))
			}
		}
	}
}
