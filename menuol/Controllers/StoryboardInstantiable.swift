//
//  StoryboardInstantiable.swift
//  menuol
//
//  Created by Ondřej Hanák on 30. 07. 2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

import UIKit

// based on https://github.com/Peterek/storyboard-instantiable

protocol StoryboardInstantiable where Self: UIViewController {
	static var storyboardName: String { get }
	static var controllerIdentifier: String { get }

	static func instantiateFromStoryboard() -> Self
}

extension StoryboardInstantiable {
	static var storyboardName: String {
		return String(describing: self)
	}

	static var controllerIdentifier: String {
		return String(describing: self)
	}

	static func instantiateFromStoryboard() -> Self {
		let storyboard = UIStoryboard(name: self.storyboardName, bundle: nil)
		guard let vc = storyboard.instantiateViewController(withIdentifier: self.controllerIdentifier) as? Self else {
			fatalError("Could not instantiate storyboard named \(self.storyboardName).")
		}
		return vc
	}
}
