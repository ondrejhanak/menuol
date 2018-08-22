//
//  UITableView+oh.swift
//  menuol
//
//  Created by Ondrej Hanak on 18/07/2017.
//  Copyright © 2017 Ondrej Hanak. All rights reserved.
//

import UIKit

extension UITableView {
	func reloadDataAnimated(duration: Double = 0.15) {
		UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
			self.reloadData()
		}, completion: nil)
	}
}
