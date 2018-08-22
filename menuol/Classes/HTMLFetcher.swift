//
//  HTMLFetcher.swift
//  menuol
//
//  Created by Ondrej Hanak on 04/02/2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

import Foundation
import Result
import UIKit

final class HTMLFetcher {
	struct HTMLFetcherError: Error {
	}

	// MARK: - Public

	public func fetchVenueHTML(for date: Date, callback: @escaping (Result<String, HTMLFetcherError>) -> Void) {
		let url = self.venueURL(date: date)
		self.fetchHTML(url: url, callback: callback)
	}

	public func fetchMenuHTML(slug: String, callback: @escaping (Result<String, HTMLFetcherError>) -> Void) {
		let url = self.venueMenuURL(slug: slug)
		self.fetchHTML(url: url, callback: callback)
	}

	// MARK: - Private

	internal func fetchHTML(url: URL, callback: @escaping (Result<String, HTMLFetcherError>) -> Void) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let task = URLSession.shared.dataTask(with: url) { data, _, error in
			guard error == nil, let data = data, let html = String(data: data, encoding: .utf8) else {
				DispatchQueue.main.async {
					callback(.failure(HTMLFetcherError()))
				}
				return
			}
			DispatchQueue.main.async {
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
				callback(.success(html))
			}
		}
		task.resume()
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
