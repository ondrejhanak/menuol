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
		if let item = menuItem {
			return item.title
		} else {
			return "Restaurace nedodala aktuální údaje"
		}
	}

	var body: some View {
		HStack {
			Text(title)
				.foregroundColor(.primary)
			Spacer()
			Text(menuItem?.priceDescription ?? "")
				.foregroundColor(.primary)
				.font(.caption)
		}
	}
}

struct MenuItemView_Previews: PreviewProvider {
	static var previews: some View {
		MenuItemView(menuItem: MenuItem.demoItems[0])
	}
}
