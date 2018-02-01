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

	private static var czechDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "cs_CZ")
		formatter.dateFormat = "EEEE d. MMMM"
		return formatter
	}()

	static func dateOnlyString(from: Date) -> String {
		return self.dateOnlyFormatter.string(from: from)
	}

	static func czechDateString(from: Date) -> String {
		return self.czechDateFormatter.string(from: from)
	}
	
}
