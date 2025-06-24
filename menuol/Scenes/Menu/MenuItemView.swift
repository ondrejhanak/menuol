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
		HStack {
			Text(menuItem.title)
				.foregroundColor(.primary)
			Spacer()
			if let price = menuItem.priceDescription, !price.isEmpty {
				Text(price)
					.foregroundColor(.primary)
					.font(.subheadline)
					.fontWeight(.semibold )
					.padding(.vertical, 6)
					.padding(.horizontal, 8)
					.background(Color(.systemGray5))
					.cornerRadius(5)
			}
		}
	}
}

#Preview {
	MenuItemView(menuItem: MenuItem.demoItems[0])
		.padding()
}
