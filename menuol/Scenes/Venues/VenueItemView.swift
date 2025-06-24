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
		HStack(spacing: 10) {
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
		VStack(alignment: .leading, spacing: 2) {
			Text(venue.name)
				.font(.system(.body))
				.foregroundColor(.primary)
			if let description = venue.menuTimeDescription {
				Text(description)
					.font(.system(.caption))
					.foregroundColor(.primary)
			}
		}
	}

	private var favoriteButton: some View {
		Button {
			favoriteCallback(venue)
		} label: {
			let imageName = isFavorited ? "heart.fill" : "heart"
			Image(systemName: imageName)
				.foregroundColor(.primary.opacity(0.75))
				.frame(width: 44, height: 44)
				.accessibilityLabel("Toggle favorite.")
		}
		.buttonStyle(.borderless) // otherwise whole view triggers tap action
	}
}

#Preview {
	VStack {
		VenueItemView(venue: Venue.demoVenueImage, isFavorited: true) { _ in }
		VenueItemView(venue: Venue.demoVenueNoImage, isFavorited: false) { _ in }
	}
	.padding()
}
