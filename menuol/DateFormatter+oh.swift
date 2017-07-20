//
//  DateFormatter+oh.swift
//  menuol
//
//  Created by Ondrej Hanak on 20/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import Foundation

extension DateFormatter {

	private static var dateOnlyFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter
	}()

	static func dateOnlyString(from: Date) -> String {
		return self.dateOnlyFormatter.string(from: from)
	}
	
}
