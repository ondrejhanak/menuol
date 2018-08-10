//
//  StoryboardInstantiable.swift
//  menuol
//
//  Created by Ondřej Hanák on 30. 07. 2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable: class {
	static var storyboardName: String { get }
	static var controllerIdentifier: String { get }
	static func instantiateFromStoryboard<T: UIViewController>() -> T
}

extension UIViewController: StoryboardInstantiable {
}

extension StoryboardInstantiable where Self: UIViewController {

	static var storyboardName: String {
		return "Main"
	}

	static var controllerIdentifier: String {
		return String(describing: self)
	}

	static func instantiateFromStoryboard<T: UIViewController>() -> T {
		let storyboard = UIStoryboard(name: T.storyboardName, bundle: nil)
		guard let vc = storyboard.instantiateViewController(withIdentifier: T.controllerIdentifier) as? T else {
			fatalError("Could not instantiate storyboard named \(T.storyboardName).")
		}
		return vc
	}

}
