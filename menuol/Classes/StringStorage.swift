//
//  StringStorage.swift
//  menuol
//
//  Created by Ondřej Hanák on 17.11.2024.
//  Copyright © 2024 Ondrej Hanak. All rights reserved.
//

import Combine
import Foundation

final class StringStorage {
	private var cancellables: Set<AnyCancellable> = []
	private var key: String
	private var userDefaults: UserDefaults
	@Published var values: Set<String> = []

	init(key: String, userDefaults: UserDefaults = .standard) {
		self.key = key
		self.userDefaults = userDefaults
		values = Set(userDefaults.array(forKey: key)?.compactMap { String(describing: $0) } ?? [])
		$values
			.sink { [weak self] values in
				self?.userDefaults.set(Array(values), forKey: key)
			}
			.store(in: &cancellables)
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
