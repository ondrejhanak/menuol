//
//  MapAnnotation.swift
//  menuol
//
//  Created by Ondrej Hanak on 26.06.2025.
//  Copyright © 2025 Ondrej Hanak. All rights reserved.
//

import CoreLocation

struct MapAnnotation: Identifiable {
	let id: String
	let coordinate: CLLocationCoordinate2D
}
