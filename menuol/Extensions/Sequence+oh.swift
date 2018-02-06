//
//  Sequence+oh.swift
//  menuol
//
//  Created by Ondrej Hanak on 06/02/2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

import Foundation

// According to https://stackoverflow.com/a/34607130/1548913
extension Sequence where Iterator.Element : AnyObject {
	
	/// Return an `Array` containing the sorted elements of `source` using criteria stored in a NSSortDescriptors array.
	public func sorted(by sortDescriptors: [NSSortDescriptor]) -> [Self.Iterator.Element] {
		return sorted {
			for sortDesc in sortDescriptors {
				switch sortDesc.compare($0, to: $1) {
				case .orderedAscending: return true
				case .orderedDescending: return false
				case .orderedSame: continue
				}
			}
			return false
		}
	}
	
}
