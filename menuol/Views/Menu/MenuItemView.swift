//
//  MenuItemView.swift
//  menuol
//
//  Created by Ondřej Hanák on 15.06.2022.
//  Copyright © 2022 Ondrej Hanak. All rights reserved.
//

import SwiftUI

struct MenuItemView: View {
	var menuItem: MenuItem?

	var title: String {
		if let menuItem {
			return menuItem.title
		} else {
			return "Restaurace nedodala aktuální údaje"
		}
	}

	var body: some View {
		HStack {
			Text(title)
				.foregroundColor(.primary)
			Spacer()
			if let price = menuItem?.priceDescription, !price.isEmpty {
				Text(price)
					.foregroundColor(.primary)
					.font(.caption)
					.padding(5)
					.background(Color(.systemGray5))
					.cornerRadius(5)
			}
		}
	}
}

#Preview {
	MenuItemView(menuItem: MenuItem.demoItems[0])
}
