//
//  AppView.swift
//  menuol
//
//  Created by Ondrej Hanak on 23.06.2025.
//  Copyright © 2025 Ondrej Hanak. All rights reserved.
//

import Factory
import SwiftUI

struct AppView: View {
	@StateObject private var coordinator = Container.shared.appCoordinator()

	var body: some View {
		NavigationStack(path: $coordinator.path) {
			coordinator.view(forRoute: .venues)
				.navigationDestination(for: AppRoute.self) { route in
					coordinator.view(forRoute: route)
				}
		}
		.tint(.accent)
	}
}
