//
//  VenueItemView.swift
//  menuol
//
//  Created by Ondřej Hanák on 30.07.2022.
//  Copyright © 2022 Ondrej Hanak. All rights reserved.
//

import Kingfisher
import SwiftUI

struct VenueItemView: View {
	var venue: Venue
	var isFavorited: Bool
	var favoriteCallback: (Venue) -> Void

	var body: some View {
		HStack(spacing: 14) {
			image
			description
			Spacer()
			favoriteButton
		}
	}

	private var image: some View {
		KFImage(venue.imageURL)
			.placeholder {
				Color.gray.opacity(0.3)
					.overlay(
						Image(systemName: "camera")
							.foregroundColor(.gray)
							.accessibility(hidden: true)
					)
			}
			.resizable()
			.aspectRatio(contentMode: .fit)
			.frame(width: 50, height: 50)
			.accessibility(hidden: true)
	}

	private var description: some View {
		VStack(alignment: .leading, spacing: 4) {
			Text(venue.name)
				.font(.system(.body))
				.foregroundColor(.primary)
			if let description = venue.menuTimeDescription {
				Text(description)
					.font(.system(.caption))
					.foregroundColor(.secondary)
			}
		}
	}

	private var favoriteButton: some View {
		Button {
			favoriteCallback(venue)
		} label: {
			let color = isFavorited ? Color.accent : Color.secondary
			Image(systemName: "heart")
				.frame(width: 44, height: 44)
				.accessibilityLabel("Toggle favorite.")
				.tint(color)
		}
		.buttonStyle(.borderless) // otherwise whole view triggers tap action
	}
}

#Preview {
	VStack {
		VenueItemView(venue: Venue.stubFilled, isFavorited: true) { _ in }
		VenueItemView(venue: Venue.stubEmpty, isFavorited: false) { _ in }
	}
	.padding()
}
