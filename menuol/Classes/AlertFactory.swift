//
//  AlertFactory.swift
//  menuol
//
//  Created by Ondrej Hanak on 03/08/2018.
//  Copyright © 2018 Ondrej Hanak. All rights reserved.
//

import UIKit

final class AlertFactory {

	public static func makeGeneralErrorAlert() -> UIAlertController {
		let controller = UIAlertController(title: "Chyba", message: "Data se nepodařilo stáhnout. Zkuste to, prosím, za chvíli znovu.", preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		controller.addAction(action)
		return controller
	}
}
