//
//  StringStorage.swift
//  menuol
//
//  Created by Ondřej Hanák on 17.11.2024.
//  Copyright © 2024 Ondrej Hanak. All rights reserved.
//

import Foundation

final class StringStorage {
	private var key: String

	init(key: String) {
		self.key = key
	}

	private var favoriteVenues: [String] {
		get {
			UserDefaults.standard.array(forKey: key)?.compactMap { String(describing: $0) } ?? []
		}
		set {
			UserDefaults.standard.set(newValue, forKey: key)
		}
	}

	func save(_ string: String) {
		favoriteVenues.append(string)
	}

	func remove(_ string: String) {
		if let index = favoriteVenues.firstIndex(of: string) {
			favoriteVenues.remove(at: index)
		}
	}

	func contains(_ string: String) -> Bool {
		favoriteVenues.contains(string)
	}
}
