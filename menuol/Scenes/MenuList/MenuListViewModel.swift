//
//  MenuListViewModel.swift
//  menuol
//
//  Created by Ondrej Hanak on 24.06.2025.
//  Copyright © 2025 Ondrej Hanak. All rights reserved.
//

import Combine

@MainActor
final class MenuListViewModel: ObservableObject {
	let venue: Venue

	init(venue: Venue) {
		self.venue = venue
	}
}
