//
//  StringStorage.swift
//  menuol
//
//  Created by Ondřej Hanák on 17.11.2024.
//  Copyright © 2024 Ondrej Hanak. All rights reserved.
//

import Foundation

@Observable
final class StringStorage {
	private let userDefaults: UserDefaults
	private let key: String

	var values: Set<String> = [] {
		didSet {
			userDefaults.set(Array(values), forKey: key)
		}
	}

	init(key: String, userDefaults: UserDefaults = .standard) {
		self.key = key
		self.userDefaults = userDefaults
		values = Set(userDefaults.array(forKey: key)?.compactMap { String(describing: $0) } ?? [])
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
