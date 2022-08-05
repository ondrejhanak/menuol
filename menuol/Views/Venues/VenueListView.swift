//
//  VenueListView.swift
//  menuol
//
//  Created by Ondřej Hanák on 30.07.2022.
//  Copyright © 2022 Ondrej Hanak. All rights reserved.
//

import SwiftUI

struct VenueListView: View {
	var venues: [Venue]

	var body: some View {
		NavigationView {
			List(venues) { venue in
				NavigationLink(destination: MenuListView(venue: venue)) {
					VenueItemView(venue: venue)
				}
			}
			.listStyle(.grouped)
			.navigationTitle("Polední menu")
		}
	}
}

struct VenueListView_Previews: PreviewProvider {
	static var previews: some View {
		VenueListView(venues: Venue.demoItems)
	}
}
