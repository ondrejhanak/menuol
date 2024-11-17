//
//  Container+.swift
//  menuol
//
//  Created by Ondřej Hanák on 17.11.2024.
//  Copyright © 2024 Ondrej Hanak. All rights reserved.
//

import Foundation
import Factory

extension Container {
	var htmlParser: Factory<HTMLParser> {
		self { HTMLParser() }
	}

	var httpClient: Factory<HTTPClient> {
		self { HTTPClient() }
	}

	var favoriteSlugsStorage: Factory<StringStorage> {
		self { StringStorage(key: "FavoriteVenueSlugs") }
			.cached
	}
}
