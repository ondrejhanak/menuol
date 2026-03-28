//
//  UserDefaults.swift
//  menuol
//
//  Created by Ondrej Hanak on 28.03.2026.
//  Copyright © 2026 Ondrej Hanak. All rights reserved.
//

import Foundation

protocol UserDefaultsType {
	func set(_ value: Any?, forKey defaultName: String)
	func array(forKey defaultName: String) -> [Any]?
}

extension UserDefaults: UserDefaultsType {}

#if DEBUG
final class MockUserDefaults: UserDefaultsType {
	private var storage: [String: Any] = [:]

	func set(_ value: Any?, forKey defaultName: String) {
		storage[defaultName] = value
	}

	func array(forKey defaultName: String) -> [Any]? {
		storage[defaultName] as? [Any]
	}
}
#endif
