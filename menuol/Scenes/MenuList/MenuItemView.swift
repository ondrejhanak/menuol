//
//  MenuItemView.swift
//  menuol
//
//  Created by Ondřej Hanák on 15.06.2022.
//  Copyright © 2022 Ondrej Hanak. All rights reserved.
//

import SwiftUI

struct MenuItemView: View {
	var menuItem: MenuItem

	var body: some View {
		ViewThatFits(in: .horizontal) {
			HStack {
				titleText
				Spacer()
				priceTag
			}
			VStack(alignment: .leading, spacing: 6) {
				titleText
				priceTag
			}
		}
	}

	private var titleText: some View {
		Text(menuItem.title)
			.foregroundStyle(.primary)
	}

	@ViewBuilder
	private var priceTag: some View {
		if let price = menuItem.priceDescription, !price.isEmpty {
			Text(price)
				.foregroundStyle(.primary)
				.font(.subheadline)
				.fontWeight(.semibold)
				.padding(.vertical, 6)
				.padding(.horizontal, 8)
				.background(.accentBackground)
				.clipShape(.rect(cornerRadius: 5))
		}
	}
}

#Preview {
	MenuItemView(menuItem: MenuItem.demoItems[0])
		.padding()
}
