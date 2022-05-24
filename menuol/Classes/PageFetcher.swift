//
//  PageFetcher.swift
//  menuol
//
//  Created by Ondrej Hanak on 04/02/2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

import Foundation
import UIKit

final class PageFetcher {
	private var httpClient: HTTPClient

	// MARK: - Lifecycle

	init(httpClient: HTTPClient = HTTPClient()) {
		self.httpClient = httpClient
	}

	// MARK: - Public

	func fetchVenuePage(for date: Date, callback: @escaping HTTPClient.HTTPCallback) {
		let url = venueURL(date: date)
		httpClient.get(url: url, callback: callback)
	}

	func fetchMenuPage(slug: String, callback: @escaping HTTPClient.HTTPCallback) {
		let url = venueMenuURL(slug: slug)
		httpClient.get(url: url, callback: callback)
	}

	// MARK: - Private

	private func venueURL(date: Date) -> URL {
		let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
		let year = components.year!
		let month = components.month!
		let day = components.day!
		let urlString = "https://www.olomouc.cz/poledni-menu/\(year)/\(month)/\(day)"
		let url = URL(string: urlString)!
		return url
	}

	private func venueMenuURL(slug: String) -> URL {
		let urlString = "https://www.olomouc.cz/poledni-menu/" + slug
		let url = URL(string: urlString)!
		return url
	}
}
