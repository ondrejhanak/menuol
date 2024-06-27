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
	var favoriteCallback: (Venue) -> Void

	var body: some View {
		HStack(spacing: 10) {
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
			Spacer()
			Button {
				favoriteCallback(venue)
			} label: {
				let imageName = venue.isFavorited ? "heart.fill" : "heart"
				Image(systemName: imageName)
					.foregroundColor(.black.opacity(0.8))
					.frame(width: 44, height: 44)
					.accessibilityLabel("Toggle favorite.")
			}
			.buttonStyle(.borderless) // otherwise whole wiew triggers tap action
		}
	}
}

struct VenueItemView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			VenueItemView(venue: Venue.demoVenueImage) { _ in }
			VenueItemView(venue: Venue.demoVenueNoImage) { _ in }
		}
	}
}
