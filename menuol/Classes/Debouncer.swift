//
//  Debouncer.swift
//  menuol
//
//  Created by Ondřej Hanák on 27.06.2024.
//  Copyright © 2024 Ondrej Hanak. All rights reserved.
//

import Combine
import Foundation

final class Debouncer<T>: ObservableObject {
	@Published var value: T
	@Published var debouncedValue: T

	init(initialValue: T, delay: TimeInterval) {
		value = initialValue
		debouncedValue = initialValue
		$value
			.debounce(for: .seconds(delay), scheduler: RunLoop.main)
			.assign(to: &$debouncedValue)
	}
}
