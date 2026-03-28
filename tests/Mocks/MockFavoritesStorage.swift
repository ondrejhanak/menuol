//
//  MockFavoritesStorage.swift
//  tests
//
//  Created by Ondrej Hanak on 28.03.2026.
//  Copyright © 2026 Ondrej Hanak. All rights reserved.
//

import Foundation
@testable import menuol

final class MockFavoritesStorage: FavoritesStorageType {
	private var storage: Set<String> = []

	func save(_ string: String) { storage.insert(string) }
	func remove(_ string: String) { storage.remove(string) }
	func contains(_ string: String) -> Bool { storage.contains(string) }
}
