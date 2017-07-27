//
//  String+oh.swift
//  menuol
//
//  Created by Ondrej Hanak on 27/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation

extension String {

	func capitalizingFirstLetter() -> String {
		let first = String(characters.prefix(1)).capitalized
		let other = String(characters.dropFirst())
		return first + other
	}

	mutating func capitalizeFirstLetter() {
		self = self.capitalizingFirstLetter()
	}

}
