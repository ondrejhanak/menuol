//
//  MockHTTPClient.swift
//  tests
//
//  Created by Ondrej Hanak on 28.03.2026.
//  Copyright © 2026 Ondrej Hanak. All rights reserved.
//

import Foundation
@testable import menuol

struct MockHTTPClient: HTTPClientType {
	func get(url: URL) async throws -> String {
		""
	}
}
