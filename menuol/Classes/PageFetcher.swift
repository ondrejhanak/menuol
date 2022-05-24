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

	func fetchVenuePage(callback: @escaping HTTPClient.HTTPCallback) {
		let url = URL(string: "https://www.olomouc.cz/poledni-menu")!
		httpClient.get(url: url, callback: callback)
	}
}
