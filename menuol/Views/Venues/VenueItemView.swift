//
//  VenueItemView.swift
//  menuol
//
//  Created by Ondřej Hanák on 30.07.2022.
//  Copyright © 2022 Ondrej Hanak. All rights reserved.
//

import SwiftUI
import Kingfisher

struct VenueItemView: View {
	var venue: Venue

	var body: some View {
		HStack(spacing: 10) {
			KFImage(venue.imageURL)
				.placeholder {
					Color.gray.opacity(0.3)
						.overlay(
							Image(systemName: "camera")
								.foregroundColor(.gray)
						)
				}
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 50, height: 50)
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
				print("tapped")
			} label: {
				Image(systemName: "heart")
					.foregroundColor(.black.opacity(0.8))
					.frame(width: 44, height: 44)
			}
		}
	}
}

struct VenueItemView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			VenueItemView(venue: Venue.demoVenueImage)
			VenueItemView(venue: Venue.demoVenueNoImage)
		}
	}
}
