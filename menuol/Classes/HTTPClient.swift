//
//  HTTPClient.swift
//  menuol
//
//  Created by Ondřej Hanák on 04. 02. 2020.
//  Copyright © 2020 Ondrej Hanak. All rights reserved.
//

import Foundation

final class HTTPClient {

	struct HTTPError: Error, Equatable {}
	
	typealias HTTPResult = Result<String, HTTPError>
	typealias HTTPCallback = (HTTPResult) -> Void

	private var session: URLSession

	init(session: URLSession = URLSession.shared) {
		self.session = session
	}

	func get(url: URL, callback: @escaping HTTPCallback) {
		let task = self.session.dataTask(with: url) { data, _, error in
			guard error == nil, let data = data, let html = String(data: data, encoding: .utf8) else {
				DispatchQueue.main.async {
					callback(.failure(HTTPError()))
				}
				return
			}
			DispatchQueue.main.async {
				callback(.success(html))
			}
		}
		task.resume()
	}
	
}
