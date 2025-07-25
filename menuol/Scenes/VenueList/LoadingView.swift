//
//  LoadingView.swift
//  menuol
//
//  Created by Ondřej Hanák on 26.09.2024.
//  Copyright © 2024 Ondrej Hanak. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
	var body: some View {
		VStack(spacing: 15) {
			ProgressView()
				.controlSize(.large)
			Text("Loading")
				.font(.body)
		}
		.foregroundStyle(.secondary)
		.tint(.secondary)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(.background)
	}
}

#Preview {
	LoadingView()
}
