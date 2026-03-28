//
//  FavoritesStorage.swift
//  menuol
//
//  Created by Ondřej Hanák on 17.11.2024.
//  Copyright © 2024 Ondrej Hanak. All rights reserved.
//

import Foundation

// MARK: - FavoritesStorageType

protocol FavoritesStorageType: AnyObject {
	func save(_ string: String)
	func remove(_ string: String)
	func contains(_ string: String) -> Bool
}

@Observable
final class FavoritesStorage: FavoritesStorageType {
	private let userDefaults: UserDefaultsType
	private let key = "FavoriteVenueSlugs"

	private var values: Set<String> = [] {
		didSet {
			userDefaults.set(Array(values), forKey: key)
		}
	}

	init(userDefaults: UserDefaultsType) {
		self.userDefaults = userDefaults
		values = Set(userDefaults.array(forKey: key)?.compactMap { $0 as? String } ?? [])
	}

	func save(_ string: String) {
		values.insert(string)
	}

	func remove(_ string: String) {
		values.remove(string)
	}

	func contains(_ string: String) -> Bool {
		values.contains(string)
	}
}
