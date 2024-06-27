//
//  MenuOl.swift
//  menuol
//
//  Created by Ondřej Hanák on 04.08.2022.
//  Copyright © 2022 Ondrej Hanak. All rights reserved.
//

import SwiftUI

@main
struct MenuOl: App {

	var body: some Scene {
		WindowGroup {
			VenueListView(venueManager: VenueManager(httpClient: HTTPClient(), htmlParser: HTMLParser()))
		}
	}
}
