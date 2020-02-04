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

	init(httpClient: HTTPClient = HTTPClient()) {
		self.httpClient = httpClient
	}

	// MARK: - Public

	public func fetchVenuePage(for date: Date, callback: @escaping (Result<String, Error>) -> Void) {
		let url = self.venueURL(date: date)
		self.httpClient.get(url: url, callback: callback)
	}

	public func fetchMenuPage(slug: String, callback: @escaping (Result<String, Error>) -> Void) {
		let url = self.venueMenuURL(slug: slug)
		self.httpClient.get(url: url, callback: callback)
	}

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
