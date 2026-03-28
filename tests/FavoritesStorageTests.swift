//
//  FavoritesStorageTests.swift
//  tests
//
//  Created by Ondrej Hanak on 28.03.2026.
//  Copyright © 2026 Ondrej Hanak. All rights reserved.
//

import Foundation
@testable import menuol
import Testing

final class FavoritesStorageTests {
	// MARK: - Core behavior

	@Test func save_makesContainReturnTrue() {
		let sut = FavoritesStorage(userDefaults: MockUserDefaults())
		sut.save("slug")
		#expect(sut.contains("slug"))
	}

	@Test func remove_makesContainReturnFalse() {
		let sut = FavoritesStorage(userDefaults: MockUserDefaults())
		sut.save("slug")
		sut.remove("slug")
		#expect(!sut.contains("slug"))
	}

	@Test func contains_returnsFalseForUnknownSlug() {
		let sut = FavoritesStorage(userDefaults: MockUserDefaults())
		#expect(!sut.contains("unknown"))
	}

	@Test func duplicateSave_removeOnceRemovesSlug() {
		let sut = FavoritesStorage(userDefaults: MockUserDefaults())
		sut.save("slug")
		sut.save("slug")
		sut.remove("slug")
		#expect(!sut.contains("slug"))
	}

	// MARK: - UserDefaults integration

	@Test func init_loadsFromUserDefaults() {
		let defaults = MockUserDefaults()
		defaults.set(["a", "b"], forKey: "FavoriteVenueSlugs")
		let sut = FavoritesStorage(userDefaults: defaults)
		#expect(sut.contains("a"))
		#expect(sut.contains("b"))
	}

	@Test func save_writesToUserDefaults() {
		let defaults = MockUserDefaults()
		let sut = FavoritesStorage(userDefaults: defaults)
		sut.save("slug")
		let stored = defaults.array(forKey: "FavoriteVenueSlugs") as? [String] ?? []
		#expect(stored.contains("slug"))
	}

	@Test func remove_updatesUserDefaults() {
		let defaults = MockUserDefaults()
		let sut = FavoritesStorage(userDefaults: defaults)
		sut.save("slug")
		sut.remove("slug")
		let stored = defaults.array(forKey: "FavoriteVenueSlugs") as? [String] ?? []
		#expect(!stored.contains("slug"))
	}

	// MARK: - Edge cases

	@Test func init_withEmptyUserDefaults_startsEmpty() {
		let sut = FavoritesStorage(userDefaults: MockUserDefaults())
		#expect(!sut.contains("anything"))
	}

	@Test func init_withNonStringValues_filtersThemOut() {
		let defaults = MockUserDefaults()
		defaults.set([1, "valid", true], forKey: "FavoriteVenueSlugs")
		let sut = FavoritesStorage(userDefaults: defaults)
		#expect(sut.contains("valid"))
		#expect(!sut.contains("1"))
	}

	@Test func remove_nonExistentSlug_doesNotCorruptState() {
		let sut = FavoritesStorage(userDefaults: MockUserDefaults())
		sut.save("keep")
		sut.remove("nonexistent")
		#expect(sut.contains("keep"))
	}
}
