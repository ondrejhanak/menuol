//
//  HTMLFetcher.swift
//  menuol
//
//  Created by Ondrej Hanak on 04/02/2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

import Foundation
import UIKit

final class HTMLFetcher {

	// MARK: - Public

	public func getVenueHTML(for date: Date, callback: @escaping (String?) -> Void) {
		let url = self.venueURL(date: date)
		self.getHTML(url: url, callback: callback)
	}

	public func getMenuHTML(slug: String, callback: @escaping (String?) -> Void) {
		let url = self.venueMenuURL(slug: slug)
		self.getHTML(url: url, callback: callback)
	}

	// MARK: - Private

	private func getHTML(url: URL, callback: @escaping (String?) -> Void) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard error == nil, let data = data, let html = String(data: data, encoding: .utf8) else {
				callback(nil)
				return
			}
			DispatchQueue.main.async {
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
				callback(html)
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
