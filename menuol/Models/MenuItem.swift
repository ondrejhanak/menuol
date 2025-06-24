//
//  MenuItem.swift
//  menuol
//
//  Created by Ondrej Hanak on 19/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation

struct MenuItem: Hashable {
	let title: String
	let order: Int
	let priceDescription: String?
}

extension MenuItem: Identifiable {
	var id: String {
		title
	}
}

extension MenuItem {
	static let demoItems = [
		MenuItem(title: "Lorem ipsum", order: 1, priceDescription: "125 Kč"),
		MenuItem(title: "Dolor sit amet", order: 2, priceDescription: "135 Kč"),
	]
}
