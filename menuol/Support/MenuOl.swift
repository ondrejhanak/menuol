//
//  MenuOl.swift
//  menuol
//
//  Created by Ondřej Hanák on 04.08.2022.
//  Copyright © 2022 Ondrej Hanak. All rights reserved.
//

import SwiftUI

@main
struct MenuOl: App {
	@State private var venues: [Venue] = []
	@State private var loading = true

	var body: some Scene {
		WindowGroup {
			ZStack {
				VenueListView(venues: venues)
				ProgressView()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.background(Color.white)
					.opacity(loading ? 1 : 0)
			}
			.onAppear(perform: loadVenues)
		}
	}

	private func loadVenues() {
		Task {
			loading = true
			let newVenues = try? await VenueManager().fetchVenues()
			venues = newVenues ?? []
			withAnimation(.default) {
				loading = false
			}
		}
	}
}
